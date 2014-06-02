#ui-fast-picker-item
*TODO* tell me all about your element.
    
    Polymer 'ui-fast-picker-item',

##Events
*TODO* describe the custom event `name` and `detail` that are fired.

##Attributes and Change Handlers

##Methods

      getParent: (node) ->
        parent = node.parentNode
        while parent.tagName isnt 'UI-FAST-PICKER-ITEM'
          parent = node.parentNode
        return parent

##Event Handlers

      clickHandler: (event) ->
        parent = @getParent(event.target)
        @fire 'open' if parent.hasAttribute 'selected-display'
          
##Polymer Lifecycle

      created: ->
        
      ready: ->

      attached: ->

      domReady: ->

      detached: ->      

