extension API {
    struct getFriends: APIRequest {
        typealias ResultValue = [User]
        var parameters: [String : String]
        
        let userId: UserId
    }
}

extension API {
    struct getPosts: APIRequest {
        typealias ResultValue = ([Post], [User])
        var parameters: [String : String]
        
        let userId: UserId
    }
}
