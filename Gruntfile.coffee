module.exports = (grunt) ->

    grunt.initConfig

        watch:
            coffee:
                files: [
                    'script.coffee'
                ]
                tasks: ['build']
            html:
                files: [
                    'index.html'
                ]
                tasks: ['build']
            less:
                files: [
                    'styles.less'
                ]
                tasks: ['build']

        nodestatic:
            server:
                options:
                    port: 8080
                    base: __dirname + '/gh-pages'
        smoosher:
            ghpages:
                files:
                    'gh-pages/index.html': 'index.html'
        less:
            options:
                yuicompress:true
            ghpages:
                files:
                    'gh-pages/styles.css': ['styles.less']
        uglify:
            ghpages:
                files:
                    'gh-pages/bundle.min.js': ['gh-pages/bundle.js']
        htmlmin:
            options:
                removeComments: true
                collapseWhitespace: true
            ghpages:
                files:
                    'gh-pages/index.html': 'gh-pages/index.html'
        copy:
            ghpages:
                files: [
                    {expand: true, cwd: 'gh-pages', src: ['**'], dest: './'}
                ]
        browserify:
            'gh-pages/bundle.js': ['script.coffee']
            options:
                transform: ['coffeeify']
        clean:
            ghpages: ['gh-pages']
            build: [
                'gh-pages/bundle.js'
                'gh-pages/styles.css'
                'gh-pages/bundle.min.js'
            ]
        exec:
            checkout_ghpages:
                command: 'git checkout gh-pages'
            git_add:
                command: 'git add .'
            git_commit:
                command: 'git commit -avm "Automated commit."'
            checkout_master:
                command: 'git checkout master'
            git_push_ghpages:
                command: 'git push origin gh-pages'

    grunt.registerTask 'build', [
        'clean:ghpages'
        'browserify'
        'less'
        'uglify'
        'smoosher'
        'htmlmin'
        'clean:build'
    ]
    grunt.registerTask 'dev', ['build', 'nodestatic', 'watch']
    grunt.registerTask 'deploy', [
        'build'
        'exec:checkout_ghpages'
        'copy'
        'exec:git_add'
        'exec:git_commit'
        'exec:git_push_ghpages'
        'exec:checkout_master'
    ]
    grunt.loadNpmTasks 'grunt-exec'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-html-smoosher'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-htmlmin'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-nodestatic'


