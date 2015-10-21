gulp = require 'gulp'
sass = require 'gulp-sass'
minifyCss = require 'gulp-minify-css'
rename = require 'gulp-rename'

require('gulp-boilerplate-agufranov')
  paths:
    src: './src'
    build: './www'
    lib: './public'
  browserify:
    path: './.browserify'
    entries: ['js/app.js']
    bundleName: 'js/bundle.js'

gulp.task 'ionic-sass', ->
  gulp.src './scss/ionic.app.scss'
    .pipe sass()
    .on 'error', sass.logError
    .pipe gulp.dest './public/css/'
    .pipe minifyCss
      keepSpecialComments: 0
    .pipe rename
      extname: '.min.css'
    .pipe gulp.dest './public/css/'
