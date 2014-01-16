#!/usr/bin/env phantomjs

var system = require('system');
var page = require('webpage').create();
page.viewportSize = { width: 256, height: 256 };
//page.open('http://mavencraft.net/current/#/-255/64/244/-1/0/0', function (status) {
//10000 0
page.open(system.args[2], function (status) {
  window.setTimeout(function () {
    page.evaluate(function() {
      $('.gm-style > div').hide(); $('.gm-style div').first().show();
    });
    page.render(system.args[1]);
    phantom.exit(); 
  }, 1000);
});

