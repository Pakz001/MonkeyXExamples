Import mojo

Global mapwidth:Int=3
Global mapheight:Int=3
Global mapdepth:Int=3

Global map:Int[mapwidth][][]

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight][]
            For Local z=0 Until mapdepth
                map[i][z] = New Int[mapdepth]
            Next
        Next
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y][0] = Int(Rnd(3))
            For Local z=1 Until mapdepth
                map[x][y][z] = Rnd(3,10)
            Next
        Next
        Next
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "3 Dimensional arrays and Length example",0,0
        For Local y=0 Until map[0].Length
        For Local x=0 Until map.Length
        For Local z=0 Until map[0][0].Length
            Local s:String="x:"+x+" y:"+y+" z:"+z+" = "
            DrawText s+""+map[x][y][z],x*132,y*64+(z*15)+32
        Next
        Next
        Next
    End Method
End Class

Function Main()
    New MyGame()
End Function
