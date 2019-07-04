//
//  CVScrollView.swift
//  AppleFrameworkRemake
//
//  Created by Cuong Vuong on 27/6/19.
//  Copyright © 2019 i3. All rights reserved.
//

import UIKit

class CVScrollView: UIView {
    /* Functions and properties need to complete:
     - contentSize
     - Scroll
     - Paging
     
     - Delegate methods(optional):
        + ScrollViewDidEndScroll
        + ScrollViewDidStartScroll
     
        open func setContentOffset(_ contentOffset: CGPoint, animated: Bool) // animate at constant velocity to new offset
     */

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var contentOffset: CGPoint
    var contentSize: CGSize
    var isShowHorizontalScrollBar = true {
        didSet {
            hScrollBar.isHidden = !isShowHorizontalScrollBar
        }
    }
    
    var isShowVerticalScrollBar = true {
        didSet {
            vScrollBar.isHidden = !isShowVerticalScrollBar
        }
    }

    private var hScrollBar: CVScrollBar
    private var vScrollBar: CVScrollBar
    
    override init(frame: CGRect) {
        contentSize = frame.size
        contentOffset = .zero
        
        hScrollBar = CVScrollBar(isHorizontal: true)
        vScrollBar = CVScrollBar(isHorizontal: false)
        
        super.init(frame: frame)

        self.addSubview(hScrollBar)
        self.addSubview(vScrollBar)
        
        clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag))
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onDrag(_ gesture: UIPanGestureRecognizer) {
        guard contentSize.width > bounds.width || contentSize.height > bounds.height else { return }
        
        let translation = gesture.translation(in: self)
        let newOffset = contentOffset - translation

        if newOffset.x > 0 && newOffset.x < contentSize.width - bounds.width {
            subviews.filter {
                $0 != hScrollBar && $0 != vScrollBar
            }.forEach {
                $0.center.x = $0.center.x + translation.x
            }
            contentOffset.x = newOffset.x
            hScrollBar.updateSizeAndPosition()
        }

        if newOffset.y > 0 && newOffset.y < contentSize.height - bounds.height {
            subviews.filter {
                $0 != hScrollBar && $0 != vScrollBar
            }.forEach {
                $0.center.y = $0.center.y + translation.y
            }
            contentOffset.y = newOffset.y
            vScrollBar.updateSizeAndPosition()
        }
        gesture.setTranslation(.zero, in: self)
    }
}

private class CVScrollBar: UIView {
    private static let thickness: CGFloat = 2
    private let isHorizontal: Bool

    init(isHorizontal: Bool = false) {
        self.isHorizontal = isHorizontal
        super.init(frame: .zero)
        layer.cornerRadius = CVScrollBar.thickness / 2
        backgroundColor = .black
        alpha = 0.4
    }
    
    func updateSizeAndPosition() {
        guard let superview = superview as? CVScrollView else { return }
        if isHorizontal {
            let width = superview.bounds.width * superview.bounds.width / superview.contentSize.width
            frame = CGRect(x: (superview.bounds.width - width) * superview.contentOffset.x / (superview.contentSize.width - superview.bounds.width),
                y: superview.bounds.height - CVScrollBar.thickness - 1,
                width: superview.bounds.width * superview.bounds.width / superview.contentSize.width,
                height: CVScrollBar.thickness)
        } else {
            let height = superview.bounds.height * superview.bounds.height / superview.contentSize.height
            frame = CGRect(x: superview.bounds.width - CVScrollBar.thickness - 1,
                y: (superview.bounds.height - height) * superview.contentOffset.y / (superview.contentSize.height - superview.bounds.height),
                width: CVScrollBar.thickness,
                height: height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
