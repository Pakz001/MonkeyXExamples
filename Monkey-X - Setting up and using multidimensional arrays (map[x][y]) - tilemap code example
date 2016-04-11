Import mojo

Class MyGame Extends App
    Const mapwidth:Int=640/32
    Const mapheight:Int=480/32
    Global map:Int[mapwidth][]

    Method OnCreate()
        SetUpdateRate(60)
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y] = Int(Rnd(0,4))
        Next
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            Select map[x][y]
                Case 0 ; SetColor(255,0,0)
                Case 1 ; SetColor(0,255,0)
                Case 2 ; SetColor(0,0,255)
                Case 3 ; SetColor(255,255,0)                                
            End Select
            DrawRect x*32,y*32,32,32
        Next
        Next
    End
End


Function Main()
    New MyGame()
End
