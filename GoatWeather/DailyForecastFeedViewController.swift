//
//  DailyForecastFeedViewController.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import UIKit
import SnapKit

class DailyForecastFeedViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var grantLocationBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Grant Access",
                                   style: .plain,
                                   target: self,
                                   action: #selector(grantLocationTapped))
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureSubviews()
        configureConstraints()
    }

    /// MARK :- Private UI methods
    
    private func configureNavigation() {
        navigationController?.navigationBar.topItem?.title = "Daily Forecast"
        navigationItem.rightBarButtonItem = grantLocationBarButtonItem
    }
    
    private func configureSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// MARK :- action handlers
    @objc
    private func grantLocationTapped() {
        // TODO: @aldrich add location tapped handling
    }
}
