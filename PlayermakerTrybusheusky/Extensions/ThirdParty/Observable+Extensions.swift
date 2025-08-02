//
//  Observable+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
	func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
		map { _ in }
	}
}

extension ObservableType {

	public func catchErrorJustComplete() -> Observable<Element> {
		self.catch { _ in
			Observable.empty()
		}
	}

	public func asDriverOnErrorJustComplete() -> Driver<Element> {
		asDriver { error in
			Driver.empty()
		}
	}

	public func asDriverOnErrorDoNothing() -> Driver<Element> {
		asDriver { error in
			Driver.never()
		}
	}

	public func asSignalOnErrorJustComplete() -> Signal<Element> {
		asSignal { error in
			Signal.empty()
		}
	}

	public func asSignalOnErrorDoNothing() -> Signal<Element> {
		asSignal { _ in
			Signal.never()
		}
	}

	public func mapToVoid() -> Observable<Void> {
		map { _ in }
	}

	public func asBoolDriver() -> Driver<Bool> {
		map { _ in true}.asDriver(onErrorJustReturn: false)
	}

	public func withPrevious(startWith defaultValue: Element) -> Observable<(current: Element, previous: Element)> {
		scan((defaultValue, defaultValue)) { previous, current in
			(current, previous.0)
		}
	}

	public func wrapWithFlag(initialFlag: Bool) -> Observable<(Element, flag: Bool)> {
			return self.scan((true, initialFlag, nil as Element?)) { (state, element) in
				// state.0: isFirst
				// state.1: initialFlag
				// state.2: previous element (not used in this case)
				return (false, state.1, element)
			}
			.map { ($0.2!, flag: $0.0 ? $0.1 : !$0.1) } // Create the tuple with the current element and the appropriate flag
		}

	public static func wrapError(_ error: Error) -> Observable<Element> {
		Observable.error(error)
	}

	public static func fatalEmpty(msg: String) -> Observable<Element> {
		#if DEBUG
		fatalError(msg)
		#else
		return Observable.empty()
		#endif
	}

	public static func fatalNever(msg: String) -> Observable<Element> {
		#if DEBUG
		fatalError(msg)
		#else
		return Observable.never()
		#endif
	}
}

extension ObservableType where Element: OptionalType {
	func unwrappedNever() -> Observable<Element.Wrapped> {
		flatMap { value -> Observable<Element.Wrapped> in
			guard let value = value.asOptional else {
				return Observable.never()
			}

			return Observable.just(value)
		}
	}
}
