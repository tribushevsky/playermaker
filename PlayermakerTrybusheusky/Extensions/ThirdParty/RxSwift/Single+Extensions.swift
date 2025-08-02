//
//  Single+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import RxSwift
import RxCocoa

extension Single {

	func asDriverOnErrorJustComplete() -> Driver<Element> {
		return asDriver { error in
			return Driver.empty()
		}
	}

	func asDriverOnErrorDoNothing() -> Driver<Element> {
		return asDriver { error in
			return Driver.never()
		}
	}

	public static func fatalNever(msg: String) -> Single<Element> {
		#if DEBUG
		fatalError(msg)
		#else
		return Single.never()
		#endif
	}
}
