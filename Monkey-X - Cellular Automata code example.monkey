Import mojo

Const mapwidth:Int=640/16
Const mapheight:Int=480/16
Const tilewidth:Int=16
Const tileheight:Int=16
Global map:Int[mapwidth][]


Class MyGame Extends App

    Method OnCreate()
        Seed = Rnd(1000)
        SetUpdateRate(1)
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        makeca
    End Method
    Method OnUpdate()        
        makeca
    End Method
    Method OnRender()
        Cls 0,0,0
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Select map[x][y]
                Case 0 ; SetColor 0,0,0 
                Case 1 ; SetColor 255,255,255 
            End Select
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        Next
        Next
        SetColor 255,255,255
        DrawText "Cellular automata example.",2,2
    End
End

Function makeca:Void()
    'fill the map with noise
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        map[x][y] = Int(Rnd(0,2))
    Next
    Next
    For Local i=0  Until 2
    ' loop through the map
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        'count the neigbouring 1's 
        Local cnt = 0
        For Local y1=-1 To 1
        For Local x1=-1 To 1
            Local x2=x+x1
            Local y2=y+y1
            If x2>=0 And y2>=0 And x2<mapwidth And y2<mapheight
                If map[x2][y2] = 1 Then cnt+=1
            End If
        Next
        Next
        ' if 3 walls and map is a wall then map x,y is not a wall anymore
        If cnt < 4 And map[x][y] = 1 Then
                map[x][y] = 0
        End If
        ' if more then 4 walls then map x,y is wall
        If cnt >= 5 Then map[x][y] = 1
    Next
    Next
    next
End Function

Function Main()
    New MyGame()
End
