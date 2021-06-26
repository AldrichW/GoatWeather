//
//  DailyForecastFeedViewController.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/25/21.
//

import CoreLocation
import UIKit
import SnapKit

class DailyForecastFeedViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(WeatherInfoItemCell.nib, forCellReuseIdentifier: WeatherInfoItemCell.identifier)
        view.dataSource = self
        
        return view
    }()
    
    private lazy var grantLocationBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Grant Access",
                                   style: .plain,
                                   target: self,
                                   action: #selector(grantLocationTapped))
        return item
    }()
    
    private let userLocationService = UserLocationService()

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
        // Create a custom alert so we don't use up the one-time location request at the OS level
        let alertController = UIAlertController(title: "Grant Location Permission", message: "We use your location to provide the daily weather forecast for your area", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
        let approve = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.userLocationService.requestLocationPermissions()
        }
        alertController.addAction(cancel)
        alertController.addAction(approve)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension DailyForecastFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7 // TODO: @aldrich populate with view model update
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoItemCell.identifier) ?? WeatherInfoItemCell()
        // TODO: @aldrich populate with view model update
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // TODO: @aldrich populate with location service city name
        "Toronto, ON"
    }
}

extension DailyForecastFeedViewController: UserLocationServiceListener {
    func didChangeLocationPermissions(to permission: CLAuthorizationStatus) {
        switch permission {
        case .authorizedAlways, .authorizedWhenInUse:
            // TODO: @aldrich make a call to fetch daily forecast
            break
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            assert(true, "Unknown location authorization status")
        }
    }
}
