//
//  TableViewCell.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import UIKit
import RxSwift
import RxCocoa

open class TableViewCell: UITableViewCell, Reusable {

	var rxReuse: Observable<[Any]> {
		get { rx.sentMessage(#selector(prepareForReuse)) }
	}

	var disposeBag = DisposeBag()

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupView()
		setNeedsUpdateConstraints()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
		setNeedsUpdateConstraints()
	}

	override open func updateConstraints() {
		setupConstraints()
		super.updateConstraints()
	}

	public override func prepareForReuse() {
		super.prepareForReuse()

		disposeBag = DisposeBag()
	}

	open func setupView() { }
	open func setupConstraints() { }

}
