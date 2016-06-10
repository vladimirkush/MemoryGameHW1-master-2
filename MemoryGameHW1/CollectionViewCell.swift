//
//  CollectionViewCell.swift
//  MemoryGameHW1
//
//  Created by Admin on 25/03/2016.
//  Copyright © 2016 SVTeam. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var BackImageView:UIImageView!
    var FrontImageView:UIImageView!
    var isFaceUp=false
    
    func setImages(front:UIImage, back:UIImage){
        if(FrontImageView == nil){
            FrontImageView = UIImageView(frame: CGRect(x:0, y:0, width: 70, height: 70))
            FrontImageView.contentMode = UIViewContentMode.ScaleToFill
        }
        if(BackImageView == nil){
            BackImageView = UIImageView(frame: CGRect(x:0, y:0, width: 70, height: 70))
            BackImageView.contentMode = UIViewContentMode.ScaleToFill
            BackImageView.image = back
            contentView.addSubview(BackImageView)
        }
        FrontImageView.image=front
    }
    
    func flip() {
        if (!isFaceUp) {
            UIView.transitionFromView(BackImageView, toView: FrontImageView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        } else {
            UIView.transitionFromView(FrontImageView, toView: BackImageView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
        }
        isFaceUp = !isFaceUp
    }
    
    func disable(){
        self.userInteractionEnabled = false
    }
    
    func enable(){
        self.userInteractionEnabled = true
    }
    
    
}