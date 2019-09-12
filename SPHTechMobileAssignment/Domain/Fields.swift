//
//  Fields.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 5/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import Foundation
struct Fields : Codable {
	let type : String?
	let id : String?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
