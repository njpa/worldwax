module Page.Profile exposing (Model, Msg, init, subscriptions, toSession, update, view)

{-| An Author's profile.
-}

import Api
import Author exposing (Author(..), FollowedAuthor, UnfollowedAuthor)
import Avatar exposing (Avatar)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import HttpBuilder exposing (RequestBuilder)
import Loading
import Log
import Page
import Profile exposing (Profile)
import Route
import Session exposing (Session)
import Task exposing (Task)
import Time
import Username exposing (Username)
import Viewer exposing (Viewer)
import Viewer.Cred as Cred exposing (Cred)


-- MODEL


type alias Model =
    { session : Session
    , errors : List String
    , author : Status Author
    }


type Status a
    = Loading Username
    | LoadingSlowly Username
    | Loaded a
    | Failed Username


init : Session -> Username -> ( Model, Cmd Msg )
init session username =
    let
        maybeCred =
            Session.cred session
    in
        ( { session = session
          , errors = []
          , author = Loading username
          }
        , Cmd.batch
            [ Author.fetch username maybeCred
                |> Http.toTask
                |> Task.mapError (Tuple.pair username)
                |> Task.attempt CompletedAuthorLoad
            , Task.perform (\_ -> PassedSlowLoadThreshold) Loading.slowThreshold
            ]
        )


currentUsername : Model -> Username
currentUsername model =
    case model.author of
        Loading username ->
            username

        LoadingSlowly username ->
            username

        Loaded author ->
            Author.username author

        Failed username ->
            username



-- HTTP
-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    let
        title =
            case model.author of
                Loaded (IsViewer _ _) ->
                    myProfileTitle

                Loaded ((IsFollowing followedAuthor) as author) ->
                    titleForOther (Author.username author)

                Loaded ((IsNotFollowing unfollowedAuthor) as author) ->
                    titleForOther (Author.username author)

                Loading username ->
                    titleForMe (Session.cred model.session) username

                LoadingSlowly username ->
                    titleForMe (Session.cred model.session) username

                Failed username ->
                    titleForMe (Session.cred model.session) username
    in
        { title = title
        , content =
            case model.author of
                Loaded author ->
                    let
                        profile =
                            Author.profile author

                        username =
                            Author.username author

                        followButton =
                            case Session.cred model.session of
                                Just cred ->
                                    case author of
                                        IsViewer _ _ ->
                                            -- We can't follow ourselves!
                                            text ""

                                        IsFollowing followedAuthor ->
                                            Author.unfollowButton ClickedUnfollow cred followedAuthor

                                        IsNotFollowing unfollowedAuthor ->
                                            Author.followButton ClickedFollow cred unfollowedAuthor

                                Nothing ->
                                    -- We can't follow if we're logged out
                                    text ""
                    in
                        div [ class "profile-page" ]
                            [ Page.viewErrors ClickedDismissErrors model.errors
                            , div [ class "user-info" ]
                                [ div [ class "container" ]
                                    [ div [ class "row" ]
                                        [ div [ class "col-xs-12 col-md-10 offset-md-1" ]
                                            [ img [ class "user-img", Avatar.src (Profile.avatar profile) ] []
                                            , h4 [] [ Username.toHtml username ]
                                            , p [] [ text (Maybe.withDefault "" (Profile.bio profile)) ]
                                            , followButton
                                            ]
                                        ]
                                    ]
                                ]
                            ]

                Loading _ ->
                    text ""

                LoadingSlowly _ ->
                    Loading.icon

                Failed _ ->
                    Loading.error "profile"
        }



-- PAGE TITLE


titleForOther : Username -> String
titleForOther otherUsername =
    "Profile — " ++ Username.toString otherUsername


titleForMe : Maybe Cred -> Username -> String
titleForMe maybeCred username =
    case maybeCred of
        Just cred ->
            if username == cred.username then
                myProfileTitle
            else
                defaultTitle

        Nothing ->
            defaultTitle


myProfileTitle : String
myProfileTitle =
    "My Profile"


defaultTitle : String
defaultTitle =
    "Profile"



-- TABS
-- UPDATE


type Msg
    = ClickedDismissErrors
    | ClickedFollow Cred UnfollowedAuthor
    | ClickedUnfollow Cred FollowedAuthor
    | CompletedFollowChange (Result Http.Error Author)
    | CompletedAuthorLoad (Result ( Username, Http.Error ) Author)
    | GotSession Session
    | PassedSlowLoadThreshold


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedDismissErrors ->
            ( { model | errors = [] }, Cmd.none )

        ClickedUnfollow cred followedAuthor ->
            ( model
            , Author.requestUnfollow followedAuthor cred
                |> Http.send CompletedFollowChange
            )

        ClickedFollow cred unfollowedAuthor ->
            ( model
            , Author.requestFollow unfollowedAuthor cred
                |> Http.send CompletedFollowChange
            )

        CompletedFollowChange (Ok newAuthor) ->
            ( { model | author = Loaded newAuthor }
            , Cmd.none
            )

        CompletedFollowChange (Err error) ->
            ( model
            , Log.error
            )

        CompletedAuthorLoad (Ok author) ->
            ( { model | author = Loaded author }, Cmd.none )

        CompletedAuthorLoad (Err ( username, err )) ->
            ( { model | author = Failed username }
            , Log.error
            )

        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

        PassedSlowLoadThreshold ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)



-- EXPORT


toSession : Model -> Session
toSession model =
    model.session
