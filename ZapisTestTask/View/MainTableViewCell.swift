//
//  MainTableViewCell.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    let cellId = "SalonsCollectionView"
    var salons: [Salon]? {
        didSet {
            salonsCollectionView.reloadData()
        }
    }
    lazy var salonsCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 0)
        var cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SalonsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .mainColor
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        salonsCollectionView.delegate = self
        salonsCollectionView.dataSource = self
        addSubview(salonsCollectionView)
    }
    
    func createConstraints() {
        salonsCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension MainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let salons = salons else { return 0 }
        return salons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let salons = salons else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SalonsCollectionViewCell
        let salon = salons[indexPath.row]
        cell.salon = salon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let salonDetailVc = SalonDetailViewController(id: salons![indexPath.row].id)
        self.window?.rootViewController!.present(salonDetailVc, animated: true, completion: nil)
    }
}
