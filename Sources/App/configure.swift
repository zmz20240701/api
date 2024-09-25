import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // Configure TLS for the client
    let tlsConfiguration = TLSConfiguration.forClient(certificateVerification: .none)
    
    // Configure the server
    app.http.server.configuration.port = 5001
    app.http.server.configuration.hostname = "0.0.0.0"
    
    // Configure the MySQL database
    app.databases.use(
        .mysql(
            hostname: "8.152.6.116",
            port: 3306,
            username: "KEN",
            password: "000",
            database: "testdb",
            tlsConfiguration: tlsConfiguration  // Apply the TLS configuration here
        ),
        as: .mysql
    )

    app.migrations.add(CreateSongs())
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
