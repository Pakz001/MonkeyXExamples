Import mojo


' The most left and most right tiles do not get drawn.
Global map:Int[][] =     [   [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
                            [1,0,0,0,0,0,0,0,0,1,2,2,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,3,0,3,0,0,0,0,0,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]

Const mapwidth:Int=50
Const mapheight:Int=10
Const tilewidth:Int=32
Const tileheight:Int=32
' Level array x location (left of the screen)
Global mapx:Int = 0
' Scrolling offset
Global mapsx:Int = 0

Class baddie
    Field d:String = "left"
    Field x:Float
    Field y:Float
    Field w:Int=20
    Field h:Int=12
    Field isjumping:Bool=False
    Field incy:Float=0
    Method update()
        If isjumping = True
            If incy < 5 Then incy+=.3
            For Local i=0 Until incy
                If btc(x,y,0,1) = False
                    y+=1
                Else
                    isjumping=False
                    Exit                
                End If
            Next
        End If
        Select d
            Case "left"
                For Local i = 0 Until 1                    
                    If x-1<0 Then 
                        d = "right"
                        Exit
                    End If
                    If isjumping = False And btc(x,y,0,1) = False
                        incy = 0
                        isjumping = True
                    End If
                    If btc(x,y,-1,0) = True
                        d="right"
                        Exit
                    End If
                    x-=1
                Next
            Case "right"
                For Local i=0 Until 1
                    If x+w+1>mapwidth*tilewidth Then
                        d="left"
                        Exit
                    End If
                    If btc(x,y,1,0) = True
                        d="left"
                        Exit
                    End If
                    x+=1
                Next
        End Select
    End Method
    Method New(_x:Float,_y:Float)
        x=_x
        y=_y
    End Method
    Method draw()
        SetColor 255,0,0
        Local x1 = x-(mapx*tilewidth)+mapsx
        Local y1 = y+tileheight-h
        DrawRect x1,y1,w,h
    End Method
End Class

Class player
    Field x:Float=32*3
    Field y:Float=32*3
    Field w:Int=32
    Field h:Int=32
    Field incy:Float=0
    Field isjumping:Bool=False
    Method update()
        If KeyDown(KEY_SPACE)
            If isjumping = False
                isjumping = True
                incy=-9
            End If
        End If
        If KeyDown(KEY_RIGHT)
            For Local i=0 Until 5
                If ptc(1,0) = False
                        x+=1
                Else
                    Exit
                End If 
            Next
        End If
        If KeyDown(KEY_LEFT)
            For Local i=0 Until 5
                If ptc(-1,0) = False
                    x-=1
                Else
                    Exit
                End If
            Next
        End If
        If isjumping = False
            If ptc(0,1) = False
                incy = 0
                isjumping = True
            End If
        End If
        If isjumping = True
            If incy>=0
                If incy<5 Then incy+=.3
                For Local i=0 Until incy
                    If ptc(0,1) = False    
                        y+=1
                    Else
                        incy = 0
                        isjumping = False
                        Exit
                    End If
                Next
            End If
            If incy<0
                incy+=.3
                For Local i=0 Until Abs(incy)
                    If ptc(0,-1) = False
                        y-=1
                    Else
                        If psc(0,-1) = True
                        End If
                        incy=0
                        Exit
                    End If
                Next
            End If
        End If
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawText "P",x+w/2,y+h/2,0.5,0.5
    End Method
End Class

Global b:List<baddie> = New List<baddie>
Global p:player = New player

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            If map[y][x] = 3
                b.AddLast(New baddie(x*tilewidth,y*tileheight))
            End If
        Next
        Next
    End Method
    Method OnUpdate()        
        p.update
        For Local i:=Eachin b
            i.update
        Next
        alignmap
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255
        For Local y=0 Until 10
        For Local x=0 Until 21
                Local x1=x*tilewidth+mapsx-tilewidth
                Local y1 = y*tileheight
                Select map[y][x+mapx]
                    Case 1
                    SetColor 255,255,255
                    DrawRect x1,y1,tilewidth,tileheight
                    Case 2
                    SetColor 255,155,22
                    DrawRect x1,y1,tilewidth,tileheight
                    SetColor 255,255,255
                    DrawText "B",x1+tilewidth/2,y1+tileheight/2,0.5,0.5
                End Select
        Next
        Next
        For Local i:=Eachin b
            i.draw
        Next
        p.draw
        DrawText "Use cursor Left and Right and space to control player.",10,20
    End
End

Function alignmap:Bool()
        For Local i=0 Until 5
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

        For Local i=0 Until 5
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
End Function


'player collide with special blocks true/false
Function psc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] = 2
                Local x3 = (x2-mapx)*tilewidth-32+mapsx
                Local y3 = y2*tileheight
                If rectsoverlap(p.x+offsetx,p.y+offsety,p.w,p.h,x3,y3,tilewidth,tileheight) = True
                    map[y2][x2] = 1
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function



'player collide with solid blocks true/false
Function ptc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth+mapx
    Local cy = (p.y+offsety)/tileheight
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] = 1 Or map[y2][x2] = 2
                Local x3 = (x2-mapx)*tilewidth-32+mapsx
                Local y3 = y2*tileheight
                If rectsoverlap(p.x+offsetx,p.y+offsety,p.w,p.h,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function

'baddie collide with solid blocks true/false
Function btc:Bool(x1:Int,y1:Int,offsetx:Int=0,offsety:Int=0)
    Local cx = (x1+offsetx)/tilewidth
    Local cy = (y1+offsety)/tileheight
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] = 1 Or map[y2][x2] = 2
                Local x3 = (x2)*tilewidth-32
                Local y3 = y2*tileheight
                If rectsoverlap(x1+offsetx,y1+offsety+tileheight-12,20,12,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function


Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function

Function Main()
    New MyGame()
End
