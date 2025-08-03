//
//  SearchDevicesUseCase.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class SearchDevicesUseCase {

	private let dependencies: SearchDevicesDependenciesProtocol

	init(dependencies: SearchDevicesDependenciesProtocol) {
		self.dependencies = dependencies
	}
	
}

// MARK: - SearchDevicesUseCaseProtocol

extension SearchDevicesUseCase: SearchDevicesUseCaseProtocol {

	var favoriteDevices: Observable<[FavoriteDeviceModel]> {
		dependencies.storage.samples(sort: .uuid)
	}

	func startScanning() -> Observable<[DiscoveredDeviceModel]> {
		Observable.create { [unowned self] observer in
			dependencies.bluetooth.startScanning { result in
				switch result {
				case .success(let devices):
					observer.onNext(devices)
				case .failure(let error):
					observer.onError(error)
				}
			}

			return Disposables.create { [weak self] in
				self?.dependencies.bluetooth.stopScanning()
			}
		}
	}

	func deleteFavoriteDevice(device: FavoriteDeviceModel) -> Single<Void> {
		dependencies.storage.delete(sample: device)
	}

	func createFavoriteDevice(device: FavoriteDeviceModel) -> Single<FavoriteDeviceModel> {
		dependencies.storage.create(sample: device)
	}

}
