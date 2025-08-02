//
//  SearchDevicesViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class SearchDevicesViewModel: ViewModelType {

	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let willAppearTrigger: Driver<Void>
		let willDismissTrigger: Driver<Void>
		let closeTrigger: Driver<Void>
	}
	struct Output {
		let tools: Driver<Void>
	}
	
	// MARK: - Stored Properties / Base
	
	private let context: SearchDevicesContextProtocol
	private let useCase: SearchDevicesUseCaseProtocol
	let navigator: SearchDevicesNavigatorProtocol

	init(
		context: SearchDevicesContextProtocol,
		useCase: SearchDevicesUseCaseProtocol,
		navigator: SearchDevicesNavigatorProtocol
	) {
		self.context = context
		self.useCase = useCase
		self.navigator = navigator
	}

}

// MARK: - Transform

extension SearchDevicesViewModel {

	func transform(input: Input) -> Output {
		let tools = Driver<Void>.merge(
			handleClose(trigger: input.closeTrigger.throttle(.milliseconds(300)))
		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension SearchDevicesViewModel {

	func handleClose(trigger: Driver<Void>) -> Driver<Void> {
		trigger.do { [weak self] _ in
			self?.navigator.complete()
		}
	}

}
