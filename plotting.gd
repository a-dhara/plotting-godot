class_name GraphicPlot2D
extends Node2D

@onready var graph: Graphic = $Control/SubViewportContainer/SubViewport/Graph
@onready var view: SubViewportContainer = %SubViewportContainer

func linspace(init: float, end: float, step:float) -> Array:
	return graph.linspace(init, end, step)


func plot(function: Callable, x_array: Array, axis_range: Array = [], aspect_ratio: float = 16./9.):
	view.size.x = view.size.y * aspect_ratio
	if axis_range.size() != 0: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = axis_range[0]
		graph.y_axis_array = axis_range[1]
	graph.function = function
	graph.x_list = linspace(x_array[0], x_array[1], x_array[2])
	graph.plotting_process = graph.plotting.PLOT
	pass

func plot_lists(y_list: Array, x_list: Array, axis_range: Array = [], aspect_ratio: float = 16./9.):
	view.size.x = view.size.y * aspect_ratio
	if axis_range.size() != 0: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = axis_range[0]
		graph.y_axis_array = axis_range[1]
	graph.plotting_process = graph.plotting.LISTPLOT
	graph.y_list = y_list
	graph.x_list = x_list
	pass


func animated_plot(function: Callable, x_array: Array, t_array: Array, axis_range: Array = [], aspect_ratio: float = 16./9.):
	view.size.x = view.size.y * aspect_ratio
	if axis_range.size() != 0: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = axis_range[0]
		graph.y_axis_array = axis_range[1]
	graph.plotting_process = graph.plotting.ANIMATEDPLOT
	graph.animated_plotting = true
	graph.function = function
	graph.x_list = linspace(x_array[0], x_array[1], x_array[2])
	graph.t_list = linspace(t_array[0], t_array[1], t_array[2])
	graph.delta_t = t_array[2]
	pass

func animated_plot_lists(y_2d_list: Array, x_2d_list: Array, axis_range: Array = [], dt: float = 1./y_2d_list.size(), aspect_ratio: float = 16./9.):
	if !y_2d_list[0][0] or !x_2d_list[0][0]: #Check if y_2d_list is a 2-dimensional array
		print("y_list is not a 2-d array")
		return
	if axis_range.size() != 0: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = axis_range[0]
		graph.y_axis_array = axis_range[1]
	graph.plotting_process = graph.plotting.ANIMATEDLISTPLOT
	graph.animated_plotting = true
	graph.y_list = y_2d_list
	graph.x_list = x_2d_list
	graph.delta_t = dt
	pass

func my_function(tl: Array) -> Array:
	var yl = []
	var xl = []
	for i in linspace(0.1,2*PI, 0.01):
		tl = linspace(0.,i, 0.01)
		var xl0 = []
		var yl0 = []
		for j in range(len(tl)):
			xl0.append(cos(tl[j]))
			yl0.append(sin(tl[j]))
			xl.append(xl0)
			yl.append(yl0)
	print(xl)
	return [xl,yl]

func _ready() -> void:
#	animated_plot((func(x,t): return cos(3*x + 4*t)*cos(4*x-3*t)).call, [0.1, 6*PI, 0.001], [0., 5., 0.01], [])
	var x_test = linspace(0.,2*PI, 0.01)
	var tl: Array = []
#	plot_lists(my_function(tl)[0], my_function(tl)[1], [[-1.2,1.2],[-1.2,1.2]])
	animated_plot_lists(my_function(tl)[0], my_function(tl)[1], [[-1.2,1.2],[-1.2,1.2]])
	pass
