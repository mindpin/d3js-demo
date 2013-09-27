class VersionUi
  constructor: (@version)->
    @stage_ui = @version.stage_ui
    @circle_layer = @stage_ui.circle_layer

    @build_group()

  build_group: ->
    @build_circle()

    if !@canvas_group
      @canvas_group = new Kinetic.Group
        x: Math.random() * 500
        y: Math.random() * 500
        draggable: true

      @canvas_group.add @canvas_circle
      @circle_layer.add @canvas_group

  build_circle: ->
    console.log @version.color
    if !@canvas_circle
      @canvas_circle = new Kinetic.Circle
        radius: 8
        fill: @version.color
        stroke: 'black'
        strokeWidth: 2

class Ui
  constructor: (@raw_versions, @raw_relations)->
    @build_stage()
    @build_nodes()
    @draw()

  build_stage: ->
    @$stage = jQuery('.stage')
    @stage = new Kinetic.Stage
      container: @$stage[0]
      width: @$stage.width()
      height: @$stage.height()
      draggable: true

    jQuery(window).on 'resize', =>
      @stage.setWidth @$stage.width()
      @stage.setHeight @$stage.height()

    @circle_layer = new Kinetic.Layer()
    @line_layer   = new Kinetic.Layer()

    @stage.add @circle_layer
    @stage.add @line_layer

  build_nodes: ->
    for version in versions
      version.stage_ui = @
      version.ui = new VersionUi(version)

  draw: ->
    @circle_layer.draw()
    @line_layer.draw()

jQuery =>
  new Ui(window.versions, window.relations)