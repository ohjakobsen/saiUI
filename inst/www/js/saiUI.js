(function($) {

$(document).ready(function() {

  // Add custom JS here
  $('button.toggle').on('click', function() {

    // Get value of object
    var value = $(this).val();

    // We want to change a true value to false and vice versa
    var ret = (value == 'true') ? 'false' : 'true';

    // Set the new value to the object
    $(this).val(ret);

  });

});

})(jQuery);
