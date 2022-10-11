saiUI 0.7.3
===============

* It's now possible to set min and max width on modals to override default Bootstrap widths with the arguments `minwidth` and `maxwidth`
* Toast will not show on top of modals

saiUI 0.7.2
===============

* `headerContent()` and `footerContent()` now supports hexadecimal colors in addition to Bootstrap colors
* New argument `wrapper` `headerContent()` and `footerContent()`. If set to `FALSE`, the content will not be wrapped in a paragraph tag
* Bugfix: properly import `stats::runif()`

saiUI 0.7.1
===============

* Bugfix: Add fixed positioning of the toast wrapper so that it always sticks to the top of the page. This avoids toasts getting out of view when the user scrolls past the top of the page

saiUI 0.7.0
===============

## Full changelog

### Breaking changes

* `bs4ModalDialog()` and `bs4ModalButton()` now masks the equivolent Shiny functions `modalDialog` and `modalButton`. This should not break any functionality from the Shiny functions, but to ensure compability with the Shiny functions, the `text` argument to `bs4ModalButton()` has been renamed `label`
* Using the `classes` argument in `dashboardCard()` will now issue a warning (argument will be removed in next release)
* `dropdownMenu()` has been renamed `dropdownInput()`
* Shiny 1.4.0 or higher (in order to use jQuery 3) and htmltools 0.4.0 or higher is now required

### New features

* Added support for toast notifications. `saiPage()` and `saiDashboard()` gain a new argument `notifications` to enable toast notifications independent on the selected tab. Toast notifications are enabled by default.
* Send new toast notifications to the UI with `sendToast()`
* New function `createIcon()` that extends the `icon` function in Shiny. Input functions have been updated to use the now icon function. `createIcon()` supports Open Iconic (the default library in saiUI) and Font Awesome Free (included in Shiny). Note that Glyphicons is not supported as the library has been removed from Bootstrap 4
* Added support for `navlistPanel()` with Bootstrap 4 card layout for the panel (replaces the well style from Bootstrap 3)
* New layout function `fullpageLayout()`

### Improvements

* `bs4ModalButton()` now supports a `color` and a `size` argument
* Update to Bootstrap 4.6.1 and Popper.js 1.16.1
* `actionButton()` now supports a `class` argument for adding addtional CSS classes to a button
* `downloadButton()` now properly handles the `class` argument
* Minor performance improvements
* Default HTML template now supports adding JS scripts to the page footer

### Bugfixes

* Classes set in `tabPanel()` function will not be overwritten for active tabs in `saiPage()`
* Single dependencies given to the `deps` argument in `bs4Page()` will now be correctly recognised
* Themes now render _after_ other styles have been added to the header
* Fixed logical checks in `dep` argument in `bs4Page()`

saiUI 0.6.0
===============

This release fixes several outstanding issues and brings improvement to performance and improved UI functions.

## Full changelog

### Breaking changes

* R version 3.5.0 or higher and shiny version 1.2.0 or higher are now required.
* `bs4Lib()` now requires a boolean value for the `theme` argument.

### New features

* New functions to add [Bootstrap 4 modals](https://getbootstrap.com/docs/4.3/components/modal/).
* New function `bs4Dropdown()` to create a dropdown with arbitrary UI elements
* Added ability to change text direction for the `html` element with the new `dir` argument to `bs4Page()`.

### Improvements

* Changes to how custom themes are added. Themes will be loaded before any dependencies by adding them directly in the HTML template. The theme argument now also supports objects of type `html_dependency`.
* `saiDashboard()` gains a `theme` argument.
* Changes to how dependency files are loaded into saiUI. Files are only loaded with the `htmlDependency()` function, and not using `addResourcePath()` on package load.
* Improved html markup on `saiPage()` using flexbox to fill the page if footer is present.
* New arguments `center` and `small` in `footerContent()` to allow for centered text and smaller font size.
* New argument `searchAsYouType` to `searchboxInput()` to control if input value should be sent to Shiny while the user is typing or not. Defaults to `TRUE` (the old behavior)
* Clear button in `searchboxInput()` will now be removed if the search string is empty.
* Finally updated the `searchboxInput()` binding methods so that they properly identify the input field and enforce new rate policies depending on the settings on the input
* SASS files are now up to date
* Performance improvments to most HTML-generating functions

### Bugfixes

* Removed `href` attribute from anchor elements in `dropdownMenu()` (and added `role` and `tabindex` attributes) to prevent the page from scrolling to the top when an option is selected.
* Updated subscribe and unsubscribe methods for all input bindings so that they work properly
* Updated bindings and custom functions for `toggleButton()`. We now listen to a change event instead of a click event to allow the relevant JS-functions to change the attribute values before they are sent to Shiny.
* Additional classes are now properly added to `cardGroup()`.

saiUI 0.5.2
===============

* New clear button for all search inputs that works on all modern browsers
* Bugfix: Fix button size when `searchboxInput()` is set to size `sm`
* Bugfix: Removed the `min-width` rule from `.shiny-input-container` as it could create havoc on small screens or small containers
* Bugfix: Added specificity to `.shiny-input-container` rules to override Shiny behavior without the need for `!important` so that the `width` parameter can be used with input functions

saiUI 0.5.1
===============

* Added function `updateSlicerInput()` and support for receiving messages from the server so that slicer inputs can be updated from the server script
* CSS-adjustments to `searchboxInput()`
* Performance adjustments to `actonButton()` and `downloadButton()`
* Removed `position` argument from `saiTabset()`

saiUI 0.5.0
===============

This release updates Bootstrap to version 4.3.1 and include several bugfixes for running on Shiny server.

## Full changelog

* Update to Bootstrap 4.3.1.
* New function `switchInput()` that uses the new custom switch class available in Bootstrap 4.2+.
* Better mobile support for dashboard pages.
* Adds `data-target` attribute to anchor elements in `saiPage()`, `dashboardPage()`, and `tabsetPanel()` to fix issue with `shiny-server-client.js` on Shiny Server
* `bs4Embed()` now properly supports the `type` argument, and adds `embed` as a new valid type
* Changed `color` argument to accept any value in inputs (to better support Bootstrap themes).
* Added `class` argument to `cardGroup()`
* Argument `classes` is deprecaed in `dashboardCard()`. Use `class` instead
* `saiLib` is renamed `bs4Lib()`.
* Bugfix: Added html template in order for the `lang` attribute to be properly added to the `html` tag
* Bugfix: `id` can now be properly assigned to the navbar in `saiPage()`.

saiUI 0.4.0
===============

This release add new UI elements and functions to more easily use Bootstrap 4 features. In addition, we have added examples and documentation to the package.

## Full changelog

* New UI function `bs4Alert()` to create Bootstrap 4 alerts.
* New UI function `bs4Embed()` to create responsive embeds using Bootstrap 4.
* Added `singlePage()` as an alternative to `fluidPage` for a simple Bootstrap 4 page without a navbar.
* Improved layout of search button in `searchboxInput()`.
* New layout functions for flex rows and columns in Bootstrap 4.
* Default color for `slicerInput()` is now `primary`.
* Update to Bootstrap 4.1.3
* Update to Popper.js 1.14.6
* Added example apps to `inst/examples`.
* Added more documentation.

saiUI 0.3.3
===============

* New functions `cardNav()` and `cardNavItem()` to support cards with Bootstrap's nav component in the header
* Minor bugfixes for the documentation

saiUI 0.3.2
===============

* `slicerInput()` now supports named vectors as input choices
* Bugfix where value of `slicerInput()` would not be sent to Shiny if multiple == `FALSE`

saiUI 0.3.1
===============

* `saiDashboard()` now supports restore feature in `shiny`
* Ability to select a different default panel in `saiDashboard()` with the `selected` parameter
* New functions `dashboardCard()` and `cardGroup()` to create Bootstrap style cards and group of cards. See the [Bootstrap documentation](https://getbootstrap.com/docs/4.3/components/card/)
* Tabs in navbar on `saiPage()` can now be hidden by default
* Wrapper for `helpText()` with update to BS4 (class `help-block` deprecated in BS4)

saiUI 0.3.0
===============

* New input function `toggleButton()` that returns a boolean value depending on button state
* New input function `slicerInput()` that creates a set of small buttons that can act as a filter for datasets. Returns a vector with values for all buttons that are active. Supports single value or multiple values. `NULL` values are also supported (no active buttons).
* New function for `downloadButton()` to mask the original `shiny` button
* New function for `fileInput()` to mask the original `shiny` function
* Added option for outlined buttons for all button inputs. Defaults to `FALSE` for `actionButton()` and `downloadButton()` and to `TRUE` for `inputSearchbox()` and `toggleButton()`
* New functions to add text to header and footer of a `saiPage()` layout
* Added language attribute to `html` tag
* `sidebarLayout()` now supports the `position` argument
* `display: flex` is now enforced for `searchboxInput()` with added class `d-flex`
* Better compliance with web accessibility requirements
* Better support for restoring app state if bookmarking is enabled
* Better handling of color option on `saiMenu()`
* Better documentation of original and masked functions

saiUI 0.2.0
===============

* New layout for interactive dashboards available with the function `saiDashboard()`. See `?saiDashboard` for more information
* Update to Bootstrap 4.1.1
* Added `sidebarLayout()` function that masks the Shiny function
* Bootstrap `rows` are now wrapped in either `container` or `container-fluid` elements
* Parameter `width` is now deprecated from `singlePage()`. Replaced with new `fluid` parameter

saiUI 0.1.3
===============

Initial public release. This is the inital public release of `saiUI`.
