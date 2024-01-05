//
//  AutoSizingCollectionView.swift
//  FakeNFT
//
//  Created by Ян Максимов on 27.12.2023.
//

import UIKit

class ResizableCollectionView: UICollectionView {
    
    // MARK: - Override Content Size
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Override Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + contentInset.top + contentInset.bottom)
    }
}
