//
//  LaunchView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class LaunchView: ViewController<LaunchViewModel> {

	// MARK: - Stored Properties / Outlets

	@IBOutlet fileprivate weak var contentContainerView: UIView!
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupBinding()
	}

}

// MARK: - Setup Binding

extension LaunchView {
	
	private func setupBinding() {
		let input = LaunchViewModel.Input(
			willAppearTrigger: rx.viewWillAppear.asDriverOnErrorDoNothing()
		)
		let output = viewModel.transform(input: input)

		output.developerName.drive(titleLabel.rx.text).disposed(by: disposeBag)
		output.isAnimationActive
			.wrapWithFlag(initialFlag: false)
			.drive(rx.isAnimationActive).disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: LaunchView {

	var isAnimationActive: Binder<(Bool, flag: Bool)> {
		Binder(base) { view, data in
			let updates = {
				view.contentContainerView.alpha = data.0 ? 1 : 0
			}

			guard data.flag else {
				updates()

				return
			}

			UIView.animate(withDuration: 0.7) {
				updates()
			}
		}
	}

}
