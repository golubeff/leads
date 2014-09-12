// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

function show_location(id) {
    $('#' + id + "_location").show()
}

$(function(){
    $(document).ready(function(){
        $('button.buynow').click(function(){
            var btn = $(this);
            var lead_id = btn.data('leadid');
            var status_field = $('#status-' + lead_id);
            var buynow_bid = $("#bid-buynow-" + lead_id).html();

            if (window['leadtimers-' + lead_id]) 
                clearInterval(window['leadtimers-' + lead_id]);

            status_field.html('Buying out...');
            status_field.removeClass('text-danger');
            status_field.removeClass('text-success');    

            btn.addClass('disabled');
            $.ajax({
                url: "/bids",
                type: "POST",
                cache: false,
                async: true,
                data: { lead_id: lead_id, bid: buynow_bid, buynow: true },
                error: function(xhr, status, error) {
                
                    var err = xhr.responseText;
                    if (xhr.status == '500') 
                        err = 'Server error';

                    status_field.html(err || "Unknown error");
                    status_field.addClass('text-danger');
                    btn.removeClass('disabled');
                }
            });
        });

        $('button.bid').click(function(){
            var btn = $(this);
            var lead_id = btn.data('leadid');
            var status_field = $('#status-' + lead_id);
            var bid_field = $("#bid-" + lead_id);
            status_field.html('Placing bid...');
            status_field.removeClass('text-danger');
            status_field.removeClass('text-success');

            if (window['leadtimers-' + lead_id]) 
                clearInterval(window['leadtimers-' + lead_id]);

            btn.addClass('disabled');
            $.ajax({
                url: "/bids",
                type: "POST",
                cache: false,
                async: true,
                data: { lead_id: lead_id, bid: bid_field.val() },
                error: function(xhr, status, error) {
                
                    var err = xhr.responseText;
                    if (xhr.status == '500') 
                        err = 'Server error';

                    status_field.html(err || "Unknown error");
                    status_field.addClass('text-danger');
                    btn.removeClass('disabled');
                }
            });
        });

        $('td.ext').click(function(){
            $(this).hide();
            $(this).next().show();
        });
    });
});

$.fn.countdown = function (duration) {
    // Get reference to container, and set initial content
    var container = $(this[0]);//.html(mm + ":" + ss);
    // Get reference to the interval doing the countdown

    function refresh_time(duration) {
            var mm = Math.floor(Math.floor(duration) / 60) + "";
            var ss = Math.ceil(Math.floor(duration) % 60) + "";

            if (mm.length < 2) { mm = "0" + mm; }
            if (ss.length < 2) { ss = "0" + ss; }
            container.html(mm + ":" + ss);

    }

    refresh_time(duration);

    clearInterval(container.data('timer'));
    container.data('timer', setInterval(function () {
        // If seconds remain
        if (--duration > 0) {
            refresh_time(duration);
        // Otherwise
        } else {
            // Clear the countdown interval
            clearInterval(container.data('timer'));
        }
    // Run interval every 1000ms (1 second)
    }, 1000));

};