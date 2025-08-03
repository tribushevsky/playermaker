//
//  SearchDevicesView.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchDevicesView: ViewController<SearchDevicesViewModel> {

	// MARK: - Stored Properties / Outlets

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var closeButton: UIButton!
	@IBOutlet fileprivate weak var devicesListContainerView: UIView!
	@IBOutlet fileprivate weak var contentPlaceholderView: UIView!
	@IBOutlet fileprivate weak var devicesTableView: UITableView!
	@IBOutlet fileprivate weak var sortByNameButton: UIButton!
	@IBOutlet fileprivate weak var sortByRSSIButton: UIButton!

	// MARK: - Stored Properties / State

	let itemFavoriteSelectRelay = PublishRelay<SearchDevicesItemViewModel>()

	private(set) lazy var dataSource: RxTableViewSectionedAnimatedDataSource<SearchDevicesSection> = { [unowned self] in
		RxTableViewSectionedAnimatedDataSource<SearchDevicesSection>(
			animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .left),
			configureCell: { _, tableView, indexPath, viewModel in
				let cell = tableView.dequeueReusableCell(withIdentifier: SearchDevicesItemCell.reuseIdentifier, for: indexPath)

				if let deviceCell = cell as? SearchDevicesItemCell {
					deviceCell.viewModel = viewModel
					deviceCell.rx.favoriteTap.map { viewModel }
						.drive(self.rx.itemFavoriteTap)
						.disposed(by: self.disposeBag)
				}

				return cell
			}
		)
	}()
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		localize()
		setupBinding()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		[sortByNameButton, sortByRSSIButton].forEach {
			$0?.layer.cornerRadius = ($0?.bounds.height ?? 0) / 2
		}
	}


}

// MARK: - Setup Binding

extension SearchDevicesView {

	private func setupView() {
		SearchDevicesItemCell.register(in: devicesTableView)

		navigationController?.navigationBar.isHidden = true
	}

	private func localize() {
		typealias Loc = L10n.SearchDevices

		titleLabel.text = Loc.title
		sortByNameButton.setTitle(Loc.Sort.name, for: .normal)
		sortByRSSIButton.setTitle(Loc.Sort.rssi, for: .normal)
	}

	private func setupBinding() {
		let input = SearchDevicesViewModel.Input(
			didAppearTrigger: rx.viewDidAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			sortByNameTrigger: sortByNameButton.rx.tap.asDriver(),
			sortByRSSITrigger: sortByRSSIButton.rx.tap.asDriver(),
			closeTrigger: closeButton.rx.tap.asDriver(),
			toggleFavoriteTrigger: itemFavoriteSelectRelay.asDriverOnErrorDoNothing()
		)

		let output = viewModel.transform(input: input)

		output.sortMode.drive(rx.sortMode).disposed(by: disposeBag)
		output.devices.map { !$0.isEmpty }.drive(rx.isDevicesVisible).disposed(by: disposeBag)
		output.devices.map {[SearchDevicesSection(items: $0)] }
			.drive(devicesTableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)

		output.tools.drive().disposed(by: disposeBag)
	}

}

// MARK: - Reactive

extension Reactive where Base: SearchDevicesView {

	var itemFavoriteTap: Binder<SearchDevicesItemViewModel> {
		Binder(base) { $0.itemFavoriteSelectRelay.accept($1) }
	}

	var sortMode: Binder<SearchDevicesSortMode> {
		Binder(base) { view, sortMode in
			view.devicesTableView.scrollToTop(animated: false)

			switch sortMode {
			case .name:
				view.sortByNameButton.backgroundColor = Colors.General.highlight.color
				view.sortByRSSIButton.backgroundColor = Colors.General.unselected.color
			case .rssi:
				view.sortByNameButton.backgroundColor = Colors.General.unselected.color
				view.sortByRSSIButton.backgroundColor = Colors.General.highlight.color
			}
		}
	}

	var isDevicesVisible: Binder<Bool> {
		Binder(base) { view, isFavoritesVisible in
			view.devicesListContainerView.isHidden = !isFavoritesVisible
			view.contentPlaceholderView.isHidden = isFavoritesVisible
		}
	}

}
