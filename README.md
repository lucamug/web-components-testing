# web-components-testing

```
npm install
cmd/start-with-virtual-dom-testing
```

Note: The issue has been fixed. See [https://github.com/lydell/virtual-dom/commit/2c1f34f23440420dc571ff1ba1bf5bd588eb3d28](https://github.com/lydell/virtual-dom/commit/2c1f34f23440420dc571ff1ba1bf5bd588eb3d28).

## To recreate the issue

Check out the branch `main-old`

Press:

* Step 1 - Hide all
* Step 2 - Show only one Web Component

The interface stop working.

Reload the page.

Press:

* Toggle "Replicate the issue" to turn it to `False`
* Step 1 - Hide all
* Step 2 - Show only one Web Component

The interface works fine.

The issue seems a combination of the unmounting feature and the use of a `none` function instead of `Html.text ""`.

The logic to enable/disable the replication of the issue is

```elm
else if model.replicateTheIssue then
    none

else
    Html.text ""
```

Where `none` is defined as

```elm
none : Html.Html msg
none =
    Html.text ""
```

The other way to fix the issue is to replace `View.none` with `Html.text ""` in the unmounting logic in the `view` section of the `main` function.

```
    ...
    , view =
        \maybeModel ->
            case maybeModel of
                Just model ->
                    View.view model

                Nothing ->
                    -- Replace this with `Html.text ""` to fix the issue
                    View.none
    ...
```

