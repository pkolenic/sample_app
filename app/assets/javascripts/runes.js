var updateRuneOptions = function() { 
	var rune_type = $('#rune_rune_type_id option:selected').html();
	
	// Hide Titles
	$('.runeTitles').hide();

	// If Rune Type has Titles Then Show them
	var titles = $('#' + rune_type + "Titles");
	if (titles) {
		titles.show();
	}

	// Hide all Extra Fields
	$('.runeFields').hide();

	// Show correct Extra Fields For Rune Type
	$('.' + rune_type).show();
};

$( document ).ready(function() {
	// Handle New Rune Page
	var rune_type_select = $('#rune_rune_type_id');
	if (rune_type_select) {
		// Set initial Rune Options
		updateRuneOptions();		
		       	
       	// Handles Changing Rune Type in Rune Creation
       	rune_type_select.change(updateRuneOptions);
	}
});