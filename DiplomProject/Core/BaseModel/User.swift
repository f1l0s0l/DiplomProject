import Foundation

typealias UserId = String

struct User {
    let id: UserId
    let name: String
    let friendIds: [UserId]
    let postIds: [PostId]
    let storyIds: [String]
    let avatarURL: URL?
}


// example json
/*
{
  "users": [
    {
      "id": "UHwc5gRdVObEFnb66qymee9Exim1",
      "name": "Пользователь 1",
      "friendIds": ["vUgYss9XHjSdW9naRh54IhLSXcx2, Vhj9xNOTyjanRzB2szsKSfLqixy2"],
      "postIds": ["postId 1", "post id 2"],
      "storyIds": []
    },
    {
      "id": "vUgYss9XHjSdW9naRh54IhLSXcx2",
      "name": "Пользователь 2",
      "friendIds": [],
      "postIds": ["post id 1"],
      "storyIds": []
    },
    {
      "id": "Vhj9xNOTyjanRzB2szsKSfLqixy2",
      "name": "Пользователь 3",
      "friendIds": ["UHwc5gRdVObEFnb66qymee9Exim1", "vUgYss9XHjSdW9naRh54IhLSXcx2"],
      "postIds": ["post id 1", "post id 2"],
      "storyIds": []
    }
  ]
}
*/
