
import UIKit

class ViewController: UIViewController {
  let transition = RevealAnimator(transitionType: .presenting)
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
    view.addGestureRecognizer(pan)
  }
  
  @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      transition.interactive = true
      
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "Second") as! SecondViewController
      vc.modalPresentationStyle = .fullScreen
      vc.transitioningDelegate = self
      present(vc, animated: true)
    default:
      transition.handlePan(recognizer)
    }
  }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionType = .presenting
        return transition
    }
  
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !transition.interactive {
            return nil
        }
        return transition
    }
  
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionType = .dismissing
        return transition
    }
  
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if !transition.interactive {
            return nil
        }
        return transition
    }
}
