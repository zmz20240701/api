import Foundation
import Fluent
import Vapor

// 向数据库中增加数据

struct SongController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        // 建立了一个 songs 的路由
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID") { song in // 创建一个路由分组songs/:SongID
            song.delete(use: delete) // 对于delete请求执行delete方法
        }
    }
    
    @Sendable // http://0.0.0.0:5001/songs 查询数据库内的数据
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    @Sendable // http://0.0.0.0:5001/songs 发送数据数据库
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self); // 将发送过来的数据转换成Song类型
        return song.save(on: req.db).transform(to: .ok)
    }
    
    @Sendable // id 是从请求体中获取的, 但是删除操作的id必须在URL 路径参数获取
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self);
        
        return Song.find(song.id, on: req.db) // 接收到 song 对象后, 根据其 id 在数据库中查找歌曲
            .unwrap(or: Abort(.notFound))
            .flatMap { // 找到歌曲, 将其展开,然后执行闭包操作
                $0.title = song.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    @Sendable // songs/id
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Song.find(req.parameters.get("songID"), on: req.db) // 从 URL 中获取歌曲 ID, 并在数据库中查找
            .unwrap(or: Abort(.notFound)) // 如果没有歌曲 ID, 返回 404
            .flatMap { // 如果找到了, 执行删除操作
                $0.delete(on: req.db)
            }.transform(to: .ok) // 删除成功返回状态码200 OK. 注意这两个transform的位置
    }
}
