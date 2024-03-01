// ==UserScript==
// @name         Archipelago SA2B Instant Launch Linker
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Add an instant launch command for SA2B AP games to be used with the URL handler program.
// @author       CheatFreak
// @match        https://archipelago.gg/room/*
// @grant        none
// @require      https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js
// ==/UserScript==

(function() {
    'use strict';

    // Wait for the page to fully load
    $(document).ready(function() {
        // Find the specific <tr> elements
        $('tr').each(function() {
            // Check if the <tr> contains "Sonic Adventure 2 Battle" in the third <td>
            var game = $(this).find('td:nth-child(3)').text().trim();
            if (game === 'Sonic Adventure 2 Battle') {
                // Check if the <tr> contains a <td> with the specific text
                var td = $(this).find('td:contains("No file to download for this game.")');
                if (td.length > 0) {
                    // Find the <a> element with the archipelago protocol within the same <tr>
                    var link = $(this).find('a[href^="archipelago://"]');
                    if (link.length > 0) {
                        // Replace the protocol in the href attribute
                        var href = link.attr('href').replace('archipelago://', 'apsa2b://');
                        // Replace the <td> contents with the new link
                        td.html('<a href="' + href + '">Launch SA2B Game</a>');
                    }
                }
            }
        });
    });
})();