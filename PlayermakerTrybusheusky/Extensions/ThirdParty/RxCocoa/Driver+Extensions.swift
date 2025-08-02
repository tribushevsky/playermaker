//
//  Driver+Extensions.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import RxSwift
import RxCocoa

extension Driver {

	public static func fatalEmpty(msg: String) -> Driver<Element> {
		#if DEBUG
		fatalError(msg)
		#else
		return Driver.empty()
		#endif
	}

	public static func fatalNever(msg: String) -> Driver<Element> {
		#if DEBUG
		fatalError(msg)
		#else
		return Driver.never()
		#endif
	}

	public func take(_ count: Int) -> Driver<Element> {
		self.asObservable().take(count).asDriverOnErrorDoNothing()
	}

	public func take(until: some ObservableType) -> Driver<Element> {
		self.asObservable().take(until: until.asObservable()).asDriverOnErrorDoNothing()
	}

	public func withPrevious(startWith defaultValue: Element) -> Driver<(current: Element, previous: Element)> {
		asObservable()
			.scan((defaultValue, defaultValue)) { previous, current in
				(current, previous.0)
			}
			.asDriver(onErrorDriveWith: .empty())
	}

	func wrapWithFlag(initialFlag: Bool) -> Driver<(Element, flag: Bool)> {
		scan((-1, nil as Element?)) { (state, element) in (state.0 + 1, element) }
			.map { ($0.1!, $0.0 > 0 ? !initialFlag : initialFlag) }
			.asDriverOnErrorDoNothing()
	}

	public func asSignalOnErrorJustComplete() -> Signal<Element> {
		asSignal { _ in
			Signal.empty()
		}
	}

	public func asSignalOnErrorDoNothing() -> Signal<Element> {
		asSignal { _ in
			Signal.never()
		}
	}

}

extension Driver where Element: OptionalType {
	func unwrappedNever() -> Driver<Element.Wrapped> {
		flatMap { value in
			guard let value = value.asOptional else {
				return Driver.never()
			}

			return Driver.just(value)
		}
	}
}
