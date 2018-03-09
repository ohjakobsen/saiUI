var searchboxInputBinding = new Shiny.InputBinding();

$.extend(searchboxInputBinding, {
  find: function(scope) {
  	return $(scope).find('.searchbox');
  },
  getId: function(el) {
  	// return InputBinding.prototype.getId.call(this, el) || el.name;
  	// console.log($(el).attr('id'));
  	return $(el).attr('id');
  },
  getValue: function(el) {
    // console.log(el.value);
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

    /*if (data.hasOwnProperty('label')) {
      console.log(el);
      $(el).parent().find('label[for="' + data.id + '"]').text(data.label);
    }*/

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
