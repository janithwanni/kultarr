% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tour_vis.R
\name{anchor_tour}
\alias{anchor_tour}
\title{Data structure to hold information necessary to animate tours}
\usage{
anchor_tour(b_boxes, data, point_colors, point_shapes = 1, point_sizes = 1)
}
\arguments{
\item{b_boxes}{S7 object of type boundary boxes}

\item{data}{data.frame of points to visualize on tours}

\item{point_colors}{Character vector of one or nrow(data)}

\item{point_shapes}{Numeric vector of one or nrow(data) containing shape number. Defaults to hollow (i.e. 1)}

\item{point_sizes}{Numeric vector of one or nrow(data) containing size. Defaults to 1}
}
\description{
Data structure to hold information necessary to animate tours
}
