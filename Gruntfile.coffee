module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        
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
                
                
        coffee:
            compile:
                options:
                    bare: true
                files:
                    'src/angular-dragtable.js': 'dev/angular-dragtable.coffee'
        uglify:
            build:
                options:
                    banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
                        '<%= grunt.template.today("yyyy-mm-dd") %> */'
                    sourceMap: true
                    sourceMapName: 'src/angular-dragtable.map'
                files:
                    'src/angular-dragtable.min.js': 'src/angular-dragtable.js'
                
    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    
    grunt.registerTask('default', ['coffee:compile', 'uglify:build']);
    