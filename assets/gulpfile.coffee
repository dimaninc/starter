gulp = require 'gulp'
Helper = require('../vendor/dimaninc/di_core/scripts/static-builder/inc/gulp.helper').setWorkFolder __dirname

# base folder
buildFolder = 'build/'
jsBuildFolder = buildFolder + 'js/'
vendorFolder = '../htdocs/assets/vendor/'
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

# images settings
imagesFolder = 'images/'
fontsFolder = 'fonts/'
videosFolder = 'videos/'

# sprites settings
spritesImageOutputFolder = 'images/'
spritesImageName = 'sprite.png'
spritesCssOutputFolder = stylusFolder + 'inc/'
spritesFileName = 'sprite.styl'

# css settings
cssFolder = 'css/'
cssOutputFolder = '../htdocs/assets/styles/'
cssOutput = cssOutputFolder + 'styles.css'
cssOutputMin = cssOutputFolder + 'styles.min.css'
cssFiles = [
    cssFolder + 'jquery/*.css'
    #Helper.getCoreFolder() + 'css/dipopups.css'
    stylusBuildFolder + 'main.css'
    #lessBuildFolder + 'less.css'
    #sassBuildFolder + 'sass.css'
]

# coffee settings
coffeeFolder = 'coffee/'

# es6 settings
es6Folder = 'es6/'
es6BuildFolder = jsBuildFolder + es6Folder

# react settings
#reactFolder = 'react/'
#reactBuildFolder = jsBuildFolder + reactFolder
#reactCoreFolder = npmFolder + 'react/'
#reactCoreFiles = [
    #'react.min.js'
    #'react-dom.min.js'
#]

# js settings
jsFolder = 'js/'
jsOutputFolder = '../htdocs/assets/js/'
jsOutput = jsOutputFolder + 'application.js'
jsOutputMin = jsOutputFolder + 'application.min.js'
#reactCoreFiles.map((f) -> reactCoreFolder + f).concat
jsFiles = [
    Helper.getCoreFolder() + 'js/functions.js'
    jsBuildFolder + '**/*.js' # compiled es6/coffee
    jsFolder + '**/**/*.js' # pure js
]

# watch settings
watchSettings =
    'stylus-sprite':
        mask: Helper.masks.sprite
    'stylus':
        mask: stylusFolder + Helper.masks.stylus
    #'less':
    #    mask: lessFolder + Helper.masks.less
    #'sass':
    #    mask: sassFolder + Helper.masks.sass
    'css-concat':
        mask: cssFiles
    'css-min':
        mask: cssOutput
    'coffee':
        mask: coffeeFolder + Helper.masks.coffee
    #'react':
    #    mask: reactFolder + Helper.masks.react
    'es6':
        mask: es6Folder + Helper.masks.js
    'js-concat':
        mask: jsFiles
    'js-min':
        mask: jsOutput

Helper
.assignBasicTasksToGulp gulp
#.assignLessTaskToGulp gulp, fn: lessFn, buildFolder: lessBuildFolder
#.assignSassTaskToGulp gulp, fn: sassFn, buildFolder: sassBuildFolder
#.assignPngSpritesTaskToGulp gulp, mask: Helper.masks.sprite, imgName: spritesImageName, cssName: spritesFileName, cssFormat: 'stylus', imgFolder: spritesImageOutputFolder, cssFolder: spritesCssOutputFolder
.assignStylusTaskToGulp gulp, fn: stylusFn, buildFolder: stylusBuildFolder
.assignCssConcatTaskToGulp gulp, files: cssFiles, output: cssOutput
.assignCssMinTaskToGulp gulp, input: cssOutput, outputFolder: stylusBuildFolder
.assignCoffeeTaskToGulp gulp, folder: coffeeFolder, mask: Helper.masks.coffee, jsBuildFolder: jsBuildFolder, cleanBefore: false
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
    'coffee'
    'es6'
    'js-concat'
    'js-min'
    'version'
    'copy-core-assets'
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
