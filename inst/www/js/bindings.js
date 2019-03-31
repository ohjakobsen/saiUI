var searchboxInputBinding = new Shiny.InputBinding();

$.extend(searchboxInputBinding, {
  find: function(scope) {
  	return $(scope).find('.searchbox');
  },
  getId: function(el) {
  	// return InputBinding.prototype.getId.call(this, el) || el.name;
  	return $(el).attr('id');
  },
  getValue: function(el) {
    return el.value;
  },
  setValue: function(el, value) {
  	el.value = value;
  },
  subscribe: function(el, callback) {
    // removed input.searchboxInputBinding from on
    $(el).on('keyup.searchboxInputBinding', function(event) {
      callback(true);
    });
    $(el).on('change.searchboxInputBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
  	$(el).off('.searchboxInputBinding');
  },
  receiveMessage: function(el, data) {
  	if (data.hasOwnProperty('value')) this.setValue(el, data.value);

    if (data.hasOwnProperty('placeholder')) {
      el.placeholder = data.placeholder;
    }

    $(el).trigger('change');
  },
  getState: function(el) {
  	return {
    	value: el.value,
    	placeholder: el.placeholder
  	};
  },
  getRatePolicy: function() {
  	return {
  	  policy: 'debounce',
    	delay: 250
  	};
  }
});
Shiny.inputBindings.register(searchboxInputBinding, 'saiUI.searchboxInput');
Shiny.inputBindings.setPriority('saiUI.searchboxInput', 10);

var navbarTabInputBinding = new Shiny.InputBinding();
$.extend(navbarTabInputBinding, {
  find: function(scope) {
    // return $(scope).find('#pagenav');
    return $(scope).find('.mainnav');
  },
  getId: function(el) {
    return $(el).attr('id');
  },
  getValue: function(el) {
    var anchor = $(el).find('li:not(.dropdown) > a.active');
    if (anchor.length === 1)
      return $(anchor).attr('data-value');

    return null;
  },
  setValue: function(el, value) {
    var self = this;
    var success = false;
    if (value) {
      var anchors = $(el).find('li:not(.dropdown)').children('a');
      anchors.each(function() {
        if ($(this).attr('data-value') === value) {
          $(this).tab('show');
          success = true;
          return false; // Break out of each()
        }
        return true;
      });
    }
    if (!success) {
      // This is to handle the case where nothing is selected, e.g. the last tab
      // was removed using removeTab.
      $(el).trigger('change');
    }
  },
  getState: function(el) {
    return { value: this.getValue(el) };
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value'))
      this.setValue(el, data.value);
  },
  subscribe: function(el, callback) {
    $(el).on('change shown.navbarTabInputBinding shown.bs.tab.navbarTabInputBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('.bootstrapTabInputBinding');
  },
  _getTabName: function(anchor) {
    return anchor.attr('data-value') || anchor.text();
  }
});
Shiny.inputBindings.register(navbarTabInputBinding, 'saiUI.navbarTabInput');
Shiny.inputBindings.setPriority('saiUI.navbarTabInput', 10);

var toggleButtonInputBinding = new Shiny.InputBinding();

$.extend(toggleButtonInputBinding, {
  find: function(scope) {
    return $(scope).find('button.toggle');
  },
  getId: function(el) {
    return $(el).attr('id');
  },
  getValue: function(el) {
    // Returns true if class active is present, false if not
    return el.classList.contains('active');
  },
  setValue: function(el, value) {
    var self = this;
    if (value) {
      console.log(value);
    }
  },
  receiveMessage: function(el, data) {
    if (data.hasOwnProperty('value') && data.value !== null) {
      // Get the old value
      var old = el.classList.contains('active');
      // If new value is not equal to the old value, trigger a click event
      if (data.value != old) {
        $(el).trigger('click');
      }
    } else if (data.hasOwnProperty('change') && data.change !== null) {
      $(el).trigger('click');
    }
  },
  subscribe: function(el, callback) {
    $(el).on('change.toggleButtonInputBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off('button.toggle');
  },
  getRatePolicy: function() {
    return {
    	policy: 'debounce',
    	delay: 100
  	};
  }
});

Shiny.inputBindings.register(toggleButtonInputBinding, 'saiUI.toggleButton');
Shiny.inputBindings.setPriority('saiUI.toggleButton', 10);

var dropdownMenuInputBinding = new Shiny.InputBinding();

$.extend(dropdownMenuInputBinding, {
  find: function(scope) {
    return $(scope).find('.dropdownmenu');
  },
  getId: function(el) {
    return $(el).attr('id');
  },
  getValue: function(el) {
    // Get values of all active items and return an array
    var vals = $(el).find('a.dropdown-item.active').map(function() {
      return $(this).text();
    }).get();
    return vals;
  },
  receiveMessage: function(el, data) {
    // TODO: Implement function!
  },
  subscribe: function(el, callback) {
    $(el).on('change.dropdownMenuInputBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off();
  }
});

Shiny.inputBindings.register(dropdownMenuInputBinding, 'saiUI.dropdownMenu');
Shiny.inputBindings.setPriority('saiUI.dropdownMenu', 10);

var slicerInputBinding = new Shiny.InputBinding();

$.extend(slicerInputBinding, {
  find: function(scope) {
    return $(scope).find('.slicer');
  },
  getId: function(el) {
    return $(el).attr('id');
  },
  getValue: function(el) {
    // Get values of all active items and return an array
    var vals = $(el).find('.slicer-input.active').map(function() {
      return $(this).attr('data-value');
    }).get();
    if (vals.length === 0) return null;
    return vals;
  },
  receiveMessage : function(el, data) {
    $(el).find('button').each(function() {
      $(this).removeClass('active');
      if ($(this).attr('data-value') === data.value) {
        $(this).addClass('active');
        $(this).attr('aria-pressed', 'true');
      }
    });
    $(el).trigger('change');
  },
  subscribe: function(el, callback) {
    $(el).on('change.slicerInputBinding', function(event) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off();
  }
})

Shiny.inputBindings.register(slicerInputBinding, 'saiUI.slicerInput');
Shiny.inputBindings.setPriority('saiUI.slicerInput', 10);
