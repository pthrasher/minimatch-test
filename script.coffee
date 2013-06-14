minimatch = require 'minimatch'

$ ->
    input = $ '#minimatch'
    source = $ '#source'
    results = $ '.right'
    matches = $ '.matches', results
    filter = $ '#filter'

    processMatches = _.debounce ->
        matched = []
        val = input.val()
        ul = $ '<ul><li>0 matches</li></ul>'
        unless val is ''
            for line in source.val().split('\n')
                if minimatch(line, val)
                    matched.push line

            if matched.length
                ul = $ '<ul></ul>'
                for match in matched
                    ul.append "<li>#{match}</li>"
            else
                ul = $ '<ul><li>0 matches</li></ul>'
        matches.html ul
        true
    , 150

    filterMatches = _.debounce ->
        filterText = filter.val()
        lis = matches.find('li')
        if filterText is ''
            $(lis).show()
            return
        filterRe = new RegExp "#{filterText}", 'gi'
        toHide = []
        toShow = []
        for li in lis
            contents = $(li).html()
            if filterRe.test contents
                toShow.push li
            else
                toHide.push li
        $(toShow).show()
        $(toHide).hide()
    , 150

    input.on 'keyup', processMatches
    source.on 'keyup', processMatches
    filter.on 'keyup', filterMatches


    $window = $ window
    $window.resize(->
        wW = $window.width()
        wH = $window.height()

        inputHeight = input.height() + 4
        input.width wW - 24

        source.width Math.floor(wW / 2) - 27
        source.height wH - 72 - inputHeight

        results.width Math.floor(wW / 2) - 17
        results.height wH - 62 - inputHeight
        true
    ).resize()

    processMatches()
    filterMatches()
