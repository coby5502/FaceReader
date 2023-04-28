//
//  MainViewController.swift
//  FaceReader
//
//  Created by COBY_PRO on 2023/04/28.
//

import UIKit

final class MainViewController: BaseViewController {
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 4.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = 60
        static let collectionInset = UIEdgeInsets(
            top: collectionVerticalSpacing,
            left: collectionHorizontalSpacing,
            bottom: collectionVerticalSpacing,
            right: collectionHorizontalSpacing
        )
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.logo.resize(to: CGSize(width: 30, height: 30))
        return imageView
    }()
    
    private let helpButton = HelpButton()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(
            ImageLiterals.btnCamera.resize(to: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .white
        button.layer.cornerRadius = 30
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(FaceDetectionViewController(), animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = 10
        return flowLayout
    }()

    private lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            cell: RankCollectionViewCell.self,
            forCellWithReuseIdentifier: RankCollectionViewCell.className
        )
        return collectionView
    }()
    
    override func setupLayout() {
        view.addSubviews(listCollectionView, cameraButton)
        
        let listCollectionViewConstraints = [
            listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let cameraButtonConstraints = [
            cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cameraButton.widthAnchor.constraint(equalToConstant: 70),
            cameraButton.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        [listCollectionViewConstraints, cameraButtonConstraints]
            .forEach { constraints in
                NSLayoutConstraint.activate(constraints)
            }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "LEADER BOARD"
        let logoImageView = makeBarButtonItem(with: logoImageView)
        let helpButton = makeBarButtonItem(with: helpButton)
        navigationItem.leftBarButtonItem = logoImageView
        navigationItem.rightBarButtonItem = helpButton
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RankCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        cell.rankLabel.text = "\(indexPath.item + 1)"
        cell.nicknameLabel.text = "바보"
        cell.gradeLabel.text = "신"
        cell.moneyLabel.text = "30,000"

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let viewController = MeetingDetailViewController(meeting: meetings[indexPath.item])
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
    }
}
