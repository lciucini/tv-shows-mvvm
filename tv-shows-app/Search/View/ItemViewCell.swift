//
//  ItemCell.swift
//  tv-shows-app
//
//  Created by Lucas Ciucini on 19/11/2020.
//

import UIKit
import Kingfisher

class ItemViewCell: UITableViewCell {
    var buttonTitle: String? {
        didSet {
            continueButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet private weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.layer.cornerRadius = 4
            posterImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            nameLabel.title(.l, .light)
        }
    }
    @IBOutlet private weak var genreLabel: UILabel! {
        didSet {
            genreLabel.title(.xs, .text_light, .regular)
        }
    }
    @IBOutlet weak var continueButton: CustomButton! {
        didSet {
            continueButton.setStyle(style: .square)
            continueButton.setTitle("ADD", for: .normal)
            continueButton.setBackgroundColor(.light, for: .selected)
            continueButton.setBackgroundColor(.light, for: .highlighted)
            continueButton.setBackgroundColor(.clear, for: .normal)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configurate(whit viewModel: TvShowViewModel) {
        posterImageView.kf.setImage(with: viewModel.posterURL)
        nameLabel.text = viewModel.name
        genreLabel.text = viewModel.genre
        continueButton.isSelected = viewModel.isSubscribed
        print(viewModel.isSubscribed)
    }
    
    private func setupView() {
        backgroundView = nil
        backgroundColor = .clear
    }
}
