Import mojo


Const tilewidth:Int=32
Const tileheight:Int=32
Const mapwidth:Int=20
Const mapheight:Int=15
Global map:Int[][] = [      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,1,3,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,1,1,1,1,1,0,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,1,3,2,0,2,0,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,1,1,0,1,1,0,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,0,0,2,0,0,3,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,0,0,0,0,1,1,1,0,0,0,0,0,0],
                            [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] ]

Class player
    Field x:Int=8
    Field y:Int=10
    Field dx:Int
    Field dy:Int
    Field ox:Int
    Field oy:Int
    Field width:Int=32
    Field height:Int=32
    Field ismoving:Bool=False
End Class

Global p:player = New player

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        moveplayer
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawText "Move all blocks into their destination (use cursor keys)",2,0
        If numfours(3) = True Then
            DrawText "All blocks are in place - finished..",2,16
        End If
        drawmap
        drawplayer
    End Method
End

Function numfours:Bool(count:Int=0)
    Local cnt:Int=0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[y][x] = 4 Then cnt+=1
    Next
    Next
    If cnt = count Then Return True
    Return False
End Function

Function moveplayer:Void()
    If p.ismoving = True 
        If p.x < p.dx Then
            p.ox += 1
            If p.ox = 31 Then 
                p.ismoving = False
                p.x = p.dx
                p.ox=0;p.oy=0
            End If
        End If
        If p.x > p.dx Then 
            p.ox -= 1
            If p.ox = -31
                p.ismoving = False
                p.x = p.dx
                p.ox=0;p.oy=0
            End If
        End If
        If p.y < p.dy Then
            p.oy += 1
            If p.oy = 31 Then
                p.ismoving = False
                p.y = p.dy
                p.ox=0;p.oy=0
            End If
        End If
        If p.y > p.dy Then
            p.oy -= 1
            If p.oy = -31 Then
                p.ismoving = False
                p.y = p.dy
                p.ox=0;p.oy=0
            End If
        End If
    End If
    
    If p.ismoving = False

    If KeyHit(KEY_RIGHT) 
        If map[p.y][p.x+1] = 0
            p.dy = p.y
            p.dx=p.x+1
            p.ismoving = True
        Elseif map[p.y][p.x+1] = 2
            If map[p.y][p.x+2] = 3
                map[p.y][p.x+2] = 4
                map[p.y][p.x+1] = 0
                p.ismoving = True
                p.dx = p.x+1
                p.dy = p.y
            End If
            If map[p.y][p.x+2] = 0
                map[p.y][p.x+2] = 2
                map[p.y][p.x+1] = 0
                p.ismoving = True
                p.dx = p.x+1
                p.dy = p.y
            End If            
        End If
    End If
    If KeyHit(KEY_LEFT)
        If map[p.y][p.x-1] = 0
            p.dy = p.y
            p.dx = p.x-1
            p.ismoving = True
        Elseif map[p.y][p.x-1] = 2
            If map[p.y][p.x-2] = 3
                map[p.y][p.x-2] = 4
                map[p.y][p.x-1] = 0
                p.ismoving = True
                p.dx = p.x-1
                p.dy = p.y
            End If
            If map[p.y][p.x-2] = 0
                map[p.y][p.x-2] = 2
                map[p.y][p.x-1] = 0
                p.ismoving = True
                p.dx = p.x-1
                p.dy = p.y
            End If            
        End If
    End If
    If KeyHit(KEY_UP)
        If map[p.y-1][p.x] = 0
            p.dx = p.x
            p.dy=p.y-1
            p.ismoving = True
        Elseif map[p.y-1][p.x] = 2
            If map[p.y-2][p.x] = 3
                map[p.y-2][p.x] = 4
                map[p.y-1][p.x] = 0
                p.ismoving = True
                p.dx = p.x
                p.dy = p.y-1
            End If
            If map[p.y-2][p.x] = 0
                map[p.y-2][p.x] = 2
                map[p.y-1][p.x] = 0
                p.ismoving = True
                p.dx = p.x
                p.dy = p.y-1
            End If            
        End If
    End If
    If KeyHit(KEY_DOWN)
        If map[p.y+1][p.x] = 0
            p.dx=p.x
            p.dy=p.y+1
            p.ismoving = True
        Elseif map[p.y+1][p.x] = 2
            If map[p.y+2][p.x] = 3
                map[p.y+2][p.x] = 4
                map[p.y+1][p.x] = 0
                p.ismoving = True
                p.dx = p.x
                p.dy = p.y+1
            End If
            If map[p.y+2][p.x] = 0
                map[p.y+2][p.x] = 2
                map[p.y+1][p.x] = 0
                p.ismoving = True
                p.dx = p.x
                p.dy = p.y+1
            End If            
        End If
    End If
    
    End If
    
End Function


Function drawplayer:Void()
    SetColor 255,255,0
    DrawRect p.x*tilewidth+p.ox,p.y*tilewidth+p.oy,p.width,p.height
End Function

Function drawmap:Void()
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Local x1=x*tilewidth
        Local y1=y*tileheight
        Select map[y][x]
            Case 1
                SetColor 255,255,255
                DrawRect x1,y1,tilewidth,tileheight
            Case 2
                SetColor 255,0,0
                DrawRect x1,y1,tilewidth,tileheight
                SetColor 255,255,255
                DrawText "Block",x1+(tilewidth/2),y1+(tileheight/2),.5,.5
            Case 3
                SetColor 0,255,0
                drawboxedrect x1,y1,tilewidth,tileheight
                SetColor 255,255,255
                DrawText "Dest",x1+(tilewidth/2),y1+(tileheight/2),.5,.5
            Case 4
                SetColor 0,255,255
                DrawRect x1,y1,tilewidth,tileheight
        End Select
    Next
    Next
End Function

Function drawboxedrect:Void(x:Int,y:Int,w:Int,h:Int)
    DrawLine x,y,x+w,y
    DrawLine x,y,x,y+h
    DrawLine x,y+h,x+w,y+h
    DrawLine x+w,y,x+w,y+h
End Function

Function Main()
    New MyGame()
End Function
