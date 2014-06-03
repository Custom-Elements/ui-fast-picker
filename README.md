#ui-fast-picker-item
A single item in the radial menu, you can put any content inside this you like.

This is really useful for flags and status indicators, and is a fun alternative
to the boring old dropdown box.

Check out the [demo](demo.html)


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






##Event Handlers






##Polymer Lifecycle







#ui-fast-picker
A fast picker is a radial menu alternative to a boring old drop down.



##Events

##Attributes and Change Handlers
### value
Currently selected value, this is the one you want to bind to a model. Setting
this will visually change to another `ui-fast-picker-item` by matching its
`value`.


























##Methods













###layout
Layout is going to be called every time we show the item picker













##Event Handlers

##Polymer Lifecycle








