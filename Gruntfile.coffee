module.exports = (grunt) ->
  grunt.initConfig

    coffee:
      compile:
        files: 
          'public/client.js': 'assets/client.coffee'

    jade:
      html:
        files:
          'public/': ['./assets/index.jade']
        options:
          client: false

    sass:
      dist:
        files: 'public/main.css': 'assets/main.scss'

    watch:
      files: ['./assets/**/*']
      tasks: ['sass','jade','coffee']
      options:
        nospawn: true 

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-jade')
  grunt.loadNpmTasks('grunt-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
