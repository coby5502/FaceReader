//
//  FaceResultViewController.swift
//  FaceReader
//
//  Created by COBY_PRO on 2022/08/23.
//

import UIKit

import Lottie

final class FaceResultViewController: BaseViewController {
    var nickname: String = ""
    
    private enum Size {
        static let wantedWidth: CGFloat = UIScreen.main.bounds.size.width
        static let wantedHeight: CGFloat = wantedWidth * 1.8
        static let imageWidth: CGFloat = UIScreen.main.bounds.size.width - 40
        static let imageHeight: CGFloat = imageWidth * 0.8
    }
    
    private let loading: AnimationView = .init(name: "loading")
    
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainText.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.text = "공유"
        label.textColor = .mainText
        label.font = .font(.regular, ofSize: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapShareLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private let scrollView : UIScrollView! = UIScrollView()
    private let contentView : UIView! = UIView()
    
    private let wantedLabel: UILabel = {
        let label = UILabel()
        label.text = "WANTED"
        label.font = .font(.regular, ofSize: 100)
        label.textColor = .mainBlack
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let faceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FaceManager.cartoonImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.mainBlack.cgColor
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let deadOrLiveLabel: UILabel = {
        let label = UILabel()
        label.text = "DEAD OR ALIVE"
        label.font = .font(.regular, ofSize: 60)
        label.textColor = .mainBlack
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .font(.regular, ofSize: 60)
        label.textColor = .mainBlack
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(gradeData[FaceManager.grade]["grade"]!): \(gradeData[FaceManager.grade]["info"]!)"
        label.font = .font(.regular, ofSize: 25)
        label.textColor = .mainBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "$\(numberFormatter(number: FaceManager.totalScore))"
        label.font = .font(.regular, ofSize: 50)
        label.textColor = .mainBlack
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var enrollButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainText.withAlphaComponent(0.5)
        button.setTitle("괴인 등록", for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 22)
        let action = UIAction { [weak self] _ in
            self?.enrollButtonTouched()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else { return }
        self.nickname = nickname
        nicknameLabel.text = "「\(nickname)」"
    }
    
    override func setupLayout() {
        view.addSubviews(scrollView, enrollButton, coverView, loading)
        loading.isHidden = true
        coverView.isHidden = true
        scrollView.addSubviews(contentView)
        contentView.addSubviews(wantedLabel, faceImageView, deadOrLiveLabel, nicknameLabel, gradeLabel, scoreLabel)
        contentView.backgroundColor = UIColor(patternImage: ImageLiterals.background)
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        scrollView.showsVerticalScrollIndicator = false
        
        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: enrollButton.topAnchor)
        ]
        
        let contentViewConstraints = [
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: Size.wantedHeight)
        ]
        
        let wantedLabelConstraints = [
            wantedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            wantedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            wantedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ]
        
        let faceImageViewConstraints = [
            faceImageView.topAnchor.constraint(equalTo: wantedLabel.bottomAnchor),
            faceImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            faceImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            faceImageView.heightAnchor.constraint(equalToConstant: Size.imageHeight)
        ]
        
        let deadOrLiveLabelConstraints = [
            deadOrLiveLabel.topAnchor.constraint(equalTo: faceImageView.bottomAnchor),
            deadOrLiveLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deadOrLiveLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ]
        
        let nicknameLabelConstraints = [
            nicknameLabel.topAnchor.constraint(equalTo: deadOrLiveLabel.bottomAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nicknameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ]
        
        let gradeLabelConstraints = [
            gradeLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor),
            gradeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            gradeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ]
        
        let scoreLabelConstraints = [
            scoreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ]
        
        let enrollButtonConstraints = [
            enrollButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            enrollButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            enrollButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            enrollButton.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let coverViewConstraints = [
            coverView.topAnchor.constraint(equalTo: view.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let loadingConstraints = [
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        [
            scrollViewConstraints,
            contentViewConstraints,
            wantedLabelConstraints,
            faceImageViewConstraints,
            deadOrLiveLabelConstraints,
            nicknameLabelConstraints,
            gradeLabelConstraints,
            scoreLabelConstraints,
            enrollButtonConstraints,
            coverViewConstraints,
            loadingConstraints
        ].forEach { constraints in
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let shareLabelView = makeBarButtonItem(with: shareLabel)
        navigationItem.rightBarButtonItem = shareLabelView
        title = "괴인 측정 결과"
    }
    
    private func enrollMonster(password: String) {
        Task { [weak self] in

            self?.coverView.isHidden = false
            self?.loading.isHidden = false
            self?.loading.play()

            await FirebaseManager.shared.createMonster(nickname: self?.nickname ?? "무명의 괴인", password: password, image: (self?.contentView.asImage())!)

            self?.coverView.isHidden = true
            self?.loading.pause()
            self?.loading.isHidden = true
            self?.showToast(message: "괴인 등록 완료")
        }
    }
    
    @objc private func didTapShareLabel(sender: UITapGestureRecognizer) {
        let wantedImage = contentView.asImage()
        var shareObject = [UIImage]()
        
        shareObject.append(wantedImage)
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.markupAsPDF
        ]

        self.present(activityViewController, animated: true)
    }
    
    private func enrollButtonTouched() {
        let alert = UIAlertController(
            title: "괴인 등록",
            message: """
리더보드에서 수배서를 보려면,
설정한 비밀번호를 입력해야 합니다.
""",
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "확인", style: .default) { (ok) in
            guard let password = alert.textFields?[0].text,
                  password.count != 0
            else {
                self.showToast(message: "비밀번호를 다시 입력해주세요")
                return
            }
            self.enrollMonster(password: password)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { (cancel) in }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        alert.addTextField { (passwordField) in
            passwordField.keyboardType = .numberPad
            passwordField.placeholder = "비밀번호"
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
