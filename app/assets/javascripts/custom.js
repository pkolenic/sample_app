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
          
		$('#micropost_content').focus(function() {
			$('#characters_remaining').show();
		 })
		 .blur(function () {
			$('#characters_remaining').hide();
		 })
		 .on("keyup", function() {
		 	var text = $('#micropost_content').val(); 
		 	if (text.length > 140) {
		 		$('#micropost_content').val(text.substring(0, 140));
		 	}
		 	var count = 140 - $('#micropost_content').val().length;
		 	$('#remaining_count').text(count);
		 });
    });
})(jQuery);
