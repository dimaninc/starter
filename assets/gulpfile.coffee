# initiating plugins
gulp = require 'gulp'
spriteSmith = require 'gulp.spritesmith' # sprite generator
stylus = require 'gulp-stylus'
less = require 'gulp-less'
csso = require 'gulp-csso' # css minify
#imagemin = require 'gulp-imagemin'
uglify = require 'gulp-uglify' # js minify
concat = require 'gulp-concat'
bower = require 'gulp-bower'
rename = require 'gulp-rename'
#babel = require 'gulp-babel'
#newer = require 'gulp-newer'
#sourcemaps = require 'gulp-sourcemaps'
#eslint = require 'gulp-eslint'
nib = require 'nib'
Helper = require('../vendor/dimaninc/di_core/scripts/static-builder/inc/gulp.helper').setWorkFolder __dirname

# base folder
buildFolder = 'build/'
jsBuildFolder = buildFolder + 'js/'
diCoreFolder = '../vendor/dimaninc/di_core/' # _core/
vendorFolder = '../htdocs/assets/vendor/'
bowerFolder = 'bower_components/'

# stylus settings
stylusFolder = 'stylus/'
stylusMask = '**/*.styl'
stylusBuildFolder = buildFolder + 'styles/'
stylusFn = stylusFolder + 'main.styl'

# less settings
lessFolder = 'less/'
lessMask = '**/*.less'
lessBuildFolder = buildFolder + 'styles/'
lessFn = lessFolder + 'less.less'

# images settings
imagesFolder = 'images/'
fontsFolder = 'fonts/'
videosFolder = 'videos/'

# sprites settings
spritesImageOutputFolder = 'images/'
spritesMask = 'images/sprite-src/**/*.png'
spritesImageName = 'sprite.png'
spritesCssOutputFolder = stylusFolder + 'inc/'
spritesFileName = 'sprite.styl'

# css settings
cssFolder = 'css/'
cssOutput = stylusBuildFolder + 'styles.css'
cssFiles = [
    cssFolder + 'jquery/*.css'
    #diCoreFolder + 'css/dipopups.css'
    #stylusBuildFolder + 'main.css'
    lessBuildFolder + 'less.css'
]

# coffee settings
coffeeFolder = 'coffee/'
coffeeMask = '**/**/*.coffee'

# react settings
reactFolder = 'react/'
reactMask = '**/**/*.jsx'
reactBuildFolder = jsBuildFolder + reactFolder
reactCoreFolder = 'bower_components/react/'
reactCoreFiles = [
    #'react.min.js'
    #'react-dom.min.js'
]

# js settings
jsFolder = 'js/'
jsOutput = 'application.js'
jsOutputMin = 'application.min.js'
jsFiles = reactCoreFiles.map (f) -> reactCoreFolder + f
.concat [
    #diCoreFolder + 'js/functions.js'
    bowerFolder + 'jsep/src/jsep.js'
    bowerFolder + 'dreampilot/dist/dp.js' #.min
    bowerFolder + 'slick-carousel/slick/slick.min.js'
    jsFolder + '**/**/*.js' # pure js
    jsBuildFolder + '**/*.js' # compiled coffee
    '!' + jsBuildFolder + jsOutput
    '!' + jsBuildFolder + jsOutputMin
]

assetFiles = [
    stylusBuildFolder + 'styles.min.css'
    jsBuildFolder + jsOutput
    jsBuildFolder + jsOutputMin
]
assetFilesForWatch = [
    stylusBuildFolder + 'styles.min.css'
    jsBuildFolder + jsOutputMin
]
assetImageFiles = [
    imagesFolder + '**/*.*'
]
assetFontFiles = [
    fontsFolder + '**/*.*'
]
assetVideoFiles = [
    videosFolder + '**/*.*'
]
assetsTargetFolder = '../htdocs/assets/'

# watch settings
watchSettings =
    #'stylus-sprite':
    #    mask: spritesMask
    #'stylus':
    #    mask: stylusFolder + stylusMask
    'less':
        mask: lessFolder + lessMask
    'css-concat':
        mask: cssFiles
    'css-min':
        mask: cssOutput
    'coffee':
        mask: coffeeFolder + coffeeMask
    #'react':
    #    mask: reactFolder + reactMask
    'js-concat':
        mask: jsFiles
    'js-min':
        mask: jsBuildFolder + jsOutput
    'copy-assets':
        mask: [
            assetFilesForWatch
            assetImageFiles
            assetFontFiles
            assetVideoFiles
        ]

# css minify
gulp.task 'css-min', (done) ->
    gulp.src Helper.fullPath cssOutput
    .pipe csso()
    .on 'error', console.log
    .pipe rename suffix: '.min'
    .pipe gulp.dest Helper.fullPath stylusBuildFolder
    .on 'end', -> done()

# copy bower files to public
gulp.task 'bower-files', (done) ->
    bower
        interactive: true
    .pipe gulp.dest vendorFolder
    .on 'end', -> done()

# js concat
gulp.task 'js-concat', (done) ->
    gulp.src jsFiles.map (f) -> Helper.fullPath f
    .pipe concat jsOutput
    .pipe gulp.dest Helper.fullPath jsBuildFolder
    .on 'end', -> done()

# js minify
gulp.task 'js-min', (done) ->
    gulp.src Helper.fullPath jsBuildFolder + jsOutput
    .pipe uglify()
    .pipe rename suffix: '.min'
    .pipe gulp.dest Helper.fullPath jsBuildFolder
    .on 'end', -> done()

# killing old assets
gulp.task 'del-old-assets', (done) ->
    excludes = [
        #assetsTargetFolder + '_core'
    ]
    console.log 'Removing old assets excluding', excludes if excludes.length
    Helper.deleteFolderRecursive assetsTargetFolder + (sf for sf in [imagesFolder, fontsFolder, videosFolder]), excludes
    done()

# copy assets to htdocs
gulp.task 'copy-assets', (done) ->
    tasksTotal = 4
    tasksDone = 0

    gulp.src assetFiles, base: buildFolder
    .on 'error', console.log
    .pipe gulp.dest assetsTargetFolder
    .on 'end', -> Helper.tryDone ++tasksDone, tasksTotal, done

    gulp.src assetImageFiles, base: imagesFolder
    .on 'error', console.log
    .pipe gulp.dest assetsTargetFolder + imagesFolder
    .on 'end', -> Helper.tryDone ++tasksDone, tasksTotal, done

    gulp.src assetFontFiles, base: fontsFolder
    .on 'error', console.log
    .pipe gulp.dest assetsTargetFolder + fontsFolder
    .on 'end', -> Helper.tryDone ++tasksDone, tasksTotal, done

    gulp.src assetVideoFiles, base: videosFolder
    .on 'error', console.log
    .pipe gulp.dest assetsTargetFolder + videosFolder
    .on 'end', -> Helper.tryDone ++tasksDone, tasksTotal, done

Helper
.assignBasicTasksToGulp gulp
.assignLessTaskToGulp gulp, fn: lessFn, buildFolder: lessBuildFolder
#.assignPngSpritesTaskToGulp gulp, mask: spritesMask, imgName: spritesImageName, cssName: spritesFileName, cssFormat: 'stylus', imgFolder: spritesImageOutputFolder, cssFolder: spritesCssOutputFolder
#.assignStylusTaskToGulp gulp, fn: stylusFn, buildFolder: stylusBuildFolder
.assignCssConcatTaskToGulp gulp, files: cssFiles, output: cssOutput
.assignCoffeeTaskToGulp gulp, folder: coffeeFolder, mask: coffeeMask, jsBuildFolder: jsBuildFolder, cleanBefore: false

# build
gulp.task 'build', gulp.series(
    'bower-files'
    #'stylus-sprite'
    #'stylus'
    'less'
    'css-concat'
    'css-min'
    'coffee'
    'js-concat'
    'js-min'
    'version'
    'del-old-assets'
    'copy-core-assets'
    'copy-assets'
)

# monitoring
gulp.task 'watch', (done) ->
    for process of watchSettings
        do (process, mask = watchSettings[process].mask) ->
            gulp.watch mask, gulp.series(process)
            .on 'change', (path, stats) ->
                console.log '[' + process + '] changed file ' + path + ''
                gulp.series 'version', 'copy-assets' if process in ['css-min', 'js-min']
            true

    done()

# default
gulp.task 'default', gulp.series(
    'build'
    'watch'
)
