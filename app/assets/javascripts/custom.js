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
});
