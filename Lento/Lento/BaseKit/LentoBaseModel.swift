//
//  LentoBaseModel.swift
//  Lento
//
//  Created by zhang on 2022/10/22.
//

import UIKit
import ObjectMapper

public class LentoBaseModel: Mappable {

    init() {}
    required public init?(map: ObjectMapper.Map) {}
    public func mapping(map: ObjectMapper.Map) {}
}
