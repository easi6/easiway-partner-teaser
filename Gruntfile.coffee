'use strict'
mountFolder = (connect, dir) ->
  connect.static require('path').resolve dir

module.exports = (grunt) ->
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    connect:
      server:
        options:
          port: 9999
          hostname: '*'
          base: 'dist'
          middleware: (connect) ->
            [ require('connect-livereload')(ignore:[]), mountFolder(connect, '.tmp'), mountFolder(connect, 'dist')]
    watch:
      options:
        livereload: true
        event: ['changed', 'added', 'deleted']
      less:
        files:
          ['assets/styles/**/*.less']
        tasks: 'less'
        options:
          livereload: false
      css:
        files:
          ['assets/styles/**/*.css']
        tasks: 'copy:styles'
        options:
          livereload: false
      js:
        files:
          ['assets/scripts/**/*.{js,json}']
        tasks: 'copy:scripts'
        options:
          livereload: false
      coffee:
        files:
          ['assets/scripts/**/*.coffee']
        tasks: 'coffee'
        options:
          livereload: false
      jade:
        files:
          ['views/**/*.jade']
        tasks: 'jade'
        options:
          livereload: false
      img:
        files:
          ['assets/images/**/*']
        tasks: 'copy:img'
        options:
          livereload: false
      favicon:
        files:
          ['assets/favicon/**/*']
        tasks: 'copy:favicon'
        options:
          livereload: false
      font:
        files:
          ['assets/fonts/**/*']
        tasks: 'copy:font'
        options:
          livereload: false
      bower:
        files:
          ['assets/bower_components/**/*']
        tasks: 'copy:bower'
        options:
          livereload: false

      bootstrap:
        files:
          ['bootstrap/dist/**/*']
        tasks: 'copy:bootstrap'
        options:
          livereload: false

      dist:
        files: ['dist/**', 'dist/img/*.*', 'dist/css/*.*', 'dist/js/*.*']
    coffee:
      compile:
        files:
          "dist/js/main.js": "assets/scripts/main.coffee"
    less:
      development:
        options:
          paths: ["assets/styles"]
        files:
          'dist/css/main.css': 'assets/styles/main.less'
    open:
      # change to the port you're using
      server:
        path: "http://localhost:<%= connect.server.options.port %>?LR-verbose=true"
    jade:
      compile:
        files:
          "dist/index.html": ["views/index.jade"],
          "dist/fare.html": ["views/fare.jade"],
    copy:
      img:
        files: [
            expand: true
            src: ['**']
            cwd: 'assets/images'
            dest: 'dist/img/'
        ]
      favicon:
        files: [
            expand: true
            src: ['**']
            cwd: 'assets/favicon'
            dest: 'dist/'
        ]
      font:
        files: [
          expand: true
          src: ['**']
          cwd: 'assets/fonts'
          dest: 'dist/fonts/'
        ]
      styles:
        files: [
            expand: true
            src: ['**.css']
            cwd: 'assets/styles'
            dest: 'dist/css/'
        ]
      scripts:
        files: [
            expand: true
            src: ['**.{js,json}']
            cwd: 'assets/scripts'
            dest: 'dist/js/'
        ]

      bootstrap:
        files: [
          expand: true
          src: ['**']
          cwd: 'bower_components/bootstrap/dist'
          dest: 'dist/bootstrap/'
        ]
      bower:
        files: [
          expand: true
          src: ['**']
          cwd: 'assets/bower_components'
          dest: 'dist/bower/'
        ]
      main:
        files: [
            expand: true
            src: ['**']
            cwd: 'assets/images'
            dest: 'dist/img/'
          ,
            expand: true
            src: ['**.js']
            cwd: 'assets/scripts'
            dest: 'dist/js/'
          ,
            expand: true
            src: ['**.css']
            cwd: 'assets/styles'
            dest: 'dist/css/'
        ]
    clean: ['dist']

  grunt.registerTask 'server', [ 'clean', 'copy', 'jade', 'less', 'coffee', 'connect:server', 'open', 'watch' ]
  grunt.registerTask 'build', [ 'clean', 'copy', 'jade', 'less', 'coffee' ]

