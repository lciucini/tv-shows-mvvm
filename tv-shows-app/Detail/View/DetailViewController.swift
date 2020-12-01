//
//  DetailViewController.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 18/11/2020.
//

import UIKit
import Kingfisher
import UIImageColors
import PureLayout
import RxSwift

class DetailViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private var detailViewModel: DetailViewModel!
    private var initialImageHeight: CGFloat = 0
    private var colors: UIImageColors?
    private let tvShowId: Int64
    
    let schedulerProvider:SchedulerProvider = SchedulerProvider()
    let tvShowsRepository: TvShowsRepository = TvShowsRepositoryImpl(tvShowsApi: TvShowsApi.shared)
    let genresRepository: GenresRepository = InMemoryGenresRepositoryImpl(genresApi: GenresApi.shared)
    
    @IBOutlet weak var activityLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backdropView: UIView!
    @IBOutlet weak var posterImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func didTapSubscribeButton(_ sender: Any) {
        detailViewModel.subscribeOrUnsubscribe()
    }
    
    init(tvShowId: Int64) {
        self.tvShowId = tvShowId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.scrollView.delegate = self
        initialImageHeight = posterImageViewHeightConstraint.constant
        applyViewStyles()
        addObservers()
    }
    
    private func addObservers() {
        detailViewModel = DetailViewModel(
            tvShowId: tvShowId,
            schedulerProvider: schedulerProvider,
            tvShowsRepository: tvShowsRepository,
            genresRepository: genresRepository)
        
        detailViewModel.isSubscribe
            .drive(continueButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        detailViewModel.tvShowDetails
            .drive(onNext: {[weak self] tvShow in
                guard
                    let tvShow = tvShow,
                    let vm = self?.detailViewModel.getTvShowViewModel(by: tvShow) else { return }
                
                self?.configurate(viewModel: vm)
            }).disposed(by: disposeBag)
    }
    
    private func loadImages(withPosterUrl posterUrl: URL, withBackdropUrl backdropUrl: URL) {
        backdropImageView.contentMode = .scaleAspectFill

        KingfisherManager.shared.retrieveImage(with: posterUrl, options: [.fromMemoryCacheOrRefresh]) {[weak self] result in
            guard let weakSelf = self else { return }
            
            switch(result) {
            case .success(let value):
                value.image.getColors { colors in
                    weakSelf.colors = colors
                    weakSelf.backdropView.backgroundColor = colors?.primary.withAlphaComponent(0.9)
                    weakSelf.posterImageView.image = value.image
                    weakSelf.backdropImageView.kf.setImage(with: backdropUrl)
                    weakSelf.descriptionTitleLabel.textColor = colors?.background
                }
            case .failure(_):
                weakSelf.containerView.backgroundColor = .dark_ligth
            }
        }
    }
    
    private func applyViewStyles() {
        // Set labels colors
        nameTitleLabel.bold(.xl, .light)
        yearLabel.body(.m, .light, .regular)
        descriptionTitleLabel.title(.xs, .dark)
        descriptionLabel.body(.s, .light, .regular)
        
        // Round poster image view
        posterImageView.layer.cornerRadius = 6
        posterImageView.layer.masksToBounds = true
        
        // Continue Button
        continueButton.setBackgroundColor(.clear, for: .normal)
        continueButton.setBackgroundColor(.light, for: .selected)
        continueButton.setBackgroundColor(.light, for: .highlighted)

        continueButton.setTitle("SUBSCRIBE", for: .normal)
        continueButton.setTitle("SUBSCRIBED", for: .selected)

    }
    
    private func applyAnimationStyles(isHidden: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            // Hide Labels name and year
            self.nameTitleLabel.isHidden = isHidden
            self.yearLabel.isHidden = isHidden
        })
    }
    
    func configurate(viewModel: TvShowViewModel) {
        nameTitleLabel.text = viewModel.name
        yearLabel.text = viewModel.firstAirYear
        descriptionTitleLabel.text = "OVERVIEW"
        descriptionLabel.text = viewModel.overview
        
        UIView.animate(withDuration: 0.6, delay: 0.5, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            self.loadImages(withPosterUrl: viewModel.posterURL, withBackdropUrl: viewModel.backdropURL)
        })
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y
        let height = initialImageHeight - contentY
        let isHidden = height <= 0
        
        // Prevent repeat unnecesary animations
        if self.nameTitleLabel.isHidden != isHidden {
            applyAnimationStyles(isHidden: isHidden)
        }
        
        // Limit resizing of Image View
        if height > 57 {
            posterImageViewHeightConstraint.constant = height
        }
    }
}
