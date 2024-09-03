const path = require('path');

module.exports = {
    mode: 'production', // 'development' or 'production'
    entry: {
        libNameExample: './ts/lib-name-example/index.ts',
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'build/scripts/typescript'),
        libraryTarget: 'var',
        library: '[name]',
    },
    devtool: 'source-map',
    resolve: {
        extensions: ['.ts', '.js'],
        alias: {
            '@': path.resolve(__dirname, 'ts'),
            '@dicore': path.resolve(__dirname, '../vendor/dimaninc/di_core/ts'),
        },
    },
    module: {
        rules: [
            {
                test: /\.ts$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
        ],
    },
};
