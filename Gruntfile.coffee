module.exports = (grunt) ->

    grunt.initConfig

        watch:
            coffee:
                files: [
                    'script.coffee'
                ]
                tasks: ['browserify', 'uglify']
            html:
                files: [
                    'index.html'
                ]
                tasks: ['htmlmin']

        nodestatic:
            server:
                options:
                    port: 8080
                    base: __dirname + '/gh-pages'
        coffee:
            ghpages:
                files:
                    'gh-pages/script.js': ['script.coffee']
        uglify:
            ghpages:
                files:
                    'gh-pages/bundle.min.js': ['gh-pages/bundle.js']
        htmlmin:
            ghpages:
                files:
                    'gh-pages/index.html':'index.html'
        copy:
            ghpages:
                files: [
                    {expand: true, cwd: 'gh-pages', src: ['**'], dest: './'}
                ]
        browserify:
            'gh-pages/bundle.js': ['script.coffee']
            options:
                transform: ['coffeeify']
        clean: ['gh-pages']
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
            create_ghpages:
                command: 'mkdir gh-pages'

    grunt.registerTask 'deploy', [
        'clean'
        'create_ghpages'
        'browserify'
        'uglify'
        'htmlmin'
        'checkout_ghpages'
        'copy'
        'git_add'
        'git_commit'
        'git_push_ghpages'
        'checkout_master'
    ]
    grunt.loadNpmTasks 'grunt-contrib-exec'
    grunt.loadNpmTasks 'grunt-contrib-htmlmin'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-nodestatic'


