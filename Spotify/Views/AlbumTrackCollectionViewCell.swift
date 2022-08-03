//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 03/08/2022.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    //MARK: - vars & outlets
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
        trackNameLabel.frame = CGRect(x:  10, y: 0, width: contentView.width - 15, height: contentView.height / 2)
        artistNameLabel.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 15, height: contentView.height / 2)
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trackNameLabel.text = nil
        self.artistNameLabel.text = nil
    }
    
    
    
    func config(with viewModel: AlbumCollectionViewCellViewModel){
        self.trackNameLabel.text = viewModel.name
        self.artistNameLabel.text = viewModel.artistName
    }
}
