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
Tells the parent to swap it's shadow root and close itself.

      clickHandler: (event) ->
        @fire 'select'
