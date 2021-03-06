# UnicodePlots

Advanced Unicode plotting library designed for use in Julia's REPL.

[![Build Status](https://travis-ci.org/Evizero/UnicodePlots.jl.svg?branch=master)](https://travis-ci.org/Evizero/UnicodePlots.jl)

## Installation

There are no dependencies on other packages. Developed for Julia v0.3 and v0.4

```Julia
Pkg.add("UnicodePlots")
using UnicodePlots
```

## High-level Interface

There are a couple of ways to generate typical plots without much verbosity. These are the four main high-level functions for typical scenarios:

  - Scatterplot
  - Lineplot
  - Barplot (horizontal)
  - Staircase Plot

Here is a quick hello world example of a typical use-case:

```Julia
myPlot = lineplot([1, 2, 3, 7], [1, 2, -1, 4], color=:red, title="My Plot")
drawLine!(myPlot, 1., -1., 7., 2., :blue)
annotate!(myPlot, :r, 2, "red  ... Curve 1")
annotate!(myPlot, :r, 4, "blue ... Curve 2")
```

![Basic Canvas](doc/img/hello_world.png)


#### Scatterplot

Creates a new scatter plot (point cloud), centers it on the given data points, and returns the new plot.

```Julia
scatterplot([1,2,5], [9, -1, 3], title = "My Scatterplot")
```
![Scatterplot Screenshot](doc/img/scatter.png)

#### Lineplot

Accepts two numerical vector. The function will draw the line in the order of the given elements

```Julia
lineplot([1,2,5], [9, -1, 3], title = "My Lineplot", width = 50)
```
![Lineplot Screenshot1](doc/img/line.png)

It's also possible to specify a function and a range.

```Julia
lineplot(sin, 1:.5:10, color = :green)
```
![Lineplot Screenshot2](doc/img/sin.png)

Granted, the labels could be better :-)

#### Barplot

Accepts either two vectors or a dictionary

![Barplot Screenshot](doc/img/barplot.png)

#### Staircase plot

Accepts two vectors

```Julia
stairs([1, 2, 4, 7, 8], [1, 3, 4, 2, 7])
```
![Staircase Screenshot](doc/img/stairs.png)

### Options

All plots support a common set of named parameters

- `title::String = ""`:

    Text to display on the top of the plot.

- `width::Int = 40`:

    Number of characters per row that should be used for plotting.
    
    ```Julia
    lineplot(sin, 1:.5:20, width = 80)
    ```
    ![Width Screenshot](doc/img/width.png)

- `height::Int = 10`:

    Number of rows that should be used for plotting. Not applicable to `barplot`.

    ```Julia
    lineplot(sin, 1:.5:20, height = 18)
    ```
    ![Height Screenshot](doc/img/height.png)

- `margin::Int = 3`:

    Number of empty characters to the left of the whole plot.

- `border::Symbol = :solid`:

    The style of the bounding box of the plot. Supports `:solid`, `:bold`, `:dashed`, `:dotted`, and `:none`.

  ```Julia
  lineplot([-1.,2, 3, 7], [1.,2, 9, 4], border=:bold)
  lineplot([-1.,2, 3, 7], [1.,2, 9, 4], border=:dashed)
  lineplot([-1.,2, 3, 7], [1.,2, 9, 4], border=:dotted)
  lineplot([-1.,2, 3, 7], [1.,2, 9, 4], border=:none)
  ```
    ![Border Screenshot](doc/img/border.png)

- `padding::Int = 1`:

    Space of the left and right of the plot between the labels and the canvas.

- `labels::Bool = true`:

    Can be used to hide the labels.

  ```Julia
  lineplot(sin, 1:.5:20, labels=false)
  ```
    ![Labels Screenshot](doc/img/labels.png)

- `color::Symbol = :blue`:

    Color of the drawing. Can be any of `:blue`, `:red`, `:yellow`

_Note_: If you want to print the plot into a file but have monospace issues with your font, you should probably try `border=:dotted`.

### Methods

The method `annotate!` is responsible for the setting all the textual decorations of a plot. It has two functions:

- `setTitle!{T<:Canvas}(plot::Plot{T}, title::String)`

    - `title` the string to write in the top center of the plot window. If the title is empty the whole line of the title will not be drawn

- `annotate!{T<:Canvas}(plot::Plot{T}, where::Symbol, value::String)`

    - `where` can be any of: `:tl` (top-left), `:tr` (top-right), `:bl` (bottom-left), `:br` (bottom-right)

- `annotate!{T<:Canvas}(plot::Plot{T}, where::Symbol, row::Int, value::String)`

    - `where` can be any of: `:l` (left), `:r` (right)

    - `row` can be between 1 and the number of character rows of the canvas

![Annotate Screenshot](doc/img/annotate.png)

## Low-level Interface

The primary structures that do all the heavy lifting behind the curtain are subtypes of `Canvas`. A canvas is a graphics object for rasterized plotting. Basically it uses Unicode characters to represent pixel.

Here is a simple example:

```Julia
canvas = BrailleCanvas(40, 10, # number of columns and rows (characters)
                       plotOriginX = 0., plotOriginY = 0., # position in virtual space
                       plotWidth = 1., plotHeight = 1.) # size of the virtual space
drawLine!(canvas, 0., 0., 1., 1., :blue)    # virtual space
setPoint!(canvas, rand(50), rand(50), :red) # virtual space
drawLine!(canvas, 0., 1., .5, 0., :yellow)  # virtual space
setPixel!(canvas, 5, 8, :red)               # pixel space
```

![Basic Canvas](doc/img/canvas.png)

As you can see, one issue that arises when multiple pixel are represented by one character is that it is hard to assign color. That is because each of the "pixel" of a character could belong to a different color group (each character can only have a single color). This package deals with this using a color-blend for the whole group.

![Blending Colors](doc/img/braille.png)

At the moment there is one type of Canvas implemented:

  - **BrailleCanvas**:
    This type of canvas is probably the one with the highest resolution for Unicode plotting. It essentially uses the Unicode characters of the [Braille](https://en.wikipedia.org/wiki/Braille) symbols as pixel. This effectively turns every character into 8 pixels that can individually be manipulated using binary operations.


## Todo

- [ ] Better rounding for labels
- [x] Color support for `lineplot` and `scatterplot`
- [x] Improve documentation
- [x] Screenshots for all different plot options (e.g. border)
- [ ] Animated plots using cursor movement
- [ ] Refactor barplot to the new API
- [ ] Animated sparklines using cursor movement
- [ ] 4x4-block-canavs as preparation for histograms
- [x] Color cleanup: standard to white, no explicit color for border
- [ ] Add canvas for 2d density plots
- [ ] Add heatmaps and hinton diagrams

## License

This code is free to use under the terms of the MIT license.

## Acknowledgement

Inspired by [TextPlots.jl](https://github.com/sunetos/TextPlots.jl), which in turn was inspired by [Drawille](https://github.com/asciimoo/drawille)
