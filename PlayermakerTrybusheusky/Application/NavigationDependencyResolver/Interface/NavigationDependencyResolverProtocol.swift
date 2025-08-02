//
//  NavigationDependencyResolverProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit

protocol NavigationDependencyResolverProtocol {

	func root(windowScene: UIWindowScene) -> RootView
	func launch(developerName: String) -> LaunchView
	func favoritesList() -> FavoritesListView
	func searchDevices(navigationController: UINavigationController) -> SearchDevicesView
	func editDevice() -> EditDeviceView

}
