//
//  RecommendedTracksCollectionViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 31/07/2022.
//

import UIKit
import SDWebImage
class RecommendedTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTracksCollectionViewCell"
    //MARK: - vars & outlets
    private let albumCoverImageView:UIImageView={
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName:"photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let trackNameLabel:UILabel={
        let label=UILabel()
        label.numberOfLines=0
        label.font = .systemFont(ofSize:18,weight:.semibold)
        return label
    }()
    private let artistNameLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize:17,weight:.thin)
        label.numberOfLines=0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(trackNameLabel)
        contentView.backgroundColor = .secondarySystemBackground
        backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        albumCoverImageView.frame = CGRect(x: 5, y: 2, width: contentView.height - 4, height: contentView.height - 4)
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: 0, width: contentView.width - albumCoverImageView.right - 15, height: contentView.height / 2)
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: contentView.height / 2, width: contentView.width - albumCoverImageView.right - 15, height: contentView.height / 2)
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trackNameLabel.text = nil
        self.artistNameLabel.text = nil
        self.albumCoverImageView.image = nil
    }
    
    
    
    func config(with viewModel: RecommendedTrackCellViewModel){
        self.trackNameLabel.text = viewModel.name
        self.artistNameLabel.text = viewModel.artistName
        self.albumCoverImageView.sd_setImage(with: viewModel.artworkURL , completed: nil)
    }
}
