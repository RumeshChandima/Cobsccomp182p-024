//
//  RoundedViews.swift
//  RumeshChandima-cobsccomp182p-024
//
//  Created by Geeth Rangana on 2/29/20.
//  Copyright © 2020 nibm. All rights reserved.
//

import UIKit

class RoundedShadowView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        //layer.shadowColor = AppColors.Blue.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView : UIImageView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }    
}
