//
//  Window.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 01/08/2025.
//

import UIKit
import RxSwift

open class Window<ViewModel: ViewModelType>: UIWindow {

	public let disposeBag = DisposeBag()
	public var viewModel: ViewModel!

	init(viewModel: ViewModel, windowScene: UIWindowScene) {
		self.viewModel = viewModel

		super.init(windowScene: windowScene)
	}

	@available(swift, deprecated: 1.0, obsoleted: 1.0, message: "Use init(viewModel:, windowScene:)")
	override init(windowScene: UIWindowScene) { fatalError("Use init(viewModel:, windowScene:)") }

	@available(swift, deprecated: 4.0, obsoleted: 4.0, message: "Use init(viewModel:, windowScene:)")
	required public init?(coder: NSCoder) { fatalError("Use init(viewModel:, windowScene:)") }

}
