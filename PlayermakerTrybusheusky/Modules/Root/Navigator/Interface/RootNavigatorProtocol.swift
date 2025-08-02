//
//  RootNavigatorProtocol.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

protocol RootNavigatorProtocol: Navigator<Void> {
	
	func routeToLaunch(developerName: String) -> Observable<Void>
	func routeToFavoritesList() -> Observable<Void>

}
