//
//  SearchDevicesItemCell.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 03/08/2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchDevicesItemCell: TableViewCell {

	// MARK: - Stored Properties / Views

	private let contentContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.General.itemBackground.color
		view.layer.masksToBounds = true
		view.layer.cornerRadius = 10

		return view
	}()

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = Colors.General.title.color
		label.font = FontFamily.Nunito.bold.font(size: 16)

		return label
	}()

	private let subtitleLabel: UILabel = {
		let label = UILabel()
		label.textColor = Colors.General.subtitle.color
		label.font = FontFamily.Nunito.regular.font(size: 12)

		return label
	}()

	private let rssiContentContainerView: UIView = {
		let view = UIView()
		view.backgroundColor = Colors.General.highlight.color
		view.layer.masksToBounds = true
		view.layer.cornerRadius = 10

		return view
	}()

	private let rssiTitleLabel: UILabel = {
		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.7
		label.textAlignment = .center
		label.textColor = Colors.General.accentLight.color.withAlphaComponent(0.5)
		label.font = FontFamily.Nunito.bold.font(size: 12)
		label.text = L10n.SearchDevices.Item.rssiTitle

		return label
	}()

	private let rssiValueLabel: UILabel = {
		let label = UILabel()
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = 0.7
		label.textAlignment = .center
		label.textColor = Colors.General.accentLight.color
		label.font = FontFamily.Nunito.regular.font(size: 16)

		return label
	}()

	fileprivate let favoriteButton: UIButton = {
		let button = UIButton()
		button.tintColor = Colors.General.icon.color
		button.setImage(Images.SearchDevice.favorite.image, for: .normal)
		button.tintColor = Colors.General.icon.color

		return button
	}()

	// MARK: - Stored Properties / View Model

	var viewModel: SearchDevicesItemViewModel? {
		didSet { fillView() }
	}

	// MARK: - Lifecycle

	override func setupView() {
		super.setupView()

		backgroundColor = Colors.General.background.color

		contentView.addSubview(favoriteButton)
		contentView.addSubview(contentContainerView)
		contentContainerView.addSubview(titleLabel)
		contentContainerView.addSubview(subtitleLabel)
		contentContainerView.addSubview(rssiContentContainerView)
		rssiContentContainerView.addSubview(rssiTitleLabel)
		rssiContentContainerView.addSubview(rssiValueLabel)
	}

	override func setupConstraints() {
		super.setupConstraints()

		favoriteButton.snp.remakeConstraints {
			$0.height.width.equalTo(44)
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().offset(6)
		}

		contentContainerView.snp.remakeConstraints {
			$0.leading.equalTo(favoriteButton.snp.trailing).offset(6)
			$0.top.equalToSuperview().offset(5)
			$0.bottom.equalToSuperview().offset(-5)
			$0.trailing.equalToSuperview().offset(-10)
		}

		titleLabel.snp.remakeConstraints {
			$0.leading.equalToSuperview().offset(10)
			$0.trailing.equalToSuperview().offset(-10)
			$0.bottom.equalTo(contentContainerView.snp.centerY).offset(-3)
		}

		subtitleLabel.snp.remakeConstraints {
			$0.leading.equalToSuperview().offset(10)
			$0.trailing.equalToSuperview().offset(-10)
			$0.top.equalTo(contentContainerView.snp.centerY).offset(3)
		}

		rssiContentContainerView.snp.remakeConstraints {
			$0.top.trailing.bottom.equalToSuperview()
			$0.width.equalTo(rssiContentContainerView.snp.height)
		}

		rssiTitleLabel.snp.remakeConstraints {
			$0.leading.equalToSuperview().offset(2)
			$0.trailing.equalToSuperview().offset(-2)
			$0.centerY.equalTo(titleLabel)
		}

		rssiValueLabel.snp.remakeConstraints {
			$0.leading.equalToSuperview().offset(2)
			$0.trailing.equalToSuperview().offset(-2)
			$0.centerY.equalTo(subtitleLabel)
		}
	}
}

// MARK: - Fill View

extension SearchDevicesItemCell {

	private func fillView() {
		if viewModel?.isFavorite == true {
			contentContainerView.backgroundColor = Colors.General.accentYellow.color.withAlphaComponent(0.7)
			favoriteButton.tintColor = Colors.General.accentYellow.color
		} else {
			contentContainerView.backgroundColor = Colors.General.itemBackground.color
			favoriteButton.tintColor = Colors.General.icon.color
		}

		titleLabel.text = viewModel?.title
		subtitleLabel.text = viewModel?.subtitle
		rssiValueLabel.text = viewModel?.rssi.map { "\($0)" } ?? ""
		rssiContentContainerView.isHidden = viewModel?.rssi == nil
	}

}

// MARK: - Reactive

extension Reactive where Base: SearchDevicesItemCell {

	var favoriteTap: Driver<Void> {
		base.favoriteButton.rx.tap
			.take(until: base.rxReuse)
			.asDriverOnErrorDoNothing()
	}

}
