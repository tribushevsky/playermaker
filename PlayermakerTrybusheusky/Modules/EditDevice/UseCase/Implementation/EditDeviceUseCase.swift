//
//  EditDeviceUseCase.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class EditDeviceUseCase {

	private let dependencies: EditDeviceDependenciesProtocol

	init(dependencies: EditDeviceDependenciesProtocol) {
		self.dependencies = dependencies
	}
	
}

// MARK: - EditDeviceUseCaseProtocol

extension EditDeviceUseCase: EditDeviceUseCaseProtocol {}
