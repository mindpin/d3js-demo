class OwlArrowRelationUi
  COLOR: '#C459DA'
  STROKE_WIDTH: 3
  constructor: (@relation)->
    @line_layer = @relation.owl_ui.line_layer

    @draw()

  draw: ->
    px = @relation.parent.ui.x
    py = @relation.parent.ui.y
    sx = @relation.sub.ui.x
    sy = @relation.sub.ui.y

    deltax = px - sx
    deltay = py - sy

    d = Math.sqrt(deltax * deltax + deltay * deltay)

    offy = 6 * deltax / d
    offx = 6 * deltay / d
    mx = (px + sx) / 2
    my = (py + sy) / 2

    line_points = [px, py, sx, sy]

    arrow_points = [
      mx - offy * 2, my - offx * 2
      mx - offx, my + offy
      mx + offx, my - offy
    ]

    if !@canvas_line
      @canvas_line = new Kinetic.Line
        points: line_points
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH
        lineCap: 'round'
        lineJoin: 'round'

      @canvas_arrow = new Kinetic.Polygon
        points: arrow_points
        fill: 'white'
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH

      @line_layer.add(@canvas_line)
      @line_layer.add(@canvas_arrow)

    else
      @canvas_line.setPoints line_points
      @canvas_arrow.setPoints arrow_points    

class OwlEqualRelationUi
  COLOR: '#C459DA'
  STROKE_WIDTH: 3
  constructor: (@relation)->
    @line_layer = @relation.owl_ui.line_layer

    @draw()

  draw: ->
    px = @relation.classes[0].ui.x
    py = @relation.classes[0].ui.y
    sx = @relation.classes[1].ui.x
    sy = @relation.classes[1].ui.y

    deltax = px - sx
    deltay = py - sy

    d = Math.sqrt(deltax * deltax + deltay * deltay)

    offy = 3 * deltax / d
    offx = 3 * deltay / d

    line_points   = [px - offx, py + offy, sx - offx, sy + offy]
    line_points_1 = [px + offx, py - offy, sx + offx, sy - offy]

    if !@canvas_line
      @canvas_line = new Kinetic.Line
        points: line_points
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH
        lineCap: 'round'
        lineJoin: 'round'

      @canvas_line_1 = new Kinetic.Line
        points: line_points_1
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH
        lineCap: 'round'
        lineJoin: 'round'

      @line_layer.add(@canvas_line)
      @line_layer.add(@canvas_line_1)

    else
      @canvas_line.setPoints line_points
      @canvas_line_1.setPoints line_points_1

class OwlClassIndividualArrowRelationUi
  COLOR: '#4285F4'
  STROKE_WIDTH: 3
  constructor: (@relation)->
    @line_layer = @relation.owl_ui.line_layer

    @draw()

  draw: ->
    px = @relation.class.ui.x
    py = @relation.class.ui.y
    sx = @relation.individual.ui.x
    sy = @relation.individual.ui.y

    deltax = px - sx
    deltay = py - sy

    d = Math.sqrt(deltax * deltax + deltay * deltay)

    offy = 6 * deltax / d
    offx = 6 * deltay / d
    mx = (px + sx) / 2
    my = (py + sy) / 2

    line_points = [px, py, sx, sy]

    arrow_points = [
      mx - offy * 2, my - offx * 2
      mx - offx, my + offy
      mx + offx, my - offy
    ]

    if !@canvas_line
      @canvas_line = new Kinetic.Line
        points: line_points
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH
        lineCap: 'round'
        lineJoin: 'round'

      @canvas_arrow = new Kinetic.Polygon
        points: arrow_points
        fill: 'white'
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH

      @line_layer.add(@canvas_line)
      @line_layer.add(@canvas_arrow)

    else
      @canvas_line.setPoints line_points
      @canvas_arrow.setPoints arrow_points    

class OwlObjectPropertyArrowRelationUi
  COLOR: '#E26533'
  STROKE_WIDTH: 3
  constructor: (@relation)->
    @line_layer = @relation.owl_ui.line_layer

    @draw()

  draw: ->
    px = @relation.host.ui.x
    py = @relation.host.ui.y
    sx = @relation.value.ui.x
    sy = @relation.value.ui.y

    deltax = px - sx
    deltay = py - sy

    d = Math.sqrt(deltax * deltax + deltay * deltay)

    offy = 6 * deltax / d
    offx = 6 * deltay / d
    mx = (px + sx) / 2
    my = (py + sy) / 2

    line_points = [px, py, sx, sy]

    arrow_points = [
      mx - offy * 2, my - offx * 2
      mx - offx, my + offy
      mx + offx, my - offy
    ]

    if !@canvas_line
      @canvas_line = new Kinetic.Line
        points: line_points
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH
        lineCap: 'round'
        lineJoin: 'round'
        dashArray: [5, 5]

      @canvas_arrow = new Kinetic.Polygon
        points: arrow_points
        fill: 'white'
        stroke: @COLOR
        strokeWidth: @STROKE_WIDTH

      @line_layer.add(@canvas_line)
      @line_layer.add(@canvas_arrow)

    else
      @canvas_line.setPoints line_points
      @canvas_arrow.setPoints arrow_points    

class OwlIndividualEqualRelationUi
  COLOR: '#4285F4'
  constructor: (@relation)->
    @line_layer = @relation.owl_ui.line_layer

    @draw()

  draw: ->
    px = @relation.individuals[0].ui.x
    py = @relation.individuals[0].ui.y
    sx = @relation.individuals[1].ui.x
    sy = @relation.individuals[1].ui.y

    deltax = px - sx
    deltay = py - sy

    d = Math.sqrt(deltax * deltax + deltay * deltay)

    offy = 3 * deltax / d
    offx = 3 * deltay / d

    line_points   = [px - offx, py + offy, sx - offx, sy + offy]
    line_points_1 = [px + offx, py - offy, sx + offx, sy - offy]

    if !@canvas_line
      @canvas_line = new Kinetic.Line
        points: line_points
        stroke: @COLOR
        strokeWidth: 2
        lineCap: 'round'
        lineJoin: 'round'

      @canvas_line_1 = new Kinetic.Line
        points: line_points_1
        stroke: @COLOR
        strokeWidth: 2
        lineCap: 'round'
        lineJoin: 'round'

      @line_layer.add(@canvas_line)
      @line_layer.add(@canvas_line_1)

    else
      @canvas_line.setPoints line_points
      @canvas_line_1.setPoints line_points_1

class OwlObjUi
  constructor: (@obj)->
    @layer      = @obj.owl_ui.layer
    @line_layer = @obj.owl_ui.line_layer
    @render()

  render: ->
    @$elm = jQuery("<a href='javascript:;'></a>")
      .addClass(@klass).addClass('obj')
      .html("#{@klass}: #{@obj.name}")
      .appendTo @parent_elm()

class CircleObjUi extends OwlObjUi
  CIRCLE_PADDING: 10
  OPACITY: 1
  TEXT_COLOR: '#333'
  FONT_SIZE: 14
  FILL: 'white'
  STROKE: '#333'
  STROKE_WIDTH: 2
  HOVER_FILL: '#f4f4f4'
  x: 100
  y: 100

  set_position: (x, y)->
    @x = ~~x
    @y = ~~y
    @build()
    @draw_relations()
    @

  build: ->
    @build_text()
    @build_circle()
    @build_group()      

  build_text: ->
    if !@canvas_text
      @canvas_text = new Kinetic.Text
        text: @obj.name
        fontSize: @FONT_SIZE
        fontStyle: 'bold'
        fontFamily: 'Calibri, Microsoft YaHei'
        fill: @TEXT_COLOR

      @text_width  = @canvas_text.getWidth()
      @text_height = @canvas_text.getHeight()

      @canvas_text.setOffset
        x: @text_width / 2
        y: @text_height / 2

      return @canvas_text

  build_circle: ->
    if !@canvas_circle
      @radius = @text_width / 2 + @CIRCLE_PADDING

      # 圆坐标是从圆心算起
      @canvas_circle = new Kinetic.Circle
        radius: @radius
        fill: @FILL
        stroke: @STROKE
        strokeWidth: @STROKE_WIDTH

      return @canvas_circle

  build_group: ->
    if !@canvas_group
      @canvas_group = new Kinetic.Group
        x: @x
        y: @y
        opacity: @OPACITY
        draggable: true

      @canvas_group.on 'mouseover', =>
        @canvas_circle.setFill(@HOVER_FILL)
        @layer.draw()
        jQuery('body').css('cursor', 'pointer')

      @canvas_group.on 'mouseout', =>
        @canvas_circle.setFill(@FILL)
        @layer.draw()
        jQuery('body').css('cursor', 'default')

      @canvas_group.on 'mousedown', =>
        @canvas_group.moveToTop()
        @layer.draw()

      @canvas_group.on 'dragstart', (evt)=>
        @layout_node.fixed = true

      @canvas_group.on 'dragmove', (evt)=>
        @x = evt.layerX - @obj.owl_ui.stage_x
        @y = evt.layerY - @obj.owl_ui.stage_y
        @layout_node.x = @x
        @layout_node.y = @y
        @layout_node.px = @x
        @layout_node.py = @y
        @obj.owl_ui.force.resume()

      @canvas_group.on 'dragend', (evt)=>
        @layout_node.fixed = false

      @canvas_group.add @canvas_circle
      @canvas_group.add @canvas_text
      @layer.add @canvas_group

    @canvas_group.setPosition(@x, @y)

class OwlClassUi extends CircleObjUi
  klass: 'class'
  parent_elm: ->
    @obj.owl_ui.$classes

  draw_relations: ->
    for relation in @obj.relations
      if !relation.ui
        relation.owl_ui = @obj.owl_ui
        relation.ui = new OwlArrowRelationUi(relation) if relation.type == 'parent-sub'
        relation.ui = new OwlEqualRelationUi(relation) if relation.type == 'equivalent'
        # relation.ui = new OwlArrowRelationUi(relation) if relation.type == 'class-individual'
      else
        relation.ui.draw()

    @

class OwlIndividualUi extends CircleObjUi
  klass: 'individual'
  TEXT_COLOR: 'white'
  FILL: '#333'
  STROKE: '#333'
  HOVER_FILL: '#111'
  parent_elm: ->
    @obj.owl_ui.$individuals

  draw_relations: ->
    for relation in @obj.relations
      if !relation.ui
        relation.owl_ui = @obj.owl_ui
        relation.ui = new OwlClassIndividualArrowRelationUi(relation) if relation.type == 'class-individual'
        relation.ui = new OwlObjectPropertyArrowRelationUi(relation) if relation.type == 'object-property-value'
      else
        relation.ui.draw()

    @

class OwlViewerUi
  constructor: ->

  load_owl: (owl_url)->
    jQuery.ajax
      url: owl_url,
      success: (data)=>
        owl_parser = new OwlParser(data)
        @ontology = owl_parser.build()

        @render()

  render: ->
    # 作为图形节点显示
    @classes = @ontology.classes
    @individuals = @ontology.individuals
    
    # 只在侧边栏显示
    @annotations = @ontology.annotations
    @data_properties = @ontology.data_properties
    @object_properties = @ontology.object_properties
    @data_types = @ontology.data_types

    @build_sidebar_dom()

    @init_stage()
    @generate_objects_ui()

  build_sidebar_dom: ->
    if !@$page
      @$page = jQuery('<div></div>')
        .addClass('owl-viewer-page')
        .appendTo(jQuery('body'))

      @$objects_list = jQuery('<div></div>')
        .addClass('objects-list')
        .appendTo(@$page)

      @$classes = jQuery('<div></div>')
        .addClass('objs').addClass('classes')
        .appendTo(@$objects_list)

      @$annotations = jQuery('<div></div>')
        .addClass('objs').addClass('annotations')
        .appendTo(@$objects_list)

      @$individuals = jQuery('<div></div>')
        .addClass('objs').addClass('individuals')
        .appendTo(@$objects_list)

      @$data_properties = jQuery('<div></div>')
        .addClass('objs').addClass('data_properties')
        .appendTo(@$objects_list)

      @$object_properties = jQuery('<div></div>')
        .addClass('objs').addClass('object_properties')
        .appendTo(@$objects_list)

      @$data_types = jQuery('<div></div>')
        .addClass('objs').addClass('data_types')
        .appendTo(@$objects_list)

  init_stage: ->
    if !@$stage
      @stage_x = 0
      @stage_y = 0

      @$stage = jQuery("<div></div>")
        .addClass('stage')
        .appendTo @$page

      @stage = new Kinetic.Stage
        container: @$stage[0]
        width: @$stage.width()
        height: @$stage.height()
        draggable: true
        dragBoundFunc: (pos)=>
          @stage_x = pos.x
          @stage_y = pos.y
          return pos

      jQuery(window).on 'resize', =>
        @stage.setWidth @$stage.width()
        @stage.setHeight @$stage.height()

      @layer = new Kinetic.Layer()
      @line_layer = new Kinetic.Layer()

      @stage.add @line_layer
      @stage.add @layer

  generate_objects_ui: ->
    for klass in @classes
      klass.owl_ui = @
      klass.ui = new OwlClassUi(klass)

    for individual in @individuals
      individual.owl_ui = @
      individual.ui = new OwlIndividualUi(individual)

    # @layout()
    @layout_force()

  # 一般节点排布算法
  layout: ->
    @layer.draw()

    setTimeout =>
      @layout_nodes = []
      @layout_edges = []

      for klass in @classes
        @layout_nodes.push {
          id: klass.name
          label: klass.name
          width: 50
          height: 50
          node: klass
        }

        for sub_klass in klass.sub_classes()
          @layout_edges.push {
            sourceId: klass.name
            targetId: sub_klass.name
          }

      dagre.layout().nodes(@layout_nodes).edges(@layout_edges).run()

      for layout_node in @layout_nodes
        ui = layout_node.node.ui

        ui.set_position layout_node.dagre.x * 2, layout_node.dagre.y

      for klass in @classes
        klass.ui.draw_relations()

      @layer.draw()
      @line_layer.draw()

    , 1

  # 力反馈节点排布算法
  layout_force: ->
    @layout_nodes = []
    @layout_edges = []

    for i in [0...@classes.length]
      klass = @classes[i]

      layout_node = { 
        ui: klass.ui
      }
      klass.ui.layout_node = layout_node
      @layout_nodes.push layout_node

      for sub_klass in klass.sub_classes()
        @layout_edges.push {
          source: i
          target: @classes.indexOf(sub_klass)
        }

      for relation in klass.get_relations_by_type('equivalent')
        classes = relation.classes
        klass = if classes[0] == klass then classes[1] else classes[0]

        @layout_edges.push {
          source: i
          target: @classes.indexOf(klass)
        }

    for j in [0...@individuals.length]
      individual = @individuals[j]

      layout_node = {
        ui: individual.ui
      }

      individual.ui.layout_node = layout_node
      @layout_nodes.push layout_node


      for klass in individual.classes()
        @layout_edges.push {
          source: @classes.indexOf(klass)
          target: @classes.length + j
        }

      for relation in individual.get_relations_by_type('object-property-value')
        individual = relation.value
        @layout_edges.push {
          source: @classes.length + @individuals.indexOf(individual)
          target: @classes.length + j
        }

    @force = d3.layout.force()
      .size([@$stage.width(), @$stage.height()])
      .nodes(@layout_nodes)
      .links(@layout_edges)
      .charge(-600)
      .linkDistance(100)
      .start()
      .on 'tick', => 
        @layout_force_tick()

  layout_force_tick: ->
    for layout_node in @layout_nodes
      layout_node.ui
        .set_position(layout_node.x, layout_node.y)
        .draw_relations()

    @layer.draw()
    @line_layer.draw()

window.OwlViewerUi = OwlViewerUi