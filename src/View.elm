module View exposing (none, view)

import Html
import Html.Attributes
import Types


view : Types.Model -> Html.Html Types.Msg
view model =
    -- "btn01" -> Show with nested component
    -- "btn02" -> Show without nested component
    -- "btn03" -> Hide
    if model.flags.webComponentType == "web-component-01" then
        if model.attr == "btn01" then
            let
                _ =
                    Debug.log "xxx" "Rendering web component WITH nested web component"
            in
            Html.div
                [ Html.Attributes.style "border" "5px solid blue" ]
                [ Html.div []
                    [ Html.text <| "With nested Web Component"
                    , Html.div [] [ Html.text <| "Replicate the issue: " ++ Debug.toString model.replicateTheIssue ]
                    ]
                , Html.node "web-component-02" [] []
                ]

        else if model.attr == "btn02" then
            let
                _ =
                    Debug.log "xxx" "Rendering web component WIHTOUT nested web component"
            in
            Html.div
                [ Html.Attributes.style "border" "5px solid blue" ]
                [ Html.div []
                    [ Html.text <| "Without nested Web Component"
                    , Html.div [] [ Html.text <| "Replicate the issue: " ++ Debug.toString model.replicateTheIssue ]
                    ]
                ]

        else if model.replicateTheIssue then
            none

        else
            Html.text ""

    else if model.flags.webComponentType == "web-component-02" then
        Html.div
            [ Html.Attributes.style "border" "5px solid red" ]
            [ Html.div [] [ Html.text "Nested Web Component" ] ]

    else
        none


none : Html.Html msg
none =
    Html.text ""
