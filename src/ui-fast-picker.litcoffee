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
        items = @querySelectorAll('ui-fast-picker-item:not([clone])')
        _.each items, (item) =>
          item.style.width = "#{@radius}px"

      startangleChanged: -> @layout()

      endangleChanged: -> @layout()

##Methods
### setup
Mainly an internal method that gets called once when DOM nodes
are attached or when childMutated events happen

      setup: ->
        @toggled = false
        @startangle ||= 0
        @endangle ||= 360

If we do not have a selected item then use the first child

        unless @querySelector '[selected]'
          first = @querySelector('ui-fast-picker-item:not([clone])')
          first.setAttribute 'selected', '' if first
          @select first if first

        selected = @querySelector '[selected]'

        @close()

For this to work as an inline element we need to line up the inner items
with the shadowRoot clone item. We use the first item as the basis for computation

        items = @querySelectorAll('ui-fast-picker-item:not([clone])')
        selected = @querySelector 'ui-fast-picker-item[clone]'
        width = selected?.offsetWidth || 0
        first = items[0]
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
Will close the picker, hide everything except the selected clone.

      close: ->
        items = @querySelectorAll('ui-fast-picker-item:not([clone])')
        _.each items, (i) =>
          i.setAttribute('hide', '')
        @querySelector('ui-fast-picker-item[clone]')?.removeAttribute 'active'

        background = @shadowRoot.querySelector 'background'
        background.setAttribute 'hide', ''

### open
Opens up the picker, shows all selectable items.

      open: ->
        items = @querySelectorAll('ui-fast-picker-item:not([clone])')
        _.each items, (i) =>
          i.removeAttribute 'hide'
        @querySelector('ui-fast-picker-item[clone]')?.setAttribute 'active', ''

        background = @shadowRoot.querySelector 'background'
        background.removeAttribute 'hide'
        @layout()

###toggle
Toggles the picker

      toggle: ->
        @toggled = !@toggled
        if @toggled
          @open()
        else
          @close()

### select(node)
Provide it a DOM element to select programatically.  Alternatively,
you can set the ```selected``` attribute on an item and it will call this for you.

      select: (node) ->
        @selected = node.value

We clone the selected node and put it into the element. This makes selecting
the actualy nodes easier and isolates the item. All styling and control specific
attributes are stripped.

        existingClone = @querySelector 'ui-fast-picker-item[clone]'

If we selected the existing clone selection, then it is a center click and
it is time to toggle to pick another value. Otherwise, a new value was picked.

        if existingClone is node
          @toggle()
        else
          @removeChild existingClone if existingClone
          clone = node.cloneNode(true)
          clone.removeAttribute 'hide'
          clone.removeAttribute 'selected'
          clone.removeAttribute 'style'
          clone.setAttribute 'clone', ''

We transform each child with a counter rotation in ```layout```, so we must reverse this here

          _.each clone.children, (child) ->
            child.removeAttribute 'style'
            clone.removeAttribute 'hide'
          @appendChild clone

Make the container ```ui-fast-picker``` the size of it's shadow root

          rect = clone.getBoundingClientRect()
          @style.width = "#{rect.width}px"
          @style.height = "#{rect.height}px"

      positionBackground: (against) ->
        background = @shadowRoot.querySelector 'background'
        background.style.width = "#{2*@radius}px"
        background.style.height = "#{2*@radius}px"
        styleDef = window.getComputedStyle(background, null)
        if styleDef
          w = Number styleDef.getPropertyValue('width').replace('px','')
          h = Number styleDef.getPropertyValue('height').replace('px','')
          background.style.left = "-#{(w/2) - (against.offsetWidth / 2)}px"
          background.style.top = "-#{(h/2) - (against.offsetHeight / 2)}px"

###layout
Layout is going to be called every time we show the item picker

      layout: ->

        items = @querySelectorAll('ui-fast-picker-item:not([clone])')
        numItems = items.length        
        totalAngle = Math.abs(Number(@startangle) - Number(@endangle))        

        numItems -= 1 if totalAngle < 360

        deg = totalAngle / numItems
        offsetAngle = Number(@startangle)

        clone = @querySelector 'ui-fast-picker-item[clone]'
        width = clone?.offsetWidth || 0

If there is no default radius set we make it 2.5 times the width
of the clone offset width then kick off ```radiusChanged```
and set the initial state to closed

        @radius ||= clone?.offsetWidth * 2.5

Here apply our rotations to each item and it's children.
The children are rotated inreverse so they are always right side up.

        _.each items, (item, index) =>
          item.setAttribute 'animate',
          item.style.left = "#{(width / 2)}px"
          item.style.webkitTransform = "rotate(#{(deg * index) + offsetAngle}deg) "
          item.style.zIndex = items.length - index

          _.each item.children, (child) =>
            child.style.webkitTransform = "rotate(-#{(deg * index) + offsetAngle}deg)"

Translate the backgrounds center point to be the center point of our clone

        @positionBackground(clone) if clone

##Event Handlers
### observeChildren
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