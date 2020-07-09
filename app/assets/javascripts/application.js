// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require bootstrap.min
//= require jquery-3.2.1.min
//= require jquery_ujs
//= require jquery.turbolinks
//= require jquery-ui.min
//= require jquery-migrate.min
//= require jquery.fancybox.min.js
//= require popper.min.js
//= require jquery.backstretch.min.js
//= require wow.min.js
//= require retina.min.js
//= require scripts.js
//= require daterangepicker.js
//= require select2.min.js
//= require moment.min.js
//= require global.js
//= require toastr
//= require_tree .
//= require turbolinks


$(function() {
  var flashCallback;
  flashCallback = function() {
    return $(".alert").fadeOut();
  };
  $(".alert").bind('click', (function(_this) {
    return function(ev) {
      return $(".alert").fadeOut();
    };
  })(this));
  return setTimeout(flashCallback, 3000);
});