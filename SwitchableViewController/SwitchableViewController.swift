//
//	SwitchableViewController.swift
//	ZKit
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy 
//	of this software and associated documentation files (the "Software"), to deal 
//	in the Software without restriction, including without limitation the rights 
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
//	copies of the Software, and to permit persons to whom the Software is 
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in 
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//


import UIKit


//
//	SwitchableViewControllerDataSource
//

@objc protocol SwitchableViewControllerDataSource: NSObjectProtocol {

	func switchableViewControllers(_ switchableViewController: SwitchableViewController) -> [UIViewController]

}


//
//	SwitchableViewController
//

class SwitchableViewController: UIViewController {

	@IBOutlet weak var dataSource: SwitchableViewControllerDataSource?

	// MARK: -

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init(dataSource: SwitchableViewControllerDataSource) {
		self.dataSource = dataSource
		super.init(nibName: nil, bundle: nil)
	}

	// MARK: -

	private var _currentViewController: UIViewController?
	
	public var currentViewController: UIViewController? {
		get { return _currentViewController }
		set { self.setCurrentViewController(newValue, animated: false) }
	}
	
	func setCurrentViewController(_ viewController: UIViewController?, animated: Bool) {
		guard _currentViewController != viewController else { return }

		if self.isViewLoaded {
			let animationDuration: TimeInterval = animated ? 0.3 : 0.0
			if let oldViewController = currentViewController,
			   let newViewController = viewController {

				oldViewController.willMove(toParentViewController: nil)
				self.addChildViewController(newViewController)
				newViewController.view.frame = self.view.bounds
				newViewController.view.alpha = 0.0
				self.view.addSubview(newViewController.view)
				self.transition(from: oldViewController, to: newViewController, duration: animationDuration, options: .curveEaseInOut, animations: {
					newViewController.view.alpha = 1.0
					oldViewController.view.alpha = 0.0
				}, completion: { (finished) in
					oldViewController.removeFromParentViewController()
					oldViewController.view.removeFromSuperview()
					newViewController.didMove(toParentViewController: self)
					self._currentViewController = newViewController
				})
			}
			else if let newViewController = viewController {
				self.addChildViewController(newViewController)
				newViewController.view.frame = self.view.bounds
				newViewController.view.alpha = 0.0
				self.view.addSubview(newViewController.view)
				UIView.animate(withDuration: animationDuration, animations: {
					newViewController.view.alpha = 1.0
				}, completion: { (finished) in
					newViewController.didMove(toParentViewController: self)
					self._currentViewController = newViewController
				})
			}
			else if let oldViewController = _currentViewController {
				oldViewController.willMove(toParentViewController: nil)
				UIView.animate(withDuration: animationDuration, animations: {
					oldViewController.view.alpha = 0.0
				}, completion: { (finished) in
					oldViewController.removeFromParentViewController()
					oldViewController.view.removeFromSuperview()
					self._currentViewController = nil
				})
			}
		}
		else {
			self._currentViewController = viewController
		}
	}

	func reloadViewControllers(animated: Bool = false) {
		let viewControllers = self.viewControllers
		if let currentViewController = self.currentViewController, !viewControllers.contains(currentViewController) {
			// when currentViewController is still in the view controllers, then fine do nothing
		}
		else {
			// currentViewController is not in the new list then replace with the first view controller in the new list
			self.setCurrentViewController(viewControllers.first, animated: animated)
		}
	}

	// MARK: -

	private var viewControllers: [UIViewController] {
		return (self.dataSource?.switchableViewControllers(self)) ?? []
	}

	// MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let firstViewController = self.viewControllers.first, _currentViewController == nil {
			self.setCurrentViewController(firstViewController, animated: false)
		}
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
