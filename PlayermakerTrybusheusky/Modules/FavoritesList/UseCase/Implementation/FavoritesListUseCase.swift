//
//  FavoritesListUseCase.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class FavoritesListUseCase {

	private let dependencies: FavoritesListDependenciesProtocol

	init(dependencies: FavoritesListDependenciesProtocol) {
		self.dependencies = dependencies
	}
	
}

// MARK: - FavoritesListUseCaseProtocol

extension FavoritesListUseCase: FavoritesListUseCaseProtocol {

	func updateDevice(device: FavoriteDeviceModel) -> Single<FavoriteDeviceModel> {
		dependencies.storage.update(sample: device)
	}

	func deleteDevice(device: FavoriteDeviceModel) -> Single<Void> {
		dependencies.storage.delete(sample: device)
	}

	func devicesList(sortCriterion: FavoriteDeviceSortCriterion) -> Observable<[FavoriteDeviceModel]> {
		dependencies.storage.samples(sort: sortCriterion)
	}

}
