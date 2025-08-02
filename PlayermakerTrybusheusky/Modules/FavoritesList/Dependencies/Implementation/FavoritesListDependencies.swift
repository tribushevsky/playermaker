//
//  FavoritesListDependencies.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

final class FavoritesListDependencies: FavoritesListDependenciesProtocol {

	let storage: ReactiveLocalStorageServiceProtocol

	init(storage: ReactiveLocalStorageServiceProtocol) {
		self.storage = storage
	}

}
