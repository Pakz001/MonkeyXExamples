Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Const tilewidth:Int=32
Const tileheight:Int=32
Const mapwidth:Int=16
Const mapheight:Int=10
Global currentscreen:Int=0

'1 = block
'2 = circle turn around ship thingy
Global screen1:Int[][] =  [ [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1],
                            [1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1],
                            [1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                            [1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,1],
                            [1,1,0,1,0,1,0,0,0,0,0,0,0,0,1,1],
                            [1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1],
                            [1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1]]
            
Global screen2:Int[][] = [  [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0],
                            [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0],
                            [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0],
                            [0,0,0,1,1,1,0,0,0,0,1,1,1,1,1,1],
                            [0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,1],
                            [0,0,0,1,1,1,1,1,0,0,1,1,1,1,1,1],
                            [0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                            [0,0,0,0,2,0,0,0,0,0,0,0,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
                            
Global screen3:Int[][] = [  [1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0],
                            [1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0],
                            [1,1,1,1,1,1,1,0,0,1,1,1,0,0,0,0],
                            [1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0],
                            [1,1,1,1,1,0,0,1,1,1,1,1,0,0,0,0],
                            [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]

Class effect
    Field x:Int
    Field y:Int
    Field w:Float
    Field h:Float
    Field delete:Bool=False
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
        w=10
        h=10
    End Method
    Method update()
        w-=.2
        h-=.2
        If w<0 Or h<0 Then delete = True
        For Local i:=Eachin e
            If i.delete = True Then e.Remove i
        Next
    End Method
    Method draw()
        SetColor 255,255,0
        DrawOval x+w/2,y+h/2,w,h
    End Method
End Class

Class powerup
    Field x:Int
    Field y:Int
    Field w:Int=32
    Field h:Int=32
    Field delete:Bool=False
    Method New(_x:Int,_y:Int)
        x=_x
        y=_y
    End Method
    Method update()
        If rectsoverlap(p.x,p.y,p.w,p.h,x,y,w,h) = True
            delete = True
            p.cweapon=True
        End If
        For Local i:=Eachin pu
            If i.delete=True Then pu.Remove i
        Next
    End Method
    Method draw()
        SetColor 255,255,0
        DrawOval x,y,w,h
        SetColor 255,255,255
        DrawText "W",x+w/2,y+h/2,0.5,0.5
    End Method
End Class

Class dualslider
    Field x1:Int
    Field y1:Int
    Field w:Int=32
    Field h:Int=32
    Field x2:Int
    Field y2:Int
    Field dir:String="right"
    Method New(_x1:Int,_y1:Int,_x2:Int,_y2:Int)
        x1 = _x1
        y1 = _y1
        x2 = _x2
        y2 = _y2
    End Method
    Method update()
        If dir="right"
            Local s:Bool=False
            If tc(x1+1,y1,w,h) = True Then s=True
            If tc(x2+1,y1,w,h) = True Then s=True
            If s = False
                x1+=1
                x2+=1
            Else
                dir="left"
            End If
        End If
        If dir="left"
            Local s:Bool=False
            If tc(x1-1,y1,w,h) = True Then s=True
            If tc(x2-1,y1,w,h) = True Then s=True
            If s = False
                x1-=1
                x2-=1
            Else
                dir="right"
            End If            
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x1,y1,w,h
        DrawOval x2,y2,w,h
    End Method
End Class

Class laser
    Field x:Float
    Field y:Float
    Field w:Int=8
    Field h:Int=8
    Field incx:Float
    Field incy:Float
    Field delete:Bool=False
    Method New(_x:Float,_y:Float,_incx:Float,_incy:Float)
        x = _x
        y = _y
        incx = _incx
        incy = _incy
    End Method
    Method update()
        x+=incx
        y+=incy
        If tc(x,y,w,h) = True
            delete=True
        End If
        For Local i:=Eachin l
            If i.delete = True Then l.Remove i
        Next
    End Method
    Method draw()
        SetColor 255,255,0
        DrawOval x-w/2,y-h/2,w,h
    End Method
End Class

Class turret
    Field x:Int
    Field y:Int
    Field w:Int=64
    Field h:Int=64
    Field shottimer:Int
    Method New(_x,_y)
        x = _x
        y = _y
    End Method
    Method update()    
        If shottimer < Millisecs()
        If p.x < x
            Local a:Int=getangle(p.x+p.w/2,p.y+p.h/2,x,y+h/2)
            Local ix:Float=Cos(a)
            Local iy:Float=Sin(a)
            l.AddLast(New laser(x,y+h/2,ix,iy))
            shottimer = Millisecs() + 1000
        End If
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x,y,w,h
    End Method
End Class
                          
Class player
    Field x:Float
    Field dir:String="right"
    Field y:Float
    Field w:Int=32
    Field h:Int=32
    Field shield:Int=100
    Field msl:Int=1
    Field msr:Int=1
    Field cweapon:Bool=False
    Field cweapona:Int=0
    Field cwd:Int=0
    Method New()
    End Method
    Method update()
        If cweapon = True 
            cwd+=1
            If cwd>10 Then
                e.AddLast(New effect(x+Cos(cweapona)*50,y+Sin(cweapona)*50))
                cwd=0
            End If
            If dir="left" Then cweapona-=5 Else cweapona+=5
            If cweapona < -180 Then cweapona = 180
            If cweapona > 180 Then cweapona = -180
            
        End If
        Select currentscreen
            Case 0
                If p.y+p.h > mapheight*tileheight+96 Then 
                    currentscreen = 1
                    t.AddLast(New turret(12*tilewidth,9*tileheight))
                    pu.AddLast(New powerup(6*tilewidth,10*tileheight))
                    p.y=96                    
                End If
            Case 1
                If p.x < 64 Then
                    currentscreen = 2
                    t.Clear()
                    l.Clear()
                    pu.Clear()
                    Local x1:Int=5*tilewidth
                    Local y1:Int=8*tileheight
                    ds.AddLast(New dualslider(x1,y1,x1+4*tilewidth,y1))
                    p.x = 32+mapwidth*tilewidth                    
                End If
            Case 2
                If p.y < 96 Then
                    currentscreen = 0
                    ds.Clear()
                    e.Clear()
                    p.cweapon=False                    
                    p.x = 6*tilewidth
                    p.y = 8*tileheight
                End If
        End Select
        If msl>0 Then msl-=1
        If msr>0 Then msr-=1
        'gravity for ship
        If p.y+p.h < mapheight*tileheight+97
        For Local i=0 Until 2
        If tc(p.x,p.y+1,p.w,p.h) = False
            p.y+=1
        End If
        Next
        End If
        If KeyDown(KEY_UP)
            If p.y-1 > 96
            For Local i=0 Until 4
            If tc(p.x,p.y-1,p.w,p.h) = False
                p.y-=1
            End If
            Next
            End If
        End If
        If KeyDown(KEY_LEFT)
            dir="left"
            If msl<3 Then msl+=2
            For Local i=0 Until msl
            If tc(p.x-1,p.y,p.w,p.h) = False
                p.x-=1
            End If
            Next            
        End If
        If KeyDown(KEY_RIGHT)
            dir="right"                         
            If p.x+p.w+1 < mapwidth*tilewidth+64
            If msr<3 Then msr+=2            
            For Local i=0 Until msr
            If tc(p.x+1,p.y,p.w,p.h) = False
                p.x+=1
            End If
            Next
            End If            
        End If
    End Method
    Method draw()
        SetColor 0,0,255
        DrawRect x,y,w,h
        If cweapon = True Then            
            DrawOval x+Cos(cweapona)*50,y+Sin(cweapona)*50,20,20
        End If
    End Method
End Class

Global p:player = New player
Global t:List<turret> = New List<turret>
Global l:List<laser> = New List<laser>
Global ds:List<dualslider> = New List<dualslider>
Global pu:List<powerup> = New List<powerup>
Global e:List<effect> = New List<effect>
                                                                                                                
Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        ' player start position screen 1
        p.x = 6*tilewidth 
        p.y = 8*tileheight
    End Method
    Method OnUpdate()                
           p.update  ' update player
           For Local i:=Eachin l 'update lasers
               i.update
           Next
           For Local i:=Eachin t 'update turrets
               i.update
           Next
        For Local i:=Eachin ds 'update dual sliders
            i.update
        Next
        For Local i:=Eachin pu 'update powerups
            i.update
        Next
        For Local i:=Eachin e ' update effects
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 100,100,100
        DrawRect 64,32,screenwidth-128,64
        SetColor 255,255,255
        drawboxedrect 64,32,screenwidth-1-128,64
        drawmap
        drawboxedrect 64,96,screenwidth-1-128,mapheight*tileheight
        For Local i:=Eachin t' draw turrets
            i.draw
        Next
        For Local i:=Eachin ds 'draw dual sliders
            i.draw
        Next
        For Local i:=Eachin l' 'draw lasers
            i.draw
        Next        
        For Local i:=Eachin pu 'draw powerups
            i.draw
        Next
        For Local i:=Eachin e 'draw effects
            i.draw
        Next
        p.draw 'draw player
    End Method
End Class

Function drawmap:Void()
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Local t:Int=0
        Select currentscreen
            Case 0
                t = screen1[y][x]
            Case 1    
                t = screen2[y][x]
            Case 2
                t = screen3[y][x]
        End Select
        If t=1 Then
            DrawRect x*tilewidth+64,y*tileheight+96,tilewidth,tileheight
        End If
    Next
    Next
End Function

'coords collide with map solid blocks true/false
Function tc:Bool(x:Int,y:Int,w:Int,h:Int)
    Local cx = (x-64)/tilewidth
    Local cy = (y-96)/tileheight
    For Local y2=cy-1 Until cy+4
    For Local x2=cx-1 Until cx+4
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            Local t:Int=0
            Select currentscreen
                Case 0;t = screen1[y2][x2]
                Case 1;t = screen2[y2][x2]
                Case 2;t = screen3[y2][x2]
            End Select
            If t = 1
                Local x3 = (x2)*tilewidth
                Local y3 = (y2)*tileheight
                If rectsoverlap(x-64,y-96,w,h,x3,y3,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function

Function drawboxedrect:Void(x:Int,y:Int,w:Int,h:Int)
    DrawLine x,y,x+w,y
    DrawLine x,y,x,y+h
    DrawLine x,y+h,x+w,y+h
    DrawLine x+w,y,x+w,y+h
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return ATan2(y1-y2, x1-x2)
End Function

Function Main()
    New MyGame()
End Function
