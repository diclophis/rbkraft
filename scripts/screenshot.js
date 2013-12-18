#!/usr/bin/env phantomjs

var system = require('system');
var page = require('webpage').create();
page.viewportSize = { width: 2048, height: 2048 };
//page.open('http://mavencraft.net/current/#/-255/64/244/-1/0/0', function (status) {
page.open('http://mavencraft.net/current/#/10000/64/0/-2/0/0', function (status) {
  window.setTimeout(function () {
    page.render(system.args[1]);
    phantom.exit(); 
  }, 1000);
});

