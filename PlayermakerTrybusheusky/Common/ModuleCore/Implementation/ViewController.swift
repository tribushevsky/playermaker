//
//  ViewController.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import UIKit
import RxSwift

open class ViewController<ViewModel: ViewModelType>: UIViewController {

	public let disposeBag = DisposeBag()
	public var viewModel: ViewModel!

	init(viewModel: ViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
		self.viewModel = viewModel
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	@available(swift, deprecated: 4.0, obsoleted: 4.0, message: "Use init(viewModel:)")
	init() { fatalError("Use init(viewModel:)") }

	@available(swift, deprecated: 4.0, obsoleted: 4.0, message: "Use init(viewModel:)")
	required public init?(coder: NSCoder) { fatalError("Use init(viewModel:)") }

	private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

}
