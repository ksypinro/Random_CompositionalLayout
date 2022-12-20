//
//  RandomLayoutViewController.swift
//  RandomLayout
//
//  Created by Kazi Samin Yeaser on 20/12/22.
//

import UIKit

class RandomLayoutViewController: UIViewController {
    var items: [RandomLayout.Section.Item] = [] {
        didSet {
            guard oldValue != items else { return }
            updateSection()
        }
    }
    
    var dataSource: RandomLayout.DataSource! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDataSource()
        initTimer()
    }
}

private extension RandomLayoutViewController {
    func initTimer() {
        Timer.scheduledTimer(
            timeInterval: 0.6,
            target: self,
            selector: #selector(handleTimerExecution),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc
    func handleTimerExecution() {
        Int.random(in: 1...5) == 1
            ? updateData()
            : updateAData()
    }
    
    func updateData() {
        let start = Int.random(in: 1...99)
        let itemsNo = Int.random(in: 10...25)
        let end = start+itemsNo
        DispatchQueue.main.async {
            self.items = (start...end).map{ .init(ID: $0) }
        }
    }
    
    func updateAData() {
        let index = Int.random(in: 0...(items.count-1))
        var tempData = items
        tempData[index] = .init(ID: tempData[index].ID)
        DispatchQueue.main.async {
            self.items = tempData
        }
    }
    
    func updateSection() {
        var snapshot = RandomLayout.Snapshot()
        snapshot.appendSections([.grid])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func groups(with items: [RandomLayout.ItemCard]) -> [RandomLayout.GroupCard] {
        if items.count == 0 { return [] }
        
        if items.count == 1 { return items[0] == .complex ? [.oneX2twoX1] : [.fourX1] }
        
        if items.count == 2 {
            switch (items[0], items[1]) {
            case (.complex, .complex):  return [.twoX2]
            case (_, .complex):         return [.oneX1oneX2oneX1]
            case (.complex, _):         return [.oneX2twoX1]
            default:                    return [.fourX1]
            }
        }
        
        if items.count == 3 {
            switch (items[0], items[1], items[2]) {
            case (.complex, .complex, .complex): return [.twoX2, .oneX2twoX1]
            case (.complex, .complex, _):        return [.twoX2, .fourX1]
            case (.complex, _, .complex):        return [.oneX2oneX1, .oneX2twoX1]
            case (.complex, _, _):               return [.oneX2twoX1]
            case (_, .complex, .complex):        return [.oneX1oneX2, .oneX2twoX1]
            case (_, .complex, _):               return [.oneX1oneX2oneX1]
            case (_, _, .complex):               return [.twoX1OneX2]
            default:                             return [.threeX1]
            }
        }
        
        var isFourX1: Bool {
            items[0].isX1 && items[1].isX1 && items[2].isX1 && items[3].isX1
        }
        
        var isThreeX1: Bool {
            items[0].isX1 && items[1].isX1 && items[2].isX1 && items[3].isX2
        }
        
        var isTwoX2: Bool {
            items[0].isX2 && items[1].isX2
        }
        
        var isTwoX1OneX2: Bool {
            items[0].isX1 && items[1].isX1 && items[2].isX2
        }
        
        var isOneX2oneX1: Bool {
            items[0].isX2 && items[1].isX1 && items[2].isX2
        }
        
        var isOneX1oneX2oneX1: Bool {
            items[0].isX1 && items[1].isX2 && items[2].isX1
        }
        
        var isOneX1oneX2: Bool {
            items[0].isX1 && items[1].isX2 && items[2].isX2
        }
        
        var isOneX2twoX1: Bool {
            items[0].isX2 && items[1].isX1 && items[2].isX1
        }
        
        var newGroups: [RandomLayout.GroupCard] = []
        var itemStart = 0
        
        if isFourX1 {
            itemStart = 4
            newGroups.append(.fourX1)
        } else if isTwoX2 {
            itemStart = 2
            newGroups.append(.twoX2)
        } else if isTwoX1OneX2 {
            itemStart = 3
            newGroups.append(.twoX1OneX2)
        } else if isOneX2oneX1 {
            itemStart = 2
            newGroups.append(.oneX2oneX1)
        } else if isOneX1oneX2oneX1 {
            itemStart = 3
            newGroups.append(.oneX1oneX2oneX1)
        } else if isOneX2twoX1 {
            itemStart = 3
            newGroups.append(.oneX2twoX1)
        } else if isThreeX1 {
            itemStart = 3
            newGroups.append(.threeX1)
        } else if isOneX1oneX2 {
            itemStart = 3
            newGroups.append(.oneX1oneX2)
        } else {
            itemStart = 2
            newGroups.append(.twoX2)
        }
        
        let newItems = (itemStart...(items.count))
            .compactMap { if items.count > $0 { return items[$0] }
                return nil
            }
        newGroups.append(contentsOf: groups(with: newItems))
        return newGroups
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self else { return nil }
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(1.0)
            )
            let groups = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: self.groups(with: self.items.map(\.card))
                    .map { $0.group(with: self.view.bounds.width) }
            )
            
            let section = NSCollectionLayoutSection(group: groups)
            return section
        }
        return layout
    }
}

private extension RandomLayoutViewController {
    func configureView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let textCellRegistration = RandomLayout.CellRegistration { $0.prepare(with: $2) }
        dataSource = RandomLayout.DataSource(
            collectionView: collectionView
        ) { $0.dequeueConfiguredReusableCell(using: textCellRegistration, for: $1, item: $2) }
        updateData()
    }
}
