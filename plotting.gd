class_name GraphicPlot2D
extends Node2D

@onready var graph: Graphic = $Control/SubViewportContainer/SubViewport/Graph
@onready var view: SubViewportContainer = %SubViewportContainer

@export_category("Plot Options")
@export var specific_axis_range: = false
@export var x_axis_min: = -1.
@export var x_axis_max: = 1.
@export var y_axis_min: = -1.
@export var y_axis_max: = 1.
@export var aspect_ratio: = 16./9.
@export var specific_fps: = false
@export var fps: float = 1.
@export var grid_lines: = true
@export var graph_color: Color = Color.ROYAL_BLUE

func linspace(init: float, end: float, step:float) -> Array:
	return graph.linspace(init, end, step)


func plot(function: Callable, x_array: Array): #Plotting a function f(x)
	graph.function = function #function f
	graph.x_list = linspace(x_array[0], x_array[1], x_array[2]) #making [x_min, x_max, delta_x] into the list
	#Graphical options
	if specific_axis_range: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = [x_axis_min, x_axis_max]
		graph.y_axis_array = [y_axis_min, y_axis_max]
	view.size.x = view.size.y * aspect_ratio #Screen Aspect Ratio
	graph.graph_color = graph_color #Color of the plot curve
	graph.grid_lines = grid_lines #Make Gridlines true or false
	#Starting
	graph.plotting_process = graph.plotting.PLOT #Set graphic to be a simple plot
	graph._ready() #In fact start the plotting process
	pass

func plot_lists(y_list: Array, x_list: Array): #Plotting two lists (x,y) points
	graph.y_list = y_list
	graph.x_list = x_list
	#Graphical options
	if specific_axis_range: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = [x_axis_min, x_axis_max]
		graph.y_axis_array = [y_axis_min, y_axis_max]
	view.size.x = view.size.y * aspect_ratio
	graph.graph_color = graph_color
	graph.grid_lines = grid_lines
	#Starting
	graph.plotting_process = graph.plotting.LISTPLOT
	graph._ready()
	pass


func animated_plot(function: Callable, x_array: Array, t_array: Array): #Plotting a f(x,t) varying t with time
	graph.function = function
	graph.x_list = linspace(x_array[0], x_array[1], x_array[2])
	graph.t_list = linspace(t_array[0], t_array[1], t_array[2])
	graph.delta_t = t_array[2]
	#Graphical options
	if specific_axis_range: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = [x_axis_min, x_axis_max]
		graph.y_axis_array = [y_axis_min, y_axis_max]
	view.size.x = view.size.y * aspect_ratio
	graph.graph_color = graph_color
	graph.grid_lines = grid_lines
	#Starting
	graph.plotting_process = graph.plotting.ANIMATEDPLOT
	graph.animated_plotting = true
	graph._ready()
	pass

func animated_plot_lists(y_2d_list: Array, x_2d_list: Array): #Plotting two lists (x(t),y(t)) varying t with time
	if y_2d_list[0][0]==null: #Check if y_2d_list is a 2-dimensional array
		print("y_list is not a 2-d array")
		return
	if x_2d_list[0][0]==null: #Check if y_2d_list is a 2-dimensional array
		print("x_list is not a 2-d array")
		return
	graph.y_list = y_2d_list
	graph.x_list = x_2d_list
	graph.t_list = range(len(x_2d_list))
	if !specific_fps:
		fps = len(x_2d_list)
	graph.delta_t = 1./fps
	#Graphical options
	if specific_axis_range: #Checking if axis range is given
		graph.automatic_axis = graph.possible_axis.GIVENXY
		graph.x_axis_array = [x_axis_min, x_axis_max]
		graph.y_axis_array = [y_axis_min, y_axis_max]
	view.size.x = view.size.y * aspect_ratio
	graph.graph_color = graph_color
	graph.grid_lines = grid_lines
	#Starting
	graph.plotting_process = graph.plotting.ANIMATEDLISTPLOT
	graph.animated_plotting = true
	graph._ready()
	pass


####################
###             ####
###  Test Area  ####
###             ####
####################


#func my_function(max_val: float) -> Array:
	#var yl = []
	#var xl = []
	#var tl = []
	#var xl0 = []
	#var yl0 = []
	#for i in linspace(0.1,max_val,0.01):
		#tl = linspace(0,i,0.01)
		#xl0 = []
		#yl0 = []
		#for j in range(len(tl)):
			#xl0.append(sqrt(2)*sin(tl[j])**3)
			#yl0.append(-cos(tl[j])**3 - cos(tl[j])**2 + 2*cos(tl[j]))
		#xl.append(xl0)
		#yl.append(yl0)
	#return [xl,yl]

func _ready() -> void:
#	animated_plot((func(x,t): return cos(3*x + 4*t)*cos(4*x-3*t)).call, [0.1, 6*PI, 0.001], [0., 5., 0.01], [])
#	var x_test = linspace(0.,2*PI, 0.01)
#	var tl: Array = linspace(0,2*PI, 0.01)
#	plot_lists(my_function(tl)[0], my_function(tl)[1])
#	aspect_ratio = 1.
#	animated_plot_lists(my_function(2*PI)[1], my_function(2*PI)[0])
	pass
