//Released under MIT license: http://www.opensource.org/licenses/mit-license.php
(function ($) {
    'use strict';
	$(function () {
		// Handles showing Placeholder text in Form Fields
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
          
        // Show Labels below Lore Library Books
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
       	
       	// Show Labels below Guildhall Items
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
       	
       	// Show the Add Event Form
       	$('#add-event').click( 
       		function() {
       			$('#new-event-form-wrapper').show();
       			$('#add-event').hide();
       		}
       	);
       	
       	// Hide the Add Event Form
       	$('#event-close').click(
       		function() {
       			// @TODO clear the Form
       			$('#new-event-form-wrapper').hide();
       			$('#add-event').show();    
       			$('#new_event')[0].reset();   			
       		}
       	);
       	
       	// Hides and submits the form
       	$('#event-submit').click(
       		function() {
       			// @TODO clear the Form
       			$('#new-event-form-wrapper').hide();
       			$('#add-event').show();       			
       		}       		
       	);
       	
    });
})(jQuery);