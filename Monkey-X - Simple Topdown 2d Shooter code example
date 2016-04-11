Import mojo

Global px:Int
Global py:Int
'player bullet delay counter
Global pbd:Int=0

Class bullet
    Field x:Int
    Field y:Int
    Field my:Int = 1
    Field rem:Bool=False
    Method New(_x,_y)
        x = _x
        y = _y
    End Method
End Class

Class ship
    Field x:Float
    Field y:Float
    Field angle:Int
    Field dx:Int
    Field dy:Int
    Field rem:Bool=False
    Method New(_x:Float,_y:Float,_dx,_dy)
        x = _x
        y = _y
        angle = 0
        dx = _dx
        dy = _dy
    End Method
End Class

Global ships:List<ship> = New List<ship>
Global bullets:List<bullet> = New List<bullet>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
           px = DeviceWidth/2
           py = DeviceHeight-64 

    End Method
    Method OnUpdate()
        ' Update the bullets
        pbd+=1
        If pbd > 10 Then
            pbd = 0
            bullets.AddLast(New bullet(px,py))
        End If
        For Local s=0 Until 4
        For Local i:bullet = Eachin bullets
            i.y-=1
            If i.y < -50 Then i.rem = True
            For Local ii:ship = Eachin ships
                If rectsoverlap(i.x,i.y,4,8,ii.x,ii.y,16,16) = True
                    i.rem = True
                    ii.rem = True
                End If
            Next
        Next        
        Next
        For Local i:bullet = Eachin bullets
            If i.rem = True Then bullets.Remove i
        Next
        For Local i:ship = Eachin ships
            If i.rem = True Then ships.Remove i
        Next
        ' For the player movement
        If px < MouseX() Then px+=6
        If px > MouseX() Then px-=6
        ' The Enemy ships 
        For Local i:ship = Eachin ships
            Local a = getangle(i.x,i.y,i.dx,i.dy)
            For Local ii = 0 Until 4
                If i.angle < a Then i.angle+=1
                If i.angle > a Then i.angle-=1
                If i.angle < -180 Then i.angle = 180
                If i.angle > 180 Then i.angle = -180
            Next
            i.x+=Cos(i.angle)*2
            i.y+=Sin(i.angle)*2
            If rectsoverlap(i.x-8,i.y-8,16,16,i.dx-16,i.dy-16,32,32) = True
                   i.dx = 320
                   i.dy = -240
            End If
        Next
        For Local i:ship = Eachin ships
            If i.y < -200 Then
                ships.Remove i
            End If
        Next
        If Rnd(1) < .005
        Local l:Int=Rnd(DeviceWidth)
        Local ll:Int=Rnd(DeviceWidth)
          For Local i=0 Until 4
            ships.AddLast(New ship(l,-50-i*32,ll,240))          
           Next
           End If

    End Method
    Method OnRender()
        Local sc:Int=0
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i:ship = Eachin ships
            DrawRect i.x,i.y,16,16
            sc+=1
        Next
        For Local i:bullet = Eachin bullets
            DrawOval i.x,i.y,4,8
        Next
        DrawText "NumShips:"+sc,10,10
        DrawRect px,py,32,32
    End Method
End

Function Main()
    New MyGame()
End Function

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
         Local dx = x2 - x1
         Local dy = y2 - y1
         Return ATan2(dy,dx)+360 Mod 360
End Function

Function rectsoverlap:Int(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 > (x2 + w2) Or (x1 + w1) < x2 Then Return False
    If y1 > (y2 + h2) Or (y1 + h1) < y2 Then Return False
    Return True
End
