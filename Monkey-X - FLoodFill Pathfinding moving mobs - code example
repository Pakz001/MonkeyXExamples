Import mojo

Const tilewidth = 32
Const tileheight = 32
Const mapwidth:Int=20
Const mapheight:Int=15
Global gamemap:Int[][] = [  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,1,1,1,1,0,1,0,0,0,0,1,0,1],
                            [1,0,1,1,1,1,1,1,1,1,1,0,1,1,0,0,1,1,1,1],
                            [1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],                       
                            [1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,1,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,0,1],
                            [1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1],
                            [1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Class openlist
    Field x:Int,y:Int
    Field val:Int
    Method New(x:Int,y:Int,val:Int)
        Self.x=x
        Self.y=y
        Self.val=val
    End Method
End Class
Class closedlist
    Field x:Int,y:Int
    Field val:Int
    Method New(x:Int,y:Int,val:Int)
        Self.x=x
        Self.y=y
        Self.val=val
    End Method    
End Class

Class agent
    Field x:Int,y:Int
    Field delay:Int    
    Field delete:Bool=False
    Method New()
        Local exitloop:Bool=False
        While exitloop = False
            Local x1:Int=Rnd(mapwidth)
            Local y1:Int=Rnd(mapheight)
            If myplayer.map[x1][y1] > 10
                x = x1
                y=y1
                exitloop=True
            End If
        Wend
    End Method
    Method update()
        delay-=1
        If delay<1
            delay = 30
            'move towards the player
            Local val:Int=myplayer.map[x][y]
            Local exitloop:Bool=False        
            Local dx:Int=x,dy:Int=y
            While exitloop = False
                Local x1:Int = x+Rnd(-1,2)
                Local y1:Int = y+Rnd(-1,2)
                If gamemap[y1][x1] = 0
                If myplayer.map[x1][y1] < val
                    dx=x1
                    dy=y1
                    val = myplayer.map[x1][y1]
                End If
                End If
                If Rnd(100)<5 Then exitloop = True
            Wend
            x = dx
            y = dy
            ' if close to the player remove
            If myplayer.map[x][y] < 2
                delete = True
            End If
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x*tilewidth+5,y*tileheight+5,tilewidth-10,tileheight-10
    End Method
End Class

Class player
    Field ol:List<openlist> = New List<openlist>
    Field x:Int=10,y:Int=10
    Field map:Int[][]
    Method New()
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        DebugLog mapwidth+","+mapheight
        makefloodmap()
    End Method
    Method update()
        If KeyHit(KEY_LEFT)
        If x-1 > 0
        If gamemap[y][x-1] = 0
            x-=1
            makefloodmap
        End If
        End If
        End If
        If KeyHit(KEY_RIGHT)
        If x+1 < mapwidth
        If gamemap[y][x+1] = 0
            x+=1
            makefloodmap
        End If
        End If
        End If
        If KeyHit(KEY_UP)
        If y-1 > 0
        If gamemap[y-1][x] = 0
            y-=1
            makefloodmap
        End If
        End If
        End If
        If KeyHit(KEY_DOWN)
        If y+1 < mapheight
        If gamemap[y+1][x] = 0
            y+=1
            makefloodmap
        End If
        End If
        End If
    End Method
    Method makefloodmap()        
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            map[x1][y1] = 0
        Next
        Next
        ol.Clear()
        ol.AddLast(New openlist(x,y,1))
        map[x][y] = 1
        While ol.IsEmpty() = False
            For Local i:=Eachin ol
                Local tx:Int=i.x
                Local ty:Int=i.y
                Local tv:Int=i.val
                ol.Remove i                
                If ty-1 > 0 
                    If map[tx][ty-1] = 0                
                    If gamemap[ty-1][tx] = 0
                        ol.AddLast(New openlist(tx,ty-1,tv+1))
                        map[tx][ty-1] = tv+1
                    End If
                    End If
                End If
                If tx+1 < mapwidth 
                    If map[tx+1][ty] = 0                
                    If gamemap[ty][tx+1] = 0                    
                        ol.AddLast(New openlist(tx+1,ty,tv+1))
                        map[tx+1][ty] = tv+1
                    End If
                    End If
                End If
                If ty+1 < mapheight 
                    If map[tx][ty+1] = 0                
                    If gamemap[ty+1][tx] = 0
                        ol.AddLast(New openlist(tx,ty+1,tv+1))
                        map[tx][ty+1] = tv+1
                    End If
                    End If
                End If
                If tx-1 > 0 
                    If map[tx-1][ty] = 0                
                    If gamemap[ty][tx-1] = 0
                        ol.AddLast(New openlist(tx-1,ty,tv+1))
                        map[tx-1][ty] = tv+1
                    End If
                    End If
                End If

            Next
        Wend
    End Method
    Method isonclosedlist:Bool(x1:Int,y1:Int)
        For Local i:=Eachin cl
            If i.x = x1 And i.y = y1 Then Return True
        Next
        Return False
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        SetColor 255,255,255
        For Local y1=0 Until mapheight
        For Local x1=0 Until mapwidth
            If map[x1][y1] > 0
                DrawText map[x1][y1],x1*tilewidth,y1*tileheight
            End If
        Next
        Next
    End Method
End Class

Global myplayer:player = New player()
Global myagent:List<agent> = New List<agent>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        If Rnd(100) < 2
            myagent.AddLast(New agent())
        End If
        myplayer.update
        For Local i:=Eachin myagent
            i.update
            If i.delete = True
                myagent.Remove i
            End If
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        For Local i:=Eachin myagent
            i.draw
        Next
        myplayer.draw
        SetColor 255,255,255
        DrawText "Monkey-X - Floodfill pathfinding agents - code example.",10,2
        DrawText "Use Cursor keys to move (yellow) player.",10,16
        
    End Method
End Class

Function drawmap:Void()
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If gamemap[y][x] = 1
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
    Next
    Next
End Function


Function Main()
    New MyGame()
End Function
