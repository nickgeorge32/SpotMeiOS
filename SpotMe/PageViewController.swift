//
//  PageViewController.swift
//  SpotMe
//
//  Created by Nick George on 11/16/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    //MARK: Outlets and Variables
    var pageTitles = ["Lift More", "Go Farther", "Set Goals", "Compete"]
    var bgImages = ["lift_more", "go_farther", "goals", "compete"]
    var pageDescriptions = ["Never workout alone again! Discover your new cycling, running, lifting, swimming pal today.", "Never workout alone again! Discover your new cycling, running, lifting, swimming pal today.", "Never workout alone again! Discover your new cycling, running, lifting, swimming pal today.", "Never workout alone again! Discover your new cycling, running, lifting, swimming pal today."]
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: Navigate    
    func viewControllerAtIndex(index: Int) -> ViewController? {
        if (index == NSNotFound || index < 0 || index >= self.pageTitles.count) {
            return nil
        }
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as? ViewController {
            viewController.bgImageName = bgImages[index]
            viewController.titleText = pageTitles[index]
            viewController.detailsText = pageDescriptions[index]
            viewController.index = index
            return viewController
        }
        return nil
    }
}
    
    //MARK: DataSource
    extension PageViewController: UIPageViewControllerDataSource {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            var index = (viewController as! ViewController).index
            index -= 1
            return self.viewControllerAtIndex(index: index)
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            var index = (viewController as! ViewController).index
            index += 1
            return self.viewControllerAtIndex(index: index)
        }
    }
