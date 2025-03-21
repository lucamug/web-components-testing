port module Main exposing (main)

import Browser
import Html
import Html.Attributes
import Html.Events


port attr01 : (String -> msg) -> Sub msg


type alias Model =
    { attr01 : String
    , flags : Flags
    }


init : Flags -> ( Model, Cmd msg )
init flags =
    ( { attr01 = "btn01"
      , flags = flags
      }
    , Cmd.none
    )


type Msg
    = Attr01 String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Attr01 string ->
            ( { model | attr01 = string }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    if model.flags.webComponentType == "web-component-01" then
        if model.attr01 == "btn03" then
            Html.text ""

        else
            Html.div [ Html.Attributes.style "border" "5px solid blue" ]
                ([ Html.div [] [ Html.text <| Debug.toString model ]
                 ]
                    ++ (if model.attr01 == "btn02" then
                            []

                        else
                            [ Html.node "web-component-02" [ Html.Attributes.attribute "attr01" model.attr01 ] [] ]
                       )
                )

    else
        Html.div [ Html.Attributes.style "border" "5px solid red" ]
            [ Html.div [] [ Html.text <| Debug.toString model ]
            ]


type alias Flags =
    { webComponentType : String
    , virtualDomTesting : Maybe String
    }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> attr01 Attr01
        }
