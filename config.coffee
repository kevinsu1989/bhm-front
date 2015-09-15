

module.exports =
  database:
    client: 'mysql',
    connection:
      host     : '123.59.21.19',
      user     : 'root',
      password : 'root',
      database : 'monitor'

  api_runner: 'app.coffee'

  apiport:8201

  port:8101


  redis:
    server: 'localhost'
    port: 6379
    database: 0
    unique: 'bhf-c63a6d217'
