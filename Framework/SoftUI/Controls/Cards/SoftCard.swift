//
//  SoftCard.swift
//  SoftUI
//
//  Created by Ivan Manov on 05.06.2020.
//  Copyright © 2020 hellc. All rights reserved.
//

import UIKit

@IBDesignable
public class SoftCard: UIView {
    var view: UIView!
    public var items = [UIView]() {
        didSet {
            self.updateUI()
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK: Init methods

    override init(frame: CGRect) {
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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }

    // MARK: Public methods

    public func update(with items: [UIView]) {
        self.items.removeAll()
        self.items.append(contentsOf: items)

        self.updateUI()
    }

    // MARK: Private methods

    private func updateUI() {
        self.scrollView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        self.pageControl.isHidden = self.items.count <= 1
        self.pageControl.numberOfPages = self.items.count

        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.scrollView.contentSize = CGSize(width: self.bounds.width * CGFloat(self.items.count),
                                             height: self.bounds.height)
        self.scrollView.isPagingEnabled = true

        for itemIndex in 0 ..< self.items.count {
            self.items[itemIndex].frame = CGRect(x: self.bounds.width * CGFloat(itemIndex),
                                                 y: 0,
                                                 width: self.bounds.width,
                                                 height: self.bounds.height)
            self.scrollView.addSubview(self.items[itemIndex])
        }

        self.layoutIfNeeded()
    }
}

// MARK: UIScrollViewDelegate

extension SoftCard: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / self.bounds.width)
        self.pageControl.currentPage = Int(pageIndex)
    }
}
