module Pages.Login exposing (Model, Msg, page)

import Effect exposing (Effect)
import Gen.Params.Login exposing (Params)
import Html
import Html.Attributes exposing (class, style)
import Http
import Json.Decode as Decode
import Material.Button as Button
import Material.Elevation as Elevation
import Material.LayoutGrid as LayoutGrid
import Material.TextField as TextField
import Material.Typography as Typography
import Page
import Request
import Service.Api as API
import Service.Login as ServiceLogin
import Shared
import Url exposing (Protocol(..))
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { username : String
    , password : String
    }


init : ( Model, Effect Msg )
init =
    ( { username = ""
      , password = ""
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ClickedSignIn
    | ValueUsernameChanged String
    | ValuePasswordChanged String
    | GotSignIn (Result String ServiceLogin.ApiResult)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ClickedSignIn ->
            ( model
            , ServiceLogin.loginUser
                { username = model.username
                , password = model.password
                , onResponse = GotSignIn
                }
            )

        ValueUsernameChanged newUsername ->
            ( { model | username = newUsername }
            , Effect.none
            )

        ValuePasswordChanged newPassword ->
            ( { model | password = newPassword }
            , Effect.none
            )

        GotSignIn (Ok received) ->
            ( model, Effect.fromShared (Shared.SignIn { name = received.result.email }) )

        GotSignIn (Err error) ->
            ( model, Effect.none )


expect : (Result String a -> msg) -> (Http.Metadata -> String -> Result String a) -> Http.Expect msg
expect toMsg onGoodStatus =
    Http.expectStringResponse toMsg (\response -> responseToResult response onGoodStatus)


expectWhatever : (Result String () -> msg) -> Http.Expect msg
expectWhatever toMsg =
    expect toMsg (\_ _ -> Ok ())


responseToResult : Http.Response String -> (Http.Metadata -> String -> Result String a) -> Result String a
responseToResult response onGoodStatus =
    case response of
        Http.BadUrl_ _ ->
            Err "Endereço inválido"

        Http.Timeout_ ->
            Err "Tempo limite de resposta atingido. Verifique sua conexão."

        Http.NetworkError_ ->
            Err "Não foi possível conectar ao servidor"

        Http.BadStatus_ _ body ->
            case Decode.decodeString (Decode.field "Message" Decode.string) body of
                Ok errorMessage ->
                    Err errorMessage

                Err error ->
                    Err "Ocorreu um erro no servidor"

        Http.GoodStatus_ metadata body ->
            onGoodStatus metadata body



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Login"
    , body =
        [ Html.section
            [ class "login_content" ]
            [ Html.div
                [ Elevation.z24
                , class "login_elevation"
                ]
                [ LayoutGrid.layoutGrid
                    [ class "login_header"
                    ]
                    [ LayoutGrid.inner
                        [ class "login_header_grid" ]
                        [ LayoutGrid.cell
                            []
                            [ Html.h1
                                [ Typography.headline1
                                , class "login_title"
                                ]
                                [ Html.text "WebDespachante"
                                ]
                            ]
                        ]
                    , LayoutGrid.inner [ class "login_header_grid" ]
                        [ LayoutGrid.cell
                            []
                            [ Html.div
                                []
                                [ Html.img
                                    [ class "login_animation"
                                    , Html.Attributes.src
                                        "https://despachantepr.com/o/animation_300_kmana8xo.gif"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    ]
                , LayoutGrid.layoutGrid
                    []
                    [ LayoutGrid.cell
                        []
                        [ Html.form
                            []
                            [ LayoutGrid.cell
                                []
                                [ TextField.filled
                                    (TextField.config
                                        |> TextField.setAttributes [ class "md_fullWidth" ]
                                        |> TextField.setLabel (Just "Username")
                                        |> TextField.setType (Just "username")
                                        |> TextField.setOnInput ValueUsernameChanged
                                    )
                                ]
                            , LayoutGrid.cell
                                []
                                [ TextField.filled
                                    (TextField.config
                                        |> TextField.setAttributes [ class "md_fullWidth" ]
                                        |> TextField.setLabel (Just "Senha")
                                        |> TextField.setType (Just "password")
                                        |> TextField.setOnInput ValuePasswordChanged
                                    )
                                ]
                            , LayoutGrid.cell
                                []
                                [ Button.raised
                                    (Button.config
                                        |> Button.setAttributes [ class "md_fullWidth" ]
                                        |> Button.setOnClick ClickedSignIn
                                        |> Button.setHref (Just "#")
                                    )
                                    "Entrar"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }
