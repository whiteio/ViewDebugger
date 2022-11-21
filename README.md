# SwiftUIViewDebugger

Inspect the content of the internal view hierarchy of a SwiftUI view at runtime.

## Setup

Swift Package Manager
Open the following menu item in Xcode:

File > Add Packages...

In the Search or Enter Package URL search box enter this URL:

```
https://github.com/whiteio/ViewDebugger
```

Then, select the dependency rule and press Add Package.

## How to use

1. Install the package using the steps above
2. Import `SwiftUIViewDebugger`
3. Wrap view(s) with the `DebuggableContainer` view
4. (Optional) Wrap `DebuggableContainer` in a `NavigationView` to be able to access the back button
4. Run in simulator or on a device

#### Example

```
struct ContentView: View {
    var body: some View {
        NavigationView {
            DebuggableContainer {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}
```

## How it works

`UIHostingController` contains a property `view` which is a private type called `_UIHostingView`.

`_UIHostingView` contains a method called `_viewDebugData()` which returns `[SwiftUI._ViewDebug.Data]`. 
```
@_Concurrency.MainActor(unsafe) final public func _viewDebugData() -> [SwiftUI._ViewDebug.Data]
```


`_UIHostingView` also contains a static function which can be used to serialize data of type `[SwiftUI._ViewDebug.Data]`:
```
public static func serializedData(_ viewDebugData: [SwiftUI._ViewDebug.Data]) -> Foundation.Data?
```

This returns JSON data which can be decoded and convert to a format which can be presented on screen.


A custom layout of type `_VariadicView_MultiViewRoot` can be created which makes each child view a button, where the label has a border and once tapped gets the serialized view debug data and a snapshot of the view which can be displayed on the details screen.

When the button of the view is tapped the following happens:
1. A `UIHostingController` is instantiated with a given child view of the custom layout as the root view 
2. The hosting controller's view property is type cased to `_UIHostingView`
3. A method on `_UIHostingView` is called to render the view, as it was passed by value when the UIHostingController was initialized. The render method is:
```
@_Concurrency.MainActor(unsafe) public func _renderForTest(interval: Swift.Double)
```
4. `_viewDebugData` is called on the instance of `_UIHostingView` to obtain the debug information
5. The static function `serializedData(...)` is called to convert the debug data to `Foundation.Data?` as encoded JSON
6. A binding value is updated to contain the snapshot of the view and the serialized debug data
7. The debug details view is presented when these two values aren't nil, which will show the debug information of the specific view that was tapped on
