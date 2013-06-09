module.exports = (grunt) ->
  grunt.initConfig

    coffee:
      compile:
        files: 
          'public/client.js': 'assets/client.coffee'

    uglify:
      my_target:
        files: 
          'public/client.js': 'public/client.js'

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
      tasks: ['default']
      options:
        nospawn: true

  grunt.registerTask 'default', ['sass','jade','coffee']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-jade')
  grunt.loadNpmTasks('grunt-sass')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-uglify')
