module Page exposing (Page(..), view)

import Browser exposing (Document)
import Html exposing (Html, a, button, div, footer, i, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, style, src)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Viewer exposing (Viewer)
import Viewer.Cred as Cred exposing (Cred)
import Username exposing (Username)
import Element exposing (Element, htmlAttribute, el, image, text, column, row, alignRight, fill, height, width, rgb255, spacing, px, centerY, padding, minimum, maximum, centerX, fillPortion, alignTop, alignBottom)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border


type Page
    = Other
    | Home
    | Profile Username
    | Article


view :
    Maybe Viewer
    -> Page
    -> { title : String, content : Html msg }
    -> Document msg
view maybeViewer page { title, content } =
    case maybeViewer of
        Just viewer ->
            let
                cred =
                    Viewer.cred viewer

                { username } =
                    cred
            in
                { title = title ++ " - worldwax"
                , body =
                    [ viewMixer
                    ]
                }

        Nothing ->
            { title = title ++ " - worldwax"
            , body =
                [ viewMixer
                ]
            }


s3 : String
s3 =
    "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/"


viewMixer : Html msg
viewMixer =
    Element.layout
        [ Background.color (rgb255 200 200 200)
        , width fill
        , padding 0
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
        , Background.color (rgb255 20 20 20)
        , Font.color (rgb255 255 255 255)
        ]
        [ record (String.concat [ s3, "rhythm-machine-fania-all-stars-label.png" ])
        , record (String.concat [ s3, "headhunters-herbie-hancock-label.png" ])
        ]


record : String -> Element msg
record path =
    row
        [ width (fill)
        ]
        [ recordImage path ]


recordImage : String -> Element msg
recordImage path =
    let
        bg =
            "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/record-label.svg"
    in
        Element.el
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


titlesContainer : Element msg
titlesContainer =
    row
        [ height (fillPortion 5)
        , width fill
        , Font.color (rgb255 255 255 255)
        , Background.color (rgb255 20 20 20)
        , Font.size 40
        ]
        [ recordTitle "Carnaval" "Discomoda"
        , recordTitle "Cada Cual Con El Suyo" "Mario Y Sus Diamantes"
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
                [ cuepoint "A" 150
                , cuepoint "B" 160
                , cuepoint "C" 180
                ]
            , row
                [ width (fillPortion 1)
                , padding 10
                , spacing 10
                ]
                [ cuepoint "A" 150
                , cuepoint "B" 160
                , cuepoint "C" 180
                ]
            ]
        ]


cuepoint : String -> Int -> Element msg
cuepoint label col =
    let
        path =
            "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/pad-cuepoint.svg"
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
            ]
            (el [ centerX ] (text "4:44 / 8:00"))
        , el
            [ width (fillPortion 1)
            , alignBottom
            , Font.color (rgb255 255 255 255)
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
    el
        [ height (fillPortion 15)
        , width fill
        , Background.color (rgb255 0 0 0)
        ]
        menuRow


menuRow : Element msg
menuRow =
    let
        ( records, mix, samples ) =
            ( "svg/menu-button-records.svg"
            , "svg/menu-button-mix.svg"
            , "svg/menu-button-samples.svg"
            )
    in
        row [ width fill ]
            [ menuItem (String.concat [ s3, records ])
            , menuItem (String.concat [ s3, mix ])
            , menuItem (String.concat [ s3, samples ])
            ]


menuItem : String -> Element msg
menuItem path =
    el
        [ width fill
        ]
        (image [ width (px 200), centerX ] { src = path, description = "" })


time : String -> Element msg
time actual =
    el
        [ height fill
        , width (fillPortion 1)
        , centerX
        , centerY
        ]
        (text actual)


recordTitle : String -> String -> Element msg
recordTitle song album =
    column
        [ height fill
        , width (fillPortion 1)
        ]
        [ text song
        , text album
        ]


titleRight : Element msg
titleRight =
    el
        [ height fill
        , width (fillPortion 1)
        , Background.color (rgb255 70 70 70)
        ]
        (text "title right")
