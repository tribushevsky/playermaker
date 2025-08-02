//
//  FavoritesListViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class FavoritesListViewModel: ViewModelType {

	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let willAppearTrigger: Driver<Void>
		let willDismissTrigger: Driver<Void>
		let searchDevicesTrigger: Driver<Void>
	}
	struct Output {
		let tools: Driver<Void>
	}
	
	// MARK: - Stored Properties / Base
	
	private let context: FavoritesListContextProtocol
	private let useCase: FavoritesListUseCaseProtocol
	let navigator: FavoritesListNavigatorProtocol

	init(
		context: FavoritesListContextProtocol,
		useCase: FavoritesListUseCaseProtocol,
		navigator: FavoritesListNavigatorProtocol
	) {
		self.context = context
		self.useCase = useCase
		self.navigator = navigator
	}

}

// MARK: - Transform

extension FavoritesListViewModel {

	func transform(input: Input) -> Output {
		let tools = Driver<Void>.merge(
			handleSearchDevices(trigger: input.searchDevicesTrigger.throttle(.milliseconds(300)))
		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension FavoritesListViewModel {

	func handleSearchDevices(trigger: Driver<Void>) -> Driver<Void> {
		trigger.flatMapLatest { [unowned self] _ in
			navigator
				.routeToSearchDevices()
				.asDriverOnErrorDoNothing()
		}
	}

}
