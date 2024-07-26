import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var eggImageView: UIImageView!
    
    var audioPlayer: AVAudioPlayer!
    var eggType: String?
    var initialDuration: TimeInterval = 0
    var remainingTime: TimeInterval = 0
    var timer: Timer?
    var shapeLayer: CAShapeLayer!
    var isTimerRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupProgressCircle()
        setupEggType()
        updateStopButtonTitle()
        startTimer(duration: initialDuration)
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    /*
    func setupProgressCircle() {
        let width = progressView.bounds.width
        let height = progressView.bounds.height
        let eggHeight = height * 0.45
        let eggWidth = width * 0.4
        let centerX = width / 2
        let centerY = height / 2

        let ovalRect = CGRect(x: centerX / 2.5, y: centerY / 2, width: eggWidth, height: eggHeight)
        let circularPath = UIBezierPath(ovalIn: ovalRect)

        shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemOrange.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        shapeLayer.lineDashPattern = [15, 15]

        progressView.layer.addSublayer(shapeLayer)
    }
    */
    
    func setupEggType() {
        switch eggType {
        case "liquid":
            initialDuration = 5 * 60 // 5 dakika
            navigationItem.title = "Liquid Egg Timer"
            eggImageView.image = UIImage(named: "liquidEgg")
        case "soft":
            initialDuration = 7 * 60 // 7 dakika
            navigationItem.title = "Soft Egg Timer"
            eggImageView.image = UIImage(named: "softEgg")
        case "hard":
            initialDuration = 12 * 60 // 12 dakika
            navigationItem.title = "Hard Egg Timer"
            eggImageView.image = UIImage(named: "hardEgg")
        default:
            initialDuration = 5 * 60
            eggImageView.image = UIImage(named: "eggShadow")
        }
        remainingTime = initialDuration
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm-sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = audioPlayer else { return }
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        guard let player = audioPlayer else { return }
        player.stop()
        audioPlayer = nil
    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
        if isTimerRunning {
            timer?.invalidate()
            isTimerRunning = false
            updateStopButtonTitle()
        } else {
            if remainingTime > 0 {
                startTimer(duration: remainingTime)
                isTimerRunning = true
                updateStopButtonTitle()
            } else {
                stopSound()
                navigationController?.popViewController(animated: true)
            }
        }
    }

    func startTimer(duration: TimeInterval) {
        remainingTime = duration
        updateTimerLabel()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
        updateStopButtonTitle()
    }

    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateTimerLabel()
            //updateProgressCircle()
        } else {
            timer?.invalidate()
            timerLabel.text = "Time's up!"
            isTimerRunning = false
            playSound()
            stopButton.setTitle("Stop the Alarm", for: .normal)
        }
    }

    func updateTimerLabel() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    /*
    func updateProgressCircle() {
        let fullDuration: CGFloat = CGFloat(initialDuration)
        let elapsedDuration: CGFloat = CGFloat(fullDuration - remainingTime)
        let percentageElapsed = elapsedDuration / fullDuration

        shapeLayer.strokeEnd = percentageElapsed
    }
    */
    
    func updateStopButtonTitle() {
        let title = isTimerRunning ? "Stop Timer" : (remainingTime > 0 ? "Start Timer Again" : "Stop the Alarm")
        stopButton.setTitle(title, for: .normal)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
