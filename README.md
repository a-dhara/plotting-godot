# plotting-godot
Make plots of data or functions for graphic visualization in godot.

## How to add

still working on the first part of the process

## Plotting Methods

After adding the GdPlotting Node to the tree you can just reference the node to use its methods in order to plot graphics on the plotting space

### plot(func, x_array:[x_min, x_max, delta_x])
plot a function f(x) along x-axis varying from x_min to x_max with step delta_x

func: Callable;
the function of one variable you want to plot

-x_array: Array of the form [x_min, x_max, delta_x];
-x_min: float;
-x_max: float;
-delta_x: float;

### plot_lists(y_list, x_list)
plot two lists in the form of points (x,y) wich will be drawn as a function on the plane

-y_list: Array;
-x_list: Array;

### animated_plot(func, x_array, t_array)
plot a function f(x,t) along the x-axis varying t with time

-func: Callable (2 variables);
-t_array: Array of the form [t_min, t_max, delta_t];
-t_min: float;
initial value for t
-t_max: float;
final value for t
-delta_t: float;
step for the t variable. Also used as the time each frame is shown on the animation by default
-x_array: Array in the same form as t_array;

### animated_plot_lists(y_2d_list, x_2d_list)
plot two 2-dimensional lists in the form of points (x(t), y(t)) both varying with t, wich shall be interpreted as draws in the (x,y) plane.

-x_2d_list: 2-d Array;
interpreted in the form [[x1(t1), x2(t1), ..., xn(t1)],[x1(t2), ..., xn(t2)], ..., [x1(tm), ..., xn(tm)]] with x length not necessarily the same.
-y_2d_list: 2-d Array;
same as x_2d_list


## Graphic Options

### specific_axis_range: bool
if true, one shall specify the shown square of the (x,y) plane wich is shown on the screen by the variables:
x_axis_min, x_axis_max, y_axis_min, y_axis_max.

### aspect_ratio: float
the screen aspect wich the graphic is stretched to fill. 16/9 by default. Changes the viewport x-size. If set to 1 the shown graphic is on a square shape.

### specific_fps: bool
if set to true, one shall specify the wanted frames per second on the 'fps' variable. If not, it is set to 1 by default.

### grid_lines: bool
true by default. Shows grid lines along the background of the graphic.

### graph_color: Color
color of the drawn graph line. Set to Color.ROYAL_BLUE by default.


