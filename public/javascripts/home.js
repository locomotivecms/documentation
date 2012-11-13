$(function() {
  $("ul.tabs").tabs("#container-sidebar > section");
  
  //$("ul.dropdown").tabs();
  
  $("ul.tabs a").click(function(){
    $("ul.tabs a").removeClass("active");
    $(this).toggleClass("active");
  });

  $("ul.dropdown a").click(function(){
    $(this).next().toggleClass("block");
    return false;
  });

  $("ul.dropdown ul li a").click(function(){
    tab_id = "#"+$(this).attr('id');
    $("ul.dropdown").tabs("#container-sidebar > section",'select', tab_id);
    return false;
  });

  
  

  // mobile 
  $('#nav-toggle').on('click',function(e){
    $('#main-nav').toggleClass('expanded');
    $(this).toggleClass('expanded');
  });
  
});