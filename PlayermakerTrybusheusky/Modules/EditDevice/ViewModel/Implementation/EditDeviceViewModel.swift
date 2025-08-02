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
	}
	struct Output {
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
		let tools = Driver<Void>.merge(

		).take(until: input.willDismissTrigger.take(1).asObservable())

		return Output(
			tools: tools
		)
	}
	
}

// MARK: - Handlers

extension EditDeviceViewModel {

}
