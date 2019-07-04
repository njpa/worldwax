module Main exposing (main)

import Browser exposing (element)
import Html exposing (audio)
import Html.Attributes exposing (class, classList, type_, controls, id, src, autoplay)
import Element.Events exposing (onClick)
import Element exposing (Element, html, htmlAttribute, el, image, text, column, row, alignRight, fill, height, width, rgb255, spacing, px, centerY, padding, minimum, maximum, centerX, fillPortion, alignTop, alignBottom)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border
import Ports exposing (audioPause, audioPlay)


-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type RecordStatus
    = Playing
    | Stopped


type Turntable
    = TurntableLeft
    | TurntableRight


type Msg
    = ClickedPlay Turntable
    | ClickedStop Turntable



-- MODEL


type alias Model =
    { record : String
    , turntableLeftStatus : RecordStatus
    , turntableRightStatus : RecordStatus
    }


initialModel : Model
initialModel =
    { record = "hello"
    , turntableLeftStatus = Stopped
    , turntableRightStatus = Stopped
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


s3 : String
s3 =
    "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/"



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedPlay turntable ->
            if turntable == TurntableLeft then
                ( { model | turntableLeftStatus = Playing }
                , Ports.audioPlay { player = "player-left", time = 1.0 }
                )
            else
                ( { model | turntableRightStatus = Playing }
                , Ports.audioPlay { player = "player-right", time = 1.0 }
                )

        ClickedStop turntable ->
            if turntable == TurntableLeft then
                ( { model | turntableLeftStatus = Stopped }
                , Ports.audioPause { player = "player-left", time = 1.0 }
                )
            else
                ( { model | turntableRightStatus = Stopped }
                , Ports.audioPause { player = "player-right", time = 1.0 }
                )



-- VIEW


view : Model -> Html.Html Msg
view model =
    Element.layout
        [ Background.color (rgb255 0 0 0)
        , width fill
        , height fill
        , padding 0
        , spacing 0
        ]
        (mixerContainer model)


mixerContainer : Model -> Element Msg
mixerContainer model =
    let
        mobile =
            True
    in
        row
            [ centerX
            , centerY
            , if mobile then
                (width fill)
              else
                (width (fill |> minimum 410 |> maximum 414))
            , height fill
            ]
            [ mixer model
            , html
                (audio
                    [ src (s3 ++ "mp3/en-orbita-fania-all-stars-128.m4a")
                    , id "player-left"
                    , type_ "audio/ogg"
                    , autoplay False
                    , controls False
                      {- , onItemLoad SetDuration
                         , onTimeUpdate TimeUpdate
                         , onEnded EndPlayer
                      -}
                    ]
                    []
                )
            , html
                (audio
                    [ src (s3 ++ "mp3/sly-herbie-hancock-128.m4a")
                    , id "player-right"
                    , type_ "audio/ogg"
                    , autoplay False
                    , controls False
                      {- , onItemLoad SetDuration
                         , onTimeUpdate TimeUpdate
                         , onEnded EndPlayer
                      -}
                    ]
                    []
                )
            ]


mixer : Model -> Element Msg
mixer model =
    column
        [ height fill
        , width fill
        ]
        [ recordsContainer model
        , titlesContainer
        , cuepointsContainer
        , timesContainer
        , transportContainer model
        , crossfaderContainer
        , menuContainer
        ]


recordsContainer : Model -> Element msg
recordsContainer model =
    row
        [ height (fillPortion 15)
        , width fill
        , Font.color (rgb255 255 255 255)
        ]
        [ record
            (String.concat [ s3, "rhythm-machine-fania-all-stars-label.png" ])
            model.turntableLeftStatus
        , record
            (String.concat [ s3, "headhunters-herbie-hancock-label.png" ])
            model.turntableRightStatus
        ]


record : String -> RecordStatus -> Element msg
record path recordStatus =
    let
        bg =
            s3 ++ "svg/label.svg"

        recordClass =
            classList
                [ ( "spin-disabled", recordStatus == Stopped )
                , ( "spin-enabled", recordStatus == Playing )
                ]
    in
        row
            [ width (fill)
            ]
            [ el
                [ width fill
                , Element.inFront
                    (image
                        [ width fill
                        , htmlAttribute (recordClass)
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


transportContainer : Model -> Element Msg
transportContainer model =
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
                , (image
                    [ width (fillPortion 1)
                    , if model.turntableLeftStatus == Playing then
                        onClick (ClickedStop TurntableLeft)
                      else
                        onClick (ClickedPlay TurntableLeft)
                    ]
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
                , (image
                    [ width (fillPortion 1)
                    , if model.turntableRightStatus == Playing then
                        onClick (ClickedStop TurntableRight)
                      else
                        onClick (ClickedPlay TurntableRight)
                    ]
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
