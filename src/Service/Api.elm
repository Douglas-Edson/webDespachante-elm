module Service.Api exposing (..)

import Http exposing (Body, Error(..), Header, Resolver, header)
import Json.Decode as Decode


baseUrlAPI : String
baseUrlAPI =
    "https://parseapi.back4app.com/functions/"


expectJsonErrorString : (Result String a -> msg) -> Decode.Decoder a -> Http.Expect msg
expectJsonErrorString toMsg decoder =
    expectStringError
        >> Result.andThen
            (\body ->
                case Decode.decodeString decoder body of
                    Ok value ->
                        Ok value

                    Err err ->
                        Err <| "Ocorreu um erro: " ++ Decode.errorToString err
            )
        |> Http.expectStringResponse toMsg


expectStringError : Http.Response String -> Result String String
expectStringError response =
    case response of
        Http.BadUrl_ _ ->
            Err "Endereço inválido"

        Http.Timeout_ ->
            Err "Tempo limite de resposta atingido. Verifique sua conexão."

        Http.NetworkError_ ->
            Err "Não foi possível conectar ao servidor"

        Http.BadStatus_ _ body ->
            case Decode.decodeString (Decode.field "message" Decode.string) body of
                Ok errorMessage ->
                    Err errorMessage

                Err a ->
                    Err "Ocorreu um erro no servidor"

        Http.GoodStatus_ _ body ->
            Ok body


request :
    { body : Http.Body
    , expect : Http.Expect msg
    , token : Maybe String
    , urlFunction : String
    }
    -> Cmd msg
request options =
    Http.request
        { method = "POST"
        , headers =
            [ header "X-Parse-Application-Id" "STwaH4KrWTsapEcNF0UuvNm6FDG7jwYdqh8Um01S"
            , header "X-Parse-REST-API-Key" "pZ9zQAalhbKniw1Zxgc90qLl3HDLUul1w8jngEX1"
            ]
                |> List.append
                    (case options.token of
                        Just token ->
                            [ header "X-Parse-Session-Token" token ]

                        Nothing ->
                            []
                    )
        , url = baseUrlAPI ++ options.urlFunction
        , body = options.body
        , expect = options.expect
        , timeout = Nothing
        , tracker = Nothing
        }
