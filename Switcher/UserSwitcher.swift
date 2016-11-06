//
//  UserSwitcher.swift
//  SubviewToFrontAnimation
//
//  Created by include tech. on 02/08/16.
//  Copyright © 2016 include tech. All rights reserved.
//

import UIKit

@objc public protocol UserSwitcherDelegate:  NSObjectProtocol {
    
    @objc optional func buttonTappedForUserId(userId: String)
    @objc optional func buttonWillStartAnimating()
}

class IdButton: UIButton {
    var identifier : String?
}

class UserSwitcher : UIView {
    
    weak var delegate:UserSwitcherDelegate?
    var number: Int?
    var userIds : [String] = [] {
        didSet {
            
            for (_, btn) in self.imageButtons.enumerated() {
                btn.removeFromSuperview()
            }
            self.imageButtons.removeAll()
            
            setupButtons(count: userIds.count)
            transformButtons(translatePoint: CGPoint(x: 0, y: 0))
        }
    }
    var imageButtons : [IdButton] = []
    let padding : CGFloat = 0.0
    var images : [UIImage] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    func setupButtons(count: Int) -> Void {
        for i in 0 ..< count {
            let button = IdButton(type: .custom)
//            button.backgroundColor = getRandomColor()
            button.setImage(UIImage(named: String(i + 1)), for: .normal)
            button.frame = CGRect(x: padding, y: padding, width: frame.size.width - (padding * 2), height: frame.size.width - (padding * 2))
            button.layer.cornerRadius = (frame.size.width - (padding * 2)) / 2
            
            button.clipsToBounds = true
            button.identifier = userIds[i]
            self.addSubview(button)
            button.addTarget(self, action: #selector(UserSwitcher.buttonTapped(button:)), for: .touchUpInside)
            imageButtons.append(button);
        }
    }
    
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    func transformButtons(translatePoint : CGPoint) -> Void {
        for (i, btn) in self.imageButtons.enumerated() {
            if i == imageButtons.count - 2 {
                let factor : CGFloat = 0.8
                let scaleTransform = CGAffineTransform(scaleX: factor, y: factor)
                let translateTransform = CGAffineTransform(translationX: -5 , y: -5)
                btn.transform = scaleTransform.concatenating(translateTransform)
            } else {
                btn.transform = CGAffineTransform.identity
            }
        }
    }
    
    func buttonTapped(button :IdButton) {
        if imageButtons.count > 1 {
            self.delegate?.buttonWillStartAnimating!()
        UIView.animate(withDuration: 0.33, animations: {
            self.imageButtons.removeLast()
            self.transformButtons(translatePoint: CGPoint(x:0, y:0))

            let scaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            let translateTransform = CGAffineTransform(translationX: -(self.frame.size.width/2), y: -10)
            button.transform = scaleTransform.concatenating(translateTransform)
            
            }) { (Bool) in
                self.sendSubview(toBack: button)
                self.imageButtons.insert(button, at: 0)
                
                UIView.animate(withDuration: 0.33, animations: {
                    self.transformButtons(translatePoint: CGPoint(x:0, y:0))
                    }, completion: { (Bool) in
                        let lastButton = self.subviews.last as! IdButton
                        self.delegate?.buttonTappedForUserId!(userId: lastButton.identifier!)
                })
            }
        }
    }
}
