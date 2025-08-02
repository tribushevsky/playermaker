//
//  UITableView+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 02/08/2025.
//

import UIKit

extension UITableView {

	func scrollToTop(animated: Bool) {
		let numberOfSections = self.numberOfSections
		let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)

		guard numberOfSections > 0, numberOfRows > 0 else {
			return
		}

		let indexPath = IndexPath(row: 0, section: 0)
		self.scrollToRow(at: indexPath, at: .top, animated: animated)
	}

}
