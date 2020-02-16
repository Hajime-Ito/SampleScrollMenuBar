//
//  ViewControllerHeader.swift
//  SampleRefreshAnimation
//
//  Created by hajime ito on 2020/02/10.
//  Copyright © 2020 hajime_poi. All rights reserved.
//

import UIKit

extension ViewController {
    
    enum headerViewStatus {
        case start(_ initHeaderFrameMinY: CGFloat)
        case move_up(_ sub: CGFloat, _ headerViewFrame: CGRect)
        case stop_up(_ scrollViewY: CGFloat, _ initHeaderFrameMaxY: CGFloat)
        case move_down(_ sub: CGFloat, _ headerViewFrame: CGRect)
        case stop_down(_ scrollViewY: CGFloat, _ initHeaderFrameMinY: CGFloat)
    }
    
    private func getHeaderViewStatus(_ sub: CGFloat, _ scrollViewY: CGFloat, _ headerViewFrame: CGRect, _ lastScrollViewY: CGFloat, _ initHeaderFrame: [String:CGFloat]) -> headerViewStatus {
        if (scrollViewY <= (0 - initHeaderFrame["height"]!)) {
            return headerViewStatus.start(initHeaderFrame["minY"]!)
        } else if (lastScrollViewY > scrollViewY) {
            if(headerViewFrame.origin.y >= scrollViewY + initHeaderFrame["maxY"]!) { return headerViewStatus.stop_up(scrollViewY, initHeaderFrame["maxY"]!)}
            else { return headerViewStatus.move_up(sub, headerViewFrame)}
        } else {
            if(headerViewFrame.origin.y <= scrollViewY + initHeaderFrame["minY"]!) { return headerViewStatus.stop_down(scrollViewY, initHeaderFrame["minY"]!)}
            else { return headerViewStatus.move_down(sub, headerViewFrame)}
        }
    }
    
    
    private func scrolling(status: headerViewStatus) {
        
        func start(_ initHeaderFrameMaxY: CGFloat) {
            print("Start")
            myHeaderView.frame.origin.y = initHeaderFrameMaxY
        }
        
        func move_up(_ sub: CGFloat,_ headerViewFrame: CGRect) {
            print("Move_up")
            myHeaderView.frame.origin.y = (headerViewFrame.origin.y + sub)
        }
        
        func stop_up(_ scrollViewY: CGFloat, _ initHeaderFrameMaxY: CGFloat) {
            print("Stop_up")
            myHeaderView.frame.origin.y = (scrollViewY + initHeaderFrameMaxY)
        }
        
        func move_down(_ sub: CGFloat, _ headerViewFrame: CGRect) {
            print("Move_down")
            myHeaderView.frame.origin.y = (headerViewFrame.origin.y + sub)
        }
        
        func stop_down(_ scrollViewY: CGFloat, _ initHeaderFrameMinY: CGFloat) {
            print("Stop_down")
            myHeaderView.frame.origin.y = (scrollViewY + initHeaderFrameMinY)
        }
        
        switch status {
        case let .start(initHeaderFrameMinY): start(initHeaderFrameMinY)
        case let .move_up(sub, headerViewFrame): move_up(sub, headerViewFrame)
        case let .stop_up(scrollViewY, initHeaderFrameMaxY): stop_up(scrollViewY, initHeaderFrameMaxY)
        case let .move_down(sub, headerViewFrame): move_down(sub, headerViewFrame)
        case let .stop_down(scrollViewY, initHeaderFrameMinY): stop_down(scrollViewY, initHeaderFrameMinY)
        }
    }
    
    private func scrollingViewBar(scrollView: UIScrollView) {
        scrollViewBar.frame.origin.x += (lastContentOffsetX - scrollView.contentOffset.x)
        lastContentOffsetX = scrollView.contentOffset.x
    }
    
    private func scrollingMyTableView(scrollView: UIScrollView) {
        //MARK: --headerView
        var sub: CGFloat = 0
        // MARK: -- 以下のinitialHeaderFrameに適切な値を入力するだけで、このプログラムは動作します。
        let initialHeaderFrame: [String:CGFloat] = ["Y": -230, "height": 30]
        let headerFrame: [String:CGFloat] = ["minY": initialHeaderFrame["Y"]! , "maxY": initialHeaderFrame["Y"]! + initialHeaderFrame["height"]!, "height": initialHeaderFrame["height"]!]
        
        sub += (lastContentOffset - scrollView.contentOffset.y)*0.1
        
        let status = self.getHeaderViewStatus(sub, scrollView.contentOffset.y, myHeaderView.frame, lastContentOffset, headerFrame)
        self.scrolling(status: status)
        lastContentOffset = scrollView.contentOffset.y
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case self.scrollView:
            scrollingViewBar(scrollView: scrollView)
        case self.myTableView:
            scrollingMyTableView(scrollView: scrollView)
        default:
            break
        }
    }
}


