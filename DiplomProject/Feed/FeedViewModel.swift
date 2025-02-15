import UIKit

final class FeedViewModel {
    private(set) var stories: [FeedStoryModel] = []//FeedStoryModel.mock
    private(set) var items: [Item] = Item.testPostsMock()
}



extension FeedViewModel {
    enum Item {
        case post(FeedPostModel)
        case date(String)
        
        static func testPostsMock() -> [Self] {
            (1...25).map {
                if $0 == 1 || $0 == 5 || $0 == 14 || $0 == 22 {
                    return .date("\($0) марта")
                } else {
                    return .post(FeedPostModel(title: "Это пост \($0)"))
                }
            }
        }
    }
    
}
