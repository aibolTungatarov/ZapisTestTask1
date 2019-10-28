//
//  SalonDetailViewController.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/26/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import Cosmos
import YandexMapKit
import RxSwift
class SalonDetailViewController: UIViewController {

    var pictures: [String]?
    var mapView = YMKMapView()
    var backBtn = UIButton()
    var salonTypeLbl = UILabel()
    var salonNameLbl = UILabel()
    var salonAddressLbl = UILabel()
    var checkRating: Double!
    var salonPictureImageView = UIImageView()
    var locationView = UIView()
    var locationImageView = UIImageView(image: UIImage(named: "locationIcon"))
    var separatorView = UIView()
    var ratingLbl = UILabel()
    var ourLocationLbl = UILabel()
    var cosmosView = CosmosView()
    let disposeBag = DisposeBag()
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        pc.currentPageIndicatorTintColor = .violet
        pc.pageIndicatorTintColor = .gray
        pc.backgroundColor = .clear
        return pc
    }()
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        sv.isPagingEnabled = true
        return sv
    }()
    
//    override func viewDidLayoutSubviews() {
//        pageControl.subviews.forEach {
//            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        createConstraints()
    }
    
    func setupFrame(){
        if let pictures = pictures {
            for index in 0..<pictures.count {
                frame.origin.x = scrollView.frame.size.width * CGFloat(index)
                frame.size = scrollView.frame.size
                let imageView = UIImageView(frame: frame)
                imageView.contentMode = .scaleToFill
                imageView.sd_setImage(with: URL(string: pictures[index]), placeholderImage: UIImage(named: "Default"))
                self.scrollView.addSubview(imageView)
            }
            scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(pictures.count)), height: view.frame.width)
            scrollView.delegate = self
        }
    }
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        getSalonInfo(by: id)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViews() {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.clear
        
        salonTypeLbl.textColor = .gray
        view.addSubview(salonTypeLbl)
        
        salonNameLbl.font = .systemFont(ofSize: 24)
        view.addSubview(salonNameLbl)
        
        salonAddressLbl.textColor = .gray
        salonAddressLbl.numberOfLines = 0
        salonAddressLbl.lineBreakMode = .byTruncatingTail
        view.addSubview(salonAddressLbl)
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
        let backImg = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(backImg, for: .normal)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(moveBackToPreviousPage), for: .touchUpInside)
        view.addSubview(backBtn)
        
        locationView.backgroundColor = .mainColor
        locationView.layer.cornerRadius = 10
        view.addSubview(locationView)
        
        locationImageView.tintColor = .gray
        locationView.addSubview(locationImageView)
        
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        
        ratingLbl.textColor = .orange
        ratingLbl.font = .systemFont(ofSize: 24)
        view.addSubview(ratingLbl)
        
        cosmosView.settings.updateOnTouch = false
        view.addSubview(cosmosView)
        
        ourLocationLbl.text = "Наше местоположение:"
        ourLocationLbl.font = .systemFont(ofSize: 24)
        view.addSubview(ourLocationLbl)
        
        view.addSubview(mapView)
    }
    
    func createConstraints() {
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-70)
            make.height.equalTo(view.snp.width)
        }
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(scrollView.snp.bottom).offset(-20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        salonNameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        salonTypeLbl.snp.makeConstraints { (make) in
            make.top.equalTo(salonNameLbl.snp.bottom).offset(10)
            make.left.equalTo(salonNameLbl.snp.left)
        }
        locationView.snp.makeConstraints { (make) in
            make.top.equalTo(salonTypeLbl.snp.bottom).offset(20)
            make.left.equalTo(salonNameLbl.snp.left)
            make.height.width.equalTo(40)
        }
        locationImageView.snp.makeConstraints { (make) in
            make.center.equalTo(locationView.snp.center)
        }
        salonAddressLbl.snp.makeConstraints { (make) in
            make.top.equalTo(locationView.snp.top)
            make.left.equalTo(locationView.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        separatorView.snp.makeConstraints { (make) in
            make.top.equalTo(salonAddressLbl.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
        }
        ratingLbl.snp.makeConstraints { (make) in
            make.left.equalTo(salonNameLbl.snp.left)
            make.centerY.equalTo(cosmosView.snp.centerY)
        }
        cosmosView.snp.makeConstraints { (make) in
            make.left.equalTo(ratingLbl.snp.right).offset(10)
            make.top.equalTo(separatorView.snp.top).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        ourLocationLbl.snp.makeConstraints { (make) in
            make.top.equalTo(cosmosView.snp.bottom).offset(30)
            make.left.equalTo(salonNameLbl.snp.left)
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(ourLocationLbl.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc func moveBackToPreviousPage() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Requests
extension SalonDetailViewController {
    func getSalonInfo(by id: Int) {
        getSalonInfoApi(id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] result in
                guard let salon = result.salon else { return }
                
                if let locationInfo = result.location {
                    if let centerX = locationInfo.centerX, let centerY = locationInfo.centerY, let zoom = locationInfo.zoom, let markerX = locationInfo.markerX, let markerY = locationInfo.markerY {
                        let map = self.mapView.mapWindow.map
                        map.mapObjects.addPlacemark(with: YMKPoint(latitude: markerY, longitude: markerX))
                        map.move(
                            with: YMKCameraPosition(target: YMKPoint(latitude: centerY, longitude: centerX), zoom: Float(zoom), azimuth: 0, tilt: 0),
                            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
                            cameraCallback: nil)
                    }
                }
                
                if let pictureUrls = salon.pictures {
                    if pictureUrls.count != 0 {
                        self.pictures = []
                        for pictureUrl in pictureUrls {
                            let fullPathToPicURL = Constants.ProductionServer.imageBaseURL + (pictureUrl)
                            //                    self.salonPictureImageView.sd_setImage(with: URL(string: fullPathToPicURL), placeholderImage: UIImage(named: "Default"))
                            self.pictures?.append(fullPathToPicURL)
                        }
                        self.pageControl.numberOfPages = self.pictures?.count ?? 0
                        self.setupFrame()
                    }
                }
                
                if let salonRating = salon.checkRating {
                    self.ratingLbl.text = "\(salonRating)"
                    self.cosmosView.rating = salonRating
                }
                
                self.salonAddressLbl.text = salon.address?.html2String
                self.salonNameLbl.text = salon.name
                self.salonTypeLbl.text = salon.type
                
                }, onError: { error in
                    print("Error is: ", error)
            })
            .disposed(by: disposeBag)
    }
    
    func getSalonInfoApi(_ id: Int) -> Observable<SalonDetailed> {
        return ApiClient.shared.request(ApiRouter.getSalonInfo(id: id))
    }
}


// MARK: ScrollViewDelegates
extension SalonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}
