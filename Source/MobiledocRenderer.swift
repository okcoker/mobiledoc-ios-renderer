//
//  MobiledocRenderer.swift
//  MobiledocRenderer
//
//  Created by Sean Coker on 1/14/21.
//

/**
 * Render for mobiledoc v0.3.1
 */

import UIKit

public struct MobiledocRender {
    public let result: [UIView]
    public let teardown: RenderCallback
}

public class MobiledocRenderer: NSObject {
    private var renderCallbacks = [RenderCallback]()
    private let mobiledocObject: Mobiledoc
    private let config: MobiledocRendererConfig = MobiledocRendererConfig()
    private let customAtoms: [AtomInterface]?
    private let customCards: [CardInterface]?
    private let customSections: [SectionInterface]?
    private let customMarkups: [MarkupInterface]?
    
    public init(mobiledoc: String,
         config: MobiledocRendererConfig = MobiledocRendererConfig(),
         atoms: [AtomInterface]? = nil,
         cards: [CardInterface]? = nil,
         sections: [SectionInterface]? = nil,
         markups: [MarkupInterface]? = nil) {
        
        do {
            self.customAtoms = atoms
            self.customCards = cards
            self.customSections = sections
            self.customMarkups = markups
            
            let dictionary = try JSONSerialization.jsonObject(with: mobiledoc.data(using: .utf8)!, options: []) as! [String: Any]
            
            let version = dictionary["version"] as! String
            let jsonAtoms = (dictionary["atoms"] as! [[Any]]).map { atom in
                return try? Atom.fromJSON(jsonArray: atom)
            }.compactMap { $0 }
            let jsonCards = (dictionary["cards"] as! [[Any]]).map { card in
                return try? Card.fromJSON(jsonArray: card)
            }.compactMap { $0 }
            let jsonMarkups = (dictionary["markups"] as! [[Any]]).map { markup in
                return try? Markup.fromJSON(jsonArray: markup)
            }.compactMap { $0 }
            let jsonSections: [SectionInterface] = (dictionary["sections"] as! [[Any]]).map { markup in
                guard let sectionTypeIdentifier = markup[0] as? Int else {
                    return nil
                }
                guard let sectionType = MarkupSectionType.forInt(int: sectionTypeIdentifier) else {
                    return nil
                }
                
                switch (sectionType) {
                case .MARKUP:
                    return try! MarkupSection.fromJSON(jsonArray: markup)
                case .IMAGE:
                    return try! ImageSection.fromJSON(jsonArray: markup)
                case .LIST:
                    return try! ListSection.fromJSON(jsonArray: markup)
                case .CARD:
                    return try! CardSection.fromJSON(jsonArray: markup)
                }
            }.compactMap { $0 }
            
            self.mobiledocObject = Mobiledoc(version: version, atoms: jsonAtoms, cards: jsonCards, markups: jsonMarkups, sections: jsonSections)
        }
        catch {
            self.mobiledocObject = Mobiledoc(version: "error", atoms: [], cards: [], markups: [], sections: [])
            print(error)
        }
    }
        
    public func render() -> MobiledocRender {
//        let ta = context.obtainStyledAttributes(nil, R.styleable.MAR)
//
//        let color = ta.getColor(R.styleable.MAR_mar_link_color, Color.BLUE)
//
//        Log.d("MAR->isBlue", "${color == Color.BLUE}")
//        ta.recycle()
        let renderedSections = renderSections()

        renderCallbacks.forEach { callback in
            _ = callback()
        }

        let teardown = { }

        return MobiledocRender(result: renderedSections, teardown: teardown)
    }

    private func renderSections() -> [UIView] {
        let sectionsList = mobiledocObject.sections
        var views = [UIView]()

        for (index, section) in sectionsList.enumerated() {
            let type = section.type
            let view: UIView?
            
            switch (type) {
                case MarkupSectionType.MARKUP:
                    let markupSection = section as! MarkupSection
                    view = renderMarkupSection(section: markupSection, markers: markupSection.markers)
                case MarkupSectionType.IMAGE:
                    view = renderImageSection(section: section)
                case MarkupSectionType.LIST:
                    let listSection = section as! ListSection
                    view = renderListSection(section: listSection)
                case MarkupSectionType.CARD:
                    let cardSection = section as! CardSection
                    view = renderCardSection(section: cardSection)
            }
            
            if let unwrappedView = view {
                views.append(unwrappedView)
            } else {
                print("#renderSections", "\(type) \(index)")
            }
        }

        return views
    }

    private func renderMarkupSection(section: MarkupSection, markers: [Marker]) -> UIView {
        let customSection = customSections?.first(where: { customSection -> Bool in
            return (customSection as? MarkupSection)?.tagName == section.tagName
        })

        // Since the sections consist of like h1, h2, p, etc. we may not even want to
        // allow custom section renders as to prevent the user from erroring when renderMarkersOnElement
        // is most likely going to return a SpannableString that HAS to be in a TextView
        //
        // HTML is obviously more flexible as many elements can be children of many other elements
        // Since this is the first native renderer, we can explore whether or not we should remove
        // first first part of this ternary statement below
        let sectionView = customSection?.render(config: config) ?? section.render(config: config)

        return renderMarkersOnElement(sectionView: sectionView, markers: markers)
    }


    private func renderImageSection(section: SectionInterface) -> UIView {
//        let section = ImageSectionInterface.fromJSON(sectionArgs)


        return UIView()
    }

    private func renderListSection(section: ListSection) -> UIView {
        let listItemMarkers = section.markers
        let list = section.render(config: config)
        
        listItemMarkers.forEach { markers in
            _ = renderMarkersOnElement(sectionView: list, markers: markers)
        }

        return list
    }

    private func renderCardSection(section: CardSection) -> UIView? {
        let index = section.index
        let cardList = mobiledocObject.cards

        let card = cardList[index]
        let name = card.name

        let customCard = customCards?.first(where: { custom -> Bool in
            return custom.name == name
        })
        
        let onTearDown: (RenderCallback) -> Void = { [weak self] callback in
            self?.registerRenderCallback(cb: callback)
        }
        let didRender: (RenderCallback) -> Void = { [weak self] callback in
            self?.registerRenderCallback(cb: callback)
        }
        let cardEnvironment = CardEnvironment(name: name, isInEditor: false, onTearDown: onTearDown, didRender: didRender)
        
        if let customCard = customCard {
            return customCard.render(cardEnvironment, nil, card.payload)
        }
        
        return card.render(cardEnvironment, nil, card.payload)
    }

    private func renderMarkersOnElement(sectionView: UIView, markers: [Marker]) -> UIView {
        let ssb = SimpleSpanBuilder()
        var spans = [SimpleSpanBuilder.Span]()
        let markupList: [Markup] = mobiledocObject.markups as! [Markup]
        var runningMarkerIdList = [Int]()

        for (_, marker) in markers.enumerated() {
            let type = marker.type
            let markerIds = marker.markupMarkerIds
            var closeCount = marker.closeCount
            let value = marker.value
            let noopMarkerId = -1

            let injectSpan = {
                // -1 will basically equal the html span tag where no
                // character styles should be applied because it's a
                // just a floating HTML Text Node
                runningMarkerIdList.append(noopMarkerId)
                closeCount += 1
            }

            markerIds.forEach { markerId in
                let markup = markupList[safeIndex: markerId]

                if (markup != nil) {
                    runningMarkerIdList.append(markerId)
                    return
                }

                injectSpan()
            }

            if markerIds.isEmpty {
                injectSpan()
            }

            let enclosedTagName = markupList[safeIndex: runningMarkerIdList.last!]?.tagName
            let parentMarkups = runningMarkerIdList[0..<(runningMarkerIdList.count - 1)].map { id in
                return markupList[safeIndex: id]
            }.filter { markup -> Bool in
                return markup != nil
            }
            let customMarkup = customMarkups?.first(where: { markup -> Bool in
                return markup.tagName == enclosedTagName
            })
       
            let defaultMarkup = markupList[safeIndex: runningMarkerIdList.last!]
            let currentSpan: SimpleSpanBuilder.Span
            
            if let customMarkup = customMarkup {
                currentSpan = customMarkup.render(config: config, value: value, parentMarkups: parentMarkups as! [Markup])
            } else if let defaultMarkup = defaultMarkup {
                currentSpan = defaultMarkup.render(config: config, value: value, parentMarkups: parentMarkups as! [Markup])
            }
            else {
                currentSpan = Markup(tagName: MarkupTagName.SPAN, attributes: []).render(config: config, value: value, parentMarkups: parentMarkups as! [Markup])
            }

//            Log.d("MAR->renderMarkers", "$value : ${defaultMarkup?.tagName} : ${parentMarkups.map { m -> m.tagName }}")

            switch (type) {
            case .TEXT:
                break
            case .ATOM:
                print("MAR->renderAtomSection", "Not implemented")
//                _ = renderAtomSection(context, index, value)
            }

            spans.append(currentSpan)
            
            for _ in 0..<closeCount {
                runningMarkerIdList.remove(at: runningMarkerIdList.count - 1)
            }
        }

        spans.forEach { span in
            ssb.append(span: span)
        }

        // @todo I'm thinking all MarkerType.Text types should be created within a TextView.
        // I'm not sure what `sectionView` (the HTML h1,h2,p,blockquote tags) equivalent will be
        // if we make that change. There's basically no need for a parent View to the TextView.
        // We should however have different sizes for the h1, h2, etc so maybe we pass this info
        // down to the actual Markup render function to determine what font size and any other
        // custom things that should render when these elements are supposed to be rendered.
        // Biggest todo here is to find out how MobiledocRendererConfig will work.
        if let sectionView = sectionView as? UITextView {
            sectionView.attributedText = ssb.build()
//            sectionView.setLinkTextColor(context.resources.getColor(config.linkColor))
//            sectionView.linksClickable = true
            spans.removeAll()
        }
        else {
            print("MAR-> not textview \(sectionView)")
        }

        return sectionView
    }


    private func renderAtomSection(atomIndex: Int, value: String) -> UIView? {
        let atomList = mobiledocObject.atoms
        let atom = customAtoms?.first(where: { a -> Bool in
            return a.name == atomList[safeIndex: atomIndex]?.name
        })


        if let atom = atom {
            let env = AtomEnvironment(
                name: atom.name,
                isInEditor: false
            )

            return atom.render(env, nil, [String: Any](), value)
        }

        return nil
    }

    private func registerRenderCallback(cb: RenderCallback) {
//        renderCallbacks.append(cb)
    }
}
