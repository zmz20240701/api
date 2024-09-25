import Fluent
import Vapor

final class Song: Model, Content, @unchecked Sendable {
    static let schema = "songs"  //对应数据库的表名

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    init() {}

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}


// Model必须与创建的表格元素相同
// 一个 Song 表示数据库中的一行数据

