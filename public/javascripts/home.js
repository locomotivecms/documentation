$(function() {

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
  
});