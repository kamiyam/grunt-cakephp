(function() {
  "use strict";
  var proxySnippet;

  proxySnippet = require("grunt-connect-proxy/lib/utils").proxyRequest;

  module.exports = function(grunt) {
    var config, serverProcess, serverStart, verbose;
    config = {
      listen: 8888,
      server: {
        port: 8000,
        start: "php -S localhost:",
        ini: "/Applications/MAMP/bin/php/php5.4.10/conf/php.ini",
        root: "app/webroot"
      }
    };
    serverStart = config.server.start + config.server.port + "";
    if (config.server.ini) {
      serverStart = serverStart + " -c " + config.server.ini;
    }
    if (config.server.root) {
      serverStart += " -t " + config.server.root;
    }
    console.log(serverStart);
    verbose = grunt.verbose;
    verbose.subhead(serverStart);
    serverProcess = require('child_process').exec(serverStart);
    serverProcess.stdout.on("data", function(d) {
      return grunt.log.writeln(d);
    });
    serverProcess.stderr.on("data", function(d) {
      return grunt.log.error(d);
    });
    serverProcess.on("exit", function(code) {
      if (code > 0) {
        grunt.log.error("Exited with code: %d.", code);
        return;
      }
      return verbose.ok("Exited with code: %d.", code);
    });
    grunt.initConfig({
      pkg: grunt.file.readJSON("package.json"),
      c: config,
      connect: {
        options: {
          hostname: "localhost",
          port: '<%= c.listen %>',
          middleware: function(connect, options) {
            return [proxySnippet];
          }
        },
        proxies: [
          {
            context: "/",
            host: "localhost",
            port: '<%= c.server.port %>',
            https: false,
            changeOrigin: false
          }
        ]
      },
      watch: {
        options: {
          livereload: true
        },
        php: {
          files: "**/*.php"
        },
        ctp: {
          files: "**/*.ctp"
        }
      },
      open: {
        server: {
          path: "http://localhost:<%= c.listen %>"
        }
      },
      coffee: {
        grunt: {
          files: {
            "_Gruntfile.js": "Gruntfile.coffee"
          }
        }
      }
    });
    require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks);
    grunt.registerTask("init", ["coffee:grunt"]);
    return grunt.registerTask("default", ["configureProxies", "connect", "open", "watch"]);
  };

}).call(this);
