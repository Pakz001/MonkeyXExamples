
Import mojo

Class texteffect
    Field x:Float,y:Float
    Field txt:String
    Field incy:Float=0
    Field delete:Bool=False
    Method New(txt:String,x:Int,y:Int)
        Self.x = x
        Self.y = y
        Self.txt = txt
    End Method
    Method update()
        incy+=.1
        y-=incy
        If y<0 Then delete=True
        For Local i:=Eachin tef
            If i.delete = True Then tef.Remove i
        Next
    End Method
    Method draw()
        SetColor 255,255,255
        DrawText txt,x,y
    End Method
End Class

Class bubba
    Field x:Int,y:Int
    Field tilewidth:Int=32
    Field tileheight:Int=32
    Field attack:Int
    Field defence:Int
    Field health:Int
    Field delete:Bool=False
    Method New(x:Int,y:Int)
        ' first see if the place is already taken
        Local exitloop:Bool = False
        While exitloop = False
            exitloop = True
            For Local i:=Eachin bub            
                If i.x = x
                If i.y = y
                    exitloop = False
                End If
                End If
            Next
            If exitloop = False
                x = Rnd(4,16)
                y = Rnd(4,10)
            End If
        Wend
        ' set the thing up
        Self.x = x
        Self.y = y
        defence = Rnd(1,7)
        attack = Rnd(1,5)
        health = Rnd(10,30)
    End Method
    Method update()
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        SetColor 255,255,255
        DrawText "A:"+attack,x*tilewidth+2,y*tileheight+1
        DrawText "D:"+defence,x*tilewidth+2,y*tileheight+9
        DrawText "H:"+health,x*tilewidth+2,y*tileheight+17
    End Method
End Class

Class player
    Field x:Int,y:Int
    Field tilewidth:Int=32
    Field tileheight:Int=32
    Field keydelay:Int
    Field attack:Int = 10
    Field defence:Int = 5
    Field health:Int=99
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
    Method update()
        Local nx:Int=x
        Local ny:Int=y
        If KeyDown(KEY_RIGHT)
            If keydelay< Millisecs()
                nx+=1
                keydelay=Millisecs()+300
            End If
        End If
        If KeyDown(KEY_LEFT)
            If keydelay< Millisecs()
                nx-=1
                keydelay=Millisecs()+300
            End If
        End If
        If KeyDown(KEY_UP)
            If keydelay< Millisecs()
                ny-=1
                keydelay=Millisecs()+300
            End If
        End If
        If KeyDown(KEY_DOWN)
            If keydelay< Millisecs()
                ny+=1
                keydelay=Millisecs()+300
            End If
        End If    
        If bubbahere(nx,ny) = True
            Local hit:Int=0
            For Local i:=Eachin bub
                If i.x = nx And i.y = ny
                    hit = Rnd(attack)-Rnd(i.defence)
                    If hit<1 Then hit = Rnd(1,3)                    
                    i.health -= hit
                    tef.AddLast(New texteffect(hit,i.x*32,i.y*32))
                    If i.health < 0 Then i.delete=True
                End If
            Next
            For Local i:=Eachin bub
                If i.delete = True Then bub.Remove i
            Next
        End If
        If mymap.map[nx][ny] = 0            
        If bubbahere(nx,ny) = False
            x = nx
            y = ny
        End If
        End If
    End Method
    Method bubbahere(x:Int,y:Int)
        For Local i:= Eachin bub
            If i.x = x And i.y = y Then Return True
        Next
    End Method
    Method drawplayer()
        SetColor 255,0,0
        DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        SetColor 255,255,255
        DrawText "A:"+attack,x*tilewidth+2,y*tileheight+1
        DrawText "D:"+defence,x*tilewidth+2,y*tileheight+9
        DrawText "H:"+health,x*tilewidth+2,y*tileheight+17
    End Method
End Class

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
        For Local i=0 Until mapwidth
            map[i][0] = 1
            map[i][14] = 1
        Next
        For Local i=0 Until mapheight
            map[0][i] = 1
            map[mapwidth-1][i] = 1
        Next
    End Method
    Method update()
        Local x1 = MouseX() / tilewidth
        Local y1 = MouseY() / tileheight
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

Global mymap:map = New map(20,22,32,32)
Global myplayer:player = New player(1,10)
Global bub:List<bubba> = New List<bubba>
Global tef:List<texteffect> = New List<texteffect>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until 10
            bub.AddLast(New bubba(Rnd(4,16),Rnd(4,10)))
        Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin tef
            i.update
        Next
        For Local i:=Eachin bub
            i.update
        Next            
        mymap.update        
        myplayer.update  
    End Method
    Method OnRender()
        Cls 0,0,0 
        mymap.drawmap
        For Local i:=Eachin bub
            i.draw
        Next                    
        myplayer.drawplayer
        For Local i:=Eachin tef
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Cursors to move the red block. RPG attack/defence example",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
