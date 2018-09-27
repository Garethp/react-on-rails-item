const path = require('path');
const webpack = require('webpack');

module.exports = env => {
    env = env || {};

    return {
        mode: 'development',
        module: {
            rules: [
                {
                    exclude: /node_modules/,
                    test: /\.js$/,
                    use: [
                        {
                            loader: 'babel-loader',
                            options: {
                                presets: [ 'react', 'stage-0', [ 'env', { "useBuiltIns": true } ]],
                                babelrc: false,
                            },
                        },
                    ],
                },
            ],
        },

        resolve: {
            modules: [
                'node_modules',
            ],
        },

        entry: {
            server: [ 'babel-polyfill', './index.js' ],
        },

        output: {
            filename: 'server.js',
            path: path.resolve(__dirname, '../'),
        },
    };
};
