//
//  LaunchViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class LaunchViewModel: ViewModelType {
	
	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let willAppearTrigger: Driver<Void>
	}
	struct Output {
		let developerName: Driver<String>
		let isAnimationActive: Driver<Bool>
	}
	
	// MARK: - Stored Properties / Base
	
	private let context: LaunchContextProtocol
	private let useCase: LaunchUseCaseProtocol
	let navigator: LaunchNavigatorProtocol

	init(
		context: LaunchContextProtocol,
		useCase: LaunchUseCaseProtocol,
		navigator: LaunchNavigatorProtocol
	) {
		self.context = context
		self.useCase = useCase
		self.navigator = navigator
	}

}

// MARK: - Transform

extension LaunchViewModel {

	func transform(input: Input) -> Output {
		let startAnimationTrigger = handleStartPulsationAnimation(
			trigger: input.willAppearTrigger.take(1)
		)

		return Output(
			developerName: Driver.just(context.developerName),
			isAnimationActive: startAnimationTrigger
		)
	}
	
}

// MARK: - Handlers

extension LaunchViewModel {

	func handleStartPulsationAnimation(trigger: Driver<Void>) -> Driver<Bool> {
		trigger
			.map { true }
			.startWith(false)
	}

}
