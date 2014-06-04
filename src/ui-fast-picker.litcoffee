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

      radiusChanged: ->                
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        _.each items, (item) =>          
          item.style.width = "#{@radius}px"

##Methods

      toggle: ->      
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        @toggled = !@toggled

        _.each items, (i) =>
          i.removeAttribute('hide') if @toggled
          i.setAttribute('hide', '') unless @toggled
          return true

        @layout()

      close: ->
        @toggled = false
        items = @querySelectorAll('ui-fast-picker-item:not([selected-display])')
        
        _.each items, (i) => i.setAttribute 'hide', ''

      select: (event) ->  
        console.log      
        selected = event.target
        @selected = selected.value
                
        existingNode = @querySelector('[selected-display]')
        @removeChild @querySelector('[selected-display]') if existingNode
        
        clone = selected.cloneNode(true)
        clone.removeAttribute 'hide'
        clone.removeAttribute 'selected'
        clone.setAttribute 'selected-display', ''
        clone.style.width = 'auto'
        clone.style.left = '0'
        clone.style.webkitTransform = 'none'
        clone.style.webkitTransformOrigin = 'none'
        _.each clone.children, (child) ->
          child.style.webkitTransform = "none"

        @appendChild clone

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
      
      childrenMutated: ->      
        @close()

        unless @querySelector '[selected]'
          first = @querySelector('ui-fast-picker-item')
          first?.setAttribute 'selected', ''

        selected = @querySelector '[selected]'                
        
        @radius ||= selected?.offsetWidth * 2.5
        @radiusChanged()

        @onMutation @, =>
          @childrenMutated()

##Polymer Lifecycle
### attached
We setup the defaults here, have to wait for the children to be mutated and then setup
the selected item and the radius

      attached: ->        
        @onMutation @, =>
          console.log 'sadfhas'
          @childrenMutated()
