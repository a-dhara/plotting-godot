class_name Graphic
extends Node2D

@onready var plot_timer: Timer = $PlotTimer
@onready var plot_scroll: HScrollBar = $"../UI/PlotScroll"
@onready var play_button: CheckButton = $"../UI/PlayAnimation"
@onready var value_label: Label = $"../UI/PlotScroll/Label"
@onready var ui: Control = $"../UI"

@onready var e_x: float = get_viewport().size.x * 0.95
@onready var e_y: float = get_viewport().size.y * 0.95

enum plotting {OFF, PLOT, LISTPLOT, ANIMATEDPLOT, ANIMATEDLISTPLOT}
enum possible_axis {AUTOMATIC, GIVENX, GIVENY, GIVENXY}

func linspace(init, end, step):
	var list: = []
	var num = init
	for i in range(int(abs(init-end)/step)+1):
		list.append(num)
		num += step
	return list

@export_category("General Inputs")
@export var plotting_process : plotting = plotting.OFF
@export var x_list: PackedFloat32Array = linspace(0.,1., 0.01)
@export var y_list: PackedFloat32Array = linspace(0.,1., 0.01)
@export var function: Callable
@export var automatic_axis: possible_axis = possible_axis.AUTOMATIC
@export var x_axis_array: Array = [-1,1]
@export var y_axis_array: Array = [-1,1]
@export var grid_lines = true

@export_category("Animate Inputs")
@export var animated_plotting = false
@export var delta_t: float = 0.005
@export var t_list: PackedFloat32Array = linspace(0., 5., delta_t)
@export var scrolling = false

@export_category("Imported Scenes")
@export var values_scene: PackedScene

@export_category("Others")
@export var count: float = 0


func function_x(x: PackedFloat32Array) -> Array:
	var ans: Array = []
	for xi in x:
		ans.append(function.call(xi))
	return ans

func function_x_t(x: PackedFloat32Array, t: float) -> Array:
	var ans: Array = []
	for xi in x:
		ans.append(function.call(xi,t))
	return ans

func create_curve(x_l, y_l) -> PackedVector2Array:
	var curve: PackedVector2Array
	
	if len(x_l) != len(y_l):
		print("Different size arrays!")
		return []
	
	for i in range(len(x_l)):
		curve.append(Vector2(x_l[i],y_l[i]))
	
	return curve

func magnit(a: float) ->int:
	return int(log(abs(a))/log(10))

func get_delta(Delta: float) -> float:
	var scales: Array = [1,2,5,10,20,50,100,200,500,1000]
	var ord: float = 10.**(magnit(Delta)-1) #Magnitude order for the minimum x interval
	var delta: float = 1 * ord #delta_x
	var n: int = int(Delta/delta)
	var i: int = 1
	while n> 8:
		delta = scales[i] * ord
		n = int(Delta/delta)
		i += 1
	return delta

func get_new_min(minim, delta) -> float:
	var nm = (int(minim/delta)) * delta
	if minim < 0:
		nm = nm - delta
	return nm

func get_subline_vecs(x, dir, translation) ->PackedVector2Array:
	var line_length: = 0.01*e_x
	var grid_length: Vector2 = 1.2*Vector2(e_x, e_y)
	var vectors: Array = []
	if dir == "x":
		vectors = [Vector2(x,-line_length+translation.y),Vector2(x,line_length+translation.y)]
	elif dir == "y":
		vectors = [Vector2(-line_length+translation.x,x),Vector2(line_length+translation.x,x)]
	elif dir == "x_":
		vectors = [Vector2(x,-grid_length.y+translation.y), Vector2(x,grid_length.y+translation.y)]
	elif dir == "y_":
		vectors = [Vector2(-grid_length.x+translation.x,x), Vector2(grid_length.x+translation.x,x)]
	return PackedVector2Array(vectors)

func translate_graph(x_min, x_max, y_min, y_max):
	var trans: = Vector2(20-x_min, 720-(20-y_min))
	position.x = trans.x
	position.y = trans.y
	var axis_translation = Vector2(0,0)
	if x_min > 0:
		axis_translation.x = (x_min + 20)
	elif x_max < 0:
		axis_translation.x = (x_max - 20)
	if y_min > 0:
		axis_translation.y = (y_min + 20)
	elif y_max < 0:
		axis_translation.y = (y_max - 20)
	
	
	return [trans, axis_translation]

func print_axis_values(pos: float, translation:Array, dir: String, scale_d: float):
	var val = values_scene.instantiate()
	var pos_vec: Vector2
	var correction = 5 * Vector2(1,1)
	var posit = Vector2(0.,0.)
	if dir == "x":
		pos_vec = Vector2(pos,0)
		posit = pos_vec * scale_d + correction + translation[0]
		posit.y -= translation[1].y
		val.position = posit
		val.get_child(0).text = str(pos)
		get_parent().add_child(val)
	elif dir == "y":
		pos_vec = Vector2(0,pos)
		posit = pos_vec * scale.y * scale_d + correction + translation[0]
		posit.x += translation[1].x
		val.position = posit
		val.get_child(0).text = str(pos)
		get_parent().add_child(val)
	pass

func axis(x_min,x_max,y_min,y_max,scale_v):
	
	var delta_x = get_delta(abs(x_max - x_min)/scale_v.x)
	var delta_y = get_delta(abs(y_max - y_min)/scale_v.y)
	var new_min_x = get_new_min(x_min/scale_v.x,delta_x)
	var new_min_y = get_new_min(y_min/scale_v.y, delta_y)
	var transl = translate_graph(x_min, x_max, y_min, y_max)
	
	for j in range(abs(x_max - x_min)/(delta_x*scale_v.x) + 2):
		if grid_lines:
			draw_polyline(get_subline_vecs(new_min_x*scale_v.x + delta_x * scale_v.x * j, "x_", transl[1]), Color.GRAY, 0.001*e_x) #x sublines
		draw_polyline(get_subline_vecs(new_min_x*scale_v.x + delta_x * scale_v.x * j, "x", transl[1]), Color.BLACK, 0.002*e_x) #x sublines
		print_axis_values(new_min_x + delta_x * j, transl, "x", scale_v.x)
	
	for j in range(abs(y_max - y_min)/(delta_y*scale_v.y) + 2):
		if grid_lines:
			draw_polyline(get_subline_vecs(new_min_y*scale_v.y + delta_y * scale_v.y * j, "y_", transl[1]), Color.GRAY, 0.001*e_x) #y sublines
		draw_polyline(get_subline_vecs(new_min_y*scale_v.y + delta_y * scale_v.y * j, "y", transl[1]), Color.BLACK, 0.002*e_x) #y sublines
		print_axis_values(new_min_y + delta_y * j, transl, "y", scale_v.y)
	
	var x_line = PackedVector2Array([Vector2(x_min, transl[1].y),Vector2(x_max, transl[1].y)])
	var y_line = PackedVector2Array([Vector2(transl[1].x, y_min),Vector2(transl[1].x, y_max)])
	draw_polyline(x_line, Color.BLACK, 0.003*e_x) #x axis line
	draw_polyline(y_line, Color.BLACK, 0.003*e_x) #y axis line
	
	return


func plot(x_li, y_li) -> void: #Plot a y(x) function along x_l
	var x_l: Array = []
	var y_l: Array = []
	var min_x = Array(x_li).min()
	var max_x = Array(x_li).max()
	var min_y = Array(y_li).min()
	var max_y = Array(y_li).max()
	
	if automatic_axis != possible_axis.AUTOMATIC: #Manual Axis
		if automatic_axis == possible_axis.GIVENX or automatic_axis == possible_axis.GIVENXY:
			min_x = x_axis_array[0]
			max_x = x_axis_array[1]
		if automatic_axis == possible_axis.GIVENY or automatic_axis == possible_axis.GIVENXY:
			min_y = y_axis_array[0]
			max_y = y_axis_array[1]
	
	var scale_vec = Vector2(e_x/abs(max_x - min_x), e_y/abs(max_y - min_y))
	
	for i in range(len(x_li)):
		x_l.append(x_li[i] * scale_vec.x)
		y_l.append(y_li[i] * scale_vec.y)
	min_x = Array(x_l).min()
	max_x = Array(x_l).max()
	min_y = Array(y_l).min()
	max_y = Array(y_l).max()
	if automatic_axis != possible_axis.AUTOMATIC: #Manual Axis
		if automatic_axis == possible_axis.GIVENX or automatic_axis == possible_axis.GIVENXY:
			min_x = x_axis_array[0]*scale_vec.x
			max_x = x_axis_array[1]*scale_vec.x
		if automatic_axis == possible_axis.GIVENY or automatic_axis == possible_axis.GIVENXY:
			min_y = y_axis_array[0]*scale_vec.y
			max_y = y_axis_array[1]*scale_vec.y

	draw_polyline(create_curve(x_l, y_l), Color.ROYAL_BLUE, 0.008*e_y)
	axis(min_x, max_x, min_y, max_y, scale_vec)
	pass

func animated_plot(x_l: Array, t_l: Array) -> void: #Plot a y(x,t) along x_l varying t alog t_l
	plot(x_l, function_x_t(x_l, t_l[count]))
	pass

func animated_plot_list(x_l_2d: Array, y_l_2d: Array) -> void:
	plot(x_l_2d[count], y_l_2d[count])

func _draw() -> void:
	if plotting_process == plotting.PLOT:
		plot(x_list, function_x(x_list))
	elif plotting_process == plotting.LISTPLOT:
		plot(x_list, y_list)
	elif plotting_process == plotting.ANIMATEDPLOT:
		animated_plot(x_list, t_list)
	elif plotting_process == plotting.ANIMATEDLISTPLOT:
		animated_plot_list(x_list, y_list)
	pass


func _ready() -> void:
	if plotting_process != plotting.OFF:
		if plotting_process == plotting.ANIMATEDPLOT: #Correcting start effects for animated plotting
			animated_plotting = true
			ui.visible = true
			plot_timer.wait_time = delta_t
			plot_scroll.max_value = len(t_list)-1
			plot_scroll.step = 1
			
			plot_scroll.scrolling.connect(func():
				plot_timer.stop(); scrolling = true; queue_redraw();
				for child in get_parent().get_children():
					if !(child is Graphic) and !(child is Control):
						child.queue_free()
				)
			play_button.button_down.connect(func():
				if play_button.button_pressed:
					plot_timer.stop(); scrolling = true
				else:
					plot_timer.start(); scrolling = false
				)
			
			if !scrolling:
				plot_timer.start()
	pass

func _process(_delta: float) -> void:
	if plotting_process != plotting.OFF:
		if animated_plotting:
			if scrolling:
				count = plot_scroll.value
				value_label.text = "t = " + str(t_list[count])
			else:
				plot_scroll.value = count
				value_label.text = "t = " + str(t_list[count])


func _on_plot_timer_timeout() -> void:
	if !animated_plotting or scrolling:
		plot_timer.one_shot = true
	count += 1
	if count == len(t_list):
		count = 0
	queue_redraw()
	for child in get_parent().get_children():
		if !(child is Graphic) and !(child is Control):
			child.queue_free()
