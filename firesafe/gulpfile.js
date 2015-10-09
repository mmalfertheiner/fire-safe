var gulp = require('gulp');
var sass = require('gulp-ruby-sass');
var autoprefixer = require('gulp-autoprefixer');
var minifycss = require('gulp-minify-css');
var jshint = require('gulp-jshint');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var rev = require('gulp-rev');
var del = require('del');

/* Error Messages */
var displayError = function (err) {
    console.error('Error:', err.message);
}

/* Styles */
gulp.task('styles', function() {

    sass('themes/firesafe/assets/styles/app.scss', { style: 'expanded', noCache: true })
        .on('error', displayError)

        .pipe(autoprefixer({
            browsers: ['last 4 versions']
        }))

        .pipe(minifycss())

        .pipe(gulp.dest('public/css'));

});

/* Scripts */
gulp.task('scripts', function() {

    gulp.src('themes/firesafe/assets/scripts/**/*.js')

        .pipe(jshint())
        .pipe(jshint.reporter('default'))

        .pipe(concat('app.js'))

        .pipe(uglify())
        .on('error', displayError)

        .pipe(gulp.dest('public/js'));

});

/* Fonts */
gulp.task('fonts', function() {
    gulp.src('node_modules/font-awesome/fonts/*')
        .pipe(gulp.dest('public/fonts'));
})

/* Vendor */
gulp.task('vendor-styles', function() {

    gulp.src('node_modules/normalize.css/normalize.css')
        .pipe(rename('_normalize.scss'))
        .pipe(gulp.dest('themes/firesafe/assets/styles/vendor'));

    gulp.src('node_modules/lightslider/dist/css/lightslider.css')
        .pipe(rename('_lightslider.scss'))
        .pipe(gulp.dest('themes/firesafe/assets/styles/vendor'));

});

gulp.task('vendor-scripts', function() {

    var files = [
        'node_modules/jquery/dist/jquery.min.js',
        'node_modules/lightslider/dist/js/lightslider.min.js'
    ];

    gulp.src(files)
        .pipe(concat('vendor.js'))
        .pipe(gulp.dest('public/js'));

});


/* Default task */
gulp.task('default', [ 'vendor-styles', 'vendor-scripts', 'fonts', 'styles', 'scripts' ]);

/* Watch task */
gulp.task('watch', [ 'default' ], function() {
    gulp.watch(['themes/firesafe/assets/styles/**/*.scss', '!themes/firesafe/assets/styles/vendor/*.scss'], ['styles']);
    gulp.watch(['themes/firesafe/assets/scripts/**/*.js'], ['scripts']);
});