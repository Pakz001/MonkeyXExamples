Import mojo

Class themap
    Field x:Int
    Field y:Int
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field map:Int[][]
    'this holds the offsets the we
    'use to tunnel. 0=upwards;1=right ect
    'use like : x+=dx[0]
    Field dx:Int[]=[0,1,0,-1]
    Field dy:Int[]=[-1,0,1,0]
    Method New(    mapwidth:Int,
                mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = DeviceWidth()/mapwidth
        tileheight = DeviceHeight()/mapheight
        x = mapwidth/2
        y = mapheight/2
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next            
        tunnel()
    End Method
    Method tunnel()
        ' direction of tunneling
        Local dir:Int=1
        'make room countdown
        Local mrt:Int=10
        ' location on the path
        ' where next room is to be made
        Local rx:Int,ry:Int
        For Local i=0 Until ((mapwidth*mapheight)/10)
            map[x][y]=1
            If Rnd(0,5) < 2
                mrt-=1
                dir = newdir(dir)
                
                If mrt = 0
                If rx>3 And ry>3
                If rx<mapwidth-3 And ry<mapheight-3
                    For Local y1 = ry-3 To ry+3
                    For Local x1 = rx-3 To rx+3
                        map[x1][y1]=1
                    Next
                    Next
                End If
                End If
                mrt=10
                End If
                If Rnd(0,20)<2 Or mrt=0
                    rx = x
                    ry = y
                    mrt = 10
                End If
            End If
            If     x>3 And x<mapwidth-3 And 
                y>3 And y<mapheight-3 Then
                x+=dx[dir]
                y+=dy[dir]
            Else
                x = mapwidth/2
                y = mapheight/2
            End If
            
        Next
    End Method
    Method newdir:Int(dir:Int)
        Local exitloop:Bool=False
        Local cnt:Int=0
        While exitloop=False
            Local d:Int=Rnd(0,4)
            cnt+=1
            If cnt>500 Then Return 0
            If d<>dir
                ' is nothing ahead taken
                If map[x+dx[d]][y+dy[d]] = 0
                If map[x+(dx[d]*2)][y+(dy[d]*2)] = 0
                ' do not go in opposite direction
                Select d
                    Case 0
                    If dir<>2 Then 
                        Return d
                    End If
                    Case 1
                    If dir<>3 Then
                        Return d
                    End If
                    Case 2
                    If dir<>0 Then
                        Return d
                    End If
                    Case 3
                    If dir<>1 Then
                        Return d
                    End If
                End Select
                End If
                End If
            End If
        Wend
    End Method
    Method draw()
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If map[x][y] > 0
                Local d:Int=distance(    mapwidth/2,
                                        mapheight/2,
                                        x,
                                        y)

                Local col:Int=0+(1500/(d+1))
                SetColor col,col,col
                DrawRect     x*tilewidth,
                            y*tileheight,
                            tilewidth-1,
                            tileheight-1
            End If
        Next
        Next
    End Method
    Method distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Method
End Class

Global mymap:themap

Class MyGame Extends App
    Field cnt:Int
    Method OnCreate()
        SetUpdateRate(60)
        Local date := GetDate()
        Seed = date[5]        
        mymap = New themap(Rnd(32,150),Rnd(32,150))
    End Method
    Method OnUpdate()        
        cnt+=1
        If cnt>100
            mymap = New themap(Rnd(32,150),Rnd(32,150))
            cnt=0
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        mymap.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
