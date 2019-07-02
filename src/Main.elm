module Main exposing (main)

import Browser exposing (element)
import Html
import Html.Attributes exposing (class)
import Element exposing (Element, htmlAttribute, el, image, text, column, row, alignRight, fill, height, width, rgb255, spacing, px, centerY, padding, minimum, maximum, centerX, fillPortion, alignTop, alignBottom)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = ClickPlay


initialModel : Model
initialModel =
    { record = "hello" }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


type alias Model =
    { record : String }


s3 : String
s3 =
    "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/"


view : Model -> Html.Html msg
view model =
    Element.layout
        [ Background.color (rgb255 0 0 0)
        , width fill
        , height fill
        , padding 0
        , spacing 0
        ]
        mixerContainer


mixerContainer : Element msg
mixerContainer =
    let
        mobile =
            True
    in
        el
            [ centerX
            , centerY
            , if mobile then
                (width fill)
              else
                (width (fill |> minimum 410 |> maximum 414))
            , height fill
            ]
            mixer



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickPlay ->
            ( model, Cmd.none )


mixer : Element msg
mixer =
    column
        [ height fill
        , width fill
        ]
        [ recordsContainer
        , titlesContainer
        , cuepointsContainer
        , timesContainer
        , transportContainer
        , crossfaderContainer
        , menuContainer
        ]


recordsContainer : Element msg
recordsContainer =
    row
        [ height (fillPortion 15)
        , width fill
        , Font.color (rgb255 255 255 255)
        ]
        [ record (String.concat [ s3, "rhythm-machine-fania-all-stars-label.png" ])
        , record (String.concat [ s3, "headhunters-herbie-hancock-label.png" ])
        ]


record : String -> Element msg
record path =
    let
        bg =
            s3 ++ "svg/label.svg"
    in
        row
            [ width (fill)
            ]
            [ el
                [ width fill
                , Element.inFront
                    (image
                        [ width fill
                        , htmlAttribute (class "spin-enabled")
                        ]
                        { src = path, description = "" }
                    )
                ]
                (image [ width fill ] { src = bg, description = "" })
            ]


titlesContainer : Element msg
titlesContainer =
    row
        [ height (fillPortion 5)
        , width fill
        , Font.color (rgb255 255 255 255)
        , Background.color (rgb255 20 20 20)
        , padding 10
        ]
        [ column
            [ height fill
            , width (fillPortion 1)
            , spacing 10
            ]
            [ el [ Font.size 16 ] (text "Carnaval")
            , el [ Font.size 12 ] (text "Discomoda")
            ]
        , column
            [ height fill
            , width (fillPortion 1)
            , spacing 10
            ]
            [ el [ Font.size 16 ] (text "Cada Cual Con El Suyo")
            , el [ Font.size 12 ] (text "Mario Y Sus Diamantes")
            ]
        ]


recordTitle : String -> String -> Element msg
recordTitle song album =
    column
        [ height fill
        , width (fillPortion 1)
        ]
        [ text song
        , text album
        ]


cuepointsContainer : Element msg
cuepointsContainer =
    column
        [ height (fillPortion 10)
        , width fill
        , Background.color (rgb255 20 20 20)
        ]
        [ el
            [ centerX ]
            (text "cuepoints")
        , row
            [ width fill ]
            [ row
                [ width (fillPortion 1)
                , padding 10
                , spacing 10
                ]
                [ cuepoint "a" 150
                , cuepoint "b" 160
                , cuepoint "c" 180
                ]
            , row
                [ width (fillPortion 1)
                , padding 10
                , spacing 10
                ]
                [ cuepoint "a" 150
                , cuepoint "b" 160
                , cuepoint "c" 180
                ]
            ]
        ]


cuepoint : String -> Int -> Element msg
cuepoint label col =
    let
        path =
            String.concat
                [ s3
                , "svg/cuepoint-button-"
                , label
                , ".svg"
                ]
    in
        el
            [ width (fillPortion 1) ]
            (image [ width fill ]
                { src = path, description = "" }
            )


timesContainer : Element msg
timesContainer =
    row
        [ height (fillPortion 5)
        , width fill
        , Background.color (rgb255 20 20 20)
        ]
        [ el
            [ width (fillPortion 1)
            , alignBottom
            , Font.color (rgb255 255 255 255)
            , Font.size 12
            ]
            (el [ centerX ] (text "4:44 / 8:00"))
        , el
            [ width (fillPortion 1)
            , alignBottom
            , Font.color (rgb255 255 255 255)
            , Font.size 12
            ]
            (el [ centerX ] (text "4:44 / 8:00"))
        ]


transportContainer : Element msg
transportContainer =
    let
        ( rewind, pause, forward ) =
            ( String.concat [ s3, "svg/transport-button-rewind.svg" ]
            , String.concat [ s3, "svg/transport-button-pause.svg" ]
            , String.concat [ s3, "svg/transport-button-forward.svg" ]
            )
    in
        row
            [ height (fillPortion 10)
            , width fill
            , Background.color (rgb255 20 20 20)
            ]
            [ row [ width (fillPortion 1), alignTop, spacing 10, padding 10 ]
                [ (image [ width (fillPortion 1) ]
                    { src = rewind, description = "" }
                  )
                , (image [ width (fillPortion 1) ]
                    { src = pause, description = "" }
                  )
                , (image [ width (fillPortion 1) ]
                    { src = forward, description = "" }
                  )
                ]
            , row [ width (fillPortion 1), alignTop, spacing 10, padding 10 ]
                [ (image [ width (fillPortion 1) ]
                    { src = rewind, description = "" }
                  )
                , (image [ width (fillPortion 1) ]
                    { src = pause, description = "" }
                  )
                , (image [ width (fillPortion 1) ]
                    { src = forward, description = "" }
                  )
                ]
            ]


crossfaderContainer : Element msg
crossfaderContainer =
    let
        crossfader =
            String.concat [ s3, "svg/crossfader.svg" ]
    in
        el
            [ height (fillPortion 10)
            , width fill
            , Background.color (rgb255 20 20 20)
            , padding 10
            ]
            (image [ width (fillPortion 1) ]
                { src = crossfader, description = "" }
            )


menuContainer : Element msg
menuContainer =
    let
        ( records, mix, samples ) =
            ( "svg/menu-button-records.svg"
            , "svg/menu-button-mix.svg"
            , "svg/menu-button-samples.svg"
            )
    in
        el
            [ height (fillPortion 15)
            , width fill
            , Background.color (rgb255 0 0 0)
            ]
            (row
                [ width fill ]
                [ menuItem (String.concat [ s3, records ])
                , menuItem (String.concat [ s3, mix ])
                , menuItem (String.concat [ s3, samples ])
                ]
            )


menuItem : String -> Element msg
menuItem path =
    el
        [ width fill
        , padding 10
        ]
        (image [ width (fillPortion 1), centerX ] { src = path, description = "" })
