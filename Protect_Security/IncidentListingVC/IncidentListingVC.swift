//
//  IncidentListingVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 26/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class IncidentListingVC: UIViewController {
    @IBOutlet weak var segmentControl: ProtectSegmentControl!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableContainer: UIView!

    private let datasource = IncidentDatasource()
    private var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.segmentNames = [
            "Today", "Yesterday", "Previous"
        ]
        datasource.delegate = self
        segmentControl.delegate = self
        
        configureTableview()
        
        datasource.loadSection(.today)
        navigationItem.title = "Aid History"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BadgeManager.shared.resetBadgeCount(for: .report)
    }
    
    private func configureTableview() {
        tableview.dataSource = datasource
        tableview.delegate = datasource
        tableview.register(UINib(nibName: "IncidentTVC", bundle: nil), forCellReuseIdentifier: "cell")
        tableview.tableFooterView = nil
        tableview.estimatedRowHeight = 60
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(tableRefreshed), for: .valueChanged)
        tableview.refreshControl = refreshControl
    }
    
    @objc func tableRefreshed(_ sender: UIRefreshControl) {
        datasource.refreshCurrentSection()
    }
}

extension IncidentListingVC: ProtectSegmentControlDelegate {
    func didSelect(item: String, atIndex index: Int) {
        switch index {
        case 0:
            //today
            datasource.loadSection(.today)
            break
        case 1:
            //yesterday
            datasource.loadSection(.yesterday)
            break
        case 2:
            //others
            datasource.loadSection(.others)
            break
        default:
            break
        }
    }
    
}

extension IncidentListingVC: IncidentDatasourceDelegate {
    
    func shouldToggleEmptyDatasetView(_ shouldShow: Bool, forSection section: IncidentListingSectionModel) {
        shouldShow ? tableview.showEmptyDatasetView(withTitle: Strings.incidentsUnavailable(forSection: section), actionTitle: nil, image: #imageLiteral(resourceName: "no-incidents"), actionBlock: nil) : tableview.removeEmptydatasetView()
    }
    
    func shouldReloadData() {
        tableview.reloadData()
    }
    
    func shouldReload(cellAtIndexpath indexPath: IndexPath) {
        tableview.reloadRows(at: [indexPath], with: .fade)
    }
    
    func didStartLoadingData(forPage page: Int, isReloading: Bool) {
        segmentControl.isUserInteractionEnabled = false
        if page == 0 && !isReloading{
            tableContainer.showShimmerView(usingCellType: ListingShimmerCell.self)
        }
        
        if isReloading {
            //do nothing and let the refresh control spin
        }
        
        if page > 0 {
            self.view.showLoadingView()
        }
    }
    
    func didEndLoadingData(with error: Error?) {
        segmentControl.isUserInteractionEnabled = true
        tableContainer.removeShimmerView()
        refreshControl?.endRefreshing()
        self.view.hideLoadingView()
    }
    
    func didSelectIncident(incident: IncidentReportModel) {
        let detailVC = IncidentDetailVC()
        detailVC.incident = incident
        present(detailVC, animated: true)
    }
}
