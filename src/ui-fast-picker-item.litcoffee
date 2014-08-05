#ui-fast-picker-item
A single item in the radial menu, you can put any content inside this you like.

    Polymer 'ui-fast-picker-item',

##Methods

##Event Handlers
### clickHandler
Clicking fires off `select` as an event, time to have a new value in the
containing control!

      clickHandler: (event) ->
        if not @hasAttribute 'clone'
          event.stopPropagation()
          @fire 'select'

      pointerdown: ->
        @$.button.setAttribute 'pressed', ''
      pointerup: ->
        @$.button.removeAttribute 'pressed'

##Polymer Lifecycle

      publish:
        value:
          reflect: true
