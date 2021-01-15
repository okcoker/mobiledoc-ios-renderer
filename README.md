## Mobiledoc iOS Renderer

Mobiledoc server and client rendering for [Mobiledoc-kit](https://github.com/bustlelabs/mobiledoc-kit).

This renderer will be used to render mobiledoc into native views. Currently testing with v0.3.1. There is currently no native renderer available at the moment. We can eventually use this for Audiomack World to do more custom things.

### Usage

From your view controller, for example:

```swift
let mobiledoc = getJsonStringFromYourAPIOrSomething()
let renderer = MobiledocRenderer(mobiledoc)

renderer.render().result.forEach { sectionView in
    view.addSubview(sectionView)
}

```

### Todo

- Figure out a clean way to allow developers to style views
- Do we need a custom MobileDocRenderer view?

### Much later todo (not used on our end)

- Figure out render/teardown callbacks
- Figure out atom rendering
- Figure out list rendering

### Sample App

This repo contains a sample app with static json that can be used to test the render output.

### Tests

Later?
