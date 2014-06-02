#ui-fast-picker
*TODO* tell me all about your element.
    
    _ = require "lodash"
    
    Polymer 'ui-fast-picker',

##Events
*TODO* describe the custom event `name` and `detail` that are fired.

##Attributes and Change Handlers
### value  
value of the selected item, this is the one you would
want to databind

      valueChanged: (oldVal, newVal) ->
        if newVal isnt oldVal
          items = @querySelectorAll("ui-fast-picker-item")
          _.each items, (i) ->
            i.removeAttribute 'selected' 

          match = @querySelector("ui-fast-picker-item[value='#{newVal}']")
          match.setAttribute 'selected', ''
          
          existingNode = @querySelector('[selected-display]')
          @removeChild @querySelector('[selected-display]') if existingNode

          clone = match.cloneNode(true)          
          clone.setAttribute 'selected-display', ''          
          @appendChild clone

##Methods

##Event Handlers

##Polymer Lifecycle

      created: ->
        console.log 'what'

      ready: ->

      attached: ->

      domReady: ->

      detached: ->
