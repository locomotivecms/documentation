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
  
  $('#install-wagon-selector, #install-engine-locally-selector').on('click', 'a', function(e){
    e.preventDefault();
    $('#install-wagon-guides, #install-engine-locally-guides').find('.guide').hide();
    $("#guide_" + $(this).data('section')).fadeIn();
  });

});
