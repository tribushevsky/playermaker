//
//  LaunchUseCase.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class LaunchUseCase {
	
	private let dependencies: LaunchDependenciesProtocol
	
	init(dependencies: LaunchDependenciesProtocol) {
		self.dependencies = dependencies
	}
	
}

// MARK: - LaunchUseCaseProtocol

extension LaunchUseCase: LaunchUseCaseProtocol {}
