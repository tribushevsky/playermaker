//
//  SearchDevicesViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class SearchDevicesViewModel: ViewModelType, CrucialActionHandableProtocol {

	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let didAppearTrigger: Driver<Void>
		let willDismissTrigger: Driver<Void>
		let closeTrigger: Driver<Void>
		let toggleFavoriteTrigger: Driver<SearchDevicesItemViewModel>
	}
	struct Output {
		let devices: Driver<[SearchDevicesItemViewModel]>
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
		let favoriteDevices = useCase.favoriteDevices.asDriver(onErrorJustReturn: [])
		let discoveredDevices = handleStartScanning(trigger: input.didAppearTrigger)
		let devices = mapDevices(discoveredDevices: discoveredDevices, favoriteDevices: favoriteDevices)

		let tools = Driver<Void>.merge(
			handleClose(trigger: input.closeTrigger.throttle(.milliseconds(300))),
			handleToggleFavorite(
				deviceTrigger: input.toggleFavoriteTrigger.throttle(.milliseconds(300)),
				discoveredDevices: discoveredDevices,
				favoriteDevices: favoriteDevices
			)
		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			devices: devices,
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension SearchDevicesViewModel {

	func mapDevices(
		discoveredDevices: Driver<[DiscoveredDeviceModel]>,
		favoriteDevices: Driver<[FavoriteDeviceModel]>
	) -> Driver<[SearchDevicesItemViewModel]> {
		Driver.combineLatest(
			discoveredDevices.distinctUntilChanged(),
			favoriteDevices.distinctUntilChanged()
		)
		.map { data in
			data.0
				.sorted { $0.uuid > $1.uuid }
				.map { discoveredDevice in
					var deviceName: String? = discoveredDevice.name
					var isFavorite: Bool = false

					if
						let favoriteDevice = data.1.first(where: { $0.uuid == discoveredDevice.uuid })
					{
						deviceName = favoriteDevice.name
						isFavorite = true
					}

					return SearchDevicesItemViewModel(
						uuid: discoveredDevice.uuid,
						title: deviceName ?? L10n.SearchDevices.Item.unknownName,
						subtitle: discoveredDevice.uuid,
						isFavorite: isFavorite,
						rssi: discoveredDevice.rssi
					)
				}
		}.startWith([])
	}

	func handleStartScanning(trigger: Driver<Void>) -> Driver<[DiscoveredDeviceModel]> {
		trigger.flatMapLatest { [unowned self] _ in
			let startScanning = useCase.startScanning().share()
			let successStartScanning = startScanning.asDriverOnErrorDoNothing()
			let failureStartScanning = startScanning.asDriverCatchError(catcher: navigator)
			let errorHandler = handleError(actionTrigger: failureStartScanning)
				.do(onNext: { [weak self] _ in
					self?.navigator.complete()
				})
				.delay(.milliseconds(500))
				.map { [DiscoveredDeviceModel]() }

			return Driver.merge(successStartScanning, errorHandler)
		}
	}

	func handleToggleFavorite(
		deviceTrigger: Driver<SearchDevicesItemViewModel>,
		discoveredDevices: Driver<[DiscoveredDeviceModel]>,
		favoriteDevices: Driver<[FavoriteDeviceModel]>
	) -> Driver<Void> {
		deviceTrigger
			.withLatestFrom(Driver.combineLatest(discoveredDevices, favoriteDevices)) { ($0, $1) }
			.flatMapLatest { [unowned self] params -> Driver<Void> in
				let (selectedDevice, (discoveredDevices, favoriteDevices)) = params

				return Observable<Void>.just(())
					.flatMapLatest { [unowned self] _ in
						if let existingFavoriteDevice = favoriteDevices.first(where: { $0.uuid == selectedDevice.uuid }) {
							typealias Loc = L10n.Delete.Sure
							return handleSure(
								actionTrigger: Observable<FavoriteDeviceModel>.just(existingFavoriteDevice),
								on: navigator.navigationController,
								title: Loc.title,
								actionTitle: Loc.action,
								cancelTitle: Loc.cancel
							).flatMapLatest { [unowned self] device in
								useCase.deleteFavoriteDevice(device: device)
							}.mapToVoid()
						} else if let existingDiscoveredDevice = discoveredDevices.first(where: { $0.uuid == selectedDevice.uuid }) {
							return navigator.routeToEditDevice(
								device: .init(
									uuid: existingDiscoveredDevice.uuid,
									name: existingDiscoveredDevice.name
								)
							).flatMapLatest { [unowned self] favoriteDevice in
								useCase.createFavoriteDevice(device: favoriteDevice)
							}.mapToVoid()
						} else {
							return Observable<Void>
								.error(SearchDevicesViewModelError.objectNotFound)
						}
					}.asDriver(onErrorJustReturn: ())
			}
	}

	func handleError(actionTrigger: Driver<NavigationCatcherAction>) -> Driver<Void> {
		actionTrigger.flatMapLatest { [unowned self] action -> Driver<Void> in
			switch action.style {
			case .action:
				return self.navigator.showAppSettings().asDriverOnErrorDoNothing()
			case .cancel, .ok:
				return Driver<Void>.just(())
			}
		}
	}

	func handleClose(trigger: Driver<Void>) -> Driver<Void> {
		trigger.do { [weak self] _ in
			self?.navigator.complete()
		}
	}

}
