const helperPath =
    '../vendor/dimaninc/di_core/scripts/static-builder/inc/gulp.helper';
const gulp = require('gulp');
const Helper = require(helperPath).setWorkFolder(__dirname);

const isBeyond = true;
const pr = './';
const beyondPrefix = isBeyond ? 'htdocs/' : '';

const buildFolder = 'build/';
const jsBuildFolder = buildFolder + 'scripts/';
const npmFolder = 'node_modules/';

const stylusFolder = 'stylus/';
const stylusBuildFolder = buildFolder + 'styles/';
const stylusFn = stylusFolder + 'main.styl';

const lessFolder = 'less/';
const lessBuildFolder = buildFolder + 'styles/';
const lessFn = lessFolder + 'less.less';

const sassFolder = 'sass/';
const sassBuildFolder = buildFolder + 'styles/';
const sassFn = sassFolder + 'sass.scss';

const spritesImageOutputFolder = 'images/';
const spritesImageName = 'sprite.png';
const spritesCssOutputFolder = stylusFolder + 'inc/';
const spritesFileName = 'sprite.styl';

const cssFolder = 'css/';
const cssOutputFolder = '../' + beyondPrefix + 'assets/styles/';
const cssOutput = cssOutputFolder + 'styles.css';
const cssOutputMin = cssOutputFolder + 'styles.min.css';
const cssFiles = [cssFolder + 'jquery/*.css', stylusBuildFolder + 'main.css'];

const coffeeFolder = 'coffee/';

const es6Folder = 'es6/';
const es6BuildFolder = jsBuildFolder + es6Folder;

const typescriptFolder = 'ts/';
const typescriptBuildFolder = jsBuildFolder + 'typescript/';

const jsFolder = 'js/';
const jsOutputFolder = '../' + beyondPrefix + 'assets/js/';
const jsOutput = jsOutputFolder + 'application.js';
const jsFiles = [
    Helper.getCoreFolder() + 'js/functions.js',
    coffeeBuildFolder + Helper.masks.js,
    typescriptBuildFolder + Helper.masks.js,
    es6BuildFolder + Helper.masks.js,
    jsFolder + '**/**/*.js',
    '!' + jsBuildFolder + 'main.js',
    jsBuildFolder + 'main.js',
];

const watchSettings = {
    'stylus': {
        mask: pr + stylusFolder + Helper.masks.stylus,
    },
    'less': {
        mask: lessFolder + Helper.masks.less,
    },
    'sass': {
        mask: sassFolder + Helper.masks.sass,
    },
    'css-concat': {
        mask: cssFiles,
    },
    'css-min': {
        mask: cssOutput,
    },
    'es6': {
        mask: pr + es6Folder + '**/*.js',
    },
    'typescript': {
        mask: typescriptFolder + Helper.masks.ts,
    },
    'js-concat': {
        mask: jsFiles,
    },
    'js-min': {
        mask: pr + jsOutput,
    },
};

Helper.assignBasicTasksToGulp(gulp)
    .assignSassTaskToGulp(gulp, {
        fn: sassFn,
        buildFolder: sassBuildFolder,
    })
    .assignLessTaskToGulp(gulp, {
        fn: lessFn,
        buildFolder: lessBuildFolder,
    })
    .assignStylusTaskToGulp(gulp, {
        fn: stylusFn,
        buildFolder: stylusBuildFolder,
    })
    .assignCssConcatTaskToGulp(gulp, {
        files: cssFiles,
        output: cssOutput,
    })
    .assignCssMinTaskToGulp(gulp, {
        input: cssOutput,
        outputFolder: cssOutputFolder,
    })
    .assignEs6TaskToGulp(gulp, {
        folder: es6Folder,
        mask: Helper.masks.js,
        jsBuildFolderr,
    })
    .assignWebpackTypescriptTaskToGulp(gulp, {
        entryFiles: ['ts/index.ts'],
        buildFolder: typescriptBuildFolder,
    })
    .assignJavascriptConcatTaskToGulp(gulp, {
        files: jsFiles,
        output: jsOutput,
    })
    .assignJavascriptMinTaskToGulp(gulp, {
        input: jsOutput,
        outputFolder: jsOutputFolder,
    })
    .assignAdminStylusTaskToGulp(gulp);

gulp.task(
    'build',
    gulp.series(
        'stylus',
        'css-concat',
        'css-min',
        'es6',
        'typescript',
        'js-concat',
        'js-min',
        'version',
        'copy-core-assets'
    )
);

gulp.task('watch', (done) => {
    const fn = (name, process) => {
        gulp.watch(process.mask, gulp.series(name)).on(
            'change',
            function (path, stats) {
                console.log(`[${name}] changed file ${path}`);

                if (['css-min', 'js-min'].includes(name)) {
                    return gulp.series('version');
                }
            }
        );
    };

    for (const [name, process] of Object.entries(watchSettings)) {
        fn(name, process);
    }

    return done();
});

gulp.task('default', gulp.series('build', 'watch'));
