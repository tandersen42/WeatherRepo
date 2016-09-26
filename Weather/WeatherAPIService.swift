//
//  WeatherAPIService.swift
//  Weather
//
//  Created by testUser on 9/25/16.
//  Copyright © 2016 Control4. All rights reserved.
//

import Foundation
import UIKit

class WeatherAPIService {
    
    let apiKey : String = "&APPID=d45ea55f23b8bc429c6eef5b33ad89f2"
    let units : String = "&units=imperial"
    let apiURL : String = "http://api.openweathermap.org/data/2.5/weather?q="
    
    let darkSkyURL : String = "https://api.darksky.net/forecast/"
    let darkSkyAPIKey : String = "2c29fa763b38b7353938a0a2d3dccd1a"
    
    func getWeatherModel(cityName: String, callback : (CityWeather) -> Void) {
        var urlString : String = apiURL + cityName + apiKey + units
        urlString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "")
        let url = NSURL(string: urlString)
        
        let returnObj = CityWeather()
        
        if(url == nil) {
            returnObj.Error = "Invalid URL"
            callback(returnObj)
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            do {
                if(error != nil) {
                    returnObj.Error = error.debugDescription
                    callback(returnObj)
                    return
                }
                
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                
                returnObj.CityName = json["name"] as! String
                returnObj.CurrentTemperature = String((json["main"] as! [String:AnyObject])["temp"] as! Double) + "°F"
                returnObj.IconName = (json["weather"]![0] as! [String:AnyObject])["icon"] as! String
                returnObj.Latitude = String(json["coord"]!["lat"]!!)
                returnObj.Longitude = String(json["coord"]!["lon"]!!)
                
                let url = NSURL(string:"http://openweathermap.org/img/w/" + returnObj.IconName + ".png")
                let data = NSData(contentsOfURL:url!)
                if data != nil {
                    returnObj.Image = UIImage(data:data!)
                }
                else {
                    returnObj.Error = "Could not retrieve image"
                }
                
                self.addDataFromDarkSkyToReturnObj(returnObj, callback: callback)
            }
            catch {
                returnObj.Error = "Retrieving weather data failed"
                callback(returnObj)
            }
        }
        
        task.resume()
    }
    
    func addDataFromDarkSkyToReturnObj(returnObj: CityWeather, callback : (CityWeather) -> Void) {
        let urlString : String = darkSkyURL + darkSkyAPIKey + "/" + returnObj.Latitude + "," + returnObj.Longitude
        
        let url = NSURL(string: urlString)
        
        let darkSkyTask = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            do {
                if(error != nil) {
                    returnObj.Error = error.debugDescription
                    callback(returnObj)
                    return
                }
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! [String: AnyObject]
                
                let todaysData = (json["daily"]!["data"] as! NSArray)[0]
                returnObj.PrecipitationChance = String(format: "%.0f", (todaysData["precipProbability"] as! Double * 100)) + "%"
                returnObj.LowTemperature = String(todaysData["temperatureMin"] as! Double) + "°F"
                returnObj.HighTemperature = String(todaysData["temperatureMax"] as! Double) + "°F"
                
                callback(returnObj)
                
            }
            catch {
                returnObj.Error = "Retrieving weather data failed"
                callback(returnObj)
            }
        }
        darkSkyTask.resume()
    }
}