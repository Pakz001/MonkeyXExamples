Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Const tilewidth:Int=32
Const tileheight:Int=32
Const mapwidth:Int=20
Const mapheight:Int=15
Const numbaddies:Int=10
Global map:Int[][] = [       [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Class baddie
    Field x:Float
    Field y:Float
    Field w:Int
    Field h:Float
    Field delete:Bool=False
    Field state:String = "wait"
    Method New(_x:Float,_y:Float,_w:Int,_h:Int)
        x=_x
        y=_y
        w=_w
        h=_h
    End Method
    Method update()
        Select state
            Case "sink"
                h-=1
                If h<=0 Then delete = true
            Case "moveright"
                For Local i=0 Until 1
                    If tc(x,y-h,w,h,1,0) = False Then x+=1 Else state="moveleft"
                Next
                If Rnd(100)<2 Then state="wait"
            Case "moveleft"
                For Local i=0 Until 1
                    If tc(x,y-h,w,h,-1,0) = False Then x-=1 Else state="moveright"
                Next
                If Rnd(100)<2 Then state="wait"
            Case "wait"
                If Rnd(100)<2
                    If Int(Rnd(1,3)) = 1
                        state="moveleft"
                    Else
                        state="moveright"
                    End If
                End If
        End Select
        For Local i:=Eachin b
            If i.delete = True Then b.Remove i
        Next
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x,y-h,w,h
    End Method
End Class

Class player
    Field x:Float=3*tilewidth
    Field y:Float=3*tileheight
    Field w:Int=tilewidth
    Field h:Int=tileheight
    Field isjumping:Bool=False
    Field incy:Float=0
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
                        incy=0
                        Exit
                    End If
                Next
            End If
        End If
        jumponbaddie
    End Method
    Method jumponbaddie()
        For Local i:=Eachin b
            If isjumping=True
            If incy>0
                If rectsoverlap(x,y,w,h,i.x,i.y-i.h,i.w,i.h) = True Then
                    i.state = "sink"
                    incy=-9
                End If
            End If
            End If
        Next
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawText "P",x+w/2,y+h/2,0.5,0.5
    End Method
End Class

Global p:player = New player
Global b:List<baddie> = New List<baddie>
    
Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until numbaddies
            Local w:Int=Rnd(10,32)
            Local h:Int=Rnd(10,32)
            b.AddLast(New baddie(Rnd(100,screenwidth-64),mapheight*tileheight-32,w,h))
        Next
    End Method
    Method OnUpdate()       
        For Local i:=Eachin b
            i.update
        Next
        p.update 
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        For Local i:=Eachin b
            i.draw
        Next
        p.draw
        SetColor 255,255,255
        DrawText "Use cursor left/right to move, space to jump.",0,0
        DrawText "Jump on ai to kill them.",0,16
    End Method
End Class

Function drawmap:Void()
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[y][x] = 1
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
    Next
    Next
End Function

'tile collision
Function tc:Bool(x:Int,y:Int,w:Int,h:Int,offsetx:Int=0,offsety:Int=0)
    Local cx = (x+offsetx)/tilewidth
    Local cy = (y+offsety)/tileheight
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] = 1
                Local x3 = (x2)*tilewidth
                Local y3 = y2*tileheight
                If rectsoverlap(x+offsetx,y+offsety,w,h,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function

'player tile collision
Function ptc:Bool(offsetx:Int=0,offsety:Int=0)
    Local cx = (p.x+offsetx)/tilewidth
    Local cy = (p.y+offsety)/tileheight
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] = 1
                Local x3 = (x2)*tilewidth
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

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function


Function Main()
    New MyGame()
End Function
