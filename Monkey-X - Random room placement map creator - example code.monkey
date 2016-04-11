Import mojo

Class room
    Field mapwidth:Int=640/12
    Field mapheight:Int=480/12
    Field tilewidth:Int=12
    Field tileheight:Int=12
    Field map:Int[640/12][]
    Field refreshmaptime:Int=0
    Method New()
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        newmap
    End Method    
    Method update()
        If KeyHit(KEY_SPACE) Then 
        newmap
        refreshmaptime=0
        End If
        refreshmaptime+=1
        If refreshmaptime>200 Then 
            newmap
            refreshmaptime=0
        End If
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
        For Local i=0 Until 10
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

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        myroom.update
    End Method
    Method OnRender()
        Cls(0,0,0)
        myroom.draw
        SetColor 255,255,255
        DrawText     "Press spacebar to create new map ",
                    2,2
    End
End


Function Main()
    New MyGame()
End
