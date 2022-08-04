//
//  FeaturedPlaylistsCollectionViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 31/07/2022.
//

import UIKit
import SDWebImage
class FeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistsCollectionViewCell"
    //MARK: - vars & outlets
    private let playlistCoverImageView:UIImageView={
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName:"photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let playlistNameLabel:UILabel={
        let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize:18,weight:.semibold)
        label.textAlignment = .center
        return label
    }()
    private let creatorNameLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize:17,weight:.thin)
        label.textAlignment = .center
        label.numberOfLines=0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
//        contentView.backgroundColor = .secondarySystemBackground
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        creatorNameLabel.frame = CGRect(x: 3, y: contentView.height - 30, width: contentView.width - 6, height: 30)
        playlistNameLabel.frame = CGRect(x: 3, y: contentView.height - 60, width: contentView.width - 6, height: 30)
        let imageSize = contentView.height-70
        playlistCoverImageView.frame = CGRect(x: (contentView.width-imageSize)/2, y: 3, width: imageSize, height: imageSize)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.playlistNameLabel.text = nil
        self.creatorNameLabel.text = nil
        self.playlistCoverImageView.image = nil
    }
    
    
    
    func config(with viewModel: FeaturedPlaylistCellViewModel){
        self.playlistNameLabel.text = viewModel.name
        self.creatorNameLabel.text = viewModel.creatorName
        self.playlistCoverImageView.sd_setImage(with: viewModel.artwork , completed: nil)
    }
}


