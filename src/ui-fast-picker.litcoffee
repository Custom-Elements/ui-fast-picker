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

          @layout()

##Methods

###layout
Layout is going to be called every time we show the item picker

      layout: ->
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        console.log items
        numItems = items.length

        console.log items
        
        maxHeight = _.reduce items, (acc, i) ->           
          Math.max(acc,i.offsetHeight)
        , 0
        
        maxWidth = _.reduce items, (acc, i) -> 
          Math.max(acc,i.offsetWidth)
        , 0

        radius = Math.max(maxWidth,maxHeight) * 1.5

        rad = (2 * Math.PI) / numItems

        console.log rad, radius

        _.each items, (item, index) ->
          item.style.top = "#{radius * Math.sin(rad * index)}px"
          item.style.left = "#{radius * Math.cos(rad * index)}px"


##Event Handlers

##Polymer Lifecycle

      created: ->
        
        

      ready: ->

      attached: ->        

      domReady: ->


      detached: ->


