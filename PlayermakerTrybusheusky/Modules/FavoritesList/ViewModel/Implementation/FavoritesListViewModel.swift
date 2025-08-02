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
		let sortByNameTrigger: Driver<Void>
		let sortByUUIDTrigger: Driver<Void>
	}
	struct Output {
		let sortMode: Driver<FavoritesListSortMode>
		let favorites: Driver<[String]>
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
		let sortMode = handleFavoritesSortMode(
			sortByNameTrigger: input.sortByNameTrigger.throttle(.microseconds(300)),
			sortByUUIDTrigger: input.sortByUUIDTrigger.throttle(.microseconds(300))
		)

		let tools = Driver<Void>.merge(
			handleSearchDevices(trigger: input.searchDevicesTrigger.throttle(.milliseconds(300)))
		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			sortMode: sortMode,
			favorites: handleFavorites(with: sortMode),
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension FavoritesListViewModel {

	func handleSearchDevices(trigger: Driver<Void>) -> Driver<Void> {
		trigger.flatMapLatest { [unowned self] in
			useCase
				.createDevice(device: .init(uuid: UUID().uuidString, name: "VLADRIMIR") )
				.asDriverOnErrorDoNothing()
				.mapToVoid()
		}
// FIXME
//		trigger.flatMapLatest { [unowned self] _ in
//			navigator
//				.routeToSearchDevices()
//				.asDriverOnErrorDoNothing()
//		}
	}

	func handleFavoritesSortMode(
		sortByNameTrigger: Driver<Void>,
		sortByUUIDTrigger: Driver<Void>
	) -> Driver<FavoritesListSortMode> {
		Driver<FavoritesListSortMode>.merge(
			sortByNameTrigger.map { .name },
			sortByUUIDTrigger.map { .uuid }
		)
		.startWith(.name)
		.distinctUntilChanged()
	}

	func handleFavorites(with sortMode: Driver<FavoritesListSortMode>) -> Driver<[String]> {
		sortMode.flatMapLatest { [unowned self] in
			useCase
				.devicesList(sortCriterion: $0.sortCriterion)
				.asDriver(onErrorJustReturn: [])
				.map { $0.map { $0.uuid } }
		}
	}

}
