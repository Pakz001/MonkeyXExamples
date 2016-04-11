Import mojo

Class _ai
    Field x:Float
    Field y:Float
    Field angle:Int
    Field speed:Float=2
    Field destinationangle:Int
    Field dist:Int
    Field state:String="follow"
    Field hitpoints:Int=4
    Method New(_x:Float,_y:Float,_angle:Int)
        x = _x
        y = _y
        angle=_angle
    End Method
    Method update()
        dist = distance(x,y,p.x,p.y)
        Select state
            Case "follow"
                x+=Cos(angle)*speed
                y+=Sin(angle)*speed                
                destinationangle = getangle(p.x,p.y,x,y)
                If dist>50 Then 'turn towards player
                    If leftangle(angle,destinationangle) = True Then angle+=3 Else angle-=3
                    If angle>180 Then angle=-180
                    If angle<-180 Then angle=180
                End If
                If Rnd(100) < 2 Then state="evade"
            Case "evade"
                destinationangle = getangle(x,y,p.x,p.y)
                If leftangle(angle,destinationangle) = True Then angle+=3 Else angle-=3
                If angle>180 Then angle=-180
                If angle<-180 Then angle=180                
                x+=Cos(angle)*speed
                y+=Sin(angle)*speed
                If dist > 250 Then state="follow"
        End Select            
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x,y,10,10
    End Method
End Class

Class playerlaser
    Field x:Float
    Field y:Float
    Field angle:Int
    Field speed:Float=4
    Field delete:Bool=False
    Method New(_x:Float,_y:Float,_angle:Int)
        x = _x
        y = _y
        angle=_angle
    End Method
    Method update()
        x+=Cos(angle)*speed
        y+=Sin(angle)*speed
        If x<-100 Then delete=True
        If x>DeviceWidth()+100 Then delete = True
        If y<-100 Then delete = True
        If y>DeviceHeight+100 Then delete = True
        ' laser ai collision
        For Local i:=Eachin ai
            If rectsoverlap(i.x,i.y,10,10,x,y,10,10) = True
                delete = True
                i.hitpoints-=1
                If i.hitpoints=0 Then ai.Remove(i)
            End If
        Next
        '
        For Local i:=Eachin pl
            If i.delete = True Then pl.Remove(i)
        Next
    End Method
    Method draw()
        SetColor 255,255,0
        DrawOval x,y,3,3
    End Method
End Class

Class player
    Field angle:Int
    Field x:Float = 100
    Field y:Float = 100
    Field mx:Float = 2 'movement speed x
    Field my:Float = 2 'movement speed y    
    Method update()
        ' player controls
        If KeyHit(KEY_SPACE)
            pl.AddLast(New playerlaser(x,y,angle))
        End If
        x+=Cos(angle)*mx
        y+=Sin(angle)*my
        Local destinationangle = getangle(MouseX(),MouseY(),x,y)
        If leftangle(angle,destinationangle) = True Then angle+=3 Else angle-=3
        If angle>180 Then angle=-180
        If angle<-180 Then angle=180
    End Method
    Method draw()
        SetColor 255,255,255
        DrawOval x,y,10,10
    End Method
End Class

Global p:player = New player
Global pl:List<playerlaser> = New List<playerlaser>
Global ai:List<_ai> = New List<_ai>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        ai.AddLast(New _ai(-100,100,0))
        ai.AddLast(New _ai(-100,200,0))
        ai.AddLast(New _ai(-100,300,0))
        ai.AddLast(New _ai(-100,400,0))
    End Method
    Method OnUpdate()        
        p.update
        For Local i:=Eachin pl
            i.update
        Next
        For Local i:=Eachin ai
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin ai
            i.draw
        Next
        For Local i:=Eachin pl
            i.draw
        Next
        p.draw
        SetColor 255,255,255
        DrawText "Player (white) moves towards mouse, space = shoot",0,0
    End Method
End Class

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
End

Function Main()
    New MyGame()
End Function
