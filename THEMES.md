# Themes

The document may be compiled using either or both

* the *light theme* (black text on white paper),
* the *dark theme* (white text on black paper).

## Light theme (default)

If you want to include the university and faculty logos, name them `logos/tum-black.pdf` and `logos/faculty-black.pdf`.
The logos themselves do not have to be black, of course.
You can use the blue logos too, but do not change the file names.

## Dark theme (optional)

To compile using the dark theme, append `jobname=dark` to the `make` call.
If you want to include the university and faculty logos, name them `logos/tum-white.pdf` and `logos/faculty-white.pdf`.

## Commands

You can use the commands `\bg` and `\fg` throughout the document to access the *background* and *foreground* colors.
Their default values are `white`/`black` for the light theme and `black`/`white` for the dark theme.
Feel free to change them in `settings.tex`.

