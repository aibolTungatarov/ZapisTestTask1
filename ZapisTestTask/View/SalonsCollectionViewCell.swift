//
//  SalonsCollectionViewCell.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class SalonsCollectionViewCell: UICollectionViewCell {
    
    var salon: Salon? {
        didSet {
            if let salonRating = salon?.checkRating {
                cosmosView.rating = salonRating
                ratingLbl.text = "\(salonRating)"
            }
            salonNameLbl.text = salon?.name
            salonTypeLbl.text = salon?.type
            let pictureUrl = salon?.pictureUrl ?? ""
            let fullPathToPicURL = Constants.ProductionServer.imageBaseURL + (pictureUrl)
            salonPictureImageView.sd_setImage(with: URL(string: fullPathToPicURL), placeholderImage: UIImage(named: "Default"))
        }
    }
    var salonTypeLbl = UILabel()
    var salonNameLbl = UILabel()
    var checkRating: Double!
    var salonPictureImageView = UIImageView()
    var ratingLbl = UILabel()
    var cosmosView = CosmosView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        setupViews()
        createConstraints()
    }
    
    func setupViews() {
        salonTypeLbl.textColor = .gray
        addSubview(salonTypeLbl)
        
        salonNameLbl.font = .systemFont(ofSize: 24)
        salonNameLbl.numberOfLines = 0
        addSubview(salonNameLbl)
        
        salonPictureImageView.contentMode = .scaleAspectFit
        addSubview(salonPictureImageView)
        
        ratingLbl.textColor = .orange
        ratingLbl.font = .systemFont(ofSize: 24)
        addSubview(ratingLbl)
        
        cosmosView.settings.updateOnTouch = false
        addSubview(cosmosView)
    }
    
    func createConstraints() {
        salonTypeLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(25)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        salonNameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(salonTypeLbl.snp.bottom).offset(5)
            make.left.equalTo(salonTypeLbl.snp.left)
            make.right.equalToSuperview().offset(20)
        }
        salonPictureImageView.snp.makeConstraints { (make) in
            make.top.equalTo(salonNameLbl.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(220)
        }
        ratingLbl.snp.makeConstraints { (make) in
            make.left.equalTo(salonNameLbl.snp.left)
            make.centerY.equalTo(cosmosView.snp.centerY)
            make.bottom.equalToSuperview().offset(-20)
        }
        cosmosView.snp.makeConstraints { (make) in
            make.left.equalTo(ratingLbl.snp.right).offset(10)
            make.top.equalTo(salonPictureImageView.snp.bottom).offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
