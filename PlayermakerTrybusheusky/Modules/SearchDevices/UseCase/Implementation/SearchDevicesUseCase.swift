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

extension SearchDevicesUseCase: SearchDevicesUseCaseProtocol {}
