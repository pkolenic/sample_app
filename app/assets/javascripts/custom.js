//Released under MIT license: http://www.opensource.org/licenses/mit-license.php
(function ($) {
    'use strict';
    $(function () {
        $('[placeholder]')
          .focus(function () {
              var input = $(this);
              if (input.val() === input.attr('placeholder')) {
                  input.val('').removeClass('placeholder');
              }
          })
          .blur(function () {
              var input = $(this);
              if (input.val() === '' || input.val() === input.attr('placeholder')) {
                  input.addClass('placeholder').val(input.attr('placeholder'));
              }
          })
          .blur()
          .parents('form').submit(function () {
              $(this).find('[placeholder]').each(function () {
                  var input = $(this);
                  if (input.val() === input.attr('placeholder')) {
                      input.val('');
                  }
              });
          });
    });
})(jQuery);

function switchHomePageTab(tab) {
	jQuery('.tab_body').hide();
	jQuery('.tab').removeClass('active');
	
	jQuery('#' + tab + '-tab').addClass('active');
	jQuery('#' + tab +'-tab-body').show();
}

jQuery(document).ready(function(){
	if (jQuery('#default_home_body')) {
		jQuery('.tab').bind('click', function() {
			switchHomePageTab(jQuery(this).attr("data-id"));
		});
	}
	
	// Grab all the TS divs and Hide them
	var ts_id_base = "ts3_h_s1004";
	var ts_user = "cl";
	var ts_elements = jQuery('div[id^="' + ts_id_base + '"]');
	if (typeof ts_channels === 'undefined' || !ts_channels) {
		ts_channels = new Array();
	}
	ts_elements.hide();
	
	// Now show only the ones for this Site
	jQuery('#' + ts_id_base).show();
	jQuery.each(ts_channels, function( index, value ) {
		var channel = jQuery('#' + ts_id_base + '_' + value);
		channel.show();
		var next_element = channel.next();
		while (next_element && next_element.attr('id') && next_element.attr('id').indexOf(ts_id_base + "_cl") >= 0) {
			next_element.show();
			next_element = next_element.next();
		}
	});
});
