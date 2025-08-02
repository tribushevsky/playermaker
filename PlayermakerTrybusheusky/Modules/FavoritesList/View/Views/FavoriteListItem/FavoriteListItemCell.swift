//
//  FavoriteListItemCell.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavoriteListItemCell: TableViewCell {

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

	fileprivate let editButton: UIButton = {
		let button = UIButton()
		button.tintColor = Colors.General.icon.color
		button.setImage(Images.Favorites.edit.image, for: .normal)

		return button
	}()

	fileprivate let deleteButton: UIButton = {
		let button = UIButton()
		button.setImage(Images.Favorites.delete.image, for: .normal)

		return button
	}()

	// MARK: - Stored Properties / View Model

	var viewModel: FavoriteListItemViewModel? {
		didSet { fillView() }
	}

	// MARK: - Lifecycle

	override func setupView() {
		super.setupView()

		backgroundColor = Colors.General.background.color

		contentView.addSubview(editButton)
		contentView.addSubview(deleteButton)
		contentView.addSubview(contentContainerView)
		contentContainerView.addSubview(titleLabel)
		contentContainerView.addSubview(subtitleLabel)
	}

	override func setupConstraints() {
		super.setupConstraints()

		editButton.snp.remakeConstraints {
			$0.height.width.equalTo(44)
			$0.centerY.equalToSuperview()
			$0.leading.equalToSuperview().offset(6)
		}

		deleteButton.snp.remakeConstraints {
			$0.height.width.equalTo(50)
			$0.centerY.equalToSuperview()
			$0.trailing.equalToSuperview().offset(-10)
		}

		contentContainerView.snp.remakeConstraints {
			$0.leading.equalTo(editButton.snp.trailing).offset(6)
			$0.top.equalToSuperview().offset(5)
			$0.bottom.equalToSuperview().offset(-5)
			$0.trailing.equalTo(deleteButton.snp.leading).offset(-10)
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
	}
}

// MARK: - Fill View

extension FavoriteListItemCell {

	private func fillView() {
		titleLabel.text = viewModel?.title
		subtitleLabel.text = viewModel?.subtitle
	}

}

// MARK: - Reactive

extension Reactive where Base: FavoriteListItemCell {

	var deleteTap: Driver<Void> {
		base.deleteButton.rx.tap
			.take(until: base.rxReuse)
			.asDriverOnErrorDoNothing()
	}

	var editTap: Driver<Void> {
		base.editButton.rx.tap
			.take(until: base.rxReuse)
			.asDriverOnErrorDoNothing()
	}

}
