module.exports = (grunt) ->
    grunt.initConfig
        watch:
            karma:
                files: ['dev/**/*.coffee', 'test/specs/**/*.coffee']
                tasks: ['karma:dev:run']
        # Karma
        karma:
            options:
                configFile: 'karma.conf.coffee'
                runnerPort: 9999
                browsers: ['PhantomJS']
                
            dev:
                background: true
                singleRun: false
                reporters: 'dots'
                
            ci:
                singleRun: true
                logLevel: 'ERROR'
                
    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    