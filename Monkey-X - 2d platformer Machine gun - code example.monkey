Import mojo

' player data
Global px:Int=640/2
Global py:Int=480/2
Global pw:Int=32
Global ph:Int=32
Global firedelay:Int

Class bulleteffects
    Field x:Float,y:Float
    Field incx:Float,incy:Float
    Field color:Int=255
    Field timeout:Int=Millisecs()+350+Rnd(250)
    Field colordecrease:Float=0
    Field delete:Bool
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
        incx = Rnd(-0.6,1)
        incy = Rnd(-2,0)
    End Method
    Method update()
        colordecrease+=5
        x+=incx
        For Local i = 0 Until Abs(incy)
            If incy<0 Then y-=1 Else y+=1
            If y>py+ph Then incy=-incy ; Exit
        Next
        incy+=0.1        
        If Millisecs() > timeout Then delete = True
        For Local i:=Eachin bulleteffect
            If i.delete = True Then bulleteffect.Remove i 
        Next
    End Method
    Method draw()
        Local c:Int = color-colordecrease
        If c<0 Then c=0
        SetColor c,c,0
        DrawRect x,y,2,2
    End Method
End Class

Class bullets
    Field x:Float,y:Float,incx:Float=5,incy:Float
    Field timeout:Int=Millisecs()+3000
    Field delete:Bool=False
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
        incy = Rnd(-0.03,0.03)
    End Method
    Method update()
        x+=incx
        y+=incy
        If Millisecs() > timeout Then delete = True
        For Local i:=Eachin bullet
            If i.delete = True Then bullet.Remove i
        Next
    End Method
    Method draw()
        SetColor 255,40,10
        DrawOval x,y,3,3
    End Method
End Class

Global bulleteffect:List<bulleteffects> = New List<bulleteffects>
Global bullet:List<bullets> = New List<bullets>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        If KeyDown(KEY_SPACE)
            If Millisecs() > firedelay
                bulleteffect.AddLast(New bulleteffects(px+32,py+10))
                bullet.AddLast(New bullets(px+32,py+10))
                firedelay = Millisecs() + 50
            End If
        End If
        For Local i:=Eachin bulleteffect
            i.update
        Next
        For Local i:=Eachin bullet
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawRect px,py,pw,ph 
        For Local i:=Eachin bulleteffect
            i.draw
        Next
        For Local i:=Eachin bullet
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Press space to fire machine gun..",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
