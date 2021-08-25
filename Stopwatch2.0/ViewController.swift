//
//  ViewController.swift
//  Stopwatch2.0
//
//  Created by Osman Perla on 8/14/21.
//

import UIKit

class ViewController: UIViewController {

    //Tableview outlet
    @IBOutlet var tableView: UITableView! // force unwrap bc it is being connected in the storyboard...
    
    @IBOutlet weak var TimerLabel: UILabel! // the title of the label (the timeString goes here)
    @IBOutlet weak var startStopButton: UIButton! // add the frame here???
    @IBOutlet weak var resetButton: UIButton!
    // create a LAP button here to be shown by default in viewDidLoad()
    
    var timer: Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //startStop button is green when view is loaded
        startStopButton.frame = CGRect(x: 267, y: 381.5, width: 20, height: 20)
        startStopButton.layer.cornerRadius = 0.5 * startStopButton.bounds.size.width // FIX BUTTON CORNER RADIUS
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(.white, for: .normal)
        startStopButton.backgroundColor = .systemGreen
        
        // reset button is shown when the view is loaded
        resetButton.frame = CGRect(x: 50, y: 381.5, width: 20, height: 20)
        resetButton.layer.cornerRadius = 0.5 * resetButton.bounds.size.width // FIX BUTTON CORNER RADIUS
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = .systemGray
        
        //delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func resetTapped(_ sender: Any) { // if the reset button is tapped...
        self.count = 0 // reset the count
        self.timer.invalidate() // stop the timer
        self.TimerLabel.text = makeTimeString(hours: 0, minutes: 0, seconds: 0) // resets the timeString
        
        // show the START button again to further indicate that the timer has been reset
        self.startStopButton.frame = CGRect(x: 267, y: 381.5, width: 20, height: 20)
        self.startStopButton.layer.cornerRadius = 0.5 * startStopButton.bounds.size.width
        self.startStopButton.setTitle("Start", for: .normal)
        self.startStopButton.setTitleColor(.white, for: .normal)
        self.startStopButton.backgroundColor = .systemGreen
        
        // if the lap button(reset) is tapped while the timer is going, add the current time to the next available table view cell...
        
    }
    
    @IBAction func startStopTapped(_ sender: Any) { // method for whether or not the start/stop button is tapped...
        if(timerCounting) {
            timerCounting = false // if the user taps this button and timerCounting is now false,
            timer.invalidate() // stop the timer,
            // show the START button to allow the user to start the timer again
            startStopButton.frame = CGRect(x: 267, y: 381.5, width: 20, height: 20)
            startStopButton.layer.cornerRadius = 0.5 * startStopButton.bounds.size.width
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.setTitleColor(.white, for: .normal)
            startStopButton.backgroundColor = .systemGreen
            
            // show the reset button when the timer is stopped
            resetButton.frame = CGRect(x: 50, y: 381.5, width: 20, height: 20)
            resetButton.layer.cornerRadius = 0.5 * resetButton.bounds.size.width // FIX BUTTON CORNER RADIUS
            resetButton.setTitle("Reset", for: .normal)
            resetButton.setTitleColor(.white, for: .normal)
            resetButton.backgroundColor = .systemGray
        }
        else
        {
            timerCounting = true // if the button is tapped again and timerCounting is now true again,
            // show the STOP button to allow the user to stop the timer
            startStopButton.frame = CGRect(x: 267, y: 381.5, width: 20, height: 20)
            startStopButton.layer.cornerRadius = 0.5 * startStopButton.bounds.size.width
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.setTitleColor(.white, for: .normal)
            startStopButton.backgroundColor = .systemRed
            // set the timer to start counting
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            
            // show the lap button when the timer is started...
            resetButton.frame = CGRect(x: 50, y: 381.5, width: 20, height: 20)
            resetButton.layer.cornerRadius = 0.5 * resetButton.bounds.size.width // FIX BUTTON CORNER RADIUS
            resetButton.setTitle("Lap", for: .normal)
            resetButton.setTitleColor(.white, for: .normal)
            resetButton.backgroundColor = .systemGray
            
            
            // create a lap in the first table view cell when the timer is started...this cell also has timer function going in real time
            // when the lap button is tapped, bring in a new cell with a timer going and push the first cell with the time at which the lap button was tapped to the next cell below and stop the time for that cell...
        }
    }
    
    // functionality for the timer counting
    @objc func timerCounter() -> Void { //VOID = the function returns no value
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count) // time holds the value of the seconds to HOUR/MINUTES/SECONDS conversion
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2) // parameters take the index of each returned Int value
        TimerLabel.text = timeString // the timerLabel will show the timeString and change as "count" is increased
    }
    
    // Edit this funtion later if you want to add milliseconds to the timerString
    // method to take all the added up seconds from "count" and convert it to Hours/Minutes/Seconds to then be used in the timerString...
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        // math conversion formula:
                //  seconds          minutes                  hours
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    // method to create a timeString using the return values from the calculation above
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = "" // string initially has nothing in it
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}

// Delegate and DataSource extensions
extension ViewController: UITableViewDelegate { // handles interaction of cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // height of each row
        50
    }
}

extension ViewController: UITableViewDataSource { // handles the data shown in the tableView...
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") //add indexPath
        cell?.textLabel?.text = "lap time goes here" // when lap button is pressed, the lap time will go here...
        return cell!
    }
}
