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

var filterValueCount = 0;
var filters = [];
var videos = [];

function switchVideoPageType(type)
{
  // Hide All the Types
  jQuery('.videoPageTypes').hide();
  
  // Show The Select Types
  jQuery('#' + type).show();
}

function createFilterValueElement(value) {
	li = "<li><label for='filter_form-value-'" + filterValueCount;
	li += "'>Value</label><input class='filter-form-value id='filter_form-value-" + filterValueCount;
	if (value != null) {
		li += "' name='filter_form-value-" + filterValueCount + "' type='text' value='" + value + "'></li>";
	} else {
		li += "' name='filter_form-value-" + filterValueCount + "' type='text'></li>";
	}
	
	return li;
}

function parseFilters() {
	raw_filters = jQuery('#video_filters').val();
	if (raw_filters) {
		filters = jQuery.parseJSON(raw_filters);
	}
}

function parseVideos() {
	raw_videos = jQuery('#video_video_list').val();
	if (raw_videos) {
		videos = jQuery.parseJSON(raw_videos);
	}
}

/* Creates a new Filter Object */
function createFilter() {
	// Create filter object
	filter = {};
	
	// Set the Name
	filter.name = jQuery('#filter-form-name-value').val();
	
	// Create array for holding the values
	values = [];
	
	jQuery('.filter-form-value').each(function(index) {
		values.push($(this).val());
	});
		
	filter.values = values;
	
	return filter;
}

function checkFilterCount() {
	// disable the add filters button if we already have 3 filters
	if (filters.length > 2) {
		jQuery('#add-filter-button').addClass('disabled');
	} else {
		jQuery('#add-filter-button').removeClass('disabled');
	}	
}

function clearFilterForm()
{
	// Hide Form
	jQuery('#filter-form').hide();
	filterValueCount = 1;
		
	// Reset Content of Form
	jQuery('#filter-form-name-value').val('');
	jQuery('#filter-form-values').html(createFilterValueElement(null));
}

function deleteFromObject(key, obj) {
	for (var k in obj) {
		if (k == key) {
			delete obj[k];
		}
	}
}

function rebuildFilterList() {
	filterList = '';
	
	// Build the Filters
	if (filters.length > 0) {
		jQuery.each(filters, function( i, filter) {
			tr = '<tr class="filter-row" id="filter-' + i + '">';
			tr += '<td class="filter-name-column">' + filter.name + '</td>';
			tr += '<td class="filter-value-column">' + filter.values.join(', ') + '</td>';
			tr += '<td class="button-column">';
			tr += '<a class="btn btn-mini btn-info edit-filter" href="#" id="edit-filter-' + i + '">edit</a>';
			tr += '<a class="btn btn-mini btn-danger delete-filter" href="#" id="delete-filter-' + i + '">delete</a>';	
			tr += '</td>';
			tr += '</tr>';
			
			filterList += tr;
		});
	}
	jQuery('#filters').html(filterList);
	
	// Rebind the Delete Click Listeners
	jQuery('.delete-filter').bind('click', function(event) {
		event.preventDefault();
		filterNo = this.id.substring(14);
		deleteFilter(filterNo);
	});
	
	// Rebind the Edit Click Listeners
	jQuery('.edit-filter').bind('click', function(event) {
		event.preventDefault();
		filterNo = this.id.substring(12);
		editFilter(filterNo);
	});
	
	checkFilterCount();	
}

function rebuildVideoList() {
	videoList = '';
	
	// Build the Videos
	if (videos.length > 0) {
		jQuery.each(videos, function( i, video) {			
			tr = '<tr>';
			tr += '<td class="id-column">' + video.id + '</td>';
			tr += '<td class="title-column">' + video.title + '</td>';

			count = 0;
			if (filters.length > 0) {
				jQuery.each(filters, function( i, filter) {															
					tr += '<td class="filter-column filter-' + count + '">' + video[filter.name.toLowerCase()] + '</td>';
					count++;
			 	});				
			}
			
			// Add Empty Filter Values
			while(count < 3) {
				tr += '<td class="filter-column filter-' + count + '"></td>';
				count++;
			}
	
			tr += '<td class="button-column">';
			tr += '<a class="btn btn-mini btn-info edit-video" href="#" id="edit-' + i + '">edit</a>';
			tr += '<a class="btn btn-mini btn-danger delete-video" href ="#" id="delete-' + i + '">delete</a>';
			tr += '</td>';
			tr += '</tr>';
			 			
			videoList += tr;
		});
	}
	
	jQuery('#videos-list').html(videoList);
	
	// Rebind the Delete Click Listeners
	jQuery('.edit-video').bind('click', function(event) {
		event.preventDefault();
		editVideo(this);
	});
		
	// Rebind the Edit Click Listeners
	jQuery('.delete-video').bind('click', function(event) {
		event.preventDefault();
		deleteVideo(this);
	});	
}

function rebuildFilterHeaders() {
	// Clear the Header Values
	jQuery('#video-list-headers').empty();
	content = '<th class="id-column" id="video-id-header">video id</th>';
	content += '<th class="title-column" id="video-title-header">title</th>';
	
	count = 0;
	if (filters.length > 0) {
		 jQuery.each(filters, function( i, filter) {
			content += '<th class="filter-column" id="video-filter-' + i + '-header">' + filter.name + '</th>';
			count++;
		 });
	 }	
	 
	 // Add Empty Filter Headers
	 while (count < 3) {
	 	content += '<th class="filter-column" id="video-filter-' + count + '-header"></th>';
	 	count++;
	 }
	 
	jQuery('#video-list-headers').html(content);
}

function editFilter(filterNo) {		
	// populate the form
	jQuery('#filter-form-name-value').val(filters[filterNo].name);
	
	// Create Values
	values = '';
	jQuery.each( filters[filterNo].values, function (i, value) {
		values += createFilterValueElement(value); 
	});		
	jQuery('#filter-form-values').html(values);
		
	jQuery('#save-filter-form').data("type", "edit");
	jQuery('#save-filter-form').data("filter-id", filterNo);
	jQuery('#filter-note').show();
		
	jQuery('#filter-form').show();
}

function deleteFilter(filterNo) {
	// Remove from Array
	filter = filters[filterNo];
	filters.splice(filterNo, 1);
	jQuery('#video_filters').val(JSON.stringify(filters));
		
	// Rebuild Filter List
	rebuildFilterList();
				
	// Now need to remove from Video List Headers
	rebuildFilterHeaders();
		
	// Now need to remove from each Video Item	
	if (videos.length > 0) {
		jQuery.each( videos, function( i, video) {
			deleteFromObject(filter.name.toLowerCase(), video);	
		});
		jQuery('#video_video_list').val(JSON.stringify(videos));
		
		// Rebuild Video List Items
		rebuildVideoList();
	}
}

function editFilters(save_button) {
	oldFilters = filters.slice();
		
	if ($(save_button).data("type") == "add") {
		filter = createFilter();
		filters.push(filter);		
		
		// Add Filter to Videos
		if (videos.length > 0) {
			jQuery.each(videos, function( i, video) {
				filter_name = filter.name.toLowerCase();
				video[filter_name] = filter.values[0];
			});
		}
	} else {
		filterId = $(save_button).data("filter-id");
		filter = createFilter();
		filters[filterId] = filter;
		
		// Update Filter on Videos
		if (videos.length > 0) {
			jQuery.each(videos, function( i, video) {
				// Grab the Current Value
				filter_name = filter.name.toLowerCase();
				value = video[oldFilters[filterId].name.toLowerCase()];
				
				// Remove the Old Proptery
				deleteFromObject(oldFilters[filterId].name.toLowerCase(), video);
				
				// Check if value is an allowable value for the edited filter
				if (jQuery.inArray(value, filter.values) >= 0) {
					video[filter_name] = value;
				} else {
					video[filter_name] = filter.values[0];
				}
			});
		}
	}		
	jQuery('#video_filters').val(JSON.stringify(filters));
			
	// Update The Filter List
	rebuildFilterList();

	// Update the Video Header List
	rebuildFilterHeaders();

	// Update the vidoe_list form field
	jQuery('#video_video_list').val(JSON.stringify(videos));
		
	// Rebuild Video List Items
	rebuildVideoList();
		
	// clear Form
	clearFilterForm();	
}

function clearVideoForm() {
	jQuery('#video-form-id').val('');
	jQuery('#video-form-title').val('');	
	jQuery('#video-form-filters').empty();
	
	jQuery('#video-form').hide();
}

function onSaveVideo(save_button) {
	if ($(save_button).data("type") == "add") {
		video = {};
		video.id = jQuery('#video-form-id').val();
		video.title = jQuery('#video-form-title').val();
		if (filters.length > 0) {
			jQuery.each(filters, function(i, filter) {
				filter_name = filter.name.toLowerCase();
				video[filter_name] = jQuery('#filter-' + filter.name).val();	
			});
		}
		videos.push(video);
	} else {
		videoId = $(save_button).data("video-id");
		videos[videoId].id = jQuery('#video-form-id').val();
		videos[videoId].title = jQuery('#video-form-title').val();
		if (filters.length > 0) {
			jQuery.each(filters, function(i, filter) {
				filter_name = filter.name.toLowerCase();
				videos[videoId][filter_name] = jQuery('#filter-' + filter.name).val();	
			});
		}		
	}
	
	// Rebuild video_list form field
	jQuery('#video_video_list').val(JSON.stringify(videos));
		
	rebuildVideoList();
		
	// Clear the Video Edit Form
	clearVideoForm();
}

function populateVideoForm(videoNo) {
	if (filters.length > 0) {
		content = '';
		jQuery.each(filters, function(i, filter) {
			content += "<label for='filter-" + filter.name + "'>" + filter.name + "</label>";
			content += "<select id='filter-" + filter.name + "'>"; 
			jQuery.each(filter.values, function(j, value) {
				content += "<option value='" + value + "'>" + value + "</option>";
			});
			content += "</select>";
		});
		jQuery('#video-form-filters').html(content);
	}
	
	if (videoNo != null) {
		if (filters.length > 0) {
			jQuery.each(filters, function(i, filter) {
				filter_name = filter.name.toLowerCase();
				jQuery('#filter-' + filter.name).val(videos[videoNo][filter_name]);
			});
		}
		
		jQuery('#video-form-id').val(videos[videoNo].id);
		jQuery('#video-form-title').val(videos[videoNo].title);
	}
}

function editVideo(video) {
	videoNo = video.id.substring(5);

	jQuery('#save-video-form').data("type", "edit");
	jQuery('#save-video-form').data("video-id", videoNo);
	populateVideoForm(videoNo);
	
	// Show Form
	jQuery('#video-form').show();
}

function deleteVideo(video) {
	videoNo = video.id.substring(7);
	// Remove from Array
	videos.splice(videoNo, 1);
	
	// Rebuild video_list form field
	jQuery('#video_video_list').val(JSON.stringify(videos));
		
	rebuildVideoList();
}

/* SETUP NEW/EDIT VIDEO PAGES */
function setupVideoPage() {			
	switchVideoPageType(jQuery('#video-type').val());
	parseFilters();
	parseVideos();
	checkFilterCount();
	
	jQuery('#add-filter-button').bind('click', function(event) {
		event.preventDefault();
		
		if (jQuery(this).hasClass('disabled')) {
			return false;
		} else {
			filterValueCount = 1;
			jQuery('#save-filter-form').data("type", "add");
			jQuery('#filter-note').hide();
			jQuery('#filter-form').show();
		}
	});
	
	jQuery('#add-video-button').bind('click', function(event) {
		event.preventDefault();
		jQuery('#save-video-form').data("type", "add");

		populateVideoForm(null);
		
		// Show the Video Edit Form
		jQuery('#video-form').show();
	});
	
	jQuery('.edit-video').bind('click', function(event) {
		event.preventDefault();
		editVideo(this);
	});
	
	jQuery('.delete-video').bind('click', function(event) {
		event.preventDefault();
		deleteVideo(this);
	});
	
	jQuery('#cancel-video-form').bind('click', function(event) {
		event.preventDefault();
		clearVideoForm();
	});
	
	jQuery('#save-video-form').bind('click', function(event) {
		event.preventDefault();
		onSaveVideo(this);
	});	
	
	jQuery('.edit-filter').bind('click', function(event) {
		event.preventDefault();
		filterNo = this.id.substring(12);
		editFilter(filterNo);
	});
	
	jQuery('.delete-filter').bind('click', function(event) {
		event.preventDefault();
		filterNo = this.id.substring(14);
		deleteFilter(filterNo);
	});
	
	jQuery('#cancel-filter-form').bind('click', function(event) {		
		event.preventDefault();
		clearFilterForm();
	});
	
	jQuery('#add-filter-form-value').bind('click', function(event) {
		event.preventDefault();
		
		// Add Value Input
		filterValueCount = filterValueCount + 1;
		jQuery('#filter-form-values').append(createFilterValueElement(null));
		jQuery('#remove-filter-form-value').removeClass('disabled');		
	});
	
	jQuery('#remove-filter-form-value').bind('click', function(event) {
		event.preventDefault();
		
		if (jQuery(this).hasClass('disabled')) {
			return false;
		} else {
			filterValueCount = filterValueCount - 1;	
			jQuery('#filter-form-values li:last').remove();
			
			if (filterValueCount < 2) {
				jQuery('#remove-filter-form-value').addClass('disabled');
			}
		}
	});
	
	jQuery('#save-filter-form').bind('click', function(event) {
		event.preventDefault();
		editFilters(this);
	});
}

/* CLAN Home Page Methods */
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
	
	var title = jQuery(document).find("title").text();
	
	if (title.indexOf("Video Page") >= 0) {
		setupVideoPage();
	}
});
