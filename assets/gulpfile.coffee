gulp = require 'gulp'
Helper = require('../vendor/dimaninc/di_core/scripts/static-builder/inc/gulp.helper').setWorkFolder __dirname

# base folder
buildFolder = 'build/'
jsBuildFolder = buildFolder + 'js/'
vendorFolder = '../htdocs/assets/vendor/'
bowerFolder = 'bower_components/'
npmFolder = 'node_modules/'

# stylus settings
stylusFolder = 'stylus/'
stylusBuildFolder = buildFolder + 'styles/'
stylusFn = stylusFolder + 'main.styl'

# less settings
lessFolder = 'less/'
lessBuildFolder = buildFolder + 'styles/'
lessFn = lessFolder + 'less.less'

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
cssOutput = stylusBuildFolder + 'styles.css'
cssOutputMin = stylusBuildFolder + 'styles.min.css'
cssFiles = [
    cssFolder + 'jquery/*.css'
    #Helper.getCoreFolder() + 'css/dipopups.css'
    stylusBuildFolder + 'main.css'
    #lessBuildFolder + 'less.css'
]

# coffee settings
coffeeFolder = 'coffee/'

# react settings
reactFolder = 'react/'
reactBuildFolder = jsBuildFolder + reactFolder
reactCoreFolder = 'bower_components/react/'
reactCoreFiles = [
    #'react.min.js'
    #'react-dom.min.js'
]

# js settings
jsFolder = 'js/'
jsOutput = jsBuildFolder + 'application.js'
jsOutputMin = jsBuildFolder + 'application.min.js'
jsFiles = reactCoreFiles.map (f) -> reactCoreFolder + f
.concat [
    Helper.getCoreFolder() + 'js/functions.js'
    #bowerFolder + 'jsep/src/jsep.js'
    #bowerFolder + 'dreampilot/dist/dp.js' #.min
    jsFolder + '**/**/*.js' # pure js
    jsBuildFolder + '**/*.js' # compiled coffee
    '!' + jsOutput
    '!' + jsOutputMin
]

assetFiles = [
    cssOutputMin
    jsOutput
    jsOutputMin
]
assetFilesForWatch = [
    cssOutputMin
    jsOutputMin
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
    'stylus-sprite':
        mask: Helper.masks.sprite
    'stylus':
        mask: stylusFolder + Helper.masks.stylus
    #'less':
    #    mask: lessFolder + Helper.masks.less
    'css-concat':
        mask: cssFiles
    'css-min':
        mask: cssOutput
    'coffee':
        mask: coffeeFolder + Helper.masks.coffee
    #'react':
    #    mask: reactFolder + Helper.masks.react
    'js-concat':
        mask: jsFiles
    'js-min':
        mask: jsOutput
    'copy-assets':
        mask: [
            assetFilesForWatch
            assetImageFiles
            assetFontFiles
            assetVideoFiles
        ]

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
    Helper
    .addSimpleCopyTaskToGulp gulp, groupId: 'copy-assets', files: assetFiles, baseFolder: buildFolder, destFolder: assetsTargetFolder, done: done
    .addSimpleCopyTaskToGulp gulp, groupId: 'copy-assets', files: assetImageFiles, baseFolder: imagesFolder, destFolder: assetsTargetFolder + imagesFolder, done: done
    .addSimpleCopyTaskToGulp gulp, groupId: 'copy-assets', files: assetFontFiles, baseFolder: fontsFolder, destFolder: assetsTargetFolder + fontsFolder, done: done
    .addSimpleCopyTaskToGulp gulp, groupId: 'copy-assets', files: assetVideoFiles, baseFolder: videosFolder, destFolder: assetsTargetFolder + videosFolder, done: done

Helper
.assignBasicTasksToGulp gulp
#.assignLessTaskToGulp gulp, fn: lessFn, buildFolder: lessBuildFolder
.assignPngSpritesTaskToGulp gulp, mask: Helper.masks.sprite, imgName: spritesImageName, cssName: spritesFileName, cssFormat: 'stylus', imgFolder: spritesImageOutputFolder, cssFolder: spritesCssOutputFolder
.assignStylusTaskToGulp gulp, fn: stylusFn, buildFolder: stylusBuildFolder
.assignCssConcatTaskToGulp gulp, files: cssFiles, output: cssOutput
.assignCssMinTaskToGulp gulp, input: cssOutput, outputFolder: stylusBuildFolder
.assignCoffeeTaskToGulp gulp, folder: coffeeFolder, mask: Helper.masks.coffee, jsBuildFolder: jsBuildFolder, cleanBefore: false
.assignJavascriptConcatTaskToGulp gulp, files: jsFiles, output: jsOutput
.assignJavascriptMinTaskToGulp gulp, input: jsOutput, outputFolder: jsBuildFolder
.assignBowerFilesTaskToGulp gulp, outputFolder: vendorFolder
.assignAdminStylusTaskToGulp gulp

# build
gulp.task 'build', gulp.series(
    'bower-files'
    'stylus-sprite'
    'stylus'
    #'less'
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
