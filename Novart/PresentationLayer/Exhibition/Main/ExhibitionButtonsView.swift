import UIKit
import SnapKit
import Combine

protocol ExhibitionButtonsViewDelegate: AnyObject {
    func didTapLikeButton(shouldLike: Bool)
    func didTapCommentButton()
    func didTapShareButton()
    func didTapGuideButton()
    func shouldShowLogin()
}

final class ExhibitionButtonsView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor = UIColor.white.withAlphaComponent(0.65)
        static let spacing: CGFloat = 8
        
        enum Common {
            static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
            static let textColor = UIColor.Common.warmGrey04
            static let cornerRadius: CGFloat = 18
        }
        
        enum LikeView {
            enum ImageView {
                static let leftMargin: CGFloat = 12
                static let diameter: CGFloat = 24
            }
            
            enum Label {
                static let leftMargin: CGFloat = 4
            }
        }
        
        enum CommentView {
            enum ImageView {
                static let leftMargin: CGFloat = 12
                static let diameter: CGFloat = 24
            }
            
            enum Label {
                static let leftMargin: CGFloat = 4
            }
        }
        
        enum ShareView {
            static let width: CGFloat = 80
            
            enum ImageView {
                static let width: CGFloat = 24
                static let height: CGFloat = 24
                static let leftMargin: CGFloat = 12
            }
            
            enum Label {
                static let text: String = "공유"
                static let leftMargin: CGFloat = 4
            }
        }
        
        enum GuideView {
            static let text: String = "전시 안내"
            static let width: CGFloat = 83
        }
    }
    
    // MARK: - Properties
    private var viewModel: ExhibitionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    weak var delegate: ExhibitionButtonsViewDelegate?
    
    // MARK: - LifeCycle
    init(viewModel: ExhibitionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setUpView()
        setUpBindings()
        setUpGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialData() {
        likeCountLabel.text = "0"
        self.likeView.snp.removeConstraints()
        let likeViewWidth = self.likeCountLabel.bounds.width + 52
        self.likeView.snp.makeConstraints({ m in
            m.width.equalTo(likeViewWidth)
        })
        self.likeHeartImageView.image = UIImage(named: "icon_exhibition_heart")
        
        self.commentCountLabel.text = "0"
        self.commentView.snp.removeConstraints()
        let commenViewWidth = self.commentCountLabel.bounds.width + 52
        self.commentView.snp.makeConstraints({ m in
            m.width.equalTo(commenViewWidth)
        })
        
    
    }
    
    private func setUpBindings() {
        viewModel.$cellIndex.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            
            if let value {
                // LikeView
                self.likeCountLabel.text = self.convertCountToString(count: self.viewModel.currentLikeCounts[value])
                self.likeView.snp.removeConstraints()
                let likeViewWidth = self.likeCountLabel.bounds.width + 52
                self.likeView.snp.makeConstraints({ m in
                    m.width.equalTo(likeViewWidth)
                })
                
                // LikeHeart
                self.likeHeartImageView.image = self.viewModel.currentLikeStates[value] ? UIImage(named: "icon_exhibition_heart_fill") : UIImage(named: "icon_exhibition_heart")
                
                // CommentView
                self.commentCountLabel.text = self.convertCountToString(count: self.viewModel.processedExhibitions[value].commentCount)
                self.commentView.snp.removeConstraints()
                let commenViewWidth = self.commentCountLabel.bounds.width + 52
                self.commentView.snp.makeConstraints({ m in
                    m.width.equalTo(commenViewWidth)
                })
            } else {
                setupInitialData()
            }
            
        }).store(in: &cancellables)
    }
    
    // MARK: - UI
    private lazy var likeView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        view.layer.cornerRadius = Constants.Common.cornerRadius
        
        view.addSubview(likeHeartImageView)
        view.addSubview(likeCountLabel)
        
        likeHeartImageView.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(Constants.LikeView.ImageView.leftMargin)
            m.width.height.equalTo(Constants.LikeView.ImageView.diameter)
        })
        
        likeCountLabel.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalTo(likeHeartImageView.snp.right).offset(Constants.LikeView.Label.leftMargin)
//            m.right.equalToSuperview().inset(12)
        })
        
        return view
    }()
    
    private var likeHeartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Common.textColor
        label.font = Constants.Common.font
        return label
    }()
    
    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        view.layer.cornerRadius = Constants.Common.cornerRadius

        let imageView = UIImageView(image: UIImage(named: "icon_exhibition_comment"))
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        view.addSubview(commentCountLabel)

        imageView.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(Constants.CommentView.ImageView.leftMargin)
            m.width.height.equalTo(Constants.CommentView.ImageView.diameter)
        })

        commentCountLabel.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalTo(imageView.snp.right).offset(Constants.CommentView.Label.leftMargin)
        })
        
        return view
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Common.textColor
        label.font = Constants.Common.font
        return label
    }()
    
    private lazy var shareView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        view.layer.cornerRadius = Constants.Common.cornerRadius
        
        let imageView = UIImageView(image: UIImage(named: "icon_exhibition_share"))
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = Constants.ShareView.Label.text
        label.font = Constants.Common.font
        label.textColor = Constants.Common.textColor
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalToSuperview().inset(Constants.ShareView.ImageView.leftMargin)
            m.width.equalTo(Constants.ShareView.ImageView.height)
            m.height.equalTo(Constants.ShareView.ImageView.height)
        })
        
        label.snp.makeConstraints({ m in
            m.centerY.equalToSuperview()
            m.left.equalTo(imageView.snp.right).offset(Constants.ShareView.Label.leftMargin)
        })
        
        return view
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        view.layer.cornerRadius = Constants.Common.cornerRadius
        
        let label = UILabel()
        label.text = Constants.GuideView.text
        label.textColor = Constants.Common.textColor
        label.font = Constants.Common.font
        
        view.addSubview(label)
        label.snp.makeConstraints({ m in
            m.center.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeView, commentView, shareView, infoView])
        
        shareView.snp.makeConstraints({ m in
            m.width.equalTo(Constants.ShareView.width)
        })
        
        infoView.snp.makeConstraints({ m in
            m.width.equalTo(Constants.GuideView.width)
        })
        
        stackView.spacing = Constants.spacing
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private func setUpView() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints({ m in
            m.top.bottom.centerX.equalToSuperview()
        })
    }
    
    
    // MARK: - Functions & Selectors
    private func convertCountToString(count: Int) -> String {
        if count > 999 && count < 10000 {
            let num = count / 100
            return "\(num/10).\(num%10)천"
        }
        
        if count >= 10000 && count < 100000 {
            let num = count / 1000
            return "\(num/10).\(num%10)만"
        }
        
        if count >= 100000 {
            return "\(count/10000)만"
        }
        
        return String(count)
    }
    
    private func setUpGesture() {
        let likeGesture = UILongPressGestureRecognizer(target: self, action: #selector(onTapLikeView))
        let commentGesture = UILongPressGestureRecognizer(target: self, action: #selector(onTapCommentView))
        let shareGesture = UILongPressGestureRecognizer(target: self, action: #selector(onTapShareView))
        let guideGesture = UILongPressGestureRecognizer(target: self, action: #selector(onTapGuideView))
        
        likeGesture.minimumPressDuration = 0
        commentGesture.minimumPressDuration = 0
        shareGesture.minimumPressDuration = 0
        guideGesture.minimumPressDuration = 0
        
        likeView.addGestureRecognizer(likeGesture)
        commentView.addGestureRecognizer(commentGesture)
        shareView.addGestureRecognizer(shareGesture)
        infoView.addGestureRecognizer(guideGesture)
    }
    
    @objc private func onTapLikeView(_ sender: UIGestureRecognizer) {
        guard let cellIndex = viewModel.cellIndex else { return }
        if sender.state == .began {
            setDimEffect(view: likeView, isPressed: true)
        } else if sender.state == .ended {
            setDimEffect(view: likeView, isPressed: false)
            
            if !Authentication.shared.isLoggedIn {
                delegate?.shouldShowLogin()
            } else {
                let updatedState = !viewModel.currentLikeStates[cellIndex]
                let updatedCount = updatedState ? (viewModel.currentLikeCounts[cellIndex] + 1) :  (viewModel.currentLikeCounts[cellIndex] - 1)
                updateLikeButton(likes: updatedState, newCount: updatedCount)
                delegate?.didTapLikeButton(shouldLike: updatedState)
                viewModel.currentLikeStates[cellIndex] = updatedState
                viewModel.currentLikeCounts[cellIndex] = updatedCount
            }
        }
    }
    
    @objc private func onTapCommentView(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            setDimEffect(view: commentView, isPressed: true)
        } else if sender.state == .ended {
            setDimEffect(view: commentView, isPressed: false)
            delegate?.didTapCommentButton()
        }
    }
    
    @objc private func onTapShareView(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            setDimEffect(view: shareView, isPressed: true)
        } else if sender.state == .ended {
            setDimEffect(view: shareView, isPressed: false)
            delegate?.didTapShareButton()
        }
    }
    
    @objc private func onTapGuideView(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            setDimEffect(view: infoView, isPressed: true)
        } else if sender.state == .ended {
            setDimEffect(view: infoView, isPressed: false)
            delegate?.didTapGuideButton()
        }
    }
    
    private func setDimEffect(view: UIView, isPressed: Bool) {
        if isPressed {
            view.backgroundColor = .black.withAlphaComponent(0.1)
        } else {
            view.backgroundColor = Constants.backgroundColor
        }
    }
    
    private func updateLikeButton(likes: Bool, newCount: Int) {
        likeHeartImageView.image = likes ? UIImage(named: "icon_exhibition_heart_fill") : UIImage(named: "icon_exhibition_heart")
        likeCountLabel.text = convertCountToString(count: newCount)
    }
}
