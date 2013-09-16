// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


// $('#voting-booth')
$(document).on('ajax:success', function(event, xhr, status) {
  // $(this).append(xhr.responseText);
  // TODO figure out if it was vote true vs. false and update counters
  // if it was a changed vote, factor in accordingly
  console.log("SUCCESS" + xhr.responseText)
  console.log(xhr);
  $('#true-score').html(xhr.vote_counts.true)
  $('#false-score').html(xhr.vote_counts.false)
}).on('ajax:error', function(event, xhr, status) {
  // insert the failure message inside the "#account_settings" element
  alert("ERROR: " + xhr.responseText);
});