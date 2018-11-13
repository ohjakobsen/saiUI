# Read me

saiUI is an extension to Shiny that let's you create beautiful layouts with a great user experience using the [Bootstrap 4](https://getbootstrap.com) framework. The package includes two layouts for Shiny apps. `saiPage` is a replacement for the `navbarPage` in Shiny. `saiDashboard` is an alternative to the dashboard layout for the package shinydashboard.

## Usage

```r
saiPage(title = 'saiPage',
  sidebarLayout(
    saiMenu(
      ## Sidebar items go here
    ),
    saiMain(
      ## Output items go here
    )
  )
)
```

## Differences from `navbarPage`

- `saiPage` includes the argument `color` to change the color of the navbar on the page
- `saiPage` includes tha argument `lang` to set the language attribute in HTML
- `saiPage` drops several arguments that are either deprecated in `navbarPage` or not relevant for Bootstrap 4. These include `collapsible`, `fluid` and `responsive`
- `tabPanel` has an extra agrument `hidden` to hide the button from the navbar

## Notes

saiUI should be loaded *after* the Shiny package to avoid namespace conflicts. saiUI masks `tabPanel` and `tabsetPanel` so that you can convert your `navbarPage`-apps more easily. To avoid namespace conflicts with Shiny, you can use either `saiUI::tabPanel` and `saiUI::tabsetPanel` or `saiTab` and `saiTabset` to specify the saiUI-functions.

saiUI should *not* be used together with [shinyWidgets](https://github.com/dreamRs/shinyWidgets) because of compatibility issues between Bootstrap 3 and 4.

saiUI replaces Font Awesome with [Open Iconic](https://useiconic.com/open/). Open Iconic is more lightweight than Font Awesome. If you need Font Awesome in your project, you can add it manually by including the Font Awesome files using `tags$head()`.

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

Bootstrap comes with the following colors:

- `primary`
- `secondary`
- `success`
- `danger`
- `warning`
- `info`
- `light`
- `dark`

These colors are available in most functions for UI elements, such as buttons, nav bars, cards and so forth.

You can replace the default Bootstrap theme when you define the app UI function. `saiPage` includes the `theme` argument where you can specify a CSS file to be inlcuded instead of the default theme. The CSS file should be placed inside the `www` directory in your app. For more information on Bootstrap theming, see [this page](https://themes.getbootstrap.com).
