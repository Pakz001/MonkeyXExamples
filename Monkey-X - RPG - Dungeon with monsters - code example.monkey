Import mojo

Global twidth:Int=8
Global theight:Int=8

Class monster
    Field mapwidth:Int=640/twidth
    Field mapheight:Int=480/theight
    Field map:Int[640/twidth][]
    Field x:Int,y:Int
    Field mdelay:Int=0
    Method New()
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        ' find place for monster
        Local exitloop:Bool=False
        While exitloop = False
            Local x1:Int=Rnd(5,mapwidth-5)
            Local y1:Int=Rnd(5,mapheight-5)
            If myroom.map[x1][y1] = 1 Then
                exitloop = True
                Self.x = x1
                Self.y = y1
                map[x][y] = 1
            End If
        Wend        
    End Method
    Method update()
        mdelay+=1
        If mdelay< 15 Then Return
        mdelay=0
        map[x][y]+=1
        If map[x][y] > 1000
            For Local y1=0 Until mapheight
            For Local x1=0 Until mapwidth
                map[x1][y1] = 0
            Next
            Next
            map[x][y]=1
        End If
        Local exitloop:Bool=False
        While exitloop = False            
            Local y2:Int=Rnd(-2,2)
            Local x2:Int=Rnd(-2,2)
            If myroom.map[x+x2][y+y2] = 1
            If map[x+x2][y+y2] <= map[x][y]
                x+=x2
                y+=y2
                exitloop=True
                Return
            End If
            End If
        Wend
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x*twidth,y*theight,twidth,theight
    End Method
End Class

Class room
    Field mapwidth:Int=640/twidth
    Field mapheight:Int=480/theight
    Field tilewidth:Int=twidth
    Field tileheight:Int=theight
    Field map:Int[640/twidth][]
    Field refreshmaptime:Int=0
    Method New()
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        newmap
    End Method    
    Method update()

    End Method
    Method draw()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If map[x][y] = 1
                SetColor 150,150,150
                DrawRect     x*tilewidth,y*tileheight,
                            tilewidth,tileheight
            End If
            If map[x][y] = 2
                SetColor 200,200,200
                DrawRect     x*tilewidth,y*tileheight,
                            tilewidth,tileheight
            End If            
        Next
        Next
    End Method
    Method newmap()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y] = 0
        Next
        Next
        drawrectinmap(Rnd(10,mapwidth-10),Rnd(10,mapheight-10),5,3)
        For Local i=0 Until 50
            makeroom
        Next
        makewalls
    
    End Method
    Method makewalls()
        ' put walls on the map
        For Local y=1 Until mapheight-1
        For Local x=1 Until mapwidth-1
            If map[x][y] = 0
                If map[x+1][y] = 1
                    map[x+1][y] = 2
                End If                
            End If
            If map[x][y] = 1
                If map[x+1][y] = 0
                    map[x][y] = 2
                End If
            End If
            If map[x][y] = 1
                If map[x][y+1] = 0
                    map[x][y] = 2
                End If
            End If
            If map[x][y] = 0
                If map[x][y+1] = 1
                    map[x][y+1] = 2
                End If
            End If
        Next
        Next
    End Method
    Method makeroom:Bool()
        'find suitable place to make room
        Local exitloop:Bool=False
        Local cnt:Int=0
        While exitloop = False
            cnt+=1
            If cnt>8000 Then exitloop=True
            Local x:Int=Rnd(5,mapwidth-8)
            Local y:Int=Rnd(5,mapheight-8)
            Local roomw:Int=Rnd(4,8)
            Local roomh:Int=Rnd(4,8)
            Local pass1:Bool=True
            For Local y1=0 Until roomh
            For Local x1=0 Until roomh
                If map[x1+x][y1+y] = 1 Then pass1=False
            Next
            Next
            Local pass2:Bool=False
            If pass1=True Then
                For Local y1=3 To roomh-3
                    If map[x-1][y+y1] = 1 Then pass2=True
                    If map[x+roomw][y+y1] = 1 Then pass2=True
                Next
                 For Local x1=3 To roomw-3
                    If map[x+x1][y-1] = 1 Then pass2 = True
                    If map[x+x1][y+roomh] = 1 Then pass2 = True
                Next
            End If
            If pass2 = True Then
                drawrectinmap(x,y,roomw,roomh)
                Return
            End If
        Wend
    End Method
    Method issuitable:Bool(x:Int,y:Int,w:Int,h:Int)
        For Local y1=0 Until h
        For Local x1=0 Until w
            If map[x+x1][y+y1] = 1 Then Return False
        Next
        Next
        Return True
    End Method
    Method drawrectinmap(x:Int,y:Int,w:Int,h:Int)
        For Local y1=0 Until h
        For Local x1=0 Until w
            map[x+x1][y+y1] = 1
        Next
        Next
    End Method
End Class

Global myroom:room = New room()
Global mymonster:List<monster> = New List<monster>


Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)                
        For Local i=0 Until 10
            mymonster.AddLast(New monster())
        Next
    End Method
    Method OnUpdate()        
        myroom.update
        For Local i:=Eachin mymonster
            i.update
        Next        
    End Method
    Method OnRender()
        Cls(0,0,0)
        myroom.draw
        For Local i:=Eachin mymonster
            i.draw
        Next         
        SetColor 255,255,255
        DrawText     "Monsters in a dungeon. (shitting hamster algorithm)",
                    2,2
    End
End


Function Main()
    New MyGame()
End
