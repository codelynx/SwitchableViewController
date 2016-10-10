//
//  ViewController.swift
//  SwitchableViewController
//
//  Created by Kaz Yoshikawa on 10/10/16.
//  Copyright © 2016 Electricwoods LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SwitchableViewControllerDataSource {

	lazy var switchableViewController: SwitchableViewController  = {
		return self.storyboard!.instantiateViewController(withIdentifier: "switchable") as! SwitchableViewController
	}()

	lazy var viewControllers: [UIViewController] = {
		return ["aaa", "bbb", "ccc", "ddd"].map { self.storyboard!.instantiateViewController(withIdentifier: $0) }
	}()

	var currentViewControllerIndex = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		self.switchableViewController.dataSource = self

		self.addChildViewController(self.switchableViewController)
		self.switchableViewController.view.frame = self.view.bounds
		self.view.addSubview(self.switchableViewController.view)
		self.switchableViewController.didMove(toParentViewController: self)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: -

	func switchableViewControllers(_ switchableViewController: SwitchableViewController) -> [UIViewController] {
		return self.viewControllers
	}

	// MARK: -

	@IBAction func next(_ sender: AnyObject) {
		if currentViewControllerIndex + 1 < self.viewControllers.count {
			let viewController = self.viewControllers[currentViewControllerIndex + 1]
			self.switchableViewController.setCurrentViewController(viewController, animated: true)
			currentViewControllerIndex = currentViewControllerIndex + 1
		}
	}

	@IBAction func previous(_ sender: AnyObject) {
		if currentViewControllerIndex - 1 >= 0 {
			let viewController = self.viewControllers[currentViewControllerIndex - 1]
			self.switchableViewController.setCurrentViewController(viewController, animated: true)
			currentViewControllerIndex = currentViewControllerIndex - 1
		}
	}

}

