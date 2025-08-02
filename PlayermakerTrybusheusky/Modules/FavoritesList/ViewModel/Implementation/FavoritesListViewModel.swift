//
//  FavoritesListViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class FavoritesListViewModel: ViewModelType, CrucialActionHandableProtocol {

	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let willAppearTrigger: Driver<Void>
		let willDismissTrigger: Driver<Void>
		let searchDevicesTrigger: Driver<Void>
		let sortByNameTrigger: Driver<Void>
		let sortByUUIDTrigger: Driver<Void>
		let editDeviceTrigger: Driver<FavoriteListItemViewModel>
		let deleteDeviceTrigger: Driver<FavoriteListItemViewModel>
	}
	struct Output {
		let sortMode: Driver<FavoritesListSortMode>
		let favorites: Driver<[FavoriteListItemViewModel]>
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
		let favoritesDevices: Driver<[FavoriteDeviceModel]> = handleFavorites(with: sortMode)

		let tools = Driver<Void>.merge(
			handleSearchDevices(trigger: input.searchDevicesTrigger.throttle(.milliseconds(300))),
			handleDeleteFavorite(deviceTrigger: input.deleteDeviceTrigger.throttle(.milliseconds(300)), favorites: favoritesDevices),
			handleEditFavorite(deviceTrigger: input.editDeviceTrigger.throttle(.milliseconds(300)))
		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			sortMode: sortMode,
			favorites: mapFavoriteListItemViewModel(itemsTrigger: favoritesDevices),
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

	func handleDeleteFavorite(
		deviceTrigger: Driver<FavoriteListItemViewModel>,
		favorites: Driver<[FavoriteDeviceModel]>
	) -> Driver<Void> {
		deviceTrigger
			.withLatestFrom(favorites) { ($0, $1) }
			.map { params in
				params.1.first(where: { $0.uuid == params.0.uuid })
			}
			.unwrappedNever()
			.flatMapLatest { [unowned self] deviceToDelete in
				typealias Loc = L10n.Delete.Sure
				return handleSure(
					actionTrigger: Observable<FavoriteDeviceModel>.just(deviceToDelete),
					on: navigator.currentView,
					title: Loc.title,
					actionTitle: Loc.action,
					cancelTitle: Loc.cancel
				).asDriverOnErrorDoNothing()
			}
			.flatMapLatest { [unowned self] deviceToDelete in
				useCase
					.deleteDevice(device: deviceToDelete)
					.asDriverCatchErrorDoNothing(
						action: .init(title: L10n.Error.Action.ok, style: .ok),
						catcher: navigator
					)
			}
			.mapToVoid()
	}

	func handleEditFavorite(deviceTrigger: Driver<FavoriteListItemViewModel>)  -> Driver<Void> {
		deviceTrigger.mapToVoid() // FIXME
	}

	func handleFavorites(with sortMode: Driver<FavoritesListSortMode>) -> Driver<[FavoriteDeviceModel]> {
		sortMode.flatMapLatest { [unowned self] in
			useCase
				.devicesList(sortCriterion: $0.sortCriterion)
				.asDriver(onErrorJustReturn: [])
		}
	}

	func mapFavoriteListItemViewModel(itemsTrigger: Driver<[FavoriteDeviceModel]>) -> Driver<[FavoriteListItemViewModel]> {
		itemsTrigger.map { devices in
			devices.map {
				FavoriteListItemViewModel(
					uuid: $0.uuid,
					title: $0.name,
					subtitle: $0.uuid
				)
			}
		}
	}

}
