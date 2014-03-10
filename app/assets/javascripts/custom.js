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
          
        $('.book').hover(
        	function() {
        		var id = $(this).attr('id');
        		var book = $('#' + id + "_title"); 
        		var img = $('#' + id + ' img');
        		var bookshelf = $('#bookshelf');
        		var x = img.offset().left - bookshelf.offset().left - (book.width() / 2);
       			var y = img.offset().top - bookshelf.offset().top + img.height() + 5;
        		book.css({left:x,top:y});
        		book.show();
        	},
        	function() {
        		var id = $(this).attr('id');
        		$('#' + id + "_title").hide();        		
        	}
       	);   	
       	
       	$('.guildhall_label').hover(
       		function() {
       			var id = $(this).attr('id');
       			var label = $('#' + id + "_label");
       			var img = $('#' + id + ' img');
       			var x = img.offset().left;
       			var y = img.offset().top + img.height() + 5;
       			
       			label.css({left:x,top:y});
       			label.width(img.width());
       			label.show();
       		},
       		function () {
       			var id = $(this).attr('id');
       			$('#' + id + "_label").hide();	
       		}
       	);
    });
})(jQuery);
