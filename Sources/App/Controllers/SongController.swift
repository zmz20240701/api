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
    
}
