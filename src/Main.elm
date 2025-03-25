port module Main exposing (main)

import Browser
import Types
import View


port portXYZ : (String -> msg) -> Sub msg


port unmount : (() -> msg) -> Sub msg


init : Types.Flags -> ( Types.Model, Cmd msg )
init flags =
    ( { attr = "btn01"
      , flags = flags
      , replicateTheIssue = True
      }
    , Cmd.none
    )


update : Types.Msg -> Types.Model -> ( Types.Model, Cmd msg )
update msg model =
    case msg of
        Types.MsgDataFromPort string ->
            if string == "toggle01" then
                ( { model | replicateTheIssue = not model.replicateTheIssue }, Cmd.none )

            else
                ( { model | attr = string }, Cmd.none )

        Types.Unmount () ->
            ( model, Cmd.none )


main : Program Types.Flags (Maybe Types.Model) Types.Msg
main =
    Browser.element
        { init =
            \flags ->
                flags
                    |> init
                    |> Tuple.mapFirst Just
        , subscriptions =
            \maybeModel ->
                case maybeModel of
                    Just _ ->
                        Sub.batch
                            [ portXYZ Types.MsgDataFromPort
                            , unmount Types.Unmount
                            ]

                    Nothing ->
                        Sub.none
        , update =
            \msg maybeModel ->
                case maybeModel of
                    Just model ->
                        case msg of
                            Types.Unmount _ ->
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
        , view =
            \maybeModel ->
                case maybeModel of
                    Just model ->
                        View.view model

                    Nothing ->
                        -- Replace this with `Html.text ""` to fix the issue
                        View.none
        }
