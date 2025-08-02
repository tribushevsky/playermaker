//
//  Reuse.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import UIKit

public protocol Reusable: AnyObject {

	static var reuseIdentifier: String { get }
	static var viewBundle: Bundle? { get }

}

extension Reusable {

	public static var reuseIdentifier: String {
		return String(describing: self)
	}

	public static var viewBundle: Bundle? {
		Bundle(for: self)
	}

}

public extension Reusable where Self: UITableViewCell {

	static func registerNib(in tableView: UITableView) {
		tableView.register(
			UINib(nibName: reuseIdentifier, bundle: viewBundle),
			forCellReuseIdentifier: reuseIdentifier
		)
	}

	static func register(in tableView: UITableView) {
		tableView.register(
			self,
			forCellReuseIdentifier: reuseIdentifier
		)
	}

}

// MARK: - TableView - HeaderFooterView

public extension Reusable where Self: UITableViewHeaderFooterView {

	static func registerHeaderFooterNib(in tableView: UITableView) {
		tableView.register(
			UINib(nibName: reuseIdentifier, bundle: viewBundle),
			forHeaderFooterViewReuseIdentifier: reuseIdentifier
		)
	}

	static func registerHeaderFooter(in tableView: UITableView) {
		tableView.register(
			self,
			forHeaderFooterViewReuseIdentifier: reuseIdentifier
		)
	}

}
