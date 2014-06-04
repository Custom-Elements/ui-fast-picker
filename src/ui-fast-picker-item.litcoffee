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
###select
This gets fired when you click on a radial, outside item passing the `value`
as the detail.

##Attributes and Change Handlers
###value
This is the data binding value shared with the containing `ui-fast-picker`.

##Methods

      getParent: (node) ->
        parent = node.parentNode
        while parent.tagName isnt 'UI-FAST-PICKER-ITEM'
          parent = node.parentNode
        return parent

      valueChanged: (oldVal, newVal) ->
        console.log newVal

      selectedChanged: (oldVal, newVal) ->
        @fire 'select', @value if @hasAttribute 'selected'
        

##Event Handlers

      clickHandler: (event) ->
        item = event.target
        item = @getParent(event.target) if item.tagName isnt 'UI-FAST-PICKER-ITEM'        
        @fire 'select', @value unless item.hasAttribute 'selected-display'
        @fire 'toggle'

##Polymer Lifecycle

      created: ->

      ready: ->

      attached: ->        

      domReady: ->

      detached: ->

