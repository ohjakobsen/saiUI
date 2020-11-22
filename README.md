# Read me

saiUI is an extension to Shiny that let's you create beautiful layouts with a great user experience using the [Bootstrap 4](https://getbootstrap.com) framework. The package replaces the Bootstrap 3 files with the new Bootstrap 4 framework. The package introduces new functions for creating user interfaces that are compatible with Bootstrap 4.

There are three main layouts included in saiUI. `singlePage` creates a simple Bootstrap 4 layout with a fluid container. It is an alternative to `fluidPage` from the Shiny package. `saiPage` is meant as a replacement for `navbarPage` in Shiny. It is built so that you can convert a navbar page to Bootstrap 4 with minimal changes to the code. Because of this, saiUI is *not* compatible with `navbarPage`. The other layout -  `saiDashboard` - is an alternative to the dashboard layout for the package [shinydashboard](https://github.com/rstudio/shinydashboard) using a custom Bootstrap 4 layout.

## Navbar page

### Usage

```r
saiPage(
  title = 'saiPage',
  sidebarLayout(
    saiMenu(
      # Sidebar items go here
    ),
    saiMain(
      # Output items go here
    )
  )
)
```

### Differences from `navbarPage`

- `saiPage` includes the argument `color` to change the color of the navbar on the page
- `saiPage` includes the argument `lang` to set the language attribute in HTML
- `saiPage` drops several arguments that are either deprecated in `navbarPage` or not relevant for Bootstrap 4. These include `collapsible`, `fluid` and `responsive`
- `tabPanel` has an extra argument `hidden` to hide the button from the navbar

## Dashboard page

```r
saiDashboard(

  title = 'Title of page',
  brand = 'Brand',
  color = 'dark',

  dashboardPanel(
    # Put elements in here
  )

)
```

## UI elements

saiUI includes functions to create UI elements based on the Bootstrap 4 framework. The functions makes it easy to build complex UI elements.

### Cards

Cards is a flexible and extensible content container. It includes options for headers and footers, a wide variety of content, contextual background colors, and powerful display options. For Shiny development, cards are particulary useful for dashboards or to highlight results from data analysis. Cards can be be created with the function `dashboardCard`, and can be grouped together with the function `cardGroup`.

```r
cardGroup(
  dashboardCard(
    header = 'This is the header',
    list(
      tags$h5('This is a title'),
      p('We add content here')
    )
  ),
  dashboardCard(
    header = 'This is the header',
    list(
      tags$h5('This is a title'),
      p('We add content here')
    )
  )
)
```

## Bootstrap theme

### Colors

Bootstrap 4 comes with the following default colors:

- `primary`
- `secondary`
- `success`
- `danger`
- `warning`
- `info`
- `light`
- `dark`

You can specify the color in most functions that create UI or input elements, such as buttons, nav bars, cards and so forth. Several standard inputs from the Shiny package have been masked to add extra arguments to adjust the appearance of the element.

If you use a custom theme, more colors might be available to you. The `color` argument in input and UI functions support any value, so you can easily use other colors if they are available in your theme, and the correct CSS classes will be added. For example, if you specify `warning` as the color argument for a button, the CSS class `btn-warning` will be added to the button.

For more information on colors in Bootstrap, refer to [the Bootstrap documentation](https://getbootstrap.com/docs/4.3/getting-started/introduction/).

### Replace theme

You can replace the default Bootstrap theme when you define the app UI function. `saiPage()` and `saiDashboard()` includes the `theme` argument where you can specify a CSS file to be included instead of the default theme. The CSS file should reside inside the `www` directory in your app. For more information on Bootstrap theming, see [this page](https://themes.getbootstrap.com).

Your custom theme **must be compatible with Bootstrap 4**. If you want to use a Bootstrap 3 theme, you should not load saiUI, but rather use the default functions in Shiny together with the corresponding `theme` argument.

## Notes

saiUI depends on the Shiny package and will load it by default. Note that saiUI masks several functions from Shiny in order to make it easier to transition from Shiny to saiUI, and to avoid adding unnecessary function names for functions that do exactly the same as the Shiny equivalent, i.e. an `actionButton` should still be an `actionButton`.

saiUI should be loaded *after* the Shiny package to avoid namespace conflicts. saiUI masks `tabPanel` and `tabsetPanel` so that you can convert your `navbarPage`-apps more easily. To avoid namespace conflicts with Shiny, you can use either `saiUI::tabPanel` and `saiUI::tabsetPanel` or `saiTab()` and `saiTabset()` to specify the saiUI-functions.

saiUI **should not be used together with [shinyWidgets](https://github.com/dreamRs/shinyWidgets)** because of compatibility issues between Bootstrap 3 and 4, and incompatibility with saiUI itself. saiUI includes UI and input elements that replicate functions available in shinyWidgets, using built-in elements in Bootstrap 4. For example, you can use `switchInput()` as an alternative to `checkboxInput()` from Shiny, and a better alternative than than the functions included in shinyWidgets.

saiUI replaces Font Awesome with [Open Iconic](https://useiconic.com/open/). Open Iconic is more lightweight than Font Awesome. If you need Font Awesome in your project, you can add it manually by including the Font Awesome files using `tags$head()`.

## Copyright and license

saiUI is copyright Riksrevisjonen. saiUI is released under the MIT license. The saiUI package is distributed with other open source projects:

* [Bootstrap 4](https://getbootstrap.com)
* [Popper.js](https://popper.js.org)
* Open Iconic

See more under [license](LICENCE.md).
