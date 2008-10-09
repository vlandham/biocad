$(document).ready(function(){
  $('.corner').corner();
  $('table').colorize();
  $("a#advanced-search-show").click(function(event){
    $('#advanced-search').show("slow");   
    return false;
  });
  $("a#advanced-search-hide").click(function(event){
    $('#advanced-search').hide("slow");
    return false;
  });
});
