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

// Helper function for setting multiple attributes to an element
function setAttributes(el, attrs) {
  for(var key in attrs) {
    el.setAttribute(key, attrs[key]);
  }
}

// Message is a list of five values; the title, the body, the id of the toast,
// a boolean if the toast should autohide and the delay in hiding in seconds.
function addToastMessage(message) {

  var newMsg = document.createElement('div');

  // Create a list of attributes
  attrs = {
    'role': 'alert',
    'aria-live': 'assertive',
    'aria-atomic': 'true',
    'class': 'toast',
    'id': message[2]
  }

  // If autohide is disabled, we need to set data-autohide to false. If not
  // we add the data-delay attribute
  if (message[3] == 'false') {
    attrs['data-autohide'] = 'false';
  } else {
    attrs['data-delay'] = parseInt(message[4], 10);
  }

  // Set the attributes using our helper function
  setAttributes(newMsg, attrs);

  // HTMl for the close button
  var btn = '<button type="button" class="ml-2 mb-1 close" data-dismiss="toast" aria-label="Close">'+
  '<span aria-hidden="true">&times;</span></button>';

  // Create the title and body elements and add them to the toast
  var msgTitle = document.createElement('div');
      msgTitle.setAttribute('class', 'toast-header');
      msgTitle.innerHTML = '<strong class="mr-auto">' + message[0] + '</strong>' + btn;
  var msgBody = document.createElement('div');
      msgBody.setAttribute('class', 'toast-body');
      msgBody.innerHTML = message[1];

  newMsg.appendChild(msgTitle);
  newMsg.appendChild(msgBody);

  // Find the toast container element and add the toast notification
  var toastContainer = document.getElementById('toast-container');
  toastContainer.appendChild(newMsg);

  // New notifications will not be shown by default. Therefore we need to apply
  // the toast method to our new notification and set it to show
  $('#' + message[2]).toast('show');

}

Shiny.addCustomMessageHandler('createToast', addToastMessage);

function destroyToastMessage() {

}

$(document).ready(function() {

  // Change value on toggle button
  $(document).on('click', 'button.toggle', function() {

    // The toggle input listens to change events (we want to wait until all attributes
    // have been updated). We set the data-value attribute to match the status of the
    // button and trigger a change event
    this.setAttribute('data-value', this.classList.contains('active'));
    // Obviously, IE does not support the Event object, so we cannot use
    // new Event('change') together with dispatchEvent. For now we fall back to jQuery
    $(this).trigger('change');

  });

  // Display form-clear if text is entered in the search field
  $(document).on('keydown focus', '.searchbox input', function() {
    if ($(this).val().length > 0) {
      var size = $(this).siblings('.input-group-append').width();
      $(this).siblings('.form-clear').css('right', size + 'px');
      $(this).siblings('.form-clear').removeClass('d-none');
    }
  }).on('keydown keyup blur', '.searchbox input', function() {
    if ($(this).val().length === 0) {
      $(this).siblings('.form-clear').addClass('d-none');
    }
  });

  // Clear the search input and notify Shiny if form-clear is clicked
  $(document).on('click', '.form-clear', function() {
    $(this).siblings('input').val('').trigger('change');
    $(this).addClass('d-none');
  });

  // Toggle values in dropdown menu when the user selects a value and notify Shiny
  // The input binding for dropdown menus listens to the change event
  $(document).on('click', '.dropdown-item', function() {

    // Check if multiple choices are allowed
    var multi = $(this).parent().prev('button').attr('data-multiple') === 'true';

    // If only a single value is allowed, deselect all siblings
    if (!multi) $(this).siblings().removeClass('active');

    // Toggle active class on or off
    $(this).toggleClass('active');

    // Trigger a change event to update Shiny
    $(this).closest('.dropdownmenu').trigger('change');

  });

  // Do not propagate clicks on elements with attribute data-stoppropagation set
  // to true
  $(document).on('click', '[data-autoclose=false]', function(e) {
     e.stopPropagation();
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
  });

  $('.navbar-collapse ul > li > a').on('click', function(){
    $('.navbar-collapse').collapse('hide');
});

});

})(jQuery);
