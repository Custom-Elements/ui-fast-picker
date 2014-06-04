This is really useful for flags and status indicators, and is a fun alternative
to the boring old dropdown box.

Check out the [demo](demo.html)

----

#ui-fast-picker
A fast picker is a radial menu alternative to a boring old drop down.

    _ = require "lodash"

    Polymer 'ui-fast-picker',

##Events

##Attributes and Change Handlers
### radiusChanged
Update the widths of all our children when the radius changes

      radiusChanged: ->                
        items = @querySelectorAll('ui-fast-picker-item')
        _.each items, (item) =>          
          item.style.width = "#{@radius}px"

##Methods
### setup
Mainly an internal method that gets called once when DOM nodes
are attached or when childMutated events happen

      setup: ->
        @toggled = false

If we do not have a selected item then use the first child

        unless @querySelector '[selected]'
          first = @querySelector('ui-fast-picker-item') 
          first.setAttribute 'selected', '' if first
          @select first if first
        
        selected = @querySelector '[selected]'    

If there is no default radius set we make it 2.5 times the width
of the first childs offset width then kick off ```radiusChanged```
and set the initial state to closed

        @radius ||= selected.offsetWidth * 2.5
        @radiusChanged()
        @close()          

For this to work as an inline element we need to line up the inner items
with the shadowRoot clone item. We use the first item as the basis for computation

        items = @querySelectorAll('ui-fast-picker-item')
        selected = @shadowRoot.querySelector 'ui-fast-picker-item'        
        width = selected?.offsetWidth || 0        
        first = @querySelector 'ui-fast-picker-item'
        styleDef = window.getComputedStyle(first, null)
                
        if styleDef
          topPadding = styleDef.getPropertyValue 'padding-top'
          topBorder = styleDef.getPropertyValue 'border-top-width'          
          offset = Number(topBorder.replace('px', '')) + Number(topPadding.replace('px', ''))

        _.each items, (item, index) ->                                
          item.style.left = "#{(width / 2)}px"
          item.style.webkitTransformOrigin = "0% 50%"  
          item.style.top = "-#{offset}px"    

        document.addEventListener 'click', (event) =>          
          t = event.target
          @close() if t isnt @

### close
Will close the picker

      close: ->
        items = @querySelectorAll('ui-fast-picker-item')      
        _.each items, (i) =>
          i.setAttribute('hide', '')  

        background = @shadowRoot.querySelector 'background'
        background.setAttribute 'hide', ''

###toggle
Toggles the picker 

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

        background = @shadowRoot.querySelector 'background'
        background.setAttribute 'hide', '' unless @toggled
        background.removeAttribute 'hide' if @toggled
                
        @layout()  

### select(node)
Provide it a DOM element to select programatically.  Alternatively,
you can set the ```selected``` attribute on an item and it will call this for you.

      select: (node) ->                    
        @selected = node.value

We clone the selected node and put it into the shadow root. This makes selecting
the actualy nodes easier and isolates the item. All styling and control specific 
attributes are stripped.

        existingClone = @shadowRoot.querySelector 'ui-fast-picker-item'
        @shadowRoot.removeChild existingClone if existingClone
        
        clone = node.cloneNode(true)
        clone.removeAttribute 'hide'
        clone.removeAttribute 'selected'
        clone.removeAttribute 'style'
        clone.setAttribute 'clone', ''

We transform each child with a counter rotation in ```layout```, so we must reverse this here

        _.each clone.children, (child) ->
          child.removeAttribute 'style'

        @shadowRoot.appendChild clone

Make the container ````ui-fast-picker``` the size of it's shadow root

        rect = clone.getBoundingClientRect()            
        @style.width = "#{rect.width}px"
        @style.height = "#{rect.height}px"  

      positionBackground: (against) ->
        background = @shadowRoot.querySelector 'background'        
        styleDef = window.getComputedStyle(background, null)        
        if styleDef
          w = Number styleDef.getPropertyValue('width').replace('px','')
          h = Number styleDef.getPropertyValue('height').replace('px','')          
          background.style.left = "-#{(w/2) - (against.offsetWidth / 2)}px"
          background.style.top = "-#{(h/2) - (against.offsetHeight / 2)}px"     

###layout
Layout is going to be called every time we show the item picker

      layout: ->
        items = @querySelectorAll('ui-fast-picker-item')
        numItems = items.length
        rad = (2 * Math.PI) / numItems

        clone = @shadowRoot.querySelector 'ui-fast-picker-item'        
        width = clone?.offsetWidth || 0

Here apply our rotations to each item and it's children.  
The children are rotated inreverse so they are always right side up.

        _.each items, (item, index) ->                                                            
          item.setAttribute 'animate',   
          item.style.left = "#{(width / 2)}px"       
          item.style.webkitTransform = "rotate(#{rad * index}rad) "  
          item.style.zIndex = items.length - index         

          _.each item.children, (child) ->
            child.style.webkitTransform = "rotate(-#{rad * index}rad)"

Translate the backgrounds center point to be the center point of our clone
                
        @positionBackground(clone)

##Event Handlers
### observerChildren
This will any function and run it withing the context of out element when 
the children are mutated.  It reschedules the event again.

      observeChildren: (fn) ->        
        fn.bind(@)()
        @onMutation @, =>
          @observeChildren(fn)

### selectHandler
Internally used to handled select events from children

      selectHandler: (event) ->        
        @select event.target       

##Polymer Lifecycle
### attached
We setup the defaults here, have to wait for the children to be mutated and then setup
the selected item and the radius

      attached: ->                
        @observeChildren @setup
        @setup()

### detached
Clean up any global event listeners

      detached: ->    
        document.removeEventListener 'click'