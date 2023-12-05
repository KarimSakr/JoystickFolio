//
//  RegisterationViewController.swift
//  JoyStickFolio
//
//  Created by Karim Sakr on 03/12/2023.
//

import UIKit

class RegisterationViewController: UIViewController {
    
    //MARK: - Login Process
    private let processes = RegisterationProcessData.allProcesses
    private var index: Int = 0
    
    private var titleText   = ""
    private var placeholder = ""
    private var buttonTitle = ""
    
    private var progressValue = 0.0
    
    
    //MARK: - titleLabel
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .center
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 30.0, weight: .regular)
        return label
    }()
    
    //MARK: - TextField
    private let textField: UITextField = {
        let field = UITextField()
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    //MARK: - Button
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let progressBarView: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.progress = 0.0
        progressBar.progressTintColor = .accent
        return progressBar
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // add target to button
        submitButton.addTarget(self,
                               action: #selector(buttonPressed),
                               for: .touchUpInside)
        
        
        textField.placeholder = processes[index].placeholder
        submitButton.setTitle(processes[index].buttonTitle, for: .normal)
        titleLabel.text = processes[index].title
        
        progressBarView.progress = Float(progressValue)
        
        view.addSubview(progressBarView)
        view.addSubview(textField)
        view.addSubview(submitButton)
        view.addSubview(titleLabel)
        
        titleLabel.text? = ""
        TextAnimator().animateTitle(text: processes[index].title) { letter in
            self.titleLabel.text?.append(letter)
            self.titleLabel.frame = CGRect(x: .zero,
                                           y: self.textField.top - 200,
                                           width: self.view.width,
                                           height: 150)
        }
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        progressBarView.frame = CGRect(x: (view.width / 2) - ((view.width * 0.8) / 2),
                                       y: view.top + 60,
                                       width: view.width * 0.8,
                                       height: 10)
        
        
        titleLabel.frame = CGRect(x: .zero,
                                  y: textField.top - 200,
                                  width: view.width,
                                  height: 150)
        
        
        textField.frame = CGRect(x: 25,
                                 y: (view.height / 2) - 70,
                                 width: view.width - 50,
                                 height: 52)
        
        submitButton.frame = CGRect(x: 25,
                                    y: textField.bottom + 10,
                                    width: view.width - 50,
                                    height: 52)
    }
    
    @objc private func buttonPressed() {
        
        if processes.last != processes[index] {
            index += 1
            progressValue += 1.0 / Double(processes.count - 1)
            
            textField.placeholder = processes[index].placeholder
            submitButton.setTitle(processes[index].buttonTitle, for: .normal)
            titleLabel.text = processes[index].title
            
            progressBarView.progress = Float(progressValue)
            
            titleLabel.text? = ""
            TextAnimator().animateTitle(text: processes[index].title) { letter in
                self.titleLabel.text?.append(letter)
                self.titleLabel.frame = CGRect(x: .zero,
                                               y: self.textField.top - 200,
                                               width: self.view.width,
                                               height: 150)
            }
        }
    }
}
