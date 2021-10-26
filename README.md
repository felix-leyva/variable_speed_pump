# variable_speed_pump

A Flutter multiplatform app, for calculations of centrifugal pump unit curves

## About this app

This application supports pump engineers and solar project planners to select and size pump projects which have
variable speed or power operation parameters.
The app simulates operating pumps of pump units and their operation points which consists of:
- head
- flow
- speed (rpm)
- hydraulic power (bhp)
- pump end efficiency
- motor power
- motor efficiency
- motor efficiency at partial load
- combined pump unit efficiency at partial load
- required pump unit power at partial load

Through the use of the pump affinity laws the app generates from a base pump curve, variable speed pump curves with
multiple operation points.

Through the generation of various variable speed curves and Newton interpolation method, the app generates the pump
curves, based in a fixed head, considering the variation of power and the changes in flow and pump unit operation points.
This feature is required for the sizing of solar pump systems, where the available power of the pump varies depending
on the instant irradiation level and available power from the photovoltaic system.

This app is currently in development stage, but ultimately the goal is adding features to estimate for every kind of
centrifugal pump unit, the minimum amount of photovoltaic power to achive an specific hydraulic point and the minimum 
irradiation level based on that system.

Another useful feature to be added, is the capability to estimate based in a system curve, the optimal speed to achieve
energy savings. This is a requirement when analysing variable speed drives and their effects on currently installed
pump systems.

## Current available features

- Input of a centrifugal pump curve, with possibility to save or delete them
- Automatic charts displaying pump curve (flow / head) and efficiency curves
- Generation of a variable power pump curve based on standard centrifugal pump curves
- Modification of the specific head and automatic variable power pump curve generation
- Generation of variable speed pump curves based on standard centrifugal pump curves

## Features to be added
- Slider in variable speed curve module
- Input module of system curve to simulate power requirements and optimize energy with variable speed drivers
- Recommendation of installed photovoltaic power capacity based on latitud/longitude, month and average cumulative irradiation

Depending on the requested features, 
- A model that simulates a PV Module could be added to estimated the required amount of PV modules and the way they should be connected (min Vmp and max Voc). 
- The connection to an API which has irradiation data (NASA) based in location 