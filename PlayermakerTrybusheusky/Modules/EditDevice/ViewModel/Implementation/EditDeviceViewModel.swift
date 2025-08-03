//
//  EditDeviceViewModel.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift
import RxCocoa

final class EditDeviceViewModel: ViewModelType {

	typealias In = Input
	typealias Out = Output
	
	struct Input {
		let willAppearTrigger: Driver<Void>
		let willDismissTrigger: Driver<Void>
		let nameChangingTrigger: Driver<String?>
		let saveTrigger: Driver<Void>
		let closeTrigger: Driver<Void>
	}
	struct Output {
		let deviceName: Driver<String?>
		let deviceUUID: Driver<String>
		let tools: Driver<Void>
	}
	
	// MARK: - Stored Properties / Base
	
	private let context: EditDeviceContextProtocol
	private let useCase: EditDeviceUseCaseProtocol
	let navigator: EditDeviceNavigatorProtocol

	init(
		context: EditDeviceContextProtocol,
		useCase: EditDeviceUseCaseProtocol,
		navigator: EditDeviceNavigatorProtocol
	) {
		self.context = context
		self.useCase = useCase
		self.navigator = navigator
	}

}

// MARK: - Transform

extension EditDeviceViewModel {

	func transform(input: Input) -> Output {
		let defaultDeviceName = Driver.just(context.device.name)
		let defaultDeviceUUID = Driver.just(context.device.uuid)

		let deviceName = Driver.merge(
			defaultDeviceName,
			input.nameChangingTrigger.throttle(.milliseconds(100))
		).distinctUntilChanged()

		let tools = Driver<Void>.merge(
			handleSave(
				saveTrigger: input.saveTrigger.throttle(.milliseconds(300)),
				deviceUUID: defaultDeviceUUID,
				deviceName: deviceName
			),
			handleClose(trigger: input.closeTrigger.throttle(.milliseconds(300)))
		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			deviceName: defaultDeviceName,
			deviceUUID: defaultDeviceUUID,
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension EditDeviceViewModel {

	func handleSave(
		saveTrigger: Driver<Void>,
		deviceUUID: Driver<String>,
		deviceName: Driver<String?>
	) -> Driver<Void> {
		saveTrigger.withLatestFrom(
			Driver.combineLatest(deviceUUID, deviceName)
		).do(onNext: { [weak self] params in
			self?.navigator.nextAndComplete(
				element: .init(
					uuid: params.0,
					name: params.1.flatMap { $0.isEmpty ? String?.none : $0 }
				)
			)
		}).mapToVoid()
	}

	func handleClose(trigger: Driver<Void>) -> Driver<Void> {
		trigger.do(onNext: { [weak self] in
			self?.navigator.complete()
		})
	}

}
