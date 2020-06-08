//
//  SoftCardItem.swift
//  SoftUI
//
//  Created by Ivan Manov on 05.06.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import UIKit

public struct SoftCardItemModel {
    public init() {}

    public var image: UIImage?
    public var title: String?
    public var description: String?
    public var actionTitle: String?
    public var actionHandler: ((_ sender: Any) -> Void)?
}

@IBDesignable
public class SoftCardItem: UIView {
    var view: UIView!
    var model: SoftCardItemModel!

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var actionButton: UIButton?

    // MARK: Init methods

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewFromNib()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadViewFromNib()
    }

    private func loadViewFromNib() {
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(view)
            self.view = view
        }
    }

    // MARK: Configure

    public func configure(with model: SoftCardItemModel) {
        self.model = model
        self.updateUI()
    }

    // MARK: Private methods

    private func updateUI() {
        guard let model = self.model else { return }

        self.imageView?.image = model.image
        self.imageView?.isHidden = model.image == nil
        self.titleLabel?.text = model.title
        self.titleLabel?.isHidden = model.title == nil
        self.descLabel?.text = model.description
        self.descLabel?.isHidden = model.description == nil
        self.actionButton?.setTitle(model.actionTitle, for: .normal)
        self.actionButton?.isHidden = model.actionTitle == nil
    }

    // MARK: UIActions

    @IBAction func onActionButtonTap(_ sender: Any) {
        self.model?.actionHandler?(sender)
    }
}
