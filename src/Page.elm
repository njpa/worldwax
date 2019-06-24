module Page exposing (Page(..), view)

import Browser exposing (Document)
import Html exposing (Html, a, button, div, footer, i, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, style, src)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Viewer exposing (Viewer)
import Viewer.Cred as Cred exposing (Cred)
import Username exposing (Username)
import Element exposing (Element, el, image, text, column, row, alignRight, fill, height, width, rgb255, spacing, px, centerY, padding, minimum, maximum, centerX, fillPortion)
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
        , Background.color (rgb255 0 0 0)
        , Font.color (rgb255 255 255 255)
        ]
        [ recordsContainer
        , titlesContainer
        , cuepointsContainer
        , timesContainer
        , transportContainer
        , crossfaderContainer
        ]


recordsContainer : Element msg
recordsContainer =
    row
        [ height (fillPortion 2)
        , width fill
        , Background.color (rgb255 20 20 20)
        , Font.color (rgb255 255 255 255)
        ]
        [ record (String.concat [ s3, "rhythm-machine-fania-all-stars-label.png" ])
        , record (String.concat [ s3, "headhunters-herbie-hancock-label.png" ])
        ]


record : String -> Element msg
record path =
    row [ width (fillPortion 1) ]
        [ recordImage path ]


recordImage : String -> Element msg
recordImage path =
    let
        bg =
            "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/record-label.svg"
    in
        Element.el
            [ width fill
            , Element.inFront (image [ width fill ] { src = path, description = "" })
            ]
            (image [ width fill ] { src = bg, description = "" })


titlesContainer : Element msg
titlesContainer =
    row
        [ height (fillPortion 1)
        , width fill
        , Font.color (rgb255 255 255 255)
        ]
        [ titleLeft
        , titleRight
        ]


cuepointsContainer : Element msg
cuepointsContainer =
    column
        [ height (fillPortion 1)
        , width fill
        ]
        [ cuepointsTitle
        , cuepointsButtonsContainer
        ]


timesContainer : Element msg
timesContainer =
    row
        [ height (fillPortion 1)
        , width fill
        , Background.color (rgb255 200 200 200)
        ]
        [ time "3:03 / 4:00"
        , time "4:44 / 8:00"
        ]


transportContainer : Element msg
transportContainer =
    el
        [ height (fillPortion 1)
        , width fill
        , Background.color (rgb255 10 10 10)
        ]
        (text "transport")


crossfaderContainer : Element msg
crossfaderContainer =
    el
        [ height (fillPortion 1)
        , width fill
        , Background.color (rgb255 40 40 30)
        ]
        (text "crossfader")


time : String -> Element msg
time actual =
    el
        [ height fill
        , width (fillPortion 1)
        , centerX
        , centerY
        ]
        (text actual)


titleLeft : Element msg
titleLeft =
    el
        [ height fill
        , width (fillPortion 1)
        , Background.color (rgb255 50 50 50)
        ]
        (text "title left")


titleRight : Element msg
titleRight =
    el
        [ height fill
        , width (fillPortion 1)
        , Background.color (rgb255 70 70 70)
        ]
        (text "title right")


cuepointsTitle : Element msg
cuepointsTitle =
    el
        [ centerX
        , height (fillPortion 1)
        ]
        (text "cuepoints")


cuepointsButtonsContainer : Element msg
cuepointsButtonsContainer =
    row
        [ width fill
        , height (fillPortion 1)
        ]
        [ cuepointsLeft
        , cuepointsRight
        ]


cuepointsLeft : Element msg
cuepointsLeft =
    row
        [ height fill
        , width (fillPortion 1)
        ]
        [ cuepoint "A" 150
        , cuepoint "B" 160
        , cuepoint "C" 180
        ]


cuepointsRight : Element msg
cuepointsRight =
    row
        [ height fill
        , width (fillPortion 1)
        ]
        [ cuepoint "A" 150
        , cuepoint "B" 160
        , cuepoint "C" 180
        ]


cuepoint : String -> Int -> Element msg
cuepoint label col =
    let
        path =
            "https://worldwax-mvp.s3.eu-central-1.amazonaws.com/pad-cuepoint.svg"
    in
        el
            [ height fill
            , width (fillPortion 3)
            , Background.color (rgb255 col col col)
            ]
            (image [ width fill ]
                { src = path, description = "" }
            )
