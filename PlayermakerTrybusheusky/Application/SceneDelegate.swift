//
//  SceneDelegate.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard
			let windowScene = scene as? UIWindowScene,
			let appAssembly = (UIApplication.shared.delegate as? AppDelegate)?.appAssembly
		else {
			return
		}

		window = appAssembly.navigationDependencyResolver.root(windowScene: windowScene)
		window?.makeKeyAndVisible()
	}

	func sceneDidDisconnect(_ scene: UIScene) {}

	func sceneDidBecomeActive(_ scene: UIScene) {}

	func sceneWillResignActive(_ scene: UIScene) {}

	func sceneWillEnterForeground(_ scene: UIScene) {}

	func sceneDidEnterBackground(_ scene: UIScene) {}


}

