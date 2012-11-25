$(function() {
  //$("ul.tabs").tabs("#container-sidebar > section");
  
  //$('.dropdown-toggle').dropdown()

  //$("ul.dropdown").tabs();
  
  $("ul.dropdown a.dropdown-toggle").click(function(){
    $("ul.dropdown .dropdown-menu").removeClass("expanded");
    $(this).next().toggleClass("expanded");
    return false
  });

  // $("ul.dropdown a").click(function(){
  //   $(this).next().toggleClass("block");
  //   return false;
  // });

  // $("ul.dropdown ul li a").click(function(){
  //   tab_id = "#"+$(this).attr('id');
  //   $("ul.dropdown").tabs("#container-sidebar > section",'select', tab_id);
  //   return false;
  // });

  
  

  // mobile 
  $('#nav-toggle').on('click',function(e){
    $('#main-nav').toggleClass('expanded');
    $(this).toggleClass('expanded');
  });
  
});