//
//  SubscriptionMovieCell.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 19/11/2020.
//

import UIKit
import PureLayout
import Kingfisher

class SubscriptionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imgView = UIImageView(forAutoLayout: ())
        imgView.layer.cornerRadius = 4
        imgView.layer.masksToBounds = true
        
        return imgView
    }()
    
    var imageURL: URL? {
        didSet {
            imageView.kf.setImage(with: imageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configurate()
    }
    
    func configurate() {
        addSubview(imageView)
        
        imageView.autoPinEdgesToSuperviewEdges()
        imageView.autoSetDimension(.height, toSize: 150, relation: .equal)
        imageView.autoSetDimension(.width, toSize: 100, relation: .equal)

        imageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
