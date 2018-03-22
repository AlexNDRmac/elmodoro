module Update exposing (update)

-- INTERNALS

import Msgs exposing (Msg(..))
import Models exposing (Model, Status(..))
import Ports exposing (setTitle)
import Utils exposing (timerToTimeString)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start time ->
            ( { model | timer = time, status = Running }, Cmd.none )

        Pause ->
            ( { model | status = Paused }, setTitle "PAUSED" )

        Resume ->
            ( { model | status = Running }, setTitle <| timerToTimeString <| model.timer )

        Stop ->
            ( { model | status = Stopped, timer = 0 }, setTitle "Elmodoro" )

        ReduceSeconds _ ->
            if model.status == Running && model.timer > 0 then
                ( { model | timer = model.timer - 1 }, setTitle <| timerToTimeString <| model.timer - 1 )
            else if model.status == Running && model.timer == 0 then
                -- TODO: Trigger sound and Message to stop
                ( { model | status = Finished }, setTitle "FINISHED" )
            else
                ( model, Cmd.none )
