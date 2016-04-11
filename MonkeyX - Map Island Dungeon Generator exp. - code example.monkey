Import mojo

Class themap
    Field mapwidth:Int
    Field mapheight:Int
    Field tilewidth:Float
    Field tileheight:Float
    Field map:Int[][]
    Field cmode:Int=Rnd(1,4)
    Method New(    mapwidth:Int,
                mapheight:Int)
        Self.mapwidth = mapwidth
        Self.mapheight = mapheight
        tilewidth = Float(DeviceWidth())/Float(mapwidth)
        tileheight = Float(DeviceHeight())/Float(mapheight)    
        map = New Int[mapwidth][]
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        map[mapwidth/2][mapheight/2] = 255
        For Local i=0 To (mapwidth*mapheight)/4
        placeblock
        Next
        mapblur
    End Method
    Method mapblur()
        For Local i=0 To mapwidth*mapheight
            Local x1:Int=Rnd(2,mapwidth-4)
            Local y1:Int=Rnd(2,mapheight-4)
            If map[x1][y1] > 0
                For Local y2=y1-1 To y1+1
                For Local x2=x1-1 To x1+1
                    If map[x2][y2] = 0
                        map[x2][y2] = map[x1][y1] / 2
                    End If
                Next
                Next
            End If
        Next
    End Method
    Method placeblock()
        Local x:Int=Rnd(0,mapwidth)
        Local y:Int=Rnd(0,mapheight)
        Local fitsx:Int=Rnd(3,12)
        Local fitsy:Int=Rnd(3,12)
        If Rnd(0,10) < 2 Then
            If Rnd(1,3) = 1
                fitsx = Rnd(6,22)                
                fitsy = 3
            Else
                fitsy = Rnd(6,22)
                fitsx = 3
            End If
        End If
        If mapfit(x,y,fitsx,fitsy) = True
            fitmap(x,y,fitsx,fitsy)
        End If
        
    End Method
    Method fitmap(x:Int,y:Int,w:Int,h:Int)
        For Local y2 = y Until y+h
        For Local x2 = x Until x+w
            map[x2][y2] = 255
        Next
        Next        
    End Method
    Method mapfit:Bool(x:Int,y:Int,w:Int,h:Int)
        If x+w > mapwidth-3 Then Return False
        If y+h > mapheight-3 Then Return False
        If x<3 Then Return False
        If y<3 Then Return False
        For Local y2 = y Until y+h
        For Local x2 = x Until x+w
            If map[x2][y2] > 0 Then Return False
        Next
        Next
        For Local y2 = y+1 Until y+h-1
            If map[x-1][y2] > 0 Then Return True
            If map[x+w][y2] > 0 Then Return True
        Next        
        For Local x2 = x+1 Until x+w-1
            If map[x2][y-1] > 0 Then Return True
            If map[x2][y+h] > 0 Then Return True
        Next
        End Method
    Method draw()
        For Local y:Float=0 Until mapheight Step 1
        For Local x:Float=0 Until mapwidth Step 1
            If map[x][y] > 0
            Local d:Int = distance(x,y,320,240)
            d = d / 2.5        
            SetColor map[x][y],d,0
            DrawRect    x*tilewidth,
                        y*tileheight,
                        tilewidth+1,
                        tileheight+1
            End If
        Next
        Next
    End Method
End Class

Global mymap:themap

Class MyGame Extends App
    Field refresh:Int
    Method OnCreate()
        SetUpdateRate(60)
        mymap = New themap(100,100)
    End Method
    Method OnUpdate()
        refresh+=1
        If refresh>120
            mymap = New themap(Rnd(100,200),Rnd(100,200))
            refresh=0
        Endif        
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

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1)+Abs(y2-y1)
End Function
