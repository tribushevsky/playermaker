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

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var placeholderView: UIView!
	@IBOutlet private weak var placeholderTitleLabel: UILabel!
	@IBOutlet fileprivate weak var tableView: UITableView!
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
		typealias Loc = L10n.FavoritesList

		titleLabel.text = Loc.title
		placeholderTitleLabel.text = Loc.placeholder
		mainButton.setTitle(Loc.mainButton, for: .normal)
	}

	private func setupBinding() {
		let input = FavoritesListViewModel.Input(
			willAppearTrigger: rx.viewWillAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			searchDevicesTrigger: mainButton.rx.tap.asDriver()
		)
		let output = viewModel.transform(input: input)

		output.favorites.map { !$0.isEmpty }.drive(rx.isFavoritesVisible).disposed(by: disposeBag)
		output.tools.drive().disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: FavoritesListView {

	var isFavoritesVisible: Binder<Bool> {
		Binder(base) { view, isFavoritesVisible in
			view.tableView.isHidden = !isFavoritesVisible
			view.placeholderView.isHidden = isFavoritesVisible
		}
	}

}
