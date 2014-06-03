#ui-fast-picker
A fast picker is a radial menu alternative to a boring old drop down.

    _ = require "lodash"

    Polymer 'ui-fast-picker',

##Events

##Attributes and Change Handlers
### value
Currently selected value, this is the one you want to bind to a model. Setting
this will visually change to another `ui-fast-picker-item` by matching its
`value`.

      valueChanged: (oldVal, newVal) ->
        if newVal isnt oldVal
          items = @querySelectorAll("ui-fast-picker-item")
          _.each items, (i) ->
            i.removeAttribute 'selected'
            i.setAttribute 'hide', ''

          match = @querySelector("ui-fast-picker-item[value='#{newVal}']")
          match.setAttribute 'selected', ''

          existingNode = @querySelector('[selected-display]')
          @removeChild @querySelector('[selected-display]') if existingNode

          clone = match.cloneNode(true)
          clone.setAttribute 'selected-display', ''
          clone.style.width = 'auto'
          clone.style.left = '0'
          clone.style.webkitTransform = 'none'
          clone.style.webkitTransformOrigin = 'none'
          _.each clone.children, (child) ->
            child.style.webkitTransform = "none"

          @appendChild clone

          clone.removeAttribute 'hide'

      radiusChanged: (oldVal,newVal)->
        console.log 'compute'
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        _.each items, (item) ->
          item.style.width = "#{newVal}px"

##Methods

      toggle: ->
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        @toggled = !@toggled

        _.each items, (i) =>
          i.removeAttribute('hide') if @toggled
          i.setAttribute('hide', '') unless @toggled
          return true

        @layout()

      select: (event) ->
        @value = event.detail
        @toggle()


###layout
Layout is going to be called every time we show the item picker

      layout: ->
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        numItems = items.length
        rad = (2 * Math.PI) / numItems

        selected = @querySelector '[selected-display]'
        w = selected.offsetWidth

        _.each items, (item, index) ->
          item.style.left = "#{(w / 2)}px"
          item.style.webkitTransform = "rotate(#{rad * index}rad) "
          item.style.webkitTransformOrigin = "0% 50%"

          _.each item.children, (child) ->
            child.style.webkitTransform = "rotate(-#{rad * index}rad)"

##Event Handlers

##Polymer Lifecycle

      created: ->
        @toggled = false

      ready: ->

      attached: ->

      domReady: ->
        selected = @querySelector '[selected-display]'
        @radius ||= selected.offsetWidth * 2.5

      detached: ->
