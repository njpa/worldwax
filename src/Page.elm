module Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Html exposing (Html, a, button, div, footer, i, img, li, nav, p, span, text, ul)
import Html.Attributes exposing (class, classList, href, style, src)
import Html.Events exposing (onClick)
import Route exposing (Route)
import Viewer exposing (Viewer)
import Graphic
import Viewer.Cred as Cred exposing (Cred)
import Username exposing (Username)


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
                    [ viewHeader
                    , viewMenu
                    , content
                    , viewFooter
                    ]
                }

        Nothing ->
            { title = title ++ " - worldwax"
            , body =
                [ viewHeader
                , a [ Route.href Route.Home ]
                    [ text "back to home to sign up" ]
                , content
                , viewFooter
                ]
            }


viewHeader : Html msg
viewHeader =
    div [ class "fl w-100 mt2" ]
        [ div [ class "center w5" ]
            [ a [ Route.href Route.Home ]
                [ Graphic.logo ]
            ]
        ]


viewMenu : Html msg
viewMenu =
    div [ class "fl w-100 bt" ]
        [ text "menu" ]


viewFooter : Html msg
viewFooter =
    let
        path =
            "https://s3.amazonaws.com/worldwax/items-images/2-round.png"

        path2 =
            "https://s3.amazonaws.com/worldwax/items-images/10-round.png"
    in
        div [ class "fl w-100 bg-near-white" ]
            [ div [ class "" ]
                [ div []
                    [ span [ class "w1 absolute" ]
                        [ Graphic.vinylBackground ]
                    , span [ class "absolute w1 spin v-mid" ]
                        [ img
                            [ src path2
                            ]
                            []
                        ]
                    ]
                ]
            ]



{--
            [ img
                [ class "absolute record center v-mid"
                , classList
                    [ ( "spin-disabled", not playing )
                    , ( "spin-enabled-33", playing )
                    ]
                , src path
                ]
                []
            , img
                [ class "absolute brooklyn shadow-1 record "
                , src Views.Base64Images.bgRecordBig
                ]
                []
            ]
        ]
--}
{- Render dismissable errors. We use this all over the place! -}


viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    if List.isEmpty errors then
        Html.text ""
    else
        div
            [ class "error-messages"
            , style "position" "fixed"
            , style "top" "0"
            , style "background" "rgb(250, 250, 250)"
            , style "padding" "20px"
            , style "border" "1px solid"
            ]
        <|
            List.map (\error -> p [] [ text error ]) errors
                ++ [ button [ onClick dismissErrors ] [ text "Ok" ] ]
