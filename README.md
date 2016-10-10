# SwitchableViewController

`SwitchableViewController` demonstrate how to implement basic custom view container classs.  `SwitchableViewController` may display one view controller at a time, but can be switched from one to the other.  `SwitchableViewController` provides APIs to control from a view controller to the other, but there is no user interface like switches or tabs. Therefore it should be done by your code.


## How to use it?

### Providing a SwitchableViewController

Use initializer to instantiate by code, or you may use Storyboard to place `SwitchableViewController` in your storyboard.  But make sure dataSource should be set.

```.swift
class YourViewController: SwitchableViewControllerDataSource {
	// ...
	var switchableViewController: SwitchableViewController!

	override func viewDidLoad() {
		let viewControllers: [UIViewController] = ...

		// setting up switchableViewController
		let switchableViewController = SwitchableViewController(dataSource: self)

		self.addChildViewController(switchableViewController)
		switchableViewController.view.frame = self.view.bounds
		self.view.addSubview(switchableViewController.view)
		switchableViewController.didMove(toParentViewController: self)
		self.switchableViewController = switchableViewController
	}
}
```

### Implement data source method

`SwitchableViewController's` data source methods are as follows.

```.swift
@objc protocol SwitchableViewControllerDataSource: NSObjectProtocol {

	func switchableViewControllers(_ switchableViewController: SwitchableViewController) -> [UIViewController]

}
```

Please implement a data source method, to return switchable view controllers.

```.swift
	func switchableViewControllers(_ switchableViewController: SwitchableViewController) -> [UIViewController] {
		return self.viewControllers
	}

```

### Select which view controller to display

By updating `currentViewController` property, the view controller being displayed will be changed without animation.


```.swift
	let viewController = // one in the list
	self.switchableViewController.currentViewController = viewController
```

If you like animation effect, you may use `setCurrentViewController()` method with `animated` option `true`.

```.swift
	self.switchableViewController.setCurrentViewController(viewController, animated: true)
```

### Updating the list of view controllers

When the set of view controllers returns for the data source changed, ou may call `reloadViewControllers()` methods to update the screen.

If the view controller currently selected is in the same array, then noting happens on the screen, otherwise, the very first view controller fetched from data source will be selected and displayed.


```.swift
	self.switchableViewController.reloadViewControllers(animated: false)
```

## License

MIT License








