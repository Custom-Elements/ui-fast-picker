#ui-fast-picker-item
A single item in the radial menu, you can put any content inside this you like.

This is really useful for flags and status indicators, and is a fun alternative
to the boring old dropdown box.

Check out the [demo](demo.html)

    Polymer 'ui-fast-picker-item',

##Events
###toggle
This gets fired when you click on the center currently selected item, and
signals that it is time to coffle the menu open.

##Attributes and Change Handlers
###


##Methods

      getParent: (node) ->
        parent = node.parentNode
        while parent.tagName isnt 'UI-FAST-PICKER-ITEM'
          parent = node.parentNode
        return parent

##Event Handlers

      clickHandler: (event) ->
        item = event.target
        item = @getParent(event.target) if item.tagName isnt 'UI-FAST-PICKER-ITEM'
        @fire 'toggle' if item.hasAttribute 'selected-display'

##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->

      domReady: ->

      detached: ->

