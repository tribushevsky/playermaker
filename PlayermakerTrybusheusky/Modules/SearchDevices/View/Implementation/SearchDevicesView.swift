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
	@IBOutlet private weak var devicesTableView: UITableView!

	// MARK: - Stored Properties / State

	let itemFavoriteSelectRelay = PublishRelay<SearchDevicesItemViewModel>()

	private(set) lazy var dataSource: RxTableViewSectionedReloadDataSource<SearchDevicesSection> = { [unowned self] in
		RxTableViewSectionedReloadDataSource<SearchDevicesSection>  { _, tableView, indexPath, viewModel in
			let cell = tableView.dequeueReusableCell(withIdentifier: SearchDevicesItemCell.reuseIdentifier, for: indexPath)

			if let deviceCell = cell as? SearchDevicesItemCell {
				deviceCell.viewModel = viewModel
				deviceCell.rx.favoriteTap.map { viewModel }
					.drive(self.rx.itemFavoriteTap)
					.disposed(by: self.disposeBag)
			}
			
			return cell
		}
	}()
	
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
		SearchDevicesItemCell.register(in: devicesTableView)

		navigationController?.navigationBar.isHidden = true
	}

	private func localize() {
		titleLabel.text = L10n.SearchDevices.title
	}

	private func setupBinding() {
		let input = SearchDevicesViewModel.Input(
			didAppearTrigger: rx.viewDidAppear.asDriverOnErrorDoNothing(),
			willDismissTrigger: rx.willBeingDismissed.asDriver(onErrorJustReturn: true).filter { $0 }.mapToVoid(),
			closeTrigger: closeButton.rx.tap.asDriver(),
			toggleFavoriteTrigger: itemFavoriteSelectRelay.asDriverOnErrorDoNothing()
		)

		let output = viewModel.transform(input: input)

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

	var isDevicesVisible: Binder<Bool> {
		Binder(base) { view, isFavoritesVisible in
			view.devicesListContainerView.isHidden = !isFavoritesVisible
			view.contentPlaceholderView.isHidden = isFavoritesVisible
		}
	}

}
