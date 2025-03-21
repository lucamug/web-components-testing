module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Http
import Json.Decode


getRandomQuote : Cmd Msg
getRandomQuote =
    Http.get
        { url = "https://elm-lang.org/api/random-quotes"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Json.Decode.Decoder Quote
quoteDecoder =
    Json.Decode.map4 Quote
        (Json.Decode.field "quote" Json.Decode.string)
        (Json.Decode.field "source" Json.Decode.string)
        (Json.Decode.field "author" Json.Decode.string)
        (Json.Decode.field "year" Json.Decode.int)


type Maybe2 a
    = Just2 a
    | Nothing2


type alias Quote =
    { quote : String
    , source : String
    , author : String
    , year : Int
    }


type Msg
    = Increment
    | Decrement
    | Tick Float
    | GotQuote (Result Http.Error Quote)


type Direction
    = Left
    | Right


type alias Model =
    { points : Int
    , delta : Float
    , objectX : Float
    , objectDirection : Direction
    , projectiles : List ( Float, Float )
    , response : Response
    }


type Response
    = Fetching
    | GotIt (Result Http.Error Quote)


init : ( Model, Cmd Msg )
init =
    ( { points = 0
      , delta = 0
      , objectX = 0
      , objectDirection = Right
      , projectiles = []
      , response = Fetching
      }
    , getRandomQuote
    )


objectSpeed : number
objectSpeed =
    4


projectileSpeed : number
projectileSpeed =
    4


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotQuote quote ->
            ( { model | response = GotIt quote }, Cmd.none )

        Increment ->
            ( { model
                | points = model.points + 1
                , projectiles = ( model.objectX, 100 ) :: model.projectiles
                , response = Fetching
              }
            , getRandomQuote
            )

        Decrement ->
            ( { model | points = model.points - 1 }, Cmd.none )

        Tick delta ->
            let
                f =
                    model.projectiles
                        |> List.filter (\( x, y ) -> not <| removeProjectile ( x, y ))
                        |> List.length
            in
            ( { model
                | delta = delta
                , points = model.points + f
                , projectiles =
                    model.projectiles
                        |> List.map (\( x, y ) -> ( x, y + projectileSpeed ))
                        |> List.filter (\( x, y ) -> not <| removeProjectile ( x, y ))
                , objectDirection =
                    if model.objectX > 350 then
                        Left

                    else if model.objectX < 0 then
                        Right

                    else
                        model.objectDirection
                , objectX =
                    case model.objectDirection of
                        Left ->
                            model.objectX - objectSpeed

                        Right ->
                            model.objectX + objectSpeed
              }
            , Cmd.none
            )


isColliding : Float -> Bool
isColliding x =
    x > 100 && x < 200


removeProjectile : ( Float, Float ) -> Bool
removeProjectile ( x, y ) =
    if isColliding x then
        y > 390

    else
        y > 500


attrsButton : List (Attribute msg)
attrsButton =
    [ Border.width 1
    , padding 10
    , Border.rounded 10
    , Background.color <| rgb 1 1 1
    ]


view2 : Element Int
view2 =
    Input.button
        attrsButton
        { label = text "Increment"
        , onPress = Just 1
        }


view : Model -> Html.Html Msg
view model =
    layout [ padding 30, Background.color <| rgb 0.1 0.2 0.4 ] <|
        column
            ([ spacing 10 ]
                ++ List.map
                    (\( x, y ) ->
                        inFront <|
                            el
                                [ moveRight x
                                , moveDown y
                                ]
                            <|
                                text <|
                                    if y > 360 && isColliding x then
                                        "💥"

                                    else
                                        "👽"
                    )
                    model.projectiles
            )
            [ row [ spacing 20 ]
                [ Input.button
                    attrsButton
                    { label = text "Increment"
                    , onPress = Just Increment
                    }
                , el attrsButton <| text <| String.fromInt model.points
                ]
            , Input.button
                [ moveRight model.objectX, Font.size 60 ]
                { label = text "🛸"
                , onPress = Just Decrement
                }
            , el [ moveDown 200, Font.size 150, moveRight 100 ] <| text "🪐"
            , case model.response of
                Fetching ->
                    paragraph [ Font.color <| rgb 1 1 1 ] [ text <| "Fetching..." ]

                GotIt (Ok quote) ->
                    paragraph [ Font.color <| rgb 1 1 1 ] [ text <| Debug.toString <| quote ]

                GotIt (Err error) ->
                    paragraph [ Font.color <| rgb 1 0 0 ] [ text "Sorry, something went wrong, try later" ]
            , text <| Debug.toString <| round <| 1000 / model.delta
            , paragraph [] [ text <| Debug.toString <| model.projectiles ]
            ]


main : Program () Model Msg
main =
    Browser.element
        { init = \() -> init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                -- Browser.Events.onAnimationFrameDelta Tick
                Sub.none
        }
