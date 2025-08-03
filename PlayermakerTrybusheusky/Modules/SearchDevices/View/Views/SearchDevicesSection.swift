//
//  SearchDevicesSection.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 03/08/2025.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SearchDevicesSection {

	var items: [SearchDevicesItemViewModel]

}

extension SearchDevicesSection: AnimatableSectionModelType {

	var identity: some Hashable {
		""
	}

	init(original: SearchDevicesSection, items: [SearchDevicesItemViewModel]) {
		self = original
		self.items = items
	}

}

extension SearchDevicesItemViewModel: IdentifiableType, Equatable {

	var identity: some Hashable {
		title + subtitle
	}


	static func == (lhs: SearchDevicesItemViewModel, rhs: SearchDevicesItemViewModel) -> Bool {
		lhs.title == rhs.title &&
		lhs.subtitle == rhs.subtitle &&
		lhs.isFavorite == rhs.isFavorite &&
		lhs.rssi == rhs.rssi
	}

}
