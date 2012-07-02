#= require "vendor/all"

# A view that behaves as stack of other views.
class StackView extends Backbone.View

  initialize:->
    @stack = []

  push: (view)->
    # Only detach the current view (remove() also removes the event listeners).
    @top()?.$el.detach()
    @stack.push view
    @trigger 'change'
    @render()

  pop:->
    throw 'Empty stack' unless @stack.length
    @stack.pop().remove()
    @trigger 'change'
    @render()

  top:->
    @stack[@stack.length - 1]

  reset: (view)->
    @top()?.remove()
    @stack = []
    @trigger 'change'
    @push view

  render:->
    view = @top()
    @$el.append view.$el
    view.render()
    @

  size:->
    @stack.length


# Exports.
window.StackView = StackView