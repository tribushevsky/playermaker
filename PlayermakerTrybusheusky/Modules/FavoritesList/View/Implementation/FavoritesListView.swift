//
//  FavoritesListView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoritesListView: ViewController<FavoritesListViewModel> {

	// MARK: - Stored Views / Outlets

	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var mainButton: UIButton!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		localize()
		setupBinding()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		mainButton.layer.cornerRadius = mainButton.bounds.height / 2
	}

}

// MARK: - Setup Binding

extension FavoritesListView {

	private func setupView() {
		tableView.contentInset.bottom = 140
	}

	private func localize() {
		mainButton.setTitle(
			L10n.FavoritesList.mainButton,
			for: .normal
		)
	}

	private func setupBinding() {
		let input = FavoritesListViewModel.Input(
			willAppearTrigger: rx.viewWillAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			searchDevicesTrigger: mainButton.rx.tap.asDriver()
		)
		let output = viewModel.transform(input: input)
		output.tools.drive().disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: FavoritesListView {

}
