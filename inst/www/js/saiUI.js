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

  $('.dropdown-item').on('click', function() {

    // Check if multiple choices are allowed
    var multi = $(this).parent().prev('button').attr('data-multiple') === 'true';

    // If only a single value is allowed, deselect all siblings
    if (!multi) $(this).siblings().removeClass('active');

    // Toggle active class on or off
    $(this).toggleClass('active');

    // Trigger a change event to update Shiny
    $(this).closest('.dropdownmenu').trigger('change');

  });

});

})(jQuery);
