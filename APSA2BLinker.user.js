// ==UserScript==
// @name         Archipelago SA2B Linker
// @namespace    http://tampermonkey.net/
// @version      1.4
// @description  Add an apsa2b:// URL to be used with the URL handler program.
// @author       CheatFreak
// @match        https://archipelago.gg/room/*
// @grant        none
// @require      https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js
// @downloadURL  https://raw.githubusercontent.com/cheatfreak47/apsa2b-linker-handler/main/APSA2BLinker.user.js
// @updateURL    https://raw.githubusercontent.com/cheatfreak47/apsa2b-linker-handler/main/APSA2BLinker.user.js
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
                // Find the <a> element with the archipelago protocol within the same <tr>
                var link = $(this).find('a[href^="archipelago://"]');
                if (link.length > 0) {
                    // Extract the port number from the href attribute
                    var port = link.attr('href').split(':').pop();
                    // Check if the port number is 0
                    if (port === '0') {
                        // Wait 5 seconds before refreshing the page
                        setTimeout(function() {
                            location.reload();
                        }, 3000);
                    } else {
                        // Check if the <tr> contains a <td> with the specific text
                        var td = $(this).find('td:contains("No file to download for this game.")');
                        if (td.length > 0) {
                            // Replace the protocol in the href attribute
                            var href = link.attr('href').replace('archipelago://', 'apsa2b://');
                            // Replace the <td> contents with the new link
                            td.html('<a href="' + href + '">Run SA2B Mod...</a>');
                        }
                    }
                }
            }
        });
    });
})();
