//
//  NewReleasesCollectionViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 31/07/2022.
//

import UIKit
import SDWebImage
class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    //MARK: - vars & outlets
    private let albumCoverImageView:UIImageView={
        let imageView = UIImageView()
        imageView.image = UIImage(systemName:"photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    private let albumNameLabel:UILabel={
        let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize:20,weight:.semibold)
        return label
    }()
    private let artistNameLabel:UILabel = {
        let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize:17,weight:.light)
        return label
    }()
    private let numberOfTracksLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize:17,weight:.thin)
        label.numberOfLines=0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        let imageSize: CGFloat = contentView.height - 10
        let albumLableSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width - imageSize-10, height: contentView.height - 10))
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        let albumHeight = min(60, albumLableSize.height)
        albumNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: albumCoverImageView.top - 5, width: albumLableSize.width, height: albumHeight)
        
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: albumNameLabel.bottom, width: contentView.width - albumCoverImageView.width - 5, height: 30)
        
        numberOfTracksLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: contentView.bottom - 40, width: 100, height: 40)
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumNameLabel.text = nil
        self.artistNameLabel.text = nil
        self.numberOfTracksLabel.text = nil
        self.albumCoverImageView.image = nil
    }
    
    
    
    func config(with viewModel: NewReleasesCellViewModel){
        self.albumNameLabel.text = viewModel.name
        self.artistNameLabel.text = viewModel.artistName
        self.numberOfTracksLabel.text = "tracks : \(viewModel.numOfTracks)"
        self.albumCoverImageView.sd_setImage(with: viewModel.artworkURL , completed: nil)
    }
}
