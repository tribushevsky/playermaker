//
//  RootViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class RootViewModel: ViewModelType {
	
	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let isVisibleTrigger: Driver<Void>
	}

	struct Output {
		let tools: Driver<Void>
	}
	
	// MARK: - Stored Properties / Base
	
	private let context: RootContextProtocol
	private let useCase: RootUseCaseProtocol
	let navigator: RootNavigatorProtocol

	init(
		context: RootContextProtocol,
		useCase: RootUseCaseProtocol,
		navigator: RootNavigatorProtocol
	) {
		self.context = context
		self.useCase = useCase
		self.navigator = navigator
	}

}

// MARK: - Transform

extension RootViewModel {

	func transform(input: Input) -> Output {
		let developerName = useCase.developerName
			.asDriver(onErrorJustReturn: "")
			.startWith("")

		let launchShowed = handleRouteToLaunch(
			showTrigger: input.isVisibleTrigger.take(1),
			developerName: developerName
		)
		let launchDelayFinished = handleLaunchDelay(trigger: launchShowed)
		let mainShowed = routeRouteToFavoritesList(trigger: launchDelayFinished)

		let tools = Driver<Void>.merge(mainShowed)

		return Output(
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension RootViewModel {

	private func handleRouteToLaunch(
		showTrigger: Driver<Void>,
		developerName: Driver<String>
	) -> Driver<Void> {
		Driver
			.combineLatest(showTrigger, developerName)
			.flatMapLatest { [unowned self] data in
				self.navigator.routeToLaunch(developerName: data.1)
					.asDriverOnErrorDoNothing()
			}
	}

	private func handleLaunchDelay(trigger: Driver<Void>) -> Driver<Void> {
		trigger.delay(.seconds(2))
	}

	private func routeRouteToFavoritesList(trigger: Driver<Void>) -> Driver<Void> {
		trigger.flatMapLatest { [unowned self] in
			self.navigator
				.routeToFavoritesList()
				.asDriverOnErrorDoNothing()
		}
	}

}
