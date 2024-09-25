import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

app.http.server.configuration.port = 5000
app.http.server.configuration.hostname = "0.0.0.0"

app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: "8.152.6.116",
        port: 3306,
        username:"KEN",
        password: "00000000",
        database: "testdb"
        tlsConfiguration: .forClient(certificateVerification: .none)  // 禁用 SSL 证书验证
    ), as: .mysql)

    app.migrations.add(CreateSongs())
    try await app.autoMigrate().get()
    // register routes
    try routes(app)
}
