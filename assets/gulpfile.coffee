gulp = require 'gulp'
Helper = require('../vendor/dimaninc/di_core/scripts/static-builder/inc/gulp.helper').setWorkFolder __dirname

# base folder
buildFolder = 'build/'
jsBuildFolder = buildFolder + 'js/'
npmFolder = 'node_modules/'

# stylus settings
stylusFolder = 'stylus/'
stylusBuildFolder = buildFolder + 'styles/'
stylusFn = stylusFolder + 'main.styl'

# less settings
lessFolder = 'less/'
lessBuildFolder = buildFolder + 'styles/'
lessFn = lessFolder + 'less.less'

# sass settings
sassFolder = 'sass/'
sassBuildFolder = buildFolder + 'styles/'
sassFn = sassFolder + 'sass.scss'

# sprites settings
spritesImageOutputFolder = 'images/'
spritesImageName = 'sprite.png'
spritesCssOutputFolder = stylusFolder + 'inc/'
spritesFileName = 'sprite.styl'

# css settings
cssFolder = 'css/'
cssOutputFolder = '../assets/styles/'
cssOutput = cssOutputFolder + 'styles.css'
cssOutputMin = cssOutputFolder + 'styles.min.css'
cssFiles = [
    cssFolder + 'jquery/*.css'
    #Helper.getCoreFolder() + 'css/dipopups.css'
    stylusBuildFolder + 'main.css'
    lessBuildFolder + 'less.css'
    #sassBuildFolder + 'sass.css'
]

# coffee settings
coffeeFolder = 'coffee/'

# es6 settings
es6Folder = 'es6/'
es6BuildFolder = jsBuildFolder + es6Folder

# js settings
jsFolder = 'js/'
jsOutputFolder = '../assets/js/'
jsOutput = jsOutputFolder + 'application.js'
jsFiles = [
    Helper.getCoreFolder() + 'js/functions.js'
    # npmFolder + 'slick-carousel/slick/slick.js'
    jsBuildFolder + '**/**/*.js' # compiled es6/coffee
    '!' + jsBuildFolder + 'main.js'
    #'!' + jsBuildFolder + 'Tweaks.js'
    #jsFolder + '**/**/*.js' # pure js
    jsBuildFolder + 'main.js'
    #jsBuildFolder + 'Tweaks.js'
]

pr = './'

# watch settings
watchSettings =
    #'stylus-sprite':
    #    mask: Helper.masks.sprite
    'stylus':
        mask: pr + stylusFolder + Helper.masks.stylus
    'less':
        mask: lessFolder + Helper.masks.less
    #'sass':
    #    mask: sassFolder + Helper.masks.sass
    'css-concat':
        mask: cssFiles
    'css-min':
        mask: cssOutput
    #'coffee':
    #    mask: coffeeFolder + Helper.masks.coffee
    'es6':
        mask: pr + es6Folder + '**/*.js'
    'js-concat':
        mask: jsFiles
    'js-min':
        mask: pr + jsOutput

Helper
.assignBasicTasksToGulp gulp
.assignLessTaskToGulp gulp, fn: lessFn, buildFolder: lessBuildFolder
#.assignSassTaskToGulp gulp, fn: sassFn, buildFolder: sassBuildFolder
#.assignPngSpritesTaskToGulp gulp, mask: Helper.masks.sprite, imgName: spritesImageName, cssName: spritesFileName, cssFormat: 'stylus', imgFolder: spritesImageOutputFolder, cssFolder: spritesCssOutputFolder
.assignStylusTaskToGulp gulp, fn: stylusFn, buildFolder: stylusBuildFolder
.assignCssConcatTaskToGulp gulp, files: cssFiles, output: cssOutput
.assignCssMinTaskToGulp gulp, input: cssOutput, outputFolder: cssOutputFolder
#.assignCoffeeTaskToGulp gulp, folder: coffeeFolder, mask: Helper.masks.coffee, jsBuildFolder: jsBuildFolder, cleanBefore: false
.assignEs6TaskToGulp gulp, folder: es6Folder, mask: Helper.masks.js, jsBuildFolder: jsBuildFolder
.assignJavascriptConcatTaskToGulp gulp, files: jsFiles, output: jsOutput
.assignJavascriptMinTaskToGulp gulp, input: jsOutput, outputFolder: jsOutputFolder
.assignAdminStylusTaskToGulp gulp

# build
gulp.task 'build', gulp.series(
    #'stylus-sprite'
    'stylus'
    #'less'
    #'sass'
    'css-concat'
    'css-min'
    #'coffee'
    'es6'
    'js-concat'
    'js-min'
    'version'
    #'copy-core-assets'
)

# monitoring
gulp.task 'watch', (done) ->
    for process of watchSettings
        do (process, mask = watchSettings[process].mask) ->
            gulp.watch mask, gulp.series(process)
            .on 'change', (path, stats) ->
                console.log '[' + process + '] changed file ' + path + ''
                gulp.series 'version' if process in ['css-min', 'js-min']
            true

    done()

# default
gulp.task 'default', gulp.series(
    'build'
    'watch'
)
