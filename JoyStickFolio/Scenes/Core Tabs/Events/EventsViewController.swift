//
//  EventsViewController.swift
//  JoyStickFolio
//
//  Created by Karim Sakr on 12/05/2024.
//  Copyright (c) 2024 Karim Sakr. All rights reserved.
//

import UIKit
import RxSwift

protocol EventsViewControllerOutput {
    
}

class EventsViewController: UIViewController {
    
    var interactor: EventsViewControllerOutput?
    var router: EventsRouter?
    
    
    
}

//MARK:- View Lifecycle
extension EventsViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventsConfigurator.shared.configure(viewController: self)
        addBottomGradient(color: .purpleApp, alpha: 0.3)
    }
    
}
