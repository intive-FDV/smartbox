#= require "vendor/all"
#= require "templates/list"
#= require "dialog"

# Base class for items of a ListView.
class window.ListItemView extends Backbone.View
  tagName: 'button'
  className: 'item'
  events:
    'click' : 'onClick'

  onClick: (e)->
    return

# A generic view for lists.
class ListView extends Backbone.View

  # Override these properties to customize the list.
  className: 'content-list'
  itemsPerRow: 5 # See $itemsContentPerLine on application.sass (body .mainPanel)
  itemsPerCol: 2

  onEmptyList: =>
    @$el.html JST["templates/empty_list"](message: @emptyListMessage())
    @focusOutList() #Expulso el focus de la lista para que no quede perdido

  emptyListMessage: ->
    'No hay contenidos'

  itemsPerPage: ->
    @itemsPerCol * @itemsPerRow

  events:
    'focus .item'          : 'focusItem'
    'mouseenter .item'     : 'mouseenterItem'
    'focus .previous-page' : 'previousPageClick'
    'focus .next-page'     : 'nextPageClick'
    'focus .focus-next'    : 'focusNext' #se llega al ultimo elemento de la pagina-hay otra pagina
    'focus .focus-out'     : 'focusOutList'#se sale de la lista hacia el tab panel
    'focus .focus-in'      : 'focusInList' #cuando se accede a la lista desde el tab panel
    'focus .focus-top'     : 'focusInList' #Se llega al top de la lista
    'focus .focus-bottom'  : 'focusInList' #se llega al bottom de la lista
    'mousewheel'           : 'scroll'

  scroll:(e) ->
    if e.originalEvent.wheelDelta < 0 # down
      @nextPageClick e
    else                              # up
      @previousPageClick e

  initialize: ->
    # The currently selected page (1-based).
    @currentPage = 1
    # The index of the currently selected item in the page (0-based).
    @focusIndex = 0

  focusOutList: (e) ->
    @trigger "exitFocus"

  focusInList: (e) ->
    @$(".items-container").children()[@focusIndex].focus()

  focusNext:(e) ->  #Se llega solo desde el ultimo item de la lista y si hay una proxima pagina
    @focusIndex = 0
    @$(".next-page")[0].focus()

  focusItem: (e) ->
    @focusIndex = $(e.target).index(".item")
    index       = (@currentPage - 1) * @itemsPerPage() + @focusIndex
    info        = @itemInfoAt index
    @$info.html info

  mouseenterItem: (e) ->
    e.currentTarget.focus()

  previousPageClick:(e) ->
    #evita que el evento de foco se dispare despues de hacer foco sobre el item
    e.stopPropagation()
    focusIndex =  (@focusIndex % @itemsPerRow + @itemsPerRow * (@itemsPerCol - 1))
    @previousPage()
    toFocus = @$itemsContainer.children()[focusIndex]

    if toFocus?
      toFocus.focus()
    else
      @$itemsContainer.find("button.item:last").focus()

  nextPageClick:(e) ->
    e.stopPropagation()
    focusIndex =  @focusIndex % @itemsPerRow

    @nextPage()
    toFocus = @$itemsContainer.children()[focusIndex]
    if toFocus?
      toFocus.focus()
    else
      @$itemsContainer.find("button.item:first").focus()

  nextPage:->
    @renderPage(@currentPage + 1)

  previousPage:->
    @renderPage(@currentPage - 1)

  hasPage:(pageNumber)=>
    1 <= pageNumber && pageNumber <= @pageCount()

  pageCount: ->
    Math.ceil @itemCount() / @itemsPerPage()

  renderPage: (pageNumber) ->
    return if pageNumber < 1
    #No hace nada si la cantidad de items en la coleccion no es suficiente para crear una pagina
    pageOffset = @itemsPerPage() * (pageNumber - 1)
    return unless @itemCount() > pageOffset

    params =
      pageNumber: pageNumber
      pageCount: @pageCount()
    _.extend params, @options
    @$el.html JST['templates/list'] params

    @$itemsContainer = @$(".items-container")
    @$info = @$(".info")

    top = Math.min(@itemCount(), pageOffset + @itemsPerPage())
    hasNextPage = @hasPage pageNumber + 1

    for i in [pageOffset...top]
      next = if i < top - 1
        "#item#{i+1}"
      else if hasNextPage
        "#vertical-next-page"
      else
        "#item#{i}"

      listItem = @itemViewAt i
      listItem.$el.attr 'id', "item#{i}"
      listItem.$el.css 'nav-right', next
      listItem.render()
      @$itemsContainer.append(listItem.$el)
    @currentPage = pageNumber

  render: =>
    # Does not render anything if items are loading (a spinner is shown then).
    return if @loading

    if @itemCount()
      @renderPage @currentPage
      @$itemsContainer?.children(".item")[@focusIndex]?.focus()
    else
      @renderEmptyList()

  renderEmptyList: ->
    @$el.html ' ' # This removes the spinner.
    dialog = new InfoDialog info: @emptyListMessage()
    dialog.on "accepted", @onEmptyList
    dialog.show()

  startLoading: ->
    @loading = true

  finishLoading: =>
    @loading = false
    @render()

  # The number of items on the list.
  itemCount: ->
    throw 'Must override'

  # A Backbone.View for the item at a given index.
  itemViewAt: (index) ->
    throw 'Must override'

  # An HTML string with the information for an intem at a given index.
  itemInfoAt: (index) -> ''

# Exports
window.ListView     = ListView
window.ListItemView = ListItemView