//  PlaylistHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 03/08/2022.

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func PlaylistHeaderCollectionReusableViewDidTappedPlayAll(header: PlaylistHeaderCollectionReusableView)
}

final class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    static let identifer = "PlaylistHeaderCollectionReusableView"
    //MARK: - vars & outlets
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    private let nameLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize:22,weight:.semibold)
        return label
    }()
    
    private let discriptionLabel:UILabel={
        let label=UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize:18,weight:.regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel:UILabel={
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize:18,weight:.light)
        return label
    }()
    
    private let playlistImageView :UIImageView={
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(ownerLabel)
        addSubview(discriptionLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTappedSignInButton), for: .touchUpInside)
        
    }
    @objc func didTappedSignInButton(){
        delegate?.PlaylistHeaderCollectionReusableViewDidTappedPlayAll(header: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = height/1.8
        playlistImageView.frame = CGRect(x: (width-imageSize)/2, y: 15, width: imageSize, height: imageSize)
        nameLabel.frame = CGRect(x: 10, y: playlistImageView.bottom, width: width-20, height: 40)
        discriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width-20, height: 43)
        ownerLabel.frame = CGRect(x: 10, y: discriptionLabel.bottom, width: width-20, height: 40)
        playAllButton.frame = CGRect(x: width-80, y: height-80, width: 60, height: 60)
        
    }
    func config(with viewModel: PlaylistHeaderViewModel){
        nameLabel.text = viewModel.name
        discriptionLabel.text = viewModel.description
        ownerLabel.text = viewModel.ownerName
        playlistImageView.sd_setImage(with: viewModel.artworkURL , completed: nil)
    }
}
