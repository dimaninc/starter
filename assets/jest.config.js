module.exports = {
    preset: 'ts-jest',
    testEnvironment: 'jsdom',
    moduleNameMapper: {
        '^@/(.*)$': '<rootDir>/ts/$1',
    },
    setupFiles: ['./jest.setup.js'],
};
