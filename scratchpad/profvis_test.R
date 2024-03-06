library(profvis)

devtools::load_all()
## basic example code

library(randomForest)
library(palmerpenguins)
library(dplyr)
library(tidyr)

set.seed(145)
train_data <- penguins |> 
  drop_na() |>
  select(bill_length_mm: body_mass_g, species) |>
  slice_sample(prop = 0.8)

rf_model <- randomForest(species ~ ., data = train_data)

model_func <- function(model, data) {
  return(predict(model, data))
}

system.time({
  final_bounds <- make_anchors(
  rf_model,
  dataset = train_data,
  cols = train_data |> select(bill_length_mm:body_mass_g) |> colnames(),
  instance = seq(10),
  model_func = model_func,
  class_col = "species",
  verbose = FALSE
)
})
profvis({
  final_bounds <- make_anchors(
    rf_model,
    dataset = train_data,
    cols = train_data |> select(bill_length_mm:body_mass_g) |> colnames(),
    instance = 1,
    model_func = model_func,
    class_col = "species",
    verbose = FALSE
  )
})
