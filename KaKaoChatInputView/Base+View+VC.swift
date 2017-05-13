//
//  Base+View+VC.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class BaseView: UIView {
  
  // MARK: - View Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  func setupViews() { }
  func setupConstraints() { }
}


class BaseTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  class var cellIdentifier: String { return "\(self)" }
  
  // MARK: - View Life Cycle
  
  override init(
    style: UITableViewCellStyle,
    reuseIdentifier: String?) {
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  func setupViews() { }
  func setupConstraints() { }
}

class BaseVC: UIViewController {
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  func setupViews() { }
  func setupConstraints() { }
}





