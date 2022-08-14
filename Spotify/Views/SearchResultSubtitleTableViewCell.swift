//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 06/08/2022.
//


import UIKit
import SDWebImage


class SearchResultSubtitleTableViewCell: UITableViewCell {
    
    static let identifer = "SearchResultSubtitleTableViewCell"
    private let lable:UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        return lable
    }()
    private let subLable:UILabel = {
        let lable = UILabel()
        lable.textColor = .secondaryLabel
        lable.numberOfLines = 1
        return lable
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lable)
        contentView.addSubview(subLable)
        contentView.addSubview(iconImageView)
        contentView.layer.masksToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        subLable.text = nil
        lable.text = nil
        iconImageView.image = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.height - 10
        let lableHeight = contentView.height/2
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        iconImageView.layer.cornerRadius = imageSize / 2
        iconImageView.layer.masksToBounds = true

        lable.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width-iconImageView.right-15, height: lableHeight)
        subLable.frame = CGRect(x: iconImageView.right + 10, y: lable.bottom, width: contentView.width-iconImageView.right-15, height: lableHeight)
    }
    func config(with viewModel: SearchResultSubTitleTableViewCellViewModel){
        lable.text = viewModel.title
        subLable.text = viewModel.subTitle
        iconImageView.sd_setImage(with: viewModel.imageUrl , placeholderImage: UIImage(systemName: "music.note" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)))
                
    }
}
