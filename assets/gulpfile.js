'use strict';
const gulp = require('gulp');
const plugins = require('gulp-load-plugins')();
const Helper = require('../vendor/dimaninc/di_core/scripts/static-builder/inc/gulp.helper').setWorkFolder(__dirname);

Helper.assignBasicTasksToGulp(gulp).assignAdminStylusTaskToGulp(gulp);

const config = {
    assetsDir: '../assets',
    npmDir: 'node_modules',
    prodDir: '../htdocs/assets/',
    isDevelopment: !plugins.util.env.production
};

gulp.task('node-scripts', () => {
    return gulp.src([
        config.npmDir+'/jquery/dist/jquery.min.js',
        config.npmDir+'/swiper/js/swiper.min.js',
    ], {since: gulp.lastRun('node-scripts')})
        .pipe(plugins.concat('plugin.js'))
        .pipe(plugins.if(!config.isDevelopment, plugins.uglify()))
        .pipe(plugins.rename({suffix: '.min'}))
        .pipe(gulp.dest(config.prodDir + '/js'));
});

gulp.task("es6", () => {
    return gulp.src(config.assetsDir + '/src/js/*.js')
        .pipe(plugins.babel())
        .pipe(plugins.uglify())
        .pipe(plugins.rename({suffix: '.min'}))
        .pipe(gulp.dest(config.prodDir + '/js'));
});

gulp.task('node-styles', () => {
    return gulp.src([
        config.npmDir+'/swiper/css/swiper.min.css',
    ],{since: gulp.lastRun('node-scripts')})
        .pipe(plugins.concat('plugin.css'))
        .pipe(plugins.postcss([require('cssnano')]))
        .pipe(plugins.rename({suffix: '.min'}))
        .pipe(gulp.dest(config.prodDir + '/styles'));
});

gulp.task('postcss', () => {
    return gulp.src(config.assetsDir + '/src/scss/**/*.scss')
        .pipe(plugins.stylelint({failAfterError: false, debug: true, reporters: [{formatter: 'verbose', console: true},],}))
        .pipe(plugins.sass().on('error', plugins.sass.logError))
        .pipe(plugins.postcss([require('precss'), require('postcss-cssnext'), require('cssnano'),]))
        .pipe(plugins.replace(["../../../images/", "../images/", "../../../fonts/", "../fonts/"]))
        .pipe(plugins.rename({suffix: '.min'}))
        .pipe(gulp.dest(config.prodDir + '/styles'));
});

gulp.task('build', gulp.series(
    gulp.parallel('node-styles', 'es6', 'node-scripts', 'postcss', 'version', 'copy-core-assets')
));

gulp.task('watch', () => {
    gulp.watch(config.assetsDir + '/src/scss/**/*.scss', gulp.series(
        gulp.parallel('postcss')
    ));
    gulp.watch(config.assetsDir + '/src/js/*.js', gulp.series(
        gulp.parallel('es6')
    ));
});

gulp.task('default',
    gulp.series( 'watch')
);