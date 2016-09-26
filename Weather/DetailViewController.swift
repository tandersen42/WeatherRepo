//
//  DetailViewController.swift
//  Weather
//
//  Created by testUser on 9/25/16.
//  Copyright © 2016 Control4. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var highTemperature: UILabel!
    @IBOutlet weak var lowTemperature: UILabel!
    @IBOutlet weak var precipitationChance: UILabel!
    

    var detailItem: CityWeather? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                if(detailItem != nil && detail.Error != nil){
                    label.text = detail.Error!
                    return
                }
                else {
                    label.text = ""
                }
            }
            
            if(cityNameLabel != nil) {
                cityNameLabel.text = detail.CityName
                weatherIcon.image = detail.Image
                currentTemperature.text = "Current Temperature: " + detail.CurrentTemperature
                highTemperature.text = "Today's High: " + detail.HighTemperature
                lowTemperature.text = "Today's Low: " + detail.LowTemperature
                precipitationChance.text = "Chance of Precipitation: " + detail.PrecipitationChance
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

