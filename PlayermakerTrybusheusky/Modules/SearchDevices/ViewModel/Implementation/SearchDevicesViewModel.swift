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
		let didAppearTrigger: Driver<Void>
		let willDismissTrigger: Driver<Void>
		let closeTrigger: Driver<Void>
	}
	struct Output {
		let devices: Driver<[SearchDeviceItemViewModel]>
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
			handleClose(trigger: input.closeTrigger.throttle(.milliseconds(300)))
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
	) -> Driver<[SearchDeviceItemViewModel]> {
		Driver.combineLatest(
			discoveredDevices.distinctUntilChanged(),
			favoriteDevices.distinctUntilChanged()
		)
		.map { data in
			data.0
				.sorted { $0.uuid > $1.uuid }
				.map { discoveredDevice in
					SearchDeviceItemViewModel(
						uuid: discoveredDevice.uuid,
						name: discoveredDevice.name,
						isFavorite: data.1.contains(where: { $0.uuid == discoveredDevice.uuid }),
						rssi: discoveredDevice.rssi
					)
				}
		}
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
