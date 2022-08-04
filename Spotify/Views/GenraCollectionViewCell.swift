//
//  GenraCollectionViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 04/08/2022.
//

import UIKit

class GenraCollectionViewCell: UICollectionViewCell {
    static let identfier = "GenraCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.tintColor = .white
        imageview.image = UIImage(systemName: "music.quarternote.3",withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular))
        return imageview
    }()
    private let lable: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.font = .systemFont(ofSize: 22 , weight: .semibold)
        return lable
    }()
    private let colors: [UIColor] = [
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemGreen,
        .systemBlue,
        .systemYellow,
        .systemOrange,
        .systemGray,
        .systemTeal
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(lable)
        contentView.addSubview(imageView)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        lable.text = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lable.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 0, width: contentView.width/2, height: contentView.height/2)
    }
    func config(with title: String){
        lable.text = title
        contentView.backgroundColor = colors.randomElement()
    }
}
