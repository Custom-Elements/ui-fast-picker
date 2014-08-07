#ui-fast-picker
A fast picker is a radial menu alternative to a boring old drop down.

This is really useful for flags and status indicators, and is a fun alternative
to the boring old dropdown box.

Check out the [demo](demo.html)


    _ = require "lodash"

    Polymer 'ui-fast-picker',

##Events
###change
Fired when `value` changes.

##Attributes and Change Handlers
### radius
Update the widths of all our children.

      radiusChanged: ->
        items = @querySelectorAll('ui-fast-picker-item:not([clone])')
        _.each items, (item) =>
          item.style.width = "#{@radius}px"

###startangle
Offset your layout.

###endangle
Use this to limit your layout. Think pie menus.

###value
This is the model value that is currently selected.

      valueChanged: (oldValue, newValue) ->
        @select @querySelector "[value='#{@value}']"
        if oldValue? and newValue? and oldValue isnt newValue
          @fire 'change', @value

##Methods

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
        @layout =>
          items = @querySelectorAll('ui-fast-picker-item:not([clone])')
          _.each items, (i) =>
            i.removeAttribute 'hide'
          @querySelector('ui-fast-picker-item[clone]')?.setAttribute 'active', ''

          background = @shadowRoot.querySelector 'background'
          background.removeAttribute 'hide'

###toggle
Toggles the picker

      toggle: ->
        background = @shadowRoot.querySelector 'background'
        if background.hasAttribute 'hide'
          @open()
        else
          @close()

### select
Provide it a DOM element to select programatically.  Alternatively,
you can set the `value` attribute on an item and it will call this for you.
Set the `value` :).

      select: (node) ->
        return if not node
        @value = node.value

We clone the selected node and put it into the element. This makes selecting
the actualy nodes easier and isolates the item. All styling and control specific
attributes are stripped.

        existingClone = @querySelector 'ui-fast-picker-item[clone]'

If we selected the existing clone selection, then it is a center click and
it is time to toggle to pick another value. Otherwise, a new value was picked.

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
        @close()

###positionBackgroud
The colored region behind the clone to provide contrast with
the rest of the page.

      positionBackground: (against) ->
        background = @shadowRoot.querySelector 'background'
        background.style.width = "#{2*@radius}px"
        background.style.height = "#{2*@radius}px"
        styleDef = window.getComputedStyle(background, null)
        if styleDef
          w = Number styleDef.getPropertyValue('width').replace('px','')
          h = Number styleDef.getPropertyValue('height').replace('px','')
          background.style.left = "-#{(w / 2) - (against.offsetWidth / 2)}px"
          background.style.top = "-#{(h / 2) - (against.offsetHeight / 2)}px"

###layout
Layout is going to be called every time we show the item picker

      layout: (after) ->
        @job 'layout', =>
          items = @querySelectorAll('ui-fast-picker-item:not([clone])')
          numItems = items.length
          return if not numItems

          clone = @querySelector 'ui-fast-picker-item[clone]'
          first = items[0]
          styleDef = window.getComputedStyle(first, null)
          itemWidth = clone?.offsetWidth || 0
          topPadding = styleDef.getPropertyValue 'padding-top'
          topBorder = styleDef.getPropertyValue 'border-top-width'
          itemOffset = Number(topBorder.replace('px', '')) + Number(topPadding.replace('px', ''))
          totalAngle = Math.abs(Number(@startangle) - Number(@endangle))

          numItems -= 1 if totalAngle < 360

          deg = totalAngle / numItems
          offsetAngle = Number(@startangle)

If there is no default radius set we make it 2.5 times the width
of the clone offset width then kick off ```radiusChanged```
and set the initial state to closed

          @radius ||= clone?.offsetWidth * 2.5

Here apply our rotations to each item and its children.
The children are rotated inreverse so they are always right side up.

          _.each items, (item, index) =>
            item.setAttribute 'animate', ''
            item.style.top = "-#{itemOffset}px"
            item.style.left = "#{(itemWidth / 2)}px"
            item.style.webkitTransformOrigin = "0% 50%"
            item.style.webkitTransform = "rotate(#{(deg * index) + offsetAngle}deg) "
            item.style.zIndex = items.length - index

            _.each item.children, (child) =>
              child.style.webkitTransform = "rotate(-#{(deg * index) + offsetAngle}deg)"

Translate the backgrounds center point to be the center point of our clone

          @positionBackground(clone) if clone
          after()
        , 20

##Event Handlers
### observeChildren
This will any function and run it withing the context of out element when
the children are mutated.  It reschedules the event again if the function call returns true.

      observeChildren: (fn) ->
        fn.bind(@)()
        @onMutation @, (tater, changes) =>
          for change in changes
            for node in change.addedNodes
              if node.tagName is "UI-FAST-PICKER-ITEM" and not node.hasAttribute 'clone'
                console.log 'mutey'
                fn()
          @observeChildren(fn)

### selectHandler
Internally used to handled select events from children

      selectHandler: (event) ->
        @select event.target
        event.stopPropagation()

      clickHandler: ->
        @toggle()

##Polymer Lifecycle
### attached
We setup the defaults here, have to wait for the children to be mutated and then setup
the selected item and the radius

      publish:
        value:
          reflect: true

Set up to listen for new children, and take the opportunity to set
the value as a new child matching that value can show up asynchronously
via data binding.

      ready: ->
        @startangle ||= 0
        @endangle ||= 360
        @observeChildren =>
          @valueChanged()
