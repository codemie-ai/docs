# How do I set the cover image of a hosted application?

Each application card takes the first cover that is available:

1. The image uploaded in the **Cover** field: PNG, JPEG, or WebP, up to 1 MiB and 2048 px per side.
2. A PNG, JPEG, or WebP file in the ZIP archive whose name starts with `preview`, `thumbnail`, `screenshot`, `cover`, or `poster`, up to 1 MiB and 1 megapixel (for example, `preview.png` at 1280 × 800).
3. An automatic picture of the start page, taken by CodeMie when the version passes validation.
4. The initials of the application name.

To use a specific image, upload it in the **Cover** field or include it in the ZIP archive. Without one, the card shows the automatic picture. Pages that use WebGL give a blank picture, so add a cover image for them.

## Sources

- [Hosted Applications](https://docs.codemie.ai/user-guide/applications/hosted-applications/)
