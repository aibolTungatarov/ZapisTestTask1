//
//  ViewController.swift
//  ZapisTestTask
//
//  Created by Aibol Tungatarov on 10/25/19.
//  Copyright © 2019 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import RxSwift
import SDWebImage

class MainViewController: UIViewController {
    
    var banners = [Banner]()
    var popularSalons = [Salon]()
    var recomendedSalons = [Salon]()
    let disposeBag = DisposeBag()
    var bannerPictureImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 200)))
    let cellId = "MainTableViewCell"
    lazy var mainTableView: UITableView  = {
        var tv = UITableView()
        tv.tableHeaderView = bannerPictureImageView
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .mainColor
        tv.tableFooterView = UIView()
        tv.register(MainTableViewCell.self, forCellReuseIdentifier: cellId)
        tv.separatorStyle = .none
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let dg = DispatchGroup()
        dg.enter()
        getPopularList(dg: dg)
        dg.enter()
        getRecommendedList(dg: dg)
        dg.enter()
        getBanners(dg: dg)
        dg.notify(queue: .main) { [unowned self] in
            self.mainTableView.reloadData()
        }
        setupViews()
        createConstraints()
    }
    
    func sizeHeaderToFit(tableView: UITableView) {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViews() {
        bannerPictureImageView.contentMode = .scaleAspectFill
        bannerPictureImageView.clipsToBounds = true
        view.addSubview(mainTableView)
    }
    
    func createConstraints() {
        mainTableView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainTableViewCell
        cell.salons = indexPath.section == 0 ? popularSalons : recomendedSalons
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let headerTitleLabel = UILabel()
        headerTitleLabel.font = .systemFont(ofSize: 30)
        headerTitleLabel.text = section == 0 ? "Популярное" : "Рекомендуемые"
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().offset(20)
        }
        return headerView
    }
    
    
}

//MARK: - Requests
extension MainViewController {
    
    func getPopularList(dg: DispatchGroup) {
        getPopularListApi()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] result in
                if let salons = result.salons {
                    self.popularSalons = salons
                    dg.leave()
                }
                }, onError: { error in
                    dg.leave()
                    print("Error is: ", error)
            })
            .disposed(by: disposeBag)
    }
    
    func getRecommendedList(dg: DispatchGroup) {
        getRecommendedApi()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] result in
                if let salons = result.salons {
                    self.recomendedSalons = salons
                    dg.leave()
                }
                }, onError: { error in
                    dg.leave()
                    print("Error is: ", error)
            })
            .disposed(by: disposeBag)
    }
    
    func getBanners(dg: DispatchGroup) {
        getBannersApi()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if let banners = result.banners {
                    self.banners = banners
                    let banner = banners[0]
                    let pictureUrl = banner.pictureUrl ?? ""
                    let fullPathToPicURL = Constants.ProductionServer.imageBaseURL + (pictureUrl)
                    self.bannerPictureImageView.sd_setImage(with: URL(string: fullPathToPicURL), placeholderImage: UIImage(named: "Default"))
                    dg.leave()
                }
                }, onError: { error in
                    dg.leave()
                    print("Error is: ", error)
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularListApi() -> Observable<Salons> {
        return ApiClient.shared.request(ApiRouter.getPopular)
    }
    
    func getRecommendedApi() -> Observable<Salons> {
        return ApiClient.shared.request(ApiRouter.getRecommended)
    }
    
    func getBannersApi() -> Observable<Banners> {
        return ApiClient.shared.request(ApiRouter.getMobileAppBanners)
    }
}
