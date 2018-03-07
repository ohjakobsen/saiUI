# Read me

saiUI is a replacement for the `navbarPage` in the `shiny` package. saiUI includes the new [Bootstrap 4](https://getbootstrap.com) framework and replaces Font Awesome with [Open Iconic](https://useiconic.com/open/).

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

* `tabPanel` has an extra parameter to hide the button from the navbar

## Notes

saiUI should be loaded *after* the Shiny package to avoid namespace conflicts. saiUI masks `tabPanel` and `tabsetPanel` so that you can convert your `navbarPage`-apps more easily. To avoild namespace conflicts, either use `saiUI::tabPanel` and `saiUI::tabsetPanel` or `saiTab` and `saiTabset`.
