//
//  RandomCell.swift
//  RandomLayout
//
//  Created by Kazi Samin Yeaser on 20/12/22.
//

import UIKit

class RandomCell: UICollectionViewCell {
    static let reuseIdentifier = "RandomCell"
    private let number = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
}

extension RandomCell {
    func prepare(with item: RandomLayout.Section.Item) {
        number.text = "\(item.ID)"
        contentView.backgroundColor = item.backGroundColor
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        number.textAlignment = .center
        number.font = UIFont.preferredFont(forTextStyle: .title1)
    }
}

private extension RandomCell {
    func setUp() {
        number.translatesAutoresizingMaskIntoConstraints = false
        number.adjustsFontForContentSizeCategory = true
        contentView.addSubview(number)
        number.font = UIFont.preferredFont(forTextStyle: .caption1)
        NSLayoutConstraint.activate(
            [
                number.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
                number.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
                number.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
                number.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
            ]
        )
    }
}
