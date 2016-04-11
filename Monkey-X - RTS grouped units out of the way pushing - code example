Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Const tilewidth:Int=16
Const tileheight:Int=16

Class player
    Field x:Int
    Field y:Int
    Field dx:Int
    Field dy:Int
    Field ox:Int
    Field oy:Int
    Field w:Int=16
    Field h:Int=16
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
        dx=x
        dy=y
    End Method
    Method update()
        Local x1:Int=MouseX()/tilewidth
        Local y1:Int=MouseY()/tileheight
        Local moved:Bool=False
        If MouseHit(MOUSE_LEFT)
            If rectsoverlap(x1,y1,1,1,x-1,y-1,3,3) = True Then moved=True
        End If
        If moved=True
            moveunit(x1,y1)
            dx = x1
            dy = y1
        End If
        If x<> dx Or y<>dy
            If x<dx Then ox+=1
            If x>dx Then ox-=1
            If y<dy Then oy+=1
            If y>dy Then oy-=1
            If ox=16 Then x+=1 ; dx=x ; ox=0
            If oy=16 Then y+=1 ; dy=y ; oy=0
            If ox=-16 Then x-=1 ; dx=x ; ox = 0
            If oy=-16 Then y-=1 ; dy=y ; oy = 0            
        End If
    End Method
    Method moveunit(_x,_y)
        Local occupied:Bool=False
        For Local i:=Eachin u
            If i.x = _x And i.y=_y Then occupied = True
        Next
        If occupied = False Then
            dx=_x
            dy=_y
            Else
            dx=_x
            dy=_y
            moveunitoutoftheway(_x,_y)
        End If
    End Method
    Method moveunitoutoftheway(x1:Int,y1:Int)
        Local xdir:Int = x1-x
        Local ydir:Int = y1-y
        Local eloop:Bool=False
        Local mx:Int=0
        Local my:Int=0
        While eloop=False
            eloop=True
            For Local i:=Eachin u
                If i.x = x1+mx And i.y=y1+my
                    If moveintofreepos(i.x,i.y) = False Then
                        i.dx+=xdir
                        i.dy+=ydir
                        eloop=False
                    Else
                        Return True
                    End If
                End If
            Next
            mx+=xdir
            my+=ydir
        Wend
    End Method
    Method moveintofreepos:Bool(x1:Int,y1:Int)
        Local eloop:Bool=False
        Local mx:Int
        Local my:Int
        Local cnt:Int=0
        For Local i:=Eachin u
        If i.x = x1 And i.y=y1
        While eloop = False
            eloop=True
            mx=Rnd(-2,2)
            my=Rnd(-2,2)
            If x1+mx = p.x And y1+my = p.y Then eloop = False
            If x1+mx = p.dx And y1+my = p.dy Then eloop = False
            If x1+mx = x1 And y1+my = y1 Then eloop = False
            For Local ii:=Eachin u
                If ii.x = x1+mx And ii.y = y1+my Then eloop = False
                If ii.dx = x1+mx And ii.dy = y1+my Then eloop = False
            Next
            cnt+=1
            If cnt>100 Then Return False
        Wend
        i.dx = x1+mx
        i.dy = y1+my
        End If
        Next
        Return True
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x*tilewidth+ox,y*tileheight+oy,tilewidth,tileheight
    End Method
End Class

Class unit
    Field x:Int
    Field y:Int
    Field w:Int=16
    Field h:Int=16
    Field dx:Float
    Field dy:Float
    Field ox:Int
    Field oy:Int
    Field moved:Bool=False
    Field hasmoved:Bool=False
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
        dx=x
        dy=y
    End Method
    Method update()
        If x<>dx Or y<>dy
            If x<dx Then ox+=1
            If x>dx Then ox-=1
            If y<dy Then oy+=1
            If y>dy Then oy-=1
            If ox=16 Then x=dx ; ox=0
            If oy=16 Then y=dy ; oy=0
            If ox=-16 Then x=dx ; ox = 0
            If oy=-16 Then y=dy ; oy = 0
        End If
        If hasmoved = True And x=dx And y=dy Then hasmoved=False
    End Method
    Method draw()
        SetColor 255,255,0
        DrawOval (x*tilewidth)+ox,(y*tileheight)+oy,tilewidth,tileheight
    End Method
End Class

Global u:List<unit> = New List<unit>
Global p:player = New player(10,10)

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        Local x1:Int=20
        Local y1:Int=15
        Local x3:Int
        Local y3:Int
        For Local i=0 Until 300
            Local taken:Bool=True
            While taken=True
            Local x2:Int=(Rnd(-10,10))
            Local y2:Int=(Rnd(-10,10))
            x3=x1+x2
            y3=y1+y2
            taken=False
            For Local ii:=Eachin u
                If ii.x = x3 And ii.y = y3 Then taken = True ; Exit
            Next
            Wend
            u.AddLast(New unit(x3,y3))
        Next
    End Method
    Method OnUpdate()        
        p.update
        For Local i:=Eachin u
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Press the mouse near the red oval to move it into that direction.",0,0
        DrawText "The yellow ovals move out of the way.",0,16
        For Local i:=Eachin u
            i.draw
        Next
        p.draw
    End Method
End Class

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1) + Abs(y2-y1)
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return ATan2(y1-y2, x1-x2)
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function    

Function Main()
    New MyGame()
End Function
