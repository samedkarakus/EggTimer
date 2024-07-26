import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var liquidEgg: UIImageView!
    @IBOutlet weak var softEgg: UIImageView!
    @IBOutlet weak var hardEgg: UIImageView!
    
    var selectedEggType: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        liquidEgg.isUserInteractionEnabled = true
        softEgg.isUserInteractionEnabled = true
        hardEgg.isUserInteractionEnabled = true

        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        liquidEgg.addGestureRecognizer(tapGestureRecognizer1)
        softEgg.addGestureRecognizer(tapGestureRecognizer2)
        hardEgg.addGestureRecognizer(tapGestureRecognizer3)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImageView = tapGestureRecognizer.view as? UIImageView else { return }

        liquidEgg.image = UIImage(named: "eggShadow")
        softEgg.image = UIImage(named: "eggShadow")
        hardEgg.image = UIImage(named: "eggShadow")

        if tappedImageView == liquidEgg {
            tappedImageView.image = UIImage(named: "liquidEgg")
            selectedEggType = "liquid"
        } else if tappedImageView == softEgg {
            tappedImageView.image = UIImage(named: "softEgg")
            selectedEggType = "soft"
        } else if tappedImageView == hardEgg {
            tappedImageView.image = UIImage(named: "hardEgg")
            selectedEggType = "hard"
        }
    }

    @IBAction func startTimerButton(_ sender: UIButton) {
        guard let selectedEggType = selectedEggType else {
            let alert = UIAlertController(title: "Uyarı", message: "Lütfen bir yumurta türü seçin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let timerViewController = storyboard.instantiateViewController(withIdentifier: "TimerViewController") as? TimerViewController {
            timerViewController.eggType = selectedEggType
            navigationController?.pushViewController(timerViewController, animated: true)
        }
    }
}
