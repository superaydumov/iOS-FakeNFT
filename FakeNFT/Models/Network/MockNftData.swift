//
//  MockNftData.swift
//  FakeNFT
//
//  Created by Андрей Асланов on 10.01.24.
//

import Foundation

enum MockNftData {

    static let nft: [NftModel] = [
        NftModel(
            createdAt: "2023-06-22T07:37:31.777Z[GMT]",
            name: "Parks",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
            ],
            rating: 3,
            description: "scripserit auctor sale quis maiorum",
            price: 49.99,
            author: URL(string: "https://gracious_noether.fakenfts.org/")!,
            id: "77c9aa30-f07a-4bed-886b-dd41051fade2"
        ),
        NftModel(
            createdAt: "2023-07-01T23:14:47.494Z[GMT]",
            name: "Jody Rivers",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
            ],
            rating: 4,
            description: "posse honestatis lobortis tritani scelerisque inimicus",
            price: 49.64,
            author: URL(string: "https://dazzling_meninsky.fakenfts.org/")!,
            id: "ca34d35a-4507-47d9-9312-5ea7053994c0"
        ),
        NftModel(
            createdAt: "2023-07-07T05:50:45.848Z[GMT]",
            name: "Stephanie Baxter",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
            ],
            rating: 8,
            description: "accumsan appareat dolor volutpat volutpat class maecenas in affert",
            price: 3.35,
            author: URL(string: "https://hungry_darwin.fakenfts.org/")!,
            id: "d6a02bd1-1255-46cd-815b-656174c1d9c0"
        ),
        NftModel(
            createdAt: "2023-07-11T00:08:48.728Z[GMT]",
            name: "Minnie Sanders",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!
            ],
            rating: 2,
            description: "mediocritatem interdum eleifend penatibus adipiscing mattis",
            price: 40.59,
            author: URL(string: "https://wonderful_dubinsky.fakenfts.org/")!,
            id: "594aaf01-5962-4ab7-a6b5-470ea37beb93"
        )
    ]
}
