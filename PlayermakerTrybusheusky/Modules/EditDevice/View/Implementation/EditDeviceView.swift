//
//  EditDeviceView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class EditDeviceView: ViewController<EditDeviceViewModel> {

	// MARK: - Stored Views / Outlets

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		localize()
		setupBinding()
	}

}

// MARK: - Setup Binding

extension EditDeviceView {

	private func setupView() {

	}

	private func localize() {

	}

	private func setupBinding() {
		let input = EditDeviceViewModel.Input(
			willAppearTrigger: rx.viewWillAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid()
		)
		let output = viewModel.transform(input: input)

		output.tools.drive().disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: EditDeviceView {

}
