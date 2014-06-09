#ui-fast-picker-item
A single item in the radial menu, you can put any content inside this you like.

    Polymer 'ui-fast-picker-item',

##Methods
### selectedChanged
Watches the selected attributes and delegates up to the parent to
properly switch out it's shadow root

      selectedChanged: (oldVal, newVal) ->
        @fire 'select', @value if @hasAttribute 'selected'

##Event Handlers
### clickHandler
Clicking fires off `select` as an event, time to have a new value in the
containing control!

      clickHandler: (event) ->
        @fire 'select'

      pointerdown: ->
        @$.button.setAttribute 'pressed', ''
      pointerup: ->
        @$.button.removeAttribute 'pressed'
