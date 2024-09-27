import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // Configure the server to listen on port 5001 and 0.0.0.0 (to accept external connections)
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 5001
    
    // Configure TLS for HTTPS (if needed for Vapor itself to handle HTTPS)
    app.http.server.configuration.tlsConfiguration = .forServer(
        certificateChain: [.file("/etc/letsencrypt/live/bayanarabic.cn/fullchain.pem")],
        privateKey: .file("/etc/letsencrypt/live/bayanarabic.cn/privkey.pem")
    )
    
    // Configure TLS for the MySQL client (with certificate verification disabled)
    var tlsConfig = TLSConfiguration.makeClientConfiguration()
    tlsConfig.certificateVerification = .none
    
    // Configure MySQL database connection
    let mysqlConfiguration = MySQLConfiguration(
        unixDomainSocketPath: "/var/run/mysqld/mysqld.sock",  // Socket path for MySQL
        username: "KEN",                                      // Your MySQL username
        password: "000",                                      // Your MySQL password
        database: "testdb",                                   // Your MySQL database name
        tlsConfiguration: tlsConfig                           // TLS configuration for MySQL
    )
    
    // Register the MySQL database with Fluent
    app.databases.use(.mysql(configuration: mysqlConfiguration), as: .mysql)
    
    // Register migrations
    app.migrations.add(CreateSongs())  // Assuming you have a migration named CreateSongs
    try await app.autoMigrate()        // Automatically run migrations at startup
    
    // Register routes
    try routes(app)
}
