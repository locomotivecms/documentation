$(function() {
  // $("ul.tabs").tabs(".panes > section");

  $('.home-row h1').each(function(index) {
    $el = $(this)
    $el.html('<span>' + $el.text() + '</span>')
  })

  $('#home-cred h1').each(function(index) {
    $el = $(this)
    $el.html('<span>' + $el.text() + '</span>')
  })

  // mobile
  $('#nav-toggle').on('click',function(e){
    $('#main-nav').toggleClass('expanded');
    $(this).toggleClass('expanded');
  });

  var platformSpecificPages = ['/get-started/install-wagon', '/get-started/install-engine-locally'];
  if( $.inArray(window.location.pathname, platformSpecificPages) > -1 ) {
    function togglePlatformSpecificGuides(platformToShow) {
      $('.guide').hide();
      if( $.inArray(platformToShow, ['#windows', '#linux', '#mac']) > -1 ) {
        $(platformToShow).fadeIn();
      }
    }
    togglePlatformSpecificGuides(window.location.hash);
    $('#platform-selector .link a').on('click', function(even) {
      togglePlatformSpecificGuides($(this).attr('href'));
    });
  }
});
