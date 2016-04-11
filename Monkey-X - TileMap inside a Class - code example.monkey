Import mojo

Class map
    Field tilewidth:Int,tileheight:Int
    Field mapwidth:Int,mapheight:Int
    Field map:Int[][]
    Method New(mapwidth:Int,mapheight:Int,tilewidth:Int,tileheight:Int)
        Self.tilewidth = tilewidth
        Self.tileheight = tileheight
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
    End Method
    Method update()
        Local x1 = MouseX() / tilewidth
        Local y1 = MouseY() / tileheight
        If MouseDown(MOUSE_LEFT)
            setmap(x1,y1,1)
        End If
        If KeyDown(KEY_SPACE)
            setmap(x1,y1,0)            
        End If
    End Method
    Method setmap:Void(x:Int,y:Int,val:Int)
        If x>=0 And y>=0 And x<mapwidth And y<mapheight
            map[x][y] = val
        End If
    End Method
    Method drawmap:Void()
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            If map[x1][y1] = 1
                SetColor 255,255,255
                DrawRect (x1*tilewidth),(y1*tileheight),tilewidth,tileheight
            End If
        Next
        Next
    End Method
End Class

Global mymap:map = New map(20,14,32,32)

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()      
        mymap.update  
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.drawmap
        SetColor 255,255,255
        DrawText "Left mouse button to set block, Space bar to erase block",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
