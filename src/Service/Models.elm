module Service.Models exposing (..)

-- Create Service


type alias StateToCreateService =
    { selectService : Maybe Service
    }


type alias Service =
    { name : String
    , code : Int
    , price : Float
    }


type alias User =
    { email : String
    , session : String
    }
