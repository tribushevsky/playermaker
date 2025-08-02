//
//  RootUseCase.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

final class RootUseCase {

	private let dependencies: RootDependenciesProtocol
	
	init(dependencies: RootDependenciesProtocol) {
		self.dependencies = dependencies
	}

}

// MARK: - RootUseCaseProtocol

extension RootUseCase: RootUseCaseProtocol {

	var developerName: Single<String> {
		Single.create { [unowned self] single in
			single(.success(dependencies.identityService.developerName))

			return Disposables.create()
		}
	}

}
