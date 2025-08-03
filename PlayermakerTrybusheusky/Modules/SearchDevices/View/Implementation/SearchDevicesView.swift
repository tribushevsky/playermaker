//
//  SearchDevicesView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchDevicesView: ViewController<SearchDevicesViewModel> {

	// MARK: - Stored Properties / Outlets

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var closeButton: UIButton!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		localize()
		setupBinding()
	}

}

// MARK: - Setup Binding

extension SearchDevicesView {

	private func setupView() {
		navigationController?.navigationBar.isHidden = true
	}

	private func localize() {
		titleLabel.text = L10n.SearchDevices.title
	}

	private func setupBinding() {
		let input = SearchDevicesViewModel.Input(
			didAppearTrigger: rx.viewDidAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			closeTrigger: closeButton.rx.tap.asDriver()
		)

		let output = viewModel.transform(input: input)

		output.devices.drive().disposed(by: disposeBag)
		output.tools.drive().disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: SearchDevicesView {

}
