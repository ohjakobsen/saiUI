saiUI 0.3.3
===============

* New functions `cardNav` and `cardNavItem` to support cards with Bootstrap's nav component in the header
* Minor bugfixes for the documentation

saiUI 0.3.2
===============

* `slicerInput` now supports named vectors as input choices
* Bugfix where value of `slicerInput` would not be sent to Shiny if multiple == `FALSE`

saiUI 0.3.1
===============

* `saiDashboard` now supports restore feature in `shiny`
* Ability to select a different default panel in `saiDashboard` with the `selected` parameter
* New functions `dashboardCard` and `cardGroup` to create Bootstrap style cards and group of cards. See the [Bootstrap documentation](https://getbootstrap.com/docs/4.1/components/card/)
* Tabs in navbar on `saiPage` can now be hidden by default
* Wrapper for `helpText` with update to BS4 (class `help-block` deprecated in BS4)

saiUI 0.3.0
===============

* New input function `toggleButton` that returns a boolean value depending on button state
* New input function `slicerInput` that creates a set of small buttons that can act as a filter for datasets. Returns a vector with values for all buttons that are active. Supports single value or multiple values. `NULL` values are also supported (no active buttons).
* New function for `downloadButton` to mask the original `shiny` button
* New function for `fileInput` to mask the original `shiny` function
* Added option for outlined buttons for all button inputs. Defaults to `FALSE` for `actionButton` and `downloadButton` and to `TRUE` for `inputSearchbox` and `toggleButton`
* New functions to add text to header and footer of a `saiPage` layout
* Added language attribute to `html` tag
* `sidebarLayout` now supports the `position` argument
* `display: flex` is now enforced for `searchboxInput` with added class `d-flex`
* Better compliance with web accessibility requirements
* Better support for restoring app state if bookmarking is enabled
* Better handling of color option on `saiMenu`
* Better documentation of original and masked functions

saiUI 0.2.0
===============

* New layout for interactice dashboards available with the function `saiDashboard()`. See `?saiDashboard` for more information
* Update to Bootstrap 4.1.1
* Added `sidebarLayout()` function that masks the Shiny function
* Bootstrap `rows` are now wrapped in either `container` or `container-fluid` elements
* Parameter `width` is now deprecated from `singlePage()`. Replaced with new `fluid` parameter

saiUI 0.1.3
===============

Initial public release. This is the inital public release of `saiUI`.
