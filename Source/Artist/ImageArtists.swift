//
//  ImageArtists.swift
//  PlayWithSprites
//
//  Created by Colin Gray on 12/19/15.
//  Copyright © 2015 colinta. All rights reserved.
//

extension ImageIdentifier {

    var artist: Artist {
        switch self {
        case .None:
            return Artist()
        case let .ColorLine(length, color):
            let color = UIColor(hex: color)
            let artist = LineArtist(length, color)
            return artist
        case let .ColorPath(path, color):
            let color = UIColor(hex: color)
            let artist = PathArtist(path, color)
            return artist
        }
    }

}
