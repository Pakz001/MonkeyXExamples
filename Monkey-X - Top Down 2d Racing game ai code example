Import mojo

Const screenwidth:Int = 640
Const screenheight:Int = 480
Global rtarray:Int[] = New Int[screenwidth*screenheight]
Global rtimage:Image
Global makert:Bool=True
Global pointx:Int[] = New Int[7] ' racing track corners
Global pointy:Int[] = New Int[7]
Global newtracktimer:Int=0

Class cars
    
    Field x:Float
    Field y:Float
    Field col:Int
    Field np:Int=1
    Field angle:Int
    Field speed:Float=0
    Field dx:Float
    Field dy:Float
    Field num:Int
    Method New(number:Int)
        num=number
        x = pointx[0]-number*12
        y = pointy[0]+number*12
        dx = pointx[1]+Rnd(-8,8)
        dy = pointy[1]+Rnd(-8,8)        
        col = Rnd(0,5)
        angle=getangle(dx,dy,x,y)
    End Method
    Method update()
        If speed < 1.5 Then speed+=0.05
        Local dangle=getangle(x,y,dx,dy)
        If leftangle(angle,dangle) = True Then angle-=3 Else angle+=3
        If angle<-180 Then angle=180
        If angle>180 Then angle=-180
        Local mx:Float=Cos(angle)*speed
        Local my:Float=Sin(angle)*speed
        x+=mx
        y+=my
        If distance(x,y,dx,dy) < 16 Then
            np+=1
            If np>6 Then np = 0
            dx = pointx[np]+Rnd(-8,8)
            dy = pointy[np]+Rnd(-8,8)
        End If
        'If the cars collide
        For Local i:=Eachin car
        For Local ii:=Eachin car
            If i<>ii
                If rectsoverlap(i.x-3,i.y-3,6,6,ii.x-3,ii.y-3,6,6) = True
                    Local d1:Int=distance(i.x,i.y,i.dx,i.dy)
                    Local d2:Int=distance(ii.x,ii.y,ii.dx,ii.dy)
                    If d1 < d2 Then ii.speed = Rnd(1) ' car furthest from dest slows down
                End If                
            End If
        Next
        Next
        ' if the car is outside of the track (gravel)
        If rtarray[Int(y)*screenwidth+Int(x-3)] <> -1 Then speed=Rnd(1)
    End Method
    Method draw()
        Select col
            Case 0 ; SetColor 255,0,0
            Case 1 ; SetColor 255,255,0
            Case 2 ; SetColor 0,255,0
            Case 3 ; SetColor 0,255,255
            Case 4 ; SetColor 0,0,255
        End Select
        DrawOval x-3,y-3,6,6
    End Method
End Class

Global car:List<cars> = New List<cars>

Class MyGame Extends App
    Method OnCreate()
        Seed = Millisecs()
        SetUpdateRate(60)
        rtimage = CreateImage(screenwidth,screenheight)
        newtracktimer = Millisecs() + 5000+Rnd(22600)
    End Method
    Method OnUpdate()
        For Local i:=Eachin car
            i.update
        Next
        If Millisecs() > newtracktimer
            makert = True
            newtracktimer = Millisecs() + 5000+Rnd(22600)
        End If
    End Method
    Method OnRender()
        If makert = True 
            car.Clear()
            createracetrack()
            For Local i=0 Until 4
                car.AddLast(New cars(i))
            Next
            makert = False            
        End If
        Cls 0,0,0 
        SetColor 255,255,255
        DrawImage rtimage,0,0
        '        
        For Local i:=Eachin car
            i.draw
            SetColor 255,255,0
            DrawRect i.dx-4,i.dy-4,8,8
        Next
        SetColor 255,0,0
        For Local i=0 Until 7
            DrawRect pointx[i]-5,pointy[i]-5,10,10
        Next
        SetColor 255,255,255
        DrawText "Topdown Racing game ai example",0,0
    End Method
End Class


Function createracetrack:Void()
    Cls 0,0,0
    SetColor 255,255,255
    Local x:Int = screenwidth/2
    Local y:Int = screenheight/2
    Local angle:Int=0
    For Local cnt=0 Until 7
        pointx[cnt] = x+Cos(angle)*Rnd(100,200)
        pointy[cnt] = y+Sin(angle)*Rnd(100,200)
        angle+=360/7
    Next
    For Local y=-16 To 16
    For Local x=-16 To 16    
        For Local i=0 Until 6
            DrawLine pointx[i]+x,pointy[i]+y,pointx[i+1]+x,pointy[i+1]+y
        Next
        DrawLine pointx[6]+x,pointy[6]+y,pointx[0]+x,pointy[0]+y
    Next
    Next    
    ReadPixels(rtarray, 0, 0, screenwidth, screenheight)
    rtimage.WritePixels(rtarray,0,0,screenwidth,screenheight)
    Cls
End Function


Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1) + Abs(y2-y1)
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return ATan2(y1-y2, x1-x2)
End Function

Function leftangle:Bool(_angle:Int,_destinationangle:Int)
    Local cnt1 = 0    
    Local a1 = _angle
    While a1<>_destinationangle    
        a1+=1
        If a1>180 Then a1=-180
        cnt1+=1
    Wend
    If cnt1<180 Then Return True Else Return False
End Function


Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function   

Function Main()
    New MyGame()
End Function
