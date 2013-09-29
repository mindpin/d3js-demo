class VersionUi
  constructor: (@version)->
    @stage_ui = @version.stage_ui
    @circle_layer = @stage_ui.circle_layer
    @line_layer = @stage_ui.line_layer

    @build_group()

    @children = []

  set_position: (x, y)->
    @canvas_group.setPosition(x, y)
    @

  add_child: (child_version)->
    @canvas_group.moveToTop()
    @children.push child_version
    @radius = @radius + 2
    @canvas_circle.setRadius @radius

  draw_relations: ()->
    for child in @children
      line_points = [
        @version.x, @version.y,
        child.x, child.y
      ]

      child_ui = child.ui
      if !child_ui.canvas_line
        child_ui.canvas_line = new Kinetic.Line
          points: line_points
          stroke: '#333'
          strokeWidth: 1
          lineCap: 'round'
          lineJoin: 'round'

        @line_layer.add child_ui.canvas_line
      else
        child_ui.canvas_line.setPoints line_points

  build_group: ->
    @build_circle()
    @build_text()

    if !@canvas_group
      @canvas_group = new Kinetic.Group
        opacity: 1
        draggable: true

      @canvas_group.on 'mouseover', =>
        @circle_layer.draw()
        jQuery('body').css('cursor', 'pointer')

      @canvas_group.on 'mouseout', =>
        @circle_layer.draw()
        jQuery('body').css('cursor', 'default')

      @canvas_group.on 'dragstart', =>
        @version.fixed = true

      @canvas_group.on 'dragmove', (evt)=>
        @x = evt.layerX - @stage_ui.stage_x
        @y = evt.layerY - @stage_ui.stage_y
        @version.x = @x
        @version.y = @y
        @version.px = @x
        @version.py = @y
        @stage_ui.force.resume()

      @canvas_group.on 'dragend', (evt)=>
        @version.fixed = false

      @canvas_group.add @canvas_circle
      @canvas_group.add @canvas_text
      @circle_layer.add @canvas_group

  build_circle: ->
    if !@canvas_circle
      @radius = 5
      @canvas_circle = new Kinetic.Circle
        radius: @radius
        fill: @version.color
        stroke: '#333'
        strokeWidth: 1.1

  build_text: ->
    if !@canvas_text
      @canvas_text = new Kinetic.Text
        text: @version.name
        fontSize: 12
        fontFamily: 'Calibri'
        fill: '#222'

      @text_width  = @canvas_text.getWidth()
      @text_height = @canvas_text.getHeight()

      @canvas_text.setOffset
        x: @text_width / 2
        y: @radius + @text_height + 2

class Ui
  constructor: (@raw_versions, @raw_relations)->
    @parse_data()
    @build_stage()
    @build_nodes()

  parse_data: ->
    @names = @raw_versions.map (version)=>
      version.name

    @edges = @raw_relations.map (relation)=>
      source_idx = @names.indexOf relation.source
      target_idx = @names.indexOf relation.target

      {
        source: @raw_versions[source_idx]
        target: @raw_versions[target_idx]
        source_idx: source_idx
        target_idx: target_idx
      }

    # console.log @names
    # console.log @edges

  build_stage: ->
    @stage_x = 0
    @stage_y = 0
    @$stage = jQuery('.stage')
    @stage = new Kinetic.Stage
      container : @$stage[0]
      width     : @$stage.width()
      height    : @$stage.height()
      draggable : true
      dragBoundFunc: (pos)=>
        @stage_x = pos.x
        @stage_y = pos.y
        return pos

    jQuery(window).on 'resize', =>
      @stage.setSize @$stage.width(), @$stage.height()

    @circle_layer = new Kinetic.Layer()
    @line_layer   = new Kinetic.Layer()

    @stage
      .add(@line_layer)
      .add(@circle_layer)

  build_nodes: ->
    @layout_nodes = []
    @layout_edges = []

    @add_node(0)

  add_node: (idx)->
    # return if idx == 100
    return if idx == @raw_versions.length

    version = @raw_versions[idx]
    version.stage_ui = @
    version.ui = new VersionUi(version)

    @layout_nodes.push version

    @edges
      .filter (edge)=> 
        edge.target_idx == idx
      .forEach (new_edge)=>
        @layout_edges.push new_edge
        new_edge.source.ui.add_child new_edge.target
    
    if !@force
      @force = d3.layout.force()
        .size([@$stage.width(), @$stage.height()])
        .nodes(@layout_nodes)
        .links(@layout_edges)
        .charge(-500)
        .linkDistance (a, b)=>
          a.source.ui.radius + a.target.ui.radius + 100
        .start()
        .on 'tick', => 
          for layout_node in @layout_nodes
            layout_node.ui
              .set_position(layout_node.x, layout_node.y)
              .draw_relations()

          @draw()
    else
      @force
        .nodes(@layout_nodes)
        .links(@layout_edges)
        .start()

      # API: In addition, it should be called again whenever the nodes or links change

    setTimeout =>
      @add_node idx + 1
    , 500

  draw: ->
    @circle_layer.draw()
    @line_layer.draw()

jQuery =>
  window.ui = new Ui(window.versions, window.relations)