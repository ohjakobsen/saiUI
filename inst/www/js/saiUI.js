(function($) {

// This is a hack to the file upload function in Shiny
// When a file is uploaded in Shiny, the name of the file is set with the
// .val() function in jQuery. This function does not raise any events that
// we can hook onto to change our new UI elements based on Bootstrap 4.
// We therefore modify the original jQuery .val() function so that if the
// element that is changed is our filename placeholder, we pick up the filename
// value and insert it to our input label. The filename (or number of files)
// is recorded in the first element in the object "arguments".
$.fn._val = $.fn.val;
$.fn.val = function () {
  // Run original function
  var obj = $.fn._val.apply(this, arguments);
  // If we have a file input, we want to add some functions
  if ($(this).hasClass('custom-file-placeholder')) {
    $(this).siblings('.custom-file-input').addClass('is-valid');
    $(this).siblings('.custom-file-label').text(arguments[0]);
  }
  return obj;
}

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

  $('body').on('click', '.slicer-input', function() {
    var multi = $(this).closest('.slicer').attr('multiple')
    if (typeof multi === typeof undefined || multi === false) {
      // Check if button is active. Return if true
      var active = $(this).hasClass('active');
      if (active)
        return;
      else {
        // Toggle button state
        $(this).toggleClass('active');
        // Set aria-pressed value
        this.setAttribute('aria-pressed', 'true');
        // Deactivate all other siblings
        $(this).siblings().removeClass('active');
        $(this).siblings().attr('aria-pressed', 'false');
        // Trigger a change event on the parent element
        $(this).closest('.slicer').trigger('change');
      }
    } else {
      // Toggle button state
      $(this).toggleClass('active');
      // Set aria-pressed value
      var pressed = (this.getAttribute('aria-pressed') === 'true');
      this.setAttribute('aria-pressed', !pressed);
      // Trigger a change event on the parent element
      $(this).closest('.slicer').trigger('change');
    }
    // console.log(this.className.split(/\s+/));
  });

  $('.navbar-collapse ul > li > a').on('click', function(){
    $('.navbar-collapse').collapse('hide');
});

});

})(jQuery);
