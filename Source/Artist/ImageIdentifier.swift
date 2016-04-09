//
//  ImageIdentifier.swift
//  AllTriangles
//
//  Created by Colin Gray on 10/19/2015.
//  Copyright (c) 2015 AllTriangles. All rights reserved.
//

enum ImageIdentifier {

    case None
    case ColorPath(path: UIBezierPath, color: Int)
    case ColorLine(length: CGFloat, color: Int)

}
