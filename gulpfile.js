// "use strict";

var gulp = require('gulp');

var jsmin = require('gulp-jsmin');
var stripDebug = require('gulp-strip-debug');

var coffee = require('gulp-coffee');

var sourcemaps = require('gulp-sourcemaps');
var concat = require('gulp-concat');

var gulpif = require('gulp-if');
var notify = require('gulp-notify');
var plumber = require('gulp-plumber');
var csso = require('gulp-csso');


// === files ===============================================
var coffeFiles = [
    './views/public/bwr/angular/angular.js',
    './views/public/bwr/Chart.js/Chart.js',
    './views/public/bwr/angular-chart.js/angular-chart.js',
    './views/src/app.coffee',
    './views/src/app-controller.coffee'
];

// coffescript ==============================================
gulp.task('coffee', function() {
    gulp.src(coffeFiles)
        .pipe(plumber({
            errorHandler: notify.onError("Error:\n<%= error %>")
        }))
        .pipe(sourcemaps.init())
        .pipe(gulpif(/[.]coffee$/, coffee({
            bare: true
        })))
        .pipe(concat('script.js'))
        .pipe(sourcemaps.write('../maps'))
        .pipe(gulp.dest('./views/public/js'));
});
// css ======================================================
gulp.task('css', function () {
    gulp.src(['./views/src/style.css'])
        .pipe(sourcemaps.init())
        .pipe(csso())
        .pipe(concat('style.css'))
        .pipe(sourcemaps.write('../maps'))
        .pipe(gulp.dest('./views/public/css/'));
});

// =========================================================
// Запуск задач
gulp.task('default', ['coffee', 'css']);

// Задача на отслеживание изменений ========================
gulp.task('watch', function() {
    gulp.watch(['./views/src/*'], ['coffee', 'css']);
});