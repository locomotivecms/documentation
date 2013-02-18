$(function() {

  var path = window.location.pathname.split( '/' ).pop(-1);
  $(".dropdown-menu").each(function(){
    current_section = $(this);
    current_section.find("a").each(function(){
      // console.log($(this).attr("href").indexOf(path))
      if ($(this).attr("href").indexOf(path) != -1){
        current_section.addClass("expanded");
        $(this).addClass("active");
      }
    });
  });

  $("ul.dropdown a.dropdown-toggle").click(function(){
    $("ul.dropdown .dropdown-menu").removeClass("expanded");
    $(this).next().toggleClass("expanded");
    return false
  });

    
  

  // mobile 
  $('#nav-toggle').on('click',function(e){
    $('#main-nav').toggleClass('expanded');
    $(this).toggleClass('expanded');
  });
  
  $('#main-nav li.guides > a').on('click', function(e){
    e.preventDefault();
    $('#guides').toggle();
  });
});