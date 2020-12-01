//
//  MovieCard.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 19/11/2020.
//

import Foundation
import UIKit
import Kingfisher

class TvShowViewCell: UICollectionViewCell {
    @IBOutlet weak var genreViewContainer: UIView! {
        didSet {
            genreViewContainer.backgroundColor = .dark
            genreViewContainer.layer.cornerRadius = 3
            genreViewContainer.layer.opacity = 0.8
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 3
            imageView.layer.masksToBounds = true
            imageView.addGradientLayerInForeground(frame: imageView.frame, colors: [.light, UIColor(hex: "#000000")], opacity: 0.2)
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.title(.xl, .light)
        }
    }
    
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.bold(.xs, .light)
        }
    }
    
    func configurate(viewModel: TvShowViewModel) {
        nameLabel.text = viewModel.name
        genreLabel.text = viewModel.genre?.uppercased()
        
        let processor = DownsamplingImageProcessor(size: contentView.frame.size)

        imageView.kf.setImage(with: viewModel.backdropURL, options: [.processor(processor), .fromMemoryCacheOrRefresh])
    }
}
