module Service.Login exposing (ApiResult, loginUser)

import Effect exposing (Effect, fromCmd)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as DecodePipeline
import Json.Encode as Encode
import Service.Api as Api
import Service.Models as Models



-- REQUEST


loginUser :
    { username : String
    , password : String
    , onResponse : Result String ApiResult -> msg
    }
    -> Effect msg
loginUser options =
    Api.request
        { body =
            Http.jsonBody <|
                Encode.object
                    [ ( "username", Encode.string options.username )
                    , ( "password", Encode.string options.password )
                    ]
        , expect = Api.expectJsonErrorString options.onResponse decoderResult
        , token = Nothing
        , urlFunction = "login-user"
        }
        |> Effect.fromCmd



-- DECODER


type alias ApiResult =
    { result : Models.User
    }


decoderResult =
    Decode.succeed ApiResult
        |> DecodePipeline.required "result" decodeUser


decodeUser =
    Decode.succeed Models.User
        |> DecodePipeline.required "email" Decode.string
        |> DecodePipeline.required "session" Decode.string
