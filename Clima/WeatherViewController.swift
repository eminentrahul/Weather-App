//
//  ViewController.swift
//  WeatherApp
//
//  Created by Rahul Ravi Prakash on 17/06/2018.
//  Copyright (c) 2018 Rahul Ravi Prakash. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "24be38882cf2c6e26a22c9a92d06f3ae"
    

    //TODO: Declare instance variables here
	let locationManager = CLLocationManager()
	let weatherDataModel = WeatherDataModel()
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.stopUpdatingLocation()
    
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
	func getWeatherData(url : String, parameter : [String : String]){
		Alamofire.request(url, method: .get, parameters: parameter).responseJSON {
			response in
			if response.result.isSuccess {
				print("Success!")
				
				let weatherDataJSON : JSON = JSON(response.result.value!)
				
				print(weatherDataJSON)
				
			}else {
				print("Error \(String(describing: response.result.error))")
				self.cityLabel.text = "Connection Error!"
			}
			
		}
		
	}
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
	func updateWeatherData(json : JSON) {
		if let temperatureResult = json["main"]["temp"].double {
		
			weatherDataModel.temperature = Int(temperatureResult - 273.15)
			weatherDataModel.city = json["name"].stringValue
			weatherDataModel.condition = json["weather"][0]["id"].intValue
			weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
			updateUIWithWeatherData()
		}
		else {
			cityLabel.text = "Weather Unavailable"
		}
	}
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
	func updateUIWithWeatherData() {
		cityLabel.text = weatherDataModel.city
		temperatureLabel.text = "\(weatherDataModel.temperature)"
		weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
	}
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations[locations.count - 1]
		if location.horizontalAccuracy > 0 {
			locationManager.stopUpdatingLocation()
			
			print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
			
			let latitude = String(location.coordinate.latitude)
			let longitude = String(location.coordinate.longitude)
			
			let params : [String : String] = ["lat" : latitude, "long" : longitude, "appid" : APP_ID ]
			
			getWeatherData(url : WEATHER_URL, parameter : params)
		}
	}
    
    
    
    //Write the didFailWithError method here:
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
		cityLabel.text = "Location Unavailable"
	}
    
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


