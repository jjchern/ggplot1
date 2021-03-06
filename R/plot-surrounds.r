# Pretty plot
# Build a plot with all the usual bits and pieces.
#
# As well as the plotting area, a plot need:
#  \item main title
#  \item x and y axis labels
#  \item space for legends (currently on the right hand side)
#
# These are stored as options in the plot object.
#
# This function sets up the appropriate viewports and packs the
# various components in.  The viewport is set up so that each component
# will only take up the amount of space that it requires.
#
# @arguments plot
# @arguments plot grob
# @keyword hplot
prettyplot <- function(plot, plotgrob) {
	position <- plot$legend.position
	if (length(position) == 2) position <- "manual"
	horiz <- any(c("top", "bottom") %in% position)
	vert <-  any(c("left", "right") %in% position)

	legend <- if (position != "none") legends(plot$scales, horiz) else NULL
	if (is.null(legend)) position <- "none"

	gp <- gpar(fill=plot$background.fill, col=plot$background.colour)

	if (plot$title == "") plot$title <- NULL
	title <- textGrob(plot$title, gp=gpar(cex=1.3, col=plot$background.colour), just=c("centre", "centre"), name="title")
	xlabel <- textGrob(plot$xlabel, just=c("centre", "centre"), gp=gp, name="xlabel")
	ylabel <- textGrob(plot$ylabel, rot=90, just=c("centre", "top"), gp=gp, name="ylabel")

	widths <- switch(position,
		right =  unit.c(unit(1, "strheight", "ylabel"), unit(1, "null"), unit(1, "grobwidth", legend)),
		left =   unit.c(unit(1, "grobwidth", legend), unit(2, "grobwidth", ylabel), unit(1, "null")),
		top =    ,
		bottom = ,
		manual = ,
		none =   unit.c(unit(2, "grobwidth", ylabel), unit(1, "null"))
	)
	heights <- switch(position,
		top =    unit.c(unit(2, "grobheight", title), unit(1, "grobheight", legend), unit(1, "null"), unit(3, "grobheight", xlabel)),
		bottom = unit.c(unit(2, "grobheight", title), unit(1, "null"), unit(2, "grobheight", xlabel), unit(1, "grobheight", legend)),
		right =  ,
		left =   ,
		manual = ,
		none =   unit.c(unit(2, "grobheight", title), unit(1, "null"), unit(2, "grobheight", xlabel))
	)

	layout <- grid.layout(length(heights), length(widths), widths=widths, heights=heights)

	lf <- frameGrob(layout, "plot-surrounds")
	lf <- placeGrob(lf, rectGrob(gp=gpar(fill=plot$background.fill, col=NA), name="background"), row=1:length(heights), col=1:length(widths))

	if (position == "right") {
		lf <- placeGrob(lf, plotgrob, row=2,   col=2)
		lf <- placeGrob(lf, legend, row=2, col=3)
		lf <- placeGrob(lf, ylabel,  row=2,   col=1)
		lf <- placeGrob(lf, xlabel,  row=3,   col=2)
		lf <- placeGrob(lf, title,  row=1,   col=2)
	} else if (position == "left") {
		lf <- placeGrob(lf, plotgrob, row=2,   col=3)
		lf <- placeGrob(lf, legend, row=2, col=1)
		lf <- placeGrob(lf, ylabel,  row=2,   col=2)
		lf <- placeGrob(lf, xlabel,  row=3,   col=3)
		lf <- placeGrob(lf, title,  row=1,   col=3)
	} else if (position == "top") {
		lf <- placeGrob(lf, plotgrob, row=3,   col=2)
		lf <- placeGrob(lf, legend, row=2, col=2)
		lf <- placeGrob(lf, ylabel,  row=3,   col=1)
		lf <- placeGrob(lf, xlabel,  row=4,   col=2)
		lf <- placeGrob(lf, title,  row=1,   col=2)
	} else if (position == "bottom") {
		lf <- placeGrob(lf, plotgrob, row=2,   col=2)
		lf <- placeGrob(lf, legend, row=4, col=2)
		lf <- placeGrob(lf, ylabel,  row=2,   col=1)
		lf <- placeGrob(lf, xlabel,  row=3,   col=2)
		lf <- placeGrob(lf, title,  row=1,   col=2)
	} else {
		lf <- placeGrob(lf, plotgrob, row=2,   col=2)
		lf <- placeGrob(lf, ylabel,  row=2,   col=1)
		lf <- placeGrob(lf, xlabel,  row=3,   col=2)
		lf <- placeGrob(lf, title,  row=1,   col=2)
		if (position == "manual") {

			leg <- gTree(
				children=gList(legend),
				vp=viewport(x=coords[1], y=coords[2], just=plot$legend.justification, width=grobWidth(legend), height=grobHeight(legend))
			)
			lf <- placeGrob(lf, leg, row=2, col=2)
		}

	}

	lf
}
