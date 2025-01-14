//
//  UICollectionView.swift
//  FaceReader
//
//  Created by COBY_PRO on 2023/04/29.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.className,
            for: indexPath
        ) as? T
        else {
            fatalError("Could not find cell with reuseID \(T.className)")
        }
        return cell
    }

    func dequeueHeaderView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.className,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.className)")
        }
        return view
    }

    func dequeueFooterView<T: UICollectionReusableView>(forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: T.className,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.className)")
        }
        return view
    }

    func register<T: UICollectionViewCell>(
        cell: T.Type,
        forCellWithReuseIdentifier reuseIdentifier: String = T.className
    ) {
        register(cell, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
