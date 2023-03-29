//
//  UIView+PinnedSubview.swift
//  Today
//
//  Created by 최우영 on 2023/03/28.
//

import UIKit

extension UIView {
    
    // if your subview doesn't have an intrinsic height, you can use the height parameter to specify one.
    func addPinnedSubview(_ subview: UIView, height: CGFloat? = nil, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)) {
        addSubview(subview)
        
        // prevent the system from creating automatic constraints for this view.
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the subview to the top of the superview
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        
        // Add padding to the leading edge of the subview by specifying and activating a leading anchor constraint.
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        
        // Add padding to the trailing edge of the subview by specifying and activating a trailing anchor constraint.
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * insets.right).isActive = true
        
        // Add padding to the bottom of the subview by defining and activating a bottom anchor constraint.
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom).isActive = true
        
        // If the caller explicitly provides a height to the function, constrain the subview to that height.
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

// Because each control uses a similar layout,
// you'll extend the capabilities of a view to add a subview
// that is pinned to its superview with optional padding.

// The system automatically generates constraints based on a view's current size and position.
// But thos constraints don't allow the view to adapt.

// The UIKit constraint syntax allows you to define
// and activate a constraint in a single step
// by setting the isActive property of a new constraint to true.
