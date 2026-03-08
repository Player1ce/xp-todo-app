## The References You Should Bookmark

These are the sources that will answer every question you'll have when customising this further:

**The authoritative source for ThemeData slots:**
`https://api.flutter.dev/flutter/material/ThemeData-class.html`
Every property is documented here. When you want to theme a new widget type, search this page for it.

**ColorScheme roles explained:**
`https://m3.material.io/styles/color/roles`
This explains what `primary`, `surface`, `onSurface` etc. semantically mean and which widgets use which role. Essential for understanding why changing one color affects many widgets.

**CupertinoThemeData reference:**
`https://api.flutter.dev/flutter/cupertino/CupertinoThemeData-class.html`

**WidgetStateProperty explained:**
`https://api.flutter.dev/flutter/widgets/WidgetStateProperty-class.html`

**Flutter cookbook — Themes:**
`https://docs.flutter.dev/cookbook/design/themes`
A shorter practical guide that complements the API reference well.

---

## The Mental Model to Carry Forward

Think of the theme file as having three layers:

``` text
AppColors / AppTextStyles     ← raw values, no Flutter dependency
AppMaterialTheme              ← maps values to Material widget slots  
AppCupertinoTheme             ← maps values to Cupertino widget slots
```

When you add a new widget to your app and want to control its appearance globally, the process is always the same — find its corresponding `*Theme` property in `ThemeData`, add it to `AppMaterialTheme`, and reference your `AppColors` constants. You never have to touch individual widgets to change the global appearance.
