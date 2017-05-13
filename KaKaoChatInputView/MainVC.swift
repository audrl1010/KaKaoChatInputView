//
//  MainVC.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

protocol KeyboardObservable {
  func registerKeyboardObservers()
  func removeKeyboardObservers()
  func keyboardWillShow(_ notification: Notification)
  func keyboardWillHide(_ notification: Notification)
  func adjustInsetForKeyboard(_ show: Bool, notification: Notification)
}

protocol keyboardDismissableByViewTouch {
  var keyboardDismissTapGesture: UITapGestureRecognizer? { get set }
  
  func adjustKeyboardDismissTapGesture(isKeyboardVisible: Bool)
  func dismissKeyboard()
}


class MainVC: BaseVC {
  
  // MARK: - Constants
  
  fileprivate struct Constant {
    static let inputBarHeight = CGFloat(40)
    static let tableViewEstimatedRowHeight = CGFloat(100)
  }
  
  fileprivate struct Color {
    static let tableViewColor =
      UIColor(red: 189/255, green: 209/255, blue: 220/255, alpha: 1.0)
  }
  
  // MARK: - Properties
  
  var keyboardDismissTapGesture: UITapGestureRecognizer?
  
  fileprivate var inputBarBottomConstraint: NSLayoutConstraint?
  
  fileprivate var inputBar = InputBar()
  
  fileprivate var tableView = UITableView(frame: .zero).then {
    $0.separatorStyle = .none
    $0.estimatedRowHeight = Constant.tableViewEstimatedRowHeight
    $0.rowHeight = UITableViewAutomaticDimension
    $0.backgroundColor = Color.tableViewColor
    $0.scrollIndicatorInsets.bottom = Constant.inputBarHeight
    $0.contentInset.bottom += Constant.inputBarHeight
    $0.register(
      MainCell.self,
      forCellReuseIdentifier: MainCell.cellIdentifier)
  }
  
  // MARK: - Life Cycle
  
  deinit {
    removeKeyboardObservers()
  }
  
  override init(
    nibName nibNameOrNil: String?,
    bundle nibBundleOrNil: Bundle?) {
    
    super.init(nibName: nil, bundle: nil)
    registerKeyboardObservers()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupViews() {
    view.addSubview(tableView)
    view.addSubview(inputBar)
    tableView.dataSource = self
    
  }
  
  override func setupConstraints() {
    tableView
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_topAnchor(equalTo: topLayoutGuide.bottomAnchor)
      .fs_bottomAnchor(equalTo: view.bottomAnchor)
      .fs_endSetup()
    
    inputBar
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_bottomAnchor(
        equalTo: view.bottomAnchor,
        constraint: &inputBarBottomConstraint)
      .fs_heightAnchor(equalToConstant: Constant.inputBarHeight)
      .fs_endSetup()
  }
}

// MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell =
      tableView.dequeueReusableCell(
        withIdentifier: MainCell.cellIdentifier,
        for: indexPath) as! MainCell
    cell.backgroundColor = .clear
    cell.isUserInteractionEnabled = false
    return cell
  }
}


// MARK: - KeyboardObservable

extension MainVC: KeyboardObservable {
  
  func registerKeyboardObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: .UIKeyboardWillHide,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: .UIKeyboardWillShow,
      object: nil)
  }
  
  func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func keyboardWillShow(_ notification: Notification) {
    adjustKeyboardDismissTapGesture(isKeyboardVisible: true)
    adjustInsetForKeyboard(true, notification: notification)
  }
  
  func keyboardWillHide(_ notification: Notification) {
    adjustKeyboardDismissTapGesture(isKeyboardVisible: false)
    adjustInsetForKeyboard(false, notification: notification)
  }
  
  func adjustInsetForKeyboard(_ show: Bool, notification: Notification) {
    let userInfo = notification.userInfo ?? [:]
    
    let keyboardFrame =
      (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
    let keyboardDuration =
      userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
    
    inputBarBottomConstraint?.constant = show ? -keyboardFrame.height : 0
    
    UIView.animate(withDuration: keyboardDuration) { [weak self] in
      guard let `self` = self else { return }
      self.view.layoutIfNeeded()
    }
    
    let adjustmentHeight = keyboardFrame.height * (show ? 1 : -1)
    tableView.contentInset.bottom += adjustmentHeight
    tableView.scrollIndicatorInsets.bottom += adjustmentHeight
  }
}


// MARK: - keyboardDismissableByViewTouch

extension MainVC: keyboardDismissableByViewTouch {
  
  func adjustKeyboardDismissTapGesture(isKeyboardVisible: Bool) {
    if isKeyboardVisible {
      if keyboardDismissTapGesture == nil {
        keyboardDismissTapGesture =
          UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyboardDismissTapGesture!)
      }
    }
    else {
      if keyboardDismissTapGesture != nil {
        view.removeGestureRecognizer(keyboardDismissTapGesture!)
        keyboardDismissTapGesture = nil
      }
    }
  }
  
  func dismissKeyboard() {
    inputBar.textView.resignFirstResponder()
  }
}


