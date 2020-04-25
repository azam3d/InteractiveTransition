
import UIKit

enum TransitionType {
    case presenting
    case dismissing
}

class RevealAnimator: UIPercentDrivenInteractiveTransition {
  private var pausedTime: CFTimeInterval = 0
  var transitionType = TransitionType.presenting
  var interactive = false
  let animationDuration = 0.2
  
  init(transitionType: TransitionType) {
    self.transitionType = transitionType
    
    super.init()
  }

  func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: recognizer.view!.superview!)
    var progress: CGFloat = translation.x / 400.0
    
    if progress > 0 {
      return
    } else {
      progress = abs(progress)
    }
    progress = min(max(progress, 0.01), 0.99)
    print(progress)
    
    switch recognizer.state {
    case .changed:
      update(progress)
    case .cancelled, .ended:
      if progress < 0.5 {
        cancel()
      } else {
        finish()
      }
      interactive = false
    default:
      break
    }
  }

}

extension RevealAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
      return animationDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
      print(transitionType)
      print(interactive)
      
      let inView   = transitionContext.containerView
      let toView   = transitionContext.view(forKey: .to)!
      let fromView = transitionContext.view(forKey: .from)!

      var frame = inView.bounds

      switch transitionType {
      case .presenting:
          frame.origin.x = -frame.size.width
          toView.frame.origin = CGPoint(x: toView.frame.width, y: 0)

          inView.addSubview(toView)
          UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {
            toView.frame.origin = CGPoint(x: 0, y: toView.bounds.origin.y)
          }, completion: { finished in
              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
          })
      case .dismissing:
          toView.frame = frame
          inView.insertSubview(toView, belowSubview: fromView)

          UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {
            frame.origin.x = frame.width
              fromView.frame = frame
          }, completion: { finished in
              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
          })
      }
    }
}
