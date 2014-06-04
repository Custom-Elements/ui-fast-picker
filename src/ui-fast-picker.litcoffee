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
        items = @querySelectorAll('ui-fast-picker-item')
        _.each items, (item) =>          
          item.style.width = "#{@radius}px"

##Methods
        
      setup: ->
        unless @querySelector '[selected]'
          first = @querySelector('ui-fast-picker-item') 
          first.setAttribute 'selected', '' if first
          @select first if first
        
        selected = @querySelector '[selected]'                
                
        @radius ||= selected.offsetWidth * 2.5
        @radiusChanged()
        @close()        

        items = @querySelectorAll('ui-fast-picker-item')
        selected = @shadowRoot.querySelector 'ui-fast-picker-item'        
        width = selected?.offsetWidth || 0

        _.each items, (item, index) ->                                
          item.style.left = "#{(width / 2)}px"
          item.style.webkitTransformOrigin = "0% 50%"      

        document.addEventListener 'click', (event) =>          
          t = event.target
          @close() if t isnt @

      close: ->
        items = @querySelectorAll('ui-fast-picker-item')      
        _.each items, (i) =>
          i.setAttribute('hide', '')                  

      toggle: ->      
        items = @querySelectorAll('ui-fast-picker-item')
        @toggled = !@toggled

        clone = @shadowRoot.querySelector 'ui-fast-picker-item'
        clone.setAttribute 'active', '' if @toggled
        clone.removeAttribute 'active' unless @toggled

        _.each items, (i) =>
          i.removeAttribute('hide') if @toggled
          i.setAttribute('hide', '') unless @toggled
          return true
                
        @layout()  

      select: (node) ->                    
        @selected = node.value
                        
        existingClone = @shadowRoot.querySelector 'ui-fast-picker-item'
        @shadowRoot.removeChild existingClone if existingClone
        
        clone = node.cloneNode(true)
        clone.removeAttribute 'hide'
        clone.removeAttribute 'selected'
        clone.removeAttribute 'style'
        clone.setAttribute 'clone', ''
        
        _.each clone.children, (child) ->
          child.removeAttribute 'style'

        @shadowRoot.appendChild clone

Make the container 'ui-fast-picker' the size of it's shadow root

        rect = clone.getBoundingClientRect()            
        @style.width = "#{rect.width}px"
        @style.height = "#{rect.height}px"       

###layout
Layout is going to be called every time we show the item picker

      layout: ->
        items = @querySelectorAll('ui-fast-picker-item')
        numItems = items.length
        rad = (2 * Math.PI) / numItems

        selected = @shadowRoot.querySelector 'ui-fast-picker-item'        
        width = selected?.offsetWidth || 0
        
For this to work as an inline element we need to line up the inner items
We use the first item as the basis for computation
        
        first = @querySelector 'ui-fast-picker-item'
        styleDef = window.getComputedStyle(first, null)
        
        if styleDef
          topPadding = styleDef.getPropertyValue 'padding-top'
          topBorder = styleDef.getPropertyValue 'border-top-width'          
          offset = Number(topBorder.replace('px', '')) + Number(topPadding.replace('px', ''))

        _.each items, (item, index) ->                                                            
          item.setAttribute 'animate',
          item.style.left = "#{(width / 2)}px"
          item.style.top = "-#{offset}px"
          item.style.webkitTransform = "rotate(#{rad * index}rad) "  
          item.style.zIndex = items.length - index         

          _.each item.children, (child) ->
            child.style.webkitTransform = "rotate(-#{rad * index}rad)"

##Event Handlers
      
      observeChildren: (fn) ->        
        fn.bind(@)()
        @onMutation @, =>
          @observeChildren(fn)

      selectHandler: (event) ->        
        @select event.target       

##Polymer Lifecycle
### attached
We setup the defaults here, have to wait for the children to be mutated and then setup
the selected item and the radius

      attached: ->                
        @observeChildren @setup
        @setup()

      detached: ->    
        document.removeEventListener 'click'