#!/usr/bin/env phantomjs

var system = require('system');
var page = require('webpage').create();
page.viewportSize = { width: 512, height: 512 };

setTimeout(function() {
  phantom.exit(); 
}, 10000);

page.open(system.args[2], function (status) {
  window.setTimeout(function () {
    page.evaluate(function() {
      $('.gm-style > div').hide(); $('.gm-style div').first().show();
    });
    page.render(system.args[1]);
    phantom.exit(); 
  }, 5000);
});

