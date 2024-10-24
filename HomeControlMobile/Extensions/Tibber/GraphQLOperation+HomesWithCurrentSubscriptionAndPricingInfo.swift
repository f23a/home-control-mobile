//
//  GraphQLOperation+HomesWithCurrentSubscriptionAndPricingInfo.swift
//  HomeControlMobile
//
//  Created by Christoph Pageler on 23.10.24.
//

import TibberSwift

public extension GraphQLOperation where Input == EmptyInput, Output == HomesWithCurrentSubscriptionAndPricingInfo {
    static func homesWithCurrentSubscriptionAndPricingInfo() -> Self {
        GraphQLOperation(
            input: EmptyInput(),
            operationString: """
                {
                  viewer {
                    homes {
                      currentSubscription {
                        status
                        priceInfo {
                          today {
                            total
                            energy
                            tax
                            startsAt
                          }
                          tomorrow {
                            total
                            energy
                            tax
                            startsAt
                          }
                        }
                      }
                    }
                  }
                }
                """
        )
    }
}
