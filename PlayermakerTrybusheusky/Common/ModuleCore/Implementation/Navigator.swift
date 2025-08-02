//
//  Navigator.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

public class Navigator<Output> {

	// MARK: - Stored Properties / Private

	private var privateOutput: PublishSubject<Output> = PublishSubject<Output>()
	weak var navigationController: UINavigationController?
	weak var currentView: UIViewController?
	weak var currentWindow: UIWindow?
	weak var tabBarController: UITabBarController?

	// MARK: - Stored Properties / Public

	let dependencyResolver: NavigationDependencyResolverProtocol

	var output: Observable<Output> {
		privateOutput.asObservable()
	}

	func next(element: Output) {
		privateOutput.onNext(element)
	}

	func complete() {
		privateOutput.onCompleted()
	}

	func nextAndComplete(element: Output) {
		privateOutput.onNext(element)
		privateOutput.onCompleted()
	}

	init(
		navigationController: UINavigationController? = nil,
		currentView: UIViewController? = nil,
		currentWindow: UIWindow? = nil,
		tabBarController: UITabBarController? = nil,
		dependencyResolver: NavigationDependencyResolverProtocol
	) {
		self.navigationController = navigationController
		self.currentView = currentView
		self.currentWindow = currentWindow
		self.tabBarController = tabBarController
		self.dependencyResolver = dependencyResolver
	}

}
