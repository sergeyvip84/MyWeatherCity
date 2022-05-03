//
//  ViewController.swift
//  MyWeatherCity
//
//  Created by Serhii Palamarchuk on 01.05.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunRiceLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    @IBAction func searchPressed(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            activityIndicator.startAnimating()
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
      
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString  + "°C"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString[0])
            self.imageBackground.image = UIImage(named: weather.systemIconNameString[1])
            self.sunRiceLabel.text = convertDateTime(timeValue: weather.sunriseCity)
            self.sunSetLabel.text = convertDateTime(timeValue: weather.sunsetCity)
            self.humidityLabel.text = String(weather.humidityCity)  + "°%"
            self.pressureLabel.text = String(weather.pressureCity)  + "°hPa"
            self.activityIndicator.stopAnimating()
        }
    }
}

func convertDateTime(timeValue: Int) -> String {
    let truncatedTime = Int(timeValue)
    let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "GMT+8")
    formatter.dateFormat = "hh:mm a"

    return formatter.string(from: date)
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
