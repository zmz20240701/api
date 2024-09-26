import Fluent

struct CreateSongs: Migration {
    // 定义了如何创建表
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs")
        .id()
        .field("title", .string, .required)
        .create()
    }
    // 定义了如何回滚
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
}
// 迁移就是定义数据库中表的结构图，当应用程序更新时，通过迁移可以自动调整数据库结构。
