//
//  LentoConstants.swift
//  Lento
//
//  Created by corgi on 2022/7/15.
//
// - 常用常量定义

import UIKit

/// 左填充20pt
let kGeneralPaddingleft: CGFloat = 20

/// 右填充20pt
let kGeneralPaddingRight: CGFloat = 20

/// 零填充0pt
let kZeroPadding: CGFloat = 0

/// 上填充15pt
let kGeneralPaddingTop: CGFloat = 15

/// 下填充15pt
let kGeneralPaddingBottom : CGFloat = 15

/// 当前屏幕宽度
let kScreenWidth: CGFloat = UIScreen.main.bounds.width

/// 当前屏幕高度
let kScreenHeight: CGFloat = UIScreen.main.bounds.height

/// 常用最大布局宽度
let kGeneralLayoutMaxWidth: CGFloat = (kScreenWidth - kGeneralPaddingleft - kGeneralPaddingRight)

/// 导航栏组件底部
let kNavigationBarMaxY: CGFloat = UIScreen.totalNavHeight
