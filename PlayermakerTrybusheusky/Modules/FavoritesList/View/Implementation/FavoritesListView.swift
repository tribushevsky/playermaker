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
	@IBOutlet fileprivate weak var sortNameButton: UIButton!
	@IBOutlet fileprivate weak var sortUUIDButton: UIButton!
	@IBOutlet fileprivate weak var favoritesListContainerView: UIView!
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

		[mainButton, sortNameButton, sortUUIDButton].forEach {
			$0?.layer.cornerRadius = ($0?.bounds.height ?? 0) / 2
		}
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
		sortNameButton.setTitle(Loc.Sort.name, for: .normal)
		sortUUIDButton.setTitle(Loc.Sort.uuid, for: .normal)
	}

	private func setupBinding() {
		let input = FavoritesListViewModel.Input(
			willAppearTrigger: rx.viewWillAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			searchDevicesTrigger: mainButton.rx.tap.asDriver(),
			sortByNameTrigger: sortNameButton.rx.tap.asDriver(),
			sortByUUIDTrigger: sortUUIDButton.rx.tap.asDriver()
		)

		let output = viewModel.transform(input: input)

		output.sortMode.drive(rx.sortMode).disposed(by: disposeBag)
		output.favorites.map { !$0.isEmpty }.drive(rx.isFavoritesVisible).disposed(by: disposeBag)
		output.tools.drive().disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: FavoritesListView {

	var sortMode: Binder<FavoritesListSortMode> {
		Binder(base) { view, sortMode in
			switch sortMode {
			case .name:
				view.sortNameButton.backgroundColor = Colors.General.highlight.color
				view.sortUUIDButton.backgroundColor = Colors.General.unselected.color
			case .uuid:
				view.sortNameButton.backgroundColor = Colors.General.unselected.color
				view.sortUUIDButton.backgroundColor = Colors.General.highlight.color
			}
		}
	}

	var isFavoritesVisible: Binder<Bool> {
		Binder(base) { view, isFavoritesVisible in
			view.favoritesListContainerView.isHidden = !isFavoritesVisible
			view.placeholderView.isHidden = isFavoritesVisible
		}
	}

}
