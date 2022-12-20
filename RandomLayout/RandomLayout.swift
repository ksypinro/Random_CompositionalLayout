//
//  RandomLayout.swift
//  RandomLayout
//
//  Created by Kazi Samin Yeaser on 20/12/22.
//

import UIKit

enum RandomLayout {
    typealias CellRegistration = UICollectionView.CellRegistration<RandomCell, Section.Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Section.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Section.Item>
    
    enum ItemCard: Equatable {
        case basic, complex, group
        
        static var randomCard: ItemCard {
            let x  = Int.random(in: 1...3)
            if x == 1 { return .basic }
            if x == 2 { return .complex }
            if x == 3 { return .group }
            return .basic
        }
        
        static var randomColor: UIColor {
            let colorss: [UIColor] = [.red, .blue, .gray, .green, .magenta, .yellow]
            return colorss[Int.random(in: 0...5)]
        }
        
        var isX2: Bool { self == .complex }
        var isX1: Bool { !isX2 }
    }
    
    enum Section: Int {
        case grid
        
        struct Item: Hashable, Equatable {
            let ID: Int
            let card: ItemCard
            let backGroundColor: UIColor
            
            func hash(into hasher: inout Hasher) {
                hasher.combine(ID)
                hasher.combine(card)
                hasher.combine(backGroundColor)
            }
            
            init(ID: Int) {
                self.ID = ID
                self.card = ItemCard.randomCard
                self.backGroundColor = ItemCard.randomColor
            }
        }
    }
    
    enum GroupCard: Equatable {
        case fourX1
        case twoX2
        case twoX1OneX2
        case oneX2oneX1
        case oneX1oneX2oneX1
        case oneX2twoX1
        case oneX1oneX2
        case threeX1
        
        func group(with width: CGFloat) -> NSCollectionLayoutGroup {
            let smallItemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(width/4),
                heightDimension: .absolute(width/4)
            )
            
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let largeItemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(width/2),
                heightDimension: .absolute(width/4)
            )
            let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
            largeItem.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(width),
                heightDimension: .absolute(width/4)
            )
            
            var items: [NSCollectionLayoutItem] {
                switch self {
                case .threeX1:              return [smallItem, smallItem, smallItem]
                case .fourX1:               return [smallItem, smallItem, smallItem, smallItem]
                case .twoX2:                return [largeItem, largeItem]
                case .twoX1OneX2:           return [smallItem, smallItem, largeItem]
                case .oneX2oneX1:           return [largeItem, smallItem]
                case .oneX1oneX2oneX1:      return [smallItem, largeItem, smallItem]
                case .oneX2twoX1:           return [largeItem, smallItem, smallItem]
                case .oneX1oneX2:           return [smallItem, largeItem]
                }
            }
            
            return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: items)
        }
    }
}
