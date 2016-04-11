Import mojo

Global mapwidth:Int=20
Global mapheight:Int=20
Global tilewidth:Int=640/mapwidth
Global tileheight:Int=480/mapheight
Global map:Int[mapwidth][]

Class agents
    Field x:Int,y:Int,dx:Int,dy:Int
    Field delete:Bool=False
    Method New(x:Int,y:Int,dx:Int,dy:Int)
        Self.x = x
        Self.y = y
        Self.dx = dx
        Self.dy = dy
    End Method
    Method update()
        Local tx:Int=x,ty:Int=y
        If x<dx Then tx+=1
        If x>dx Then tx-=1
        If y<dy Then ty+=1
        If y>dy Then ty-=1
        If map[tx][ty] = 1 'if occupied step into random direction
            Local exitloop = False
            While exitloop = False
                tx=x+Rnd(-1,2)
                ty=y+Rnd(-1,2)
                If map[tx][ty] = 0 Then exitloop = True
            Wend
        End If
        'update the position
        x = tx
        y = ty
        'if arived then delete agent from list
        If x=dx And y=dy Then delete = True
        If delete = True Then
            For Local i:=Eachin agent
                If i.delete=True Then agent.Remove i
            Next
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x*tilewidth,y*tileheight,tilewidth,tileheight
    End Method
End Class

Global agent:List<agents> = New List<agents>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(10)
        'setup the array
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        'make the obstacles
        For Local i=0 Until 30
            Local x1:Int=Rnd(2,18)
            Local y1:Int=Rnd(2,18)
            map[x1][y1] = 1
        Next
    End Method
    Method OnUpdate()        
        If Rnd(50)<5 Then addagent
        For Local i:=Eachin agent
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        For Local i:=Eachin agent
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Random obstacle avoidance example.",0,0
    End Method
End Class

Function addagent:Void()
    Local x:Int = 0
    Local y:Int = Rnd(mapheight-1)
    Local dx:Int = mapwidth-1
    Local dy:Int=Rnd(mapheight-1)
    agent.AddLast(New agents(x,y,dx,dy))
End Function

Function drawmap:Void()
    SetColor 0,255,0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[x][y] = 1
            DrawOval x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
    Next
    Next
End Function

Function Main()
    New MyGame()
End Function
