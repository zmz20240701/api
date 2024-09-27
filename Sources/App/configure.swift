import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // Configure the server
    app.http.server.configuration.port = 5001
    app.http.server.configuration.hostname = "0.0.0.0"
    
    // Configure TLS for the client
    var tlsConfig = TLSConfiguration.makeClientConfiguration()
    tlsConfig.certificateVerification = .none
    
    // Configure the MySQL database
    let mysqlConfiguration = MySQLConfiguration(
        unixDomainSocketPath: "/var/run/mysqld/mysqld.sock",
        username: "KEN",
        password: "000",
        database: "testdb",
        tlsConfiguration: tlsConfig
    )
    
    app.databases.use(.mysql(configuration: mysqlConfiguration), as: .mysql)
    
    // Register migrations
    app.migrations.add(CreateSongs())
    try await app.autoMigrate()
    
    // Register routes
    try routes(app)
}
