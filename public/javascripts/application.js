$(document).ready(function(){
  // $('.corner').corner();
  $('.formatted').colorize();
  $("a#advanced-search-show").click(function(event){
    $('#advanced-search').show("slow");   
    return false;
  });
  $("a#advanced-search-hide").click(function(event){
    $('#advanced-search').hide("slow");
    return false;
  });
  $("a#exact-search-show").click(function(event){
    $('#exact-search').show("slow");   
    return false;
  });
  $("a#exact-search-hide").click(function(event){
    $('#exact-search').hide("slow");
    return false;
  });
  
});
