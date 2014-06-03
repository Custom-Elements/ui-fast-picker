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
            i.setAttribute 'hide', ''
            
          match = @querySelector("ui-fast-picker-item[value='#{newVal}']")
          match.setAttribute 'selected', ''
                    
          existingNode = @querySelector('[selected-display]')
          @removeChild @querySelector('[selected-display]') if existingNode

          clone = match.cloneNode(true)          
          clone.setAttribute 'selected-display', ''          
          clone.style.width = 'auto'
          @appendChild clone

          clone.removeAttribute 'hide'          

      radiusChanged: (oldVal,newVal)->         
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

        @layout2()

###layout
Layout is going to be called every time we show the item picker

      layout2: -> 
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        numItems = items.length
        rad = (2 * Math.PI) / numItems

        
        selected = @querySelector '[selected-display]'
        w = selected.offsetWidth;         
        
        _.each items, (item, index) ->
          item.style.left = "#{(w / 2)}px"
          item.style.webkitTransform = "rotate(#{rad * index}rad) "          
          item.style.webkitTransformOrigin = "0% 50%";
          
          _.each item.children, (child) ->             
            child.style.webkitTransform = "rotate(-#{rad * index}rad)"              

##Event Handlers            

##Polymer Lifecycle

      created: ->   
        @toggled = false             

      ready: ->

      attached: ->        

      domReady: ->

      detached: ->


