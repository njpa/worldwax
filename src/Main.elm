module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Graphic
import Page exposing (Page)
import Html exposing (..)
import Html.Attributes exposing (src, href, style)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Json.Decode as Decode exposing (Value)
import Url
import Route exposing (Route)
import Page.Home as Home
import Page.Profile as Profile
import Page.Blank as Blank
import Page.Article as Article
import Session exposing (Session)
import Username exposing (Username)


-- MODEL


type Model
    = Redirect Session
    | Home Home.Model
    | Profile Username Profile.Model
    | Article Article.Model


init : Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.decode navKey flags))



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view (Session.viewer (toSession model)) page config
            in
                { title = title
                , body = List.map (Html.map toMsg) body
                }
    in
        case model of
            Redirect _ ->
                viewPage Page.Other (\_ -> Ignored) Blank.view

            Home home ->
                viewPage Page.Home GotHomeMsg (Home.view home)

            Profile username profile ->
                viewPage (Page.Profile username) GotProfileMsg (Profile.view profile)

            Article article ->
                viewPage Page.Other GotArticleMsg (Article.view article)



-- UPDATE


type Msg
    = Ignored
    | ClickedLink Browser.UrlRequest
    | ChangedRoute (Maybe Route)
    | ChangedUrl Url.Url
    | GotArticleMsg Article.Msg
    | GotHomeMsg Home.Msg
    | GotProfileMsg Profile.Msg
    | GotSession Session


toSession : Model -> Session
toSession page =
    case page of
        Redirect session ->
            session

        Home home ->
            Home.toSession home

        Profile _ profile ->
            Profile.toSession profile

        Article article ->
            Article.toSession article


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
        case maybeRoute of
            Nothing ->
                Home.init session
                    |> updateWith Home GotHomeMsg model

            Just (Route.Home) ->
                Home.init session
                    |> updateWith Home GotHomeMsg model

            Just (Route.Profile username) ->
                Profile.init session username
                    |> updateWith (Profile username) GotProfileMsg model

            Just (Route.Article) ->
                Article.init session
                    |> updateWith Article GotArticleMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model))
                        (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedRoute route, _ ) ->
            changeRouteTo route model

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotArticleMsg subMsg, Article article ) ->
            Article.update subMsg article
                |> updateWith Article GotArticleMsg model

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GotHomeMsg model

        ( GotProfileMsg subMsg, Profile username profile ) ->
            Profile.update subMsg profile
                |> updateWith (Profile username) GotProfileMsg model

        ( GotSession session, Redirect _ ) ->
            ( Redirect session
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        ( _, _ ) ->
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Redirect _ ->
            Session.changes GotSession (Session.navKey (toSession model))

        Home home ->
            Sub.map GotHomeMsg (Home.subscriptions home)

        Profile _ profile ->
            Sub.map GotProfileMsg (Profile.subscriptions profile)

        Article article ->
            Sub.map GotArticleMsg (Article.subscriptions article)



-- MAIN


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
