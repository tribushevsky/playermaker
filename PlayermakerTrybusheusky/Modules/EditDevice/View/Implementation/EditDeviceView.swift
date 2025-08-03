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

	// MARK: - Stored Properties / Outlets

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var closeButton: UIButton!
	@IBOutlet private weak var saveButton: UIButton!
	@IBOutlet private weak var uuidTitleLabel: UILabel!
	@IBOutlet private weak var nameTitleLabel: UILabel!
	@IBOutlet private weak var uuidTextField: UITextField!
	@IBOutlet private weak var nameTextField: UITextField!
	@IBOutlet private weak var uuidContentContainerView: UIView!
	@IBOutlet private weak var nameContentContainerView: UIView!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		localize()
		setupBinding()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		saveButton.layer.cornerRadius = saveButton.bounds.height / 2
	}

}

// MARK: - Setup Binding

extension EditDeviceView {

	private func setupView() {
		setupHideKeyboardGestures()

		uuidContentContainerView.layer.cornerRadius = 10
		nameContentContainerView.layer.cornerRadius = 10
		uuidTextField.layer.cornerRadius = 4
		nameTextField.layer.cornerRadius = 4
	}

	private func setupHideKeyboardGestures() {
		let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
		endEditingGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(endEditingGesture)
	}

	private func localize() {
		typealias Loc = L10n.DeviceInfo

		titleLabel.text = Loc.title
		uuidTitleLabel.text = Loc.uuidTitle
		nameTitleLabel.text = Loc.nameTitle
		saveButton.setTitle(Loc.save, for: .normal)
	}

	private func setupBinding() {
		let input = EditDeviceViewModel.Input(
			willAppearTrigger: rx.viewWillAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			nameChangingTrigger: nameTextField.rx.text.asDriverOnErrorDoNothing(),
			saveTrigger: saveButton.rx.tap.asDriver(),
			closeTrigger: closeButton.rx.tap.asDriver()
		)

		let output = viewModel.transform(input: input)

		output.deviceUUID.drive(uuidTextField.rx.text).disposed(by: disposeBag)
		output.deviceName.drive(nameTextField.rx.text).disposed(by: disposeBag)
		output.tools.drive().disposed(by: disposeBag)
	}

	@objc private func endEditing() {
		view.endEditing(true)
	}

}
