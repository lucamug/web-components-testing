port module Main exposing (main)

import Browser
import Html
import Html.Attributes
import Html.Events


port portXYZ : (String -> msg) -> Sub msg


port unmount : (() -> msg) -> Sub msg


type alias Model =
    { attr : String
    , flags : Flags
    }


init : Flags -> ( Model, Cmd msg )
init flags =
    ( { attr = "btn01"
      , flags = flags
      }
    , Cmd.none
    )


type Msg
    = MsgDataFromPort String
    | Unmount ()


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MsgDataFromPort string ->
            ( { model | attr = string }, Cmd.none )

        Unmount () ->
            ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    if model.flags.webComponentType == "web-component-01" then
        if model.attr == "btn03" then
            Html.text ""

        else
            Html.div [ Html.Attributes.style "border" "5px solid blue" ]
                ([ Html.div [] [ Html.text <| Debug.toString model ]
                 ]
                    ++ (if model.attr == "btn02" then
                            []

                        else
                            [ Html.node "web-component-02" [ Html.Attributes.attribute "attr01" model.attr ] [] ]
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


main : Program Flags (Maybe Model) Msg
main =
    Browser.element
        { init =
            \flags ->
                flags
                    |> init
                    |> Tuple.mapFirst Just
        , view =
            \maybeModel ->
                case maybeModel of
                    Just model ->
                        view model

                    Nothing ->
                        Html.text ""
        , update =
            \msg maybeModel ->
                case maybeModel of
                    Just model ->
                        case msg of
                            Unmount _ ->
                                let
                                    _ =
                                        Debug.log "Unmounting" maybeModel
                                in
                                ( Nothing, Cmd.none )

                            _ ->
                                update msg model
                                    |> Tuple.mapFirst Just

                    Nothing ->
                        ( Nothing, Cmd.none )
        , subscriptions =
            \maybeModel ->
                case maybeModel of
                    Just model ->
                        Sub.batch
                            [ portXYZ MsgDataFromPort
                            , unmount Unmount
                            ]

                    Nothing ->
                        Sub.none
        }
