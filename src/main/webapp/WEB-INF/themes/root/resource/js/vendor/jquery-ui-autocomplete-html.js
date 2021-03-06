
  /*
   * jQuery UI Autocomplete HTML Extension
   *
   * Copyright 2010, Scott González (http://scottgonzalez.com)
   * Dual licensed under the MIT or GPL Version 2 licenses.
   *
   * http://github.com/scottgonzalez/jquery-ui-extensions
   */

// HTML extension to autocomplete borrowed from
// https://github.com/scottgonzalez/jquery-ui-extensions/blob/master/autocomplete/jquery.ui.autocomplete.html.js

(function( $ ) {
  var proto = $.ui.autocomplete.prototype,
    initSource = proto._initSource;

  function filter( array, term ) {
    var matcher = new RegExp( $.ui.autocomplete.escapeRegex(term), "i" );
    return $.grep( array, function(value) {

      return matcher.test( $( "<div>" ).html( value.label || value.value || value ).text() );
    });
  }

  $.extend( proto, {
    _initSource: function() {
      if ($.isArray(this.options.source) ) {
        this.source = function( request, response ) {
          response( filter( this.options.source, request.term ) );

        };
      } else {
        initSource.call( this );
      }
    },

    //_renderItem function is called for each list item returned from the autocomplete source
    _renderItem: function( ul, item) {
      //'info' is set as the value for headers or other info in the list that should not have a value
      if (item.value == 'info') {
        item.value = "";
      }
      return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( $( "<a></a>" )
          [item.type == "html" ? "html" : "text"]( item.label ) )
        .appendTo( ul );
    }
  });

})( jQuery );

