
# Need to use the polygons package
if (!require(polygons)) {
  devtools::install_github("USCBiostats/polygons")
  library(polygons)
}

if (!require(readr)) {
  devtools::install_github("hadley/readr")
  library(readr)
} 

# The plotting function
plot_predq <- function(
  x,
  y=NULL, 
  main = "Predicted v/s\nExpected Values",
  main.colorkey = "Probability of Functional Annotation",
  include.labels = NULL,
  labels.col = "black",
  ...) {
  
  y <- rep(1L, nrow(x$expected))
  
  # Should we draw the labels?
  if (!length(include.labels)) {
    if (nrow(x$expected) > 40) include.labels <- FALSE
    else include.labels <- TRUE
  }
  
  
  
  oldpar <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(oldpar))
  graphics::par(mar=c(6,0,3,0))
  
  # Sorting accordingly to predicted
  ord <- order(x$predicted)
  
  # Outer polygon
  piechart(
    y, border="transparent", col = "transparent", lwd=2,
    radius = 1.5,
    doughnut = .5, skip.plot.slices = TRUE
  )
  
  graphics::polygon(circle(0,0,1.5), border="gray", lwd = 1.5)
  graphics::polygon(circle(0,0,0.5), border="gray", lwd = 1.5)
  
  # Function to color the absence/presence of function
  blue <- function(x) {
    
    # Mapping the colors
    ans <- grDevices::colorRamp(c("steelblue", "lightgray", "darkred"))(x)
    grDevices::rgb(ans[,1], ans[,2], ans[,3], 200, maxColorValue = 255)
  }
  
  xold <- x
  
  # Range
  xran <- with(x, range(c(expected, predicted), na.rm = TRUE))
  
  x$predicted <- (x$predicted - xran[1])/(xran[2] - xran[1])
  x$expected  <- (x$expected - xran[1])/(xran[2] - xran[1])
  
  # Outer pie
  piechart(
    y,
    radius    = 1,
    doughnut  = .755,
    add       = TRUE,
    col       = blue(x$predicted[ord,]),
    border    = blue(x$predicted[ord,]), 
    lwd       = 1.5,
    slice.off = abs(x$predicted[ord, ] - x$expected[ord, ])/2
  )
  
  # Inner pie
  piechart(
    y,
    doughnut  = 0.5,
    radius    = .745,
    add       = TRUE,
    col       = blue(x$expected[ord, ]),
    border    = blue(x$expected[ord, ]),
    lwd       = 1.5,
    slice.off = abs(x$predicted[ord, ] - x$expected[ord, ])/2
  )
  
  # Labels
  if (include.labels) {
    deg <- 1:length(y)
    deg <- c(deg[1], deg[-1] + deg[-length(y)])/length(y)/2*360
    piechart(
      y,
      radius    = .5,
      add       = TRUE,
      border    = NA,
      labels    = rownames(x$expected)[ord],
      text.args = list(
        srt  = ifelse(deg > 270, deg,
                      ifelse(deg > 90, deg + 180, deg)),
        col  = labels.col, #c("white", "darkgray"),
        cex  = .7 - (1 - 1/k)*.5,
        xpd  = TRUE
      ),
      tick.len  = 0,
      segments.args = list(col="transparent"),
      skip.plot.slices = TRUE
    )
  }
  
  # graphics::polygon(circle(0, 0, r=.60), border = "black", lwd=1)
  graphics::text(0, 0, label=colnames(x$expected), font=2)
  
  
  # Drawing color key
  graphics::par(mfrow=c(1,1), new=TRUE, mar=c(3,0,3,0), xpd=TRUE)
  graphics::plot.new()
  graphics::plot.window(c(0,1), c(0,1))
  
  
  
  colorkey(
    .10, 0, .90, .05, 
    label.from = 'No function',
    label.to = "Function",
    cols = grDevices::adjustcolor(c("steelblue", "lightgray", "darkred"), alpha.f = 200/255),
    tick.range = xran,
    tick.marks = pretty(xran),
    nlevels = 200,
    main = main.colorkey
  )
  
  graphics::title(
    main= main, font.main=1
  )
  
}

