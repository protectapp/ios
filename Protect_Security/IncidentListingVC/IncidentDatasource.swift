//
//  IncidentDatasource.swift
//  Protect_Security
//
//  Created by Jatin Garg on 26/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

protocol IncidentDatasourceDelegate: class {
    func shouldReloadData()
    func didStartLoadingData(forPage page: Int, isReloading: Bool)
    func didEndLoadingData(with error: Error?)
    func shouldReload(cellAtIndexpath indexPath: IndexPath)
    func shouldToggleEmptyDatasetView(_ shouldShow: Bool, forSection section: IncidentListingSectionModel )
    func didSelectIncident(incident: IncidentReportModel)
}

class IncidentDatasource: NSObject {
    private var viewModel = IncidentListingViewModel(sections: [
        IncidentListingSectionModel(sectionName: .today, incidents: nil),
        IncidentListingSectionModel(sectionName: .yesterday, incidents: nil),
        IncidentListingSectionModel(sectionName: .others, incidents: nil)
        ])
    
    private var loadedSection: IncidentListingSectionModel!
    private var sectionCount: Int {
        return loadedSection?.incidents?.reportSections.count ?? 0
    }
    private func rowCount(forSection section: Int) -> Int {
        return loadedSection.incidents?.reportSections[section].reports.count ?? 0
    }
    private var isReloading: Bool = false
    public static let presentDetailNoti = Notification.Name("detailVCPresentationNotification")
    
    public weak var delegate: IncidentDatasourceDelegate?
    
    
    public func refreshCurrentSection() {
        guard loadedSection != nil else {
            return
        }
        loadedSection.canFetchMore = true
        loadedSection.incidents = nil
        let name = loadedSection.sectionName
        loadedSection = nil
        isReloading = true
        loadSection(name)
    }
    
    public func loadSection( _ section: IncidentTime) {
        if loadedSection != nil && loadedSection.sectionName == section {
            return
        }else{
            let sectionToLoad = viewModel.sections.filter ({
                $0.sectionName == section
            }).first!
            delegate?.shouldToggleEmptyDatasetView(false, forSection: sectionToLoad)
            loadedSection = sectionToLoad
            if sectionToLoad.incidents  == nil || sectionToLoad.incidents!.reportSections.count == 0 {
                //need to hit api for first page of that section
                hitAPI(forSection: sectionToLoad)
            }
            delegate?.shouldReloadData()
        }
    }
    
    public func incident(atIndexPath indexPath: IndexPath) -> IncidentReportModel? {
        return loadedSection.incidents?.reportSections[indexPath.section].reports[indexPath.row]
    }
    
    private func hitAPI(forSection section: IncidentListingSectionModel) {
        if !section.canFetchMore {
            if section.incidents == nil || section.incidents!.reportSections.count == 0 {
                delegate?.shouldToggleEmptyDatasetView(true, forSection: section)
            }
            return
        }
        let page = section.incidents?.currentPage ?? 0
        let service = GetIncidentsService(page: page, type: section.sectionName)
        delegate?.didStartLoadingData(forPage: page, isReloading: isReloading)
        service.fire { (listingmodel, error) in
            self.delegate?.didEndLoadingData(with: error)
            self.isReloading = false
            if error == nil {
                let canFetchMore = listingmodel!.totalPages > 0 && listingmodel!.currentPage<listingmodel!.totalPages
                section.canFetchMore = canFetchMore
                if section.incidents == nil {
                    section.incidents = listingmodel
                    
                    if listingmodel!.reportSections.count == 0 {
                        self.delegate?.shouldToggleEmptyDatasetView(true, forSection: section)
                    }else{
                        self.delegate?.shouldToggleEmptyDatasetView(false, forSection: section)
                    }
                }else{
                    self.delegate?.shouldToggleEmptyDatasetView(false, forSection: section)
                    let newSections = listingmodel!.reportSections
                    var currentSections = section.incidents!.reportSections
                    for newSection in newSections {
                        let currentIndex = currentSections.index(where: {
                            return $0.date == newSection.date
                        })
                        if currentIndex == nil {
                            //this section needs to be appended
                            currentSections.append(newSection)
                        }else{
                            currentSections[currentIndex!].reports += newSection.reports
                        }
                    }
                }
            }else{
                if let delegate = self.delegate as? UIViewController{
                    System.showInfo(withMessage: error?.localizedDescription ?? "", ofType: .error, onVC: delegate)
                    self.delegate?.shouldToggleEmptyDatasetView(true, forSection: section)
                }
            }
            self.delegate?.shouldReloadData()
        }
    }
}

extension IncidentDatasource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let image = UIImage(named: "backbround")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        let dateLabel = UILabel()
        dateLabel.textColor = Color.textColor
        dateLabel.font = Font.font(ofSize: 17, andFace: .bold)
        dateLabel.textAlignment = .left
        let lineView = UIView()
        lineView.backgroundColor = UIColor.gray
        
        headerView.addSubview(imageView)
        headerView.addSubview(dateLabel)
        headerView.addSubview(lineView)
        
        dateLabel.anchor(toView: headerView, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 12, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
        
        lineView.anchor(toView: dateLabel, myHorizontalEdge: .left, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 8, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: -2)
        lineView.anchor(toView: headerView, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: -12, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
        
        imageView.anchorCenterXToSuperview()
        imageView.anchorCenterXToSuperview()
        imageView.setWidth(equalToView: headerView)
        imageView.setHeight(equalToView: headerView)
        lineView.fixHeight(to: 1)
        dateLabel.setCenter(withRespectTo: headerView, axis: .vertical)
        dateLabel.text = loadedSection.incidents?.reportSections[section].date
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let incident = incident(atIndexPath: indexPath) else{
            return
        }
        delegate?.didSelectIncident(incident: incident)
    }
}

extension IncidentDatasource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let incident = incident(atIndexPath: indexPath) else{
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! IncidentTVC
        cell.myTableview = tableView
        cell.incident = incident
        cell.moreTapHandler = { [weak self] in
            guard let `self` = self else { return }
            let currentValue = self.loadedSection.incidents?.reportSections[indexPath.section].reports[indexPath.row].isCollapsed!
            self.loadedSection.incidents?.reportSections[indexPath.section].reports[indexPath.row].isCollapsed = !currentValue!
            self.delegate?.shouldReload(cellAtIndexpath: indexPath)
        }
        
        if indexPath.row == rowCount(forSection: indexPath.section) - 1 {
            //rendering last cell, call for more pages
            loadedSection.incidents?.currentPage += 1
            hitAPI(forSection: loadedSection)
        }
        
        return cell
    }
}
