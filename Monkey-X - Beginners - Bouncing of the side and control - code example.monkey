Import mojo

' player coords and start position
Global px:Int = 320
Global py:Int = 220
' starting movement direction
Global currentdir:String="right"
Global movementspeed = 3

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
        ' the next 4 lines is the input (cursors)
        If KeyDown(KEY_LEFT) Then currentdir="left"
        If KeyDown(KEY_RIGHT) Then currentdir="right"
        If KeyDown(KEY_UP) Then currentdir="up"
        If KeyDown(KEY_DOWN) Then currentdir="down"
        For Local i=0 Until movementspeed
            ' move the player based on the direction
            Select currentdir
                Case "left"
                    px-=1
                Case "right"
                    px+=1
                Case "down"
                    py+=1
                Case "up"
                    py-=1
            End Select
            ' if the player is outside of the device
            ' screen then (BOUNCE) go in other direction
            If px<0 Then currentdir="right"
            If px>640-16 Then currentdir="left"
            If py<0 Then currentdir="down"
            If py>480-16 Then currentdir="up"
        Next
    End
    Method OnRender()
        Cls 0,0,0 
        'set the color
        SetColor 255,255,255
        ' draw the player
        DrawRect px,py,16,16
        DrawText "Bounce Example - Use cursors to move player.",10,10
    End
End

Function Main()
    New MyGame()
End
