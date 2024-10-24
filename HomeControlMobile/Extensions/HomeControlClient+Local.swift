//
//  HomeControlClient+Local.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 24.10.24.
//

import HomeControlClient
import HomeControlKit

extension HomeControlClient {
    static var usingLocalIPAddress: Self {
        var client = HomeControlClient(address: "192.168.178.90", port: 8080)!
        client.authToken = DotEnv.require("AUTH_TOKEN")
        return client
    }
}
