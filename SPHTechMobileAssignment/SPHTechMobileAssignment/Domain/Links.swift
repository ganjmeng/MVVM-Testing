//
//  links.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 5/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
struct Links : Codable {
	let start : String?
	let next : String?

	enum CodingKeys: String, CodingKey {

		case start = "start"
		case next = "next"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		start = try values.decodeIfPresent(String.self, forKey: .start)
		next = try values.decodeIfPresent(String.self, forKey: .next)
	}

}
