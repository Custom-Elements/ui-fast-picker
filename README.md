#ui-fast-picker-item
A single item in the radial menu, you can put any content inside this you like.


##Methods
### selectedChanged
Watches the selected attributes and delegates up to the parent to 
properly switch out it's shadow root



##Event Handlers
### clickHandler
Tells the parent to swap it's shadow root and close itself.



This is really useful for flags and status indicators, and is a fun alternative
to the boring old dropdown box.

Check out the [demo](demo.html)

----

#ui-fast-picker
A fast picker is a radial menu alternative to a boring old drop down.



##Events

##Attributes and Change Handlers
### radiusChanged
Update the widths of all our children when the radius changes





##Methods
### setup
Mainly an internal method that gets called once when DOM nodes
are attached or when childMutated events happen



If we do not have a selected item then use the first child







If there is no default radius set we make it 2.5 times the width
of the first childs offset width then kick off ```radiusChanged```
and set the initial state to closed




For this to work as an inline element we need to line up the inner items
with the shadowRoot clone item. We use the first item as the basis for computation


















### close
Will close the picker





###toggle
Toggles the picker 













### select(node)
Provide it a DOM element to select programatically.  Alternatively,
you can set the ```selected``` attribute on an item and it will call this for you.



We clone the selected node and put it into the shadow root. This makes selecting
the actualy nodes easier and isolates the item. All styling and control specific 
attributes are stripped.









We transform each child with a counter rotation in ```layout```, so we must reverse this here




Make the container ````ui-fast-picker``` the size of it's shadow root




###layout
Layout is going to be called every time we show the item picker







Here apply our rotations to each item and it's children.  
The children are rotated inreverse so they are always right side up.








##Event Handlers
### observerChildren
This will any function and run it withing the context of out element when 
the children are mutated.  It reschedules the event again.





### selectHandler
Internally used to handled select events from children



##Polymer Lifecycle
### attached
We setup the defaults here, have to wait for the children to be mutated and then setup
the selected item and the radius




### detached
Clean up any global event listeners

