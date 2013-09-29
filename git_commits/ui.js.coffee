class FileUi
  constructor: (@file_obj)->
    @stage_ui     = @file_obj.stage_ui
    @circle_layer = @stage_ui.circle_layer
    @line_layer   = @stage_ui.line_layer

    @build_group()

    @children = []

  random_color: ->
    '#'+('00000'+(Math.random()*0x1000000<<0).toString(16)).slice(-6)

  set_position: (x, y)->
    @canvas_group.setPosition(x, y)
    @canvas_circle.setRadius @file_obj.count
    @

  add_child: (child_version)->
    @canvas_group.moveToTop()
    @children.push child_version
    @radius = @radius + 2
    @canvas_circle.setRadius @radius

  build_group: ->
    @build_circle()
    @build_text()

    if !@canvas_group
      @canvas_group = new Kinetic.Group
        draggable: true

      @canvas_group.on 'mouseover', =>
        @circle_layer.draw()
        jQuery('body').css('cursor', 'pointer')

      @canvas_group.on 'mouseout', =>
        @circle_layer.draw()
        jQuery('body').css('cursor', 'default')

      @canvas_group.on 'dragstart', =>
        @file_obj.fixed = true

      @canvas_group.on 'dragmove', (evt)=>
        @x = evt.layerX - @stage_ui.stage_x
        @y = evt.layerY - @stage_ui.stage_y
        @file_obj.x = @x
        @file_obj.y = @y
        @file_obj.px = @x
        @file_obj.py = @y
        @stage_ui.force.resume()

      @canvas_group.on 'dragend', (evt)=>
        @file_obj.fixed = false

      @canvas_group.add @canvas_circle
      @canvas_group.add @canvas_text
      @circle_layer.add @canvas_group

  build_circle: ->
    if !@canvas_circle
      @radius = 5
      @canvas_circle = new Kinetic.Circle
        radius: @file_obj.count
        fill: @random_color()
        stroke: '#333'
        strokeWidth: 1.1

  build_text: ->
    if !@canvas_text
      @canvas_text = new Kinetic.Text
        text: @file_obj.name
        fontSize: 12
        fontFamily: 'Calibri'
        fill: '#222'

      @text_width  = @canvas_text.getWidth()
      @text_height = @canvas_text.getHeight()

      @canvas_text.setOffset
        x: @text_width / 2
        y: @radius + @text_height + 2

  remove: ->
    @canvas_group.remove()

class File
  constructor: (@name, @size, @is_file)->
    @type = 'file'
    @children = {}

    @count = @is_file

  add_file: (file_or_dir_name, size, is_file)->
    if !@children[file_or_dir_name]
      file = new File(file_or_dir_name, size, is_file)
      file.stage_ui = @stage_ui
      file.ui = new FileUi(file)

      @children[file_or_dir_name] = file
      file.parent = @

      p = @
      loop
        p.count = p.count + file.count
        p.size = p.size + file.size
        p = p.parent
        break if !p

    @children[file_or_dir_name]

  update_file: (file_or_dir_name, size)->
    file = @children[file_or_dir_name]
    
    delta = size - file.size
    file.size = size

    p = @
    loop
      p.size = p.size + delta
      p = p.parent
      break if !p

  delete_file: (file_or_dir_name)->
    file = @children[file_or_dir_name]

    p = @
    loop
      p.count = p.count - file.count
      p.size = p.size - file.size
      p = p.parent
      break if !p

    file.clear()

  clear: ->
    for file in @children
      file.clear()

    @ui.remove()


class FileTree extends File
  constructor: (@stage_ui)->
    @children = {}
    @size = 0
    @count = 0

  parse_path: (path)->
    splits = path.split('/')
    len = splits.length
    return {
      dirs: splits[0...len - 1]
      fname: splits[len - 1]
    }

  add_files: (files)->
    return if !files
    for raw_file in files
      parse = @parse_path(raw_file.path)

      p = @
      for dir_name in parse.dirs
        p = p.add_file(dir_name, 0, 0)

      p.add_file(parse.fname, parseInt(raw_file.size), 1)

  update_files: (files)->
    return if !files
    for raw_file in files
      parse = @parse_path(raw_file.path)

      p = @
      for dir_name in parse.dirs
        p = p.add_file(dir_name, 0, 0)

      p.update_file(parse.fname, parseInt(raw_file.size))

  delete_files: (files)->
    return if !files
    for raw_file in files
      parse = @parse_path(raw_file.path)

      p = @
      for dir_name in parse.dirs
        p = p.children[dir_name]

      p.delete_file(parse.fname)

class Ui
  constructor: (@raw_commits)->
    @parse_data()
    @build_stage()
    @build_nodes()

  parse_data: ->
    @file_tree = new FileTree(@)

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
    @add_node(0)

  add_node: (idx)->
    # return if idx == 10
    return if idx == @raw_commits.length
    commit = @raw_commits[idx]
    
    @file_tree.add_files commit.added_files
    @file_tree.update_files commit.modified_files
    @file_tree.delete_files commit.deleted_files
    
    @layout_nodes = []
    @parse_layout_nodes()

    if !@force
      @force = d3.layout.force()
        .size([@$stage.width(), @$stage.height()])
        .nodes(@layout_nodes)
        .links([])
        .charge(-50)
        .linkDistance(1)
        .start()
        .on 'tick', => 
          for layout_node in @layout_nodes
            layout_node.ui
              .set_position(layout_node.x, layout_node.y)

          @draw()
    else
      @force
        .nodes(@layout_nodes)
        .links([])
        .start()

      # API: In addition, it should be called again whenever the nodes or links change

    setTimeout =>
      @add_node idx + 1
    , 500

  parse_layout_nodes: ->
    @_parse_layout_nodes_r @file_tree

  _parse_layout_nodes_r: (tree)->
    for key of tree.children
      child = tree.children[key]
      @_parse_layout_nodes_r child

      @layout_nodes.push child if child.count > 0

  draw: ->
    @circle_layer.draw()
    @line_layer.draw()

jQuery =>
  jQuery.ajax
    url: 'data.json'
    success: (res)->
      json = jQuery.parseJSON res

      window.ui = new Ui(json.reverse())