module.exports = (grunt) ->
    grunt.initConfig
        
        # Karma
        karma:
            options:
                configFile: 'test/karma.conf.coffee'
                runnerPort: 9999
                
            dev:
                background: true
                
            continuous:
                singleRun: true
                browsers: ['PhantomJS']
                logLevel: 'ERROR'