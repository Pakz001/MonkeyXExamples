Import mojo

' 1 = wal, 2 = door, 3 = key, 4 = coin, 5 = tree, 6 = water, 7 = rock
Global map:Int[][] = [      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,3,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1,0,0,0,5,5,5,5,0,0,1,1],
                            [1,1,4,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,4,1,0,0,0,0,5,5,5,0,0,1,1],
                            [1,1,4,0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,1,0,4,1,0,0,0,1,1,1,1,0,0,0,0,0,5,5,0,0,1,1],
                            [1,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,1,2,1,1,0,0,0,0,0,0,0,5,5,0,0,0,1,1],
                            [1,1,3,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,5,5,5,5,0,0,1,1],
                            [1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,5,5,0,0,0,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,0,0,0,1,1],
                            [1,1,0,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,1,1],
                            [1,1,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,5,5,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0,0,0,0,0,7,0,0,0,1,1],
                            [1,1,5,5,5,0,0,0,0,0,0,5,5,5,0,0,0,0,0,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,5,5,5,5,0,0,0,0,0,0,5,5,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0,7,7,7,0,0,0,0,0,1,1],
                            [1,1,0,0,5,5,5,7,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,7,0,0,0,0,1,1],
                            [1,1,0,0,0,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,1,1],
                            [1,1,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,6,6,6,6,6,6,6,6,6,0,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,1,1,1,2,1,1,1,1],
                            [1,1,6,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1],
                            [1,1,6,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0,1,0,0,0,0,3,1,1],
                            [1,1,3,0,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,5,5,5,5,0,0,7,0,0,0,0,1,1,1,2,1,1,1,1],
                            [1,1,4,0,0,0,6,6,6,6,6,0,0,0,0,0,7,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0,1,4,4,4,4,4,1,1],
                            [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,1,4,4,4,4,4,1,1],
                            [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,4,4,4,4,1,1],
                            [1,1,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,4,4,4,4,4,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Class player
    Field x:Float=3*tilewidth
    Field y:Float=3*tileheight
    Field width:Int = tilewidth
    Field height:Int = tileheight
    Field keys:Int = 0
    Field coins:Int = 0
    Field lives:Int = 3
End Class
' the player class in p
Global p:player = New player

Const mapwidth:Int=40
Const mapheight:Int=30
Const tilewidth:Int=32
Const tileheight:Int=32
Global mapx:Int=0
Global mapy:Int=0
Global mapsx:Int=0
Global mapsy:Int=0

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
'        p.x = MouseX()
 '       p.y = MouseY()

        For Local i=0 Until 2
        If p.x > DeviceWidth / 2
            If mapx+20 < mapwidth-1
                mapsx-=1
                If mapsx < 0 Then 
                    mapsx = 31
                    mapx += 1
                Endif
                p.x-=1
            End If
        End If
        Next

        For Local i=0 Until 2
        If p.x < DeviceWidth / 2
            If mapx > 0
                mapsx+=1
                If mapsx > 32 Then 
                    mapsx = 0
                    mapx -= 1
                Endif
                p.x+=1
            End If
        End If
        Next
        ' scrolling down
        For Local i=0 Until 2
        If p.y > DeviceHeight / 2
            If mapy+14 < mapheight-1
                mapsy-=1
                If mapsy < 0 Then 
                    mapsy = 31
                    mapy += 1
                Endif
                p.y-=1
            End If
        End If
        Next
        ' scrolling up
        For Local i=0 Until 2
        If p.y < DeviceHeight / 2
            If mapy > 0
                mapsy+=1
                If mapsy > 31 Then 
                    mapsy = 0
                    mapy -= 1
                Endif
                p.y+=1
            End If
        End If
        Next

        
        If KeyDown(KEY_RIGHT)
            ptcs(1,0)
            For Local i=0 Until 2
                If ptc(1,0) = False
                p.x+=1
                End If
            Next
        End If
        If KeyDown(KEY_LEFT)
            ptcs(-1,0)
            For Local i=0 Until 2
                If ptc(-1,0) = False
                p.x-=1
                End If
            Next
        End If
        If KeyDown(KEY_UP)
            ptcs(0,-1)
            For Local i=0 Until 2
                If ptc(0,-1) = False
                p.y-=1
                End If
            Next
        End If
        If KeyDown(KEY_DOWN)
            ptcs(0,1)
            For Local i=0 Until 2
                If ptc(0,1) = False
                p.y+=1
                End If
            Next
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        SetColor 255,255,0
        DrawOval p.x,p.y,p.width,p.height
        SetColor 0,0,0
        DrawRect 0,0,DeviceWidth,32
        SetColor 255,255,255
        DrawText "Keys : "+p.keys,10,0
        DrawText "Coins : "+p.coins,10,16
        DrawText "Lives : "+p.lives,96,0
        DrawText "Use Cursor keys to move.",DeviceWidth/2,0
        DrawText "Collect keys/coins, open doors",DeviceWidth/2,16        
    End Method
End Class

' player collide with special blocks.
Function ptcs:Int(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight+mapy
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] > 0
                Local x3 = (x2-mapx)*tilewidth-32+mapsx
                Local y3 = (y2-mapy)*tileheight+mapsy
                If rectsoverlap(p.x+offsetx,p.y+offsety,p.width,p.height,x3,y3,tilewidth,tileheight) = True
                    Select map[y2][x2]
                        Case 2
                        If p.keys > 0 
                            map[y2][x2] = 0
                            p.keys-=1
                        End If
                        Case 3 'keys
                        map[y2][x2] = 0
                        p.keys+=1
                        Case 4 'coins
                        map[y2][x2] = 0
                        p.coins+=1
                    End Select
                End If
            End If
        End If
    Next
    Next
    Return 0
End Function

'player collide with solid blocks true/false
Function ptc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight+mapy
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] = 1 Or map[y2][x2] = 2 Or map[y2][x2] = 5 Or map[y2][x2] = 6 Or map[y2][x2] = 7
                Local x3 = (x2-mapx)*tilewidth-32+mapsx
                Local y3 = (y2-mapy)*tileheight+mapsy
                If rectsoverlap(p.x+offsetx,p.y+offsety,p.width,p.height,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function



Function drawmap:Void()
    For Local y=0 To 14
    For Local x=0 To 20
        Local x1 = ((x*tilewidth)+mapsx)-tilewidth
        Local y1 = ((y*tileheight)+mapsy)
        Select map[y+mapy][x+mapx]
            Case 1'Wall
            SetColor 100,100,100
            DrawRect x1,y1,tilewidth,tileheight
            Case 2'Door
            SetColor 200,100,0
            DrawRect x1,y1,tilewidth,tileheight
            Case 3'Key
            SetColor 200,200,0
            DrawOval x1+4,y1+4,tilewidth-8,tileheight-8
            SetColor 255,255,255
            DrawText "K",x1+tilewidth/2,y1+tileheight/2,0.5,0.5
            Case 4'Coin
            SetColor 255,255,0
            DrawOval x1+4,y1+4,tilewidth-8,tileheight-8
            SetColor 255,255,255
            DrawText "$",x1+tilewidth/2,y1+tileheight/2,0.5,0.5
            Case 5'tree
            SetColor 0,200,0
            DrawPoly([Float(x1+16),y1 ,x1+tilewidth,y1+tileheight , x1,y1+tileheight])
            Case 6'water
            SetColor 0,0,200
            DrawRect x1,y1,tilewidth,tileheight
            Case 7'rock
            SetColor 150,50,0
            DrawRect x1,y1+10,tilewidth,tileheight-10
        End Select        
    Next
    Next
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
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
