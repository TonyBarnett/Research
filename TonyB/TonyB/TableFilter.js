// Change the icons on columns that are filtered.
window.addEvent('domready', function () {
    var url = document.location.href;

    // Filtering matches.
    var fre = new RegExp('TableFilter(\\d+)-(\\d+)=(\\w){2}', 'g');
    fm = fre.exec(url)
    while (fm != null) {
        $('Table' + fm[1] + 'Column' + fm[2]).set('src', 'https://static.uk-plc.net/ukplc/images/filtered.png');
        fm = fre.exec(url);
    }

    // Sorting matches.
    var sre = new RegExp('TableSort(\\d+)=(\\d+)(\\w)');
    sm = url.match(sre) // What if there are 0 or 2 or more matches? E.g., for different tables.

    if (sm != null && sm.length == 4) {
        var fs = 'TableFilter' + sm[1] + '-' + sm[2] + '=';
        if (sm[3] == 'A' && url.indexOf(fs) > 0) {
            // Ascending and filtered
            $('Table' + sm[1] + 'Column' + sm[2]).set('src', 'https://static.uk-plc.net/ukplc/images/filteredAscending.png');
        }
        else if (sm[3] == 'A')
        {
            // Ascending and not filtered
            $('Table' + sm[1] + 'Column' + sm[2]).set('src', 'https://static.uk-plc.net/ukplc/images/filterSortedAscending.png');
        }
        else if (sm[3] == 'Z' && url.indexOf(fs) > 0) {
            // Descending and filtered
            $('Table' + sm[1] + 'Column' + sm[2]).set('src', 'https://static.uk-plc.net/ukplc/images/filteredDescending.png');
        }
        else if (sm[3] == 'Z') {
            // Descending and not filtered
            $('Table' + sm[1] + 'Column' + sm[2]).set('src', 'https://static.uk-plc.net/ukplc/images/filterSortedDescending.png');
        }
    }
});

// Plumb in the click on the icon.
// Show the box and set the URLs.
window.addEvent('domready', function () {
    $$('img.tableFilter').each(function (cell) {
        cell.addEvent('click', function (event) {
            var id = cell.get('id'); // TableNColumnM
            var m = id.match(/Table(\d+)Column(\d+)/)
            var tableId = m[1];
            var columnIndex = m[2];

            // Remove any existing table filtering parameters from this table. We support sorting only by one column.
            var url = urlNoSort = document.location.href.split('#')[0];

            var re = new RegExp('TableSort' + tableId + '=(\\d+)(\\w)?&?');
            m = re.exec(urlNoSort);
            if (m != null && m.length == 3) {
                // Remove the sort parameter.
                urlNoSort = urlNoSort.replace(re, '');
                // we want to know these so we know whether to apply a new sort or not.
                var sortColumn = m[1];
                var sortType = m[2];
            }
            if (urlNoSort.match(/&$/)) { // Remove the ampersand at the end of the url-TableSort if required.
                urlNoSort = urlNoSort.substring(0, urlNoSort.length - 1);
            }

            // Make links.
            // The sorting text depends on the data type, as do the filtering options.
            var type = cell.get('class').substring(12);
            var elts = [];

            // Is there a filter on this column?
            re = RegExp('TableFilter' + tableId + '-' + columnIndex + '=(\\w{2})');
            m = re.exec(urlNoSort);
            var f = '';
            if (m != null && m.length == 2) {
                f = m[1];
            }

            removeDatePicker('TableFilterFormText1');
            removeDatePicker('TableFilterFormText2');
            if (type == 'Number' || type == 'Currency') {
                $('TableFilterUp').getElement('span').set('html', 'Sort smallest to largest');
                $('TableFilterDown').getElement('span').set('html', 'Sort largest to smallest');
                elts.push("<p class=\"filter" + (f == 'EQ' ? 'ed' : '') + "\"><a href=\"EQ-" + tableId + "-" + columnIndex + "\">Equals...</a></p>");
                elts.push("<p class=\"filter" + (f == 'NE' ? 'ed' : '') + "\"><a href=\"NE-" + tableId + "-" + columnIndex + "\">Does not equal...</a></p>");
                elts.push("<p class=\"filter" + (f == 'GT' ? 'ed' : '') + "\"><a href=\"GT-" + tableId + "-" + columnIndex + "\">Greater than...</a></p>");
                elts.push("<p class=\"filter" + (f == 'GE' ? 'ed' : '') + "\"><a href=\"GE-" + tableId + "-" + columnIndex + "\">Greater than or equal to...</a></p>");
                elts.push("<p class=\"filter" + (f == 'LT' ? 'ed' : '') + "\"><a href=\"LT-" + tableId + "-" + columnIndex + "\">Less than...</a></p>");
                elts.push("<p class=\"filter" + (f == 'LE' ? 'ed' : '') + "\"><a href=\"LE-" + tableId + "-" + columnIndex + "\">Less than or equal to...</a></p>");
            }
            else if (type == 'Date' || type == 'Date Time') {
                $('TableFilterUp').getElement('span').set('html', 'Sort oldest to newest');
                $('TableFilterDown').getElement('span').set('html', 'Sort newest to oldest');

                elts.push("<p class=\"filter" + (f == 'EQ' ? 'ed' : '') + "\"><a href=\"EQ-" + tableId + "-" + columnIndex + "\">Equals...</a></p>");
                elts.push("<p class=\"filter" + (f == 'NE' ? 'ed' : '') + "\"><a href=\"NE-" + tableId + "-" + columnIndex + "\">Does not equal...</a></p>");
                elts.push("<p class=\"filter" + (f == 'GT' ? 'ed' : '') + "\"><a href=\"GT-" + tableId + "-" + columnIndex + "\">After...</a></p>");
                elts.push("<p class=\"filter" + (f == 'GE' ? 'ed' : '') + "\"><a href=\"GE-" + tableId + "-" + columnIndex + "\">On or after...</a></p>");
                elts.push("<p class=\"filter" + (f == 'LT' ? 'ed' : '') + "\"><a href=\"LT-" + tableId + "-" + columnIndex + "\">Before...</a></p>");
                elts.push("<p class=\"filter" + (f == 'LE' ? 'ed' : '') + "\"><a href=\"LE-" + tableId + "-" + columnIndex + "\">Before or on...</a></p>");

                if (type == 'Date') {
                    new DatePicker('#TableFilterFormText1', { pickerClass: 'datepicker_vista', yearPicker: true, format: 'd/m/y', inputOutputFormat: 'd/m/Y', allowEmpty: false });
                    new DatePicker('#TableFilterFormText2', { pickerClass: 'datepicker_vista', yearPicker: true, format: 'd/m/y', inputOutputFormat: 'd/m/Y', allowEmpty: true });
                }
                else {
                    new DatePicker('#TableFilterFormText1', { pickerClass: 'datepicker_vista', timePicker: true, format: 'd/m/Y H:i', inputOutputFormat: 'd/m/Y H:i', allowEmpty: false });
                    new DatePicker('#TableFilterFormText2', { pickerClass: 'datepicker_vista', timePicker: true, format: 'd/m/Y H:i', inputOutputFormat: 'd/m/Y H:i', allowEmpty: true });
                }
            }
            else {
                $('TableFilterUp').getElement('span').set('html', 'Sort A to Z');
                $('TableFilterDown').getElement('span').set('html', 'Sort Z to A');
                elts.push("<p class=\"filter" + (f == 'EQ' ? 'ed' : '') + "\"><a href=\"EQ-" + tableId + "-" + columnIndex + "\">Equals...</a></p>");
                elts.push("<p class=\"filter" + (f == 'NE' ? 'ed' : '') + "\"><a href=\"NE-" + tableId + "-" + columnIndex + "\">Does not equal...</a></p>");
                elts.push("<p class=\"filter" + (f == 'BW' ? 'ed' : '') + "\"><a href=\"BW-" + tableId + "-" + columnIndex + "\">Begins with...</a></p>");
                elts.push("<p class=\"filter" + (f == 'EW' ? 'ed' : '') + "\"><a href=\"EW-" + tableId + "-" + columnIndex + "\">Ends with...</a></p>");
                elts.push("<p class=\"filter" + (f == 'CT' ? 'ed' : '') + "\"><a href=\"CT-" + tableId + "-" + columnIndex + "\">Contains...</a></p>");
                elts.push("<p class=\"filter" + (f == 'NC' ? 'ed' : '') + "\"><a href=\"NC-" + tableId + "-" + columnIndex + "\">Does not contain...</a></p>");
            }
            $('TableFilterMenu').set('html', elts.join(''));

            // Plumb in the clicks on the new filter links. (Turtles all the way down.)
            $$('#TableFilterMenu a').addEvent('click', function (e2) {
                e2.stop(); // it's not a real link.

                // Reset the form.
                $('TableFilterFormSelect1').value = '';
                $('TableFilterFormText1').value = '';
                $('TableFilterFormAnd').checked = true;
                $('TableFilterFormSelect2').value = '';
                $('TableFilterFormText2').value = '';

                var xx = this.get('href').split('-'); // filter, tableId, columnIndex
                // Set the hidden field.
                $('TableFilterFormTableColumn').value = xx[1] + '-' + xx[2];

                // Set the value of the first select based on what was clicked.
                $('TableFilterFormSelect1').getElements('option').each(function (o) {
                    if (o.get('value') == xx[0]) {
                        //o.set('selected', 'selected');
                        //o.selected = true;
                        $('TableFilterFormSelect1').value = o.value;
                    }
                });

                // Overwrite the form settings with any existing values.
                //                                                        m1        m2          m4      m5       m6
                var re = RegExp('TableFilter' + xx[1] + '-' + xx[2] + '=(\\w{2})([\\w%+]+)(~(or|and)~(\\w{2})([\\w%+]+))?')
                var m = re.exec(document.location.href);

                // Do we have values in the first pair?
                if (m != null && typeof m[2] != 'undefined' && m[1] == xx[0]) {
                    $('TableFilterFormText1').value = decodeURIComponent(m[2])

                    // Do we have a value in the second pair?
                    // (If we don't have a value in the first pair, then we also don't have a value in the second pair.)
                    if (typeof m[5] != 'undefined' && typeof m[6] != 'undefined') {
                        $('TableFilterFormSelect2').value = decodeURIComponent(m[5]);
                        $('TableFilterFormText2').value = decodeURIComponent(m[6]);
                    }

                    if (typeof m[4] != 'undefined' && m[4] == 'or') {
                        $('TableFilterFormOr').checked = true;
                    }
                }

                // Form submit.
                $('TableFilterFormSubmitButton').addEvent('click', function (ce) {
                    ce.stop(); // don't submit the form.
                    var tc = $('TableFilterFormTableColumn').value.split('-');

                    // Some rather poor value checking.
                    var type = $('Table' + xx[1] + 'Column' + xx[2]).get('class').substring(12);
                    if (type == 'Number' || type == 'Currency') {
                        var digit = /\D/;
                        if (digit.test($('TableFilterFormText1').value)) {
                            $('TableFilterFormText1').set('style', 'background: #ffcccc;');
                            return;
                        }
                    }
                    // Submit the form.
                    var url = tableFilterBaseUrl(document.location.href, tc[0], tc[1]);

                    // if there are no get parameters then prepend with '?' else prepend with '&'
                    var seperator = '?';
                    var qm = new RegExp('\\?');
                    if (qm.test(urlNoSort)) {
                        seperator = '&';
                    }

                    url = url + seperator + 'TableFilter'
                            + $('TableFilterFormTableColumn').value
                            + '='
                            + $('TableFilterFormSelect1').getSelected()[0].value
                            + encodeURIComponent($('TableFilterFormText1').value)

                    if ($('TableFilterFormText2').value != '' && $('TableFilterFormSelect2').value != '') {
                        var operator = $('TableFilterFormAnd').checked ? 'and' : 'or';
                        url = url
                            + '~'
                            + operator
                            + '~'
                            + $('TableFilterFormSelect2').getSelected()[0].value
                            + encodeURIComponent($('TableFilterFormText2').value)
                    }

                    url = url + '#tableBody' + tc[0];
                    window.location.href = url; // could this break if run in a frame?
                });


                // Remove blackout and both divs on the cancel button only,
                // i.e., this dialogue is modal.
                $('body').removeEvents('click');
                $('TableFilterFormCancelButton').addEvent('click', function () {
                    removeBlackout(1);
                    $('TableFilter').set('style', 'display: none;');
                    $('TableFilterForm').set('style', 'display: none;');
                });

                // Show the form.
                var x = e2.client.x;
                var y = e2.client.y;
                if (e2.client.x > window.getSize().x - 350) {
                    x = window.getSize().x - 350;
                }
                if (e2.client.y > window.getSize().y - 200) {
                    y = window.getSize().y - 200;
                }
                $('TableFilterForm').fade(1);
                $('TableFilterForm').set('style', 'display: block; top: ' + y + 'px; left: ' + x + 'px; z-index: 20000;');

                /*
                Now this is a problem.
                The stopPropagation prevents the click on OK.
                // Click outside to cancel.
                $('body').addEvent('click', function () {
                removeBlackout(1);
                $('TableFilter').set('style', 'display: none;');
                $('TableFilterForm').set('style', 'display: none;');
                $('body').removeEvents('click'); // we'd prefer to remove only THIS event.
                });
                $('TableFilterForm').addEvent('click', function (e) {
                e.stopPropagation(); // Otherwise it would propagate to the body and close the window.
                });
                */
            });
            // if there are no get parameters then prepend with '?' else prepend with '&'
            var seperator = '?';
            var qm = new RegExp('\\?');

            if (qm.test(urlNoSort)) {
                if (urlNoSort.charAt(urlNoSort.length - 1) == '?') { // If the url-TableFilter ends in a ? then don't prepend the table 
                    seperator = '';     // with an ampersand (otherwise you get ?&'
                }
                else {
                    seperator = '&';
                }
            }

            var re = new RegExp('TableSort' + tableId + '=(\\d+)\\w?&?')
            var m = re.exec(url)

            // If we have a sort on a different column then we wish to preserve it when clearing the filter from this column.
            if (m != null && m[1] != columnIndex) {
                var urlClear = tableFilterBaseUrl(urlNoSort, tableId, columnIndex) + m[0].toString();
            }
            else { // Otherwise if there are no Get parameters then we want to remove the ? when the table filter is cleared.
                var urlClear = urlNoSort.split('?')[1] == '' ? urlNoSort.substring(0, urlNoSort.length - 1) : urlNoSort;
            }

            // Set the links for sort.
            $('TableFilterUp').set('href', urlNoSort + seperator + 'TableSort' + tableId + '=' + columnIndex + 'A#tableBody' + tableId);
            $('TableFilterDown').set('href', urlNoSort + seperator + 'TableSort' + tableId + '=' + columnIndex + 'Z#tableBody' + tableId);
            $('TableFilterClear').set('href', tableFilterBaseUrl(urlClear, tableId, columnIndex) + '#tableBody' + tableId); // Zero matches \d+ so C# can't parse!

            // Show the window.
            $('TableFilter').fade(1);
            var x = event.client.x;
            var y = event.client.y;
            if (event.client.x > window.getSize().x - 200) {
                x = window.getSize().x - 200;
            }
            if (event.client.y > window.getSize().y - 300) {
                y = window.getSize().y - 300;
            }
            $('TableFilter').set('style', 'display: block; top: ' + y + 'px; left: ' + x + 'px; z-index: 10000;');
            addBlackout(1);

            // Click outside to cancel.
            $('body').addEvent('click', function () {
                removeBlackout(1);
                $('TableFilter').set('style', 'display: none;');
                $('TableFilterForm').set('style', 'display: none;');
                $('body').removeEvents('click'); // we'd prefer to remove only THIS event.
            });
            $('TableFilter').addEvent('click', function (e) {
                e.stopPropagation(); // Otherwise it would propagate to the body and close the window.
            });

            // If a descending sort exists on the column and is reapplied, just get rid of the 
            // box, nothing to do.
            if (sortType != null && sortColumn == columnIndex && sortType == 'Z') {
                $('TableFilterDown').addEvent('click', function (e) {
                    removeBlackout(1);
                    $('TableFilter').set('style', 'display: none;');
                    $('TableFilterForm').set('style', 'display: none;');
                    $('TableFilterDown').removeEvents('click');
                });
            }
            // Else if an ascending sort exists on the column and is reapplied, same as before.
            else if (sortType != null && sortColumn == columnIndex && sortType == 'A') {
                $('TableFilterUp').addEvent('click', function (e) {
                    removeBlackout(1);
                    $('TableFilter').set('style', 'display: none;');
                    $('TableFilterForm').set('style', 'display: none;');
                    $('TableFilterDown').removeEvents('click');
                });
            }
            event.stop(); // Our event is inside body, so event matches it. To stop the above from running we must stop event.
        });
    });
});

// Remove any existing filtering options for the given column from the URL.
function tableFilterBaseUrl(url, tableId, columnIndex) {
    var re = new RegExp('TableFilter' + tableId + '-' + columnIndex + '=[A-Z]{2}[~\\w%+]+&?');
    baseUrl = url.split('#')[0].replace(re, '');
    if (baseUrl.match(/&$/)) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    return baseUrl;
}


function removeDatePicker(id) {
    var e = $(id);
    var f = e.getSiblings('input');

    if (e.retrieve('datepicker') && f != null && f.retrieve('datepicker')) {
        e.set('name', f.get('name'));
        e.erase('style');
        e.eliminate('datepicker');
        f.destroy();
    }
}