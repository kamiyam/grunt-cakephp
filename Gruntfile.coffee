"use strict"

mountFolder = (connect, point) ->
  return connect.static(require('path').resolve(point))

proxySnippet = require("grunt-connect-proxy/lib/utils").proxyRequest

module.exports = (grunt) ->

  # configurable paths
  config =
    listen: 3001  ## if use apache ... proxy setting
    server:
      port: 3000
      start: "php -S localhost:"
      ini: "/usr/local/etc/php/5.4/php.ini"   # -c option ini file path ex) /usr/local/etc/php/5.4/php.ini
      root: "app/webroot"   # -t option docment root file path ex)/htdocs

  # php -S localhost:8080 -t /path/to/app/docroot -c /path/to/app/php.ini

  # server start process
  serverStart = config.server.start + config.server.port + ""

  if config.server.ini
    serverStart =  serverStart + " -c " + config.server.ini
  if config.server.root
    serverStart += " -t " + config.server.root

  console.log serverStart

  verbose = grunt.verbose;

  verbose.subhead(serverStart);
  serverProcess = require('child_process').exec(serverStart)

  serverProcess.stdout.on "data", (d) ->
    grunt.log.writeln d

  serverProcess.stderr.on "data", (d) ->
    grunt.log.error d

  serverProcess.on "exit", (code) ->
    if code > 0
      grunt.log.error "Exited with code: %d.", code
      return
    verbose.ok "Exited with code: %d.", code

  # Project configuration.
  grunt.initConfig

    pkg: grunt.file.readJSON("package.json")

    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
    '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
    '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
    '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
    ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n',

    c: config

    connect:
      options:
        hostname: "localhost"
        port: '<%= c.listen %>'
        middleware: (connect, options) ->
          return [ proxySnippet, mountFolder connect, '.' ]

      proxies: [
        context: "/"
        host: "localhost"
        port: '<%= c.server.port %>'
        https: false
        changeOrigin: false
      ]

    watch:
      options:
        livereload: true

      php:
        files: ["app/View/**/*.php","app/Config/*.php"]

      ctp:
        files: "**/*.ctp"

    open:
      server:
        path: "http://localhost:<%= c.server.port %>"

    phpunit:
      classes:
        dir: 'tests/php/'
      options:
        bin: 'vendor/bin/phpunit'
        bootstrap: 'tests/php/phpunit.php'
        colors: true

    coffee:
      grunt:
        files:
          ".Gruntfile.js": "Gruntfile.coffee"


  # load all grunt-plugin tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  grunt.registerTask "init", ["coffee:grunt"]
  grunt.registerTask "default", [ "configureProxies", "connect", "open", "watch" ]

