//
//  FileManager+MAExtensions.swift
//  Lento
//
//  Created by zhang on 2022/10/22.
//

#if os(iOS) || os(tvOS)

import UIKit

public extension FileManager {
 
    /// 读取本地文件 -> Dictionary/Array
    @objc static func JsonData(forResource desc: String?, ofType type: String? = nil) -> Any? {
        guard let _ = desc else { return nil }
        guard let path = Bundle.main.path(forResource: desc, ofType: type ?? "json") else { return nil }
        guard let data = NSData(contentsOfFile: path) else { return nil }
        return try? JSONSerialization.jsonObject(with: data as Data) as? [String: Any]
    }
}

#endif
