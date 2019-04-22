// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

const { SpecReporter } = require('jasmine-spec-reporter');
// const puppeteer = require('puppeteer');

exports.config = {
  allScriptsTimeout: 11000,
  specs: [
    './src/**/*.e2e-spec.ts'
  ],
  capabilities: {
    browserName: 'chrome',
    // chromeDriver: '/usr/bin/chromium-browser',
    chromeOptions: {
      args: ['--no-sandbox', '--headless', '--disable-gpu', '--remote-debugging-port=9222', '--window-size=1024,768'],
      // binary: puppeteer.executablePath(),
      // chromeDriver: require('path').join(__dirname, '../node_modules/webdriver-manager/selenium/chromedriver_2.46'),
    }
  },
  // chromeDriver: '/usr/bin/chromium-browser',
  // chromeDriver: require('path').join(__dirname, '../node_modules/webdriver-manager/selenium/chromedriver_2.46'),
  // ignoreUncaughtExceptions: true,
  directConnect: true,
  // directConnect: false,
  // seleniumAddress: 'http://localhost:4444/wd/hub',
  // seleniumAddress: 'http://selenium-chrome:4444/wd/hub',
  baseUrl: 'http://localhost:4200/',
  framework: 'jasmine',
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000,
    print: function() {}
  },
  onPrepare() {
    require('ts-node').register({
      project: require('path').join(__dirname, './tsconfig.e2e.json')
    });
    jasmine.getEnv().addReporter(new SpecReporter({ spec: { displayStacktrace: true } }));
  }
};
