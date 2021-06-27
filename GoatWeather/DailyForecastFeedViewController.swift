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
        view.refreshControl = UIRefreshControl()
        
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
    private var viewModel = DailyForecastViewModel(service: WeatherService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocationService.listener = self
        viewModel.presenter = self
        
        configureNavigation()
        configureSubviews()
        configureConstraints()
        
        fetchDailyForecastIfApplicable()
    }

    /// MARK :- Private UI methods
    
    private func configureNavigation() {
        navigationController?.navigationBar.topItem?.title = "Daily Forecast"
        navigationItem.rightBarButtonItem = grantLocationBarButtonItem
    }
    
    private func configureSubviews() {
        tableView.refreshControl?.addTarget(self, action: #selector(fetchDailyForecastIfApplicable), for: .valueChanged)
        view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func fetchDailyForecastIfApplicable() {
        let permissions = userLocationService.getCurrentLocationPermissions()
        
        switch permissions {
        case .authorizedAlways, .authorizedWhenInUse:
            fetchDailyForecast()
        case .denied, .notDetermined, .restricted:
            break
        @unknown default:
            assert(true, "Unknown location authorization status")
        }
    }
    
    private func fetchDailyForecast() {
        guard let coordinates = userLocationService.getCurrentLocation()?.coordinate else { return }
        userLocationService.fetchCurrentCity { cityStateString in
            self.viewModel.cityAndStateTitle = cityStateString
        }
        viewModel.getDailyForecast(with: coordinates)
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
        viewModel.weatherInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfoItemCell.identifier) as? WeatherInfoItemCell ?? WeatherInfoItemCell()
        
        if let weatherInfo = viewModel.weatherInfo {
            let viewModel = weatherInfo[indexPath.row]
            cell.dayOfWeekLabel.text = viewModel.dayOfWeek
            cell.monthDayLabel.text = viewModel.date
            cell.currentTempLabel.text = viewModel.currentTemp
            cell.highTempLabel.text = viewModel.highTemp
            cell.lowTempLabel.text = viewModel.lowTemp
            
            viewModel.getImage { image in
                cell.weatherImageView.image = image
                cell.layoutIfNeeded()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.cityAndStateTitle
    }
}

extension DailyForecastFeedViewController: UserLocationServiceListener {
    func didChangeLocationPermissions(to permission: CLAuthorizationStatus, currentLocation: CLLocation?) {
        switch permission {
        case .authorizedAlways, .authorizedWhenInUse:
            fetchDailyForecast()
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            assert(true, "Unknown location authorization status")
        }
    }
}

extension DailyForecastFeedViewController: DailyForecastPresenting {
    func feedShouldUpdate(with state: DailyForecastFeedState) {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            switch state {
            case .empty:
                break
            case .error(_):
                break
            case .feed:
                self.tableView.reloadData()
            }
        }
    }
}
