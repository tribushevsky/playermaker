//
//  FavoritesListNavigatorProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

protocol FavoritesListNavigatorProtocol: NavigatorErrorCatcher<Void> {

	func routeToEditDevice(device: FavoriteDeviceModel) -> Observable<FavoriteDeviceModel>
	func routeToSearchDevices() -> Observable<Void>

}
