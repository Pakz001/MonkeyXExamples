Import mojo

' player data
Global px:Int=640/2
Global py:Int=480/2
Global pw:Int=32
Global ph:Int=32
Global firestart:Bool=True
Global firetime:Int = Millisecs() + Rnd(100,200)

Class flames
    Field x:Float,y:Float,incx:Float=5,incy:Float
    Field mody:Float=0
    Field timeout:Int=Millisecs()+600+Rnd(25)
    Field flamerisetime:Int = Rnd(100,200)
    Field spread:Float
    Field delete:Bool=False
    Field radius:Float=2,col:Float=255
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y+Rnd(-3,3)
        Self.incy = Rnd(-0.3,0.1)
    End Method
    Method update()    
        ' increase the size of the flame
        If radius<8 Then radius+=Rnd(0.4,0.7)
        ' decrease red color
        col-=3
        '         
        x+=incx
        y+=incy        
        ' increase the spread
        spread+=0.02
        incy += Rnd(-spread,spread)
        ' if the flame is near the end        
        If Millisecs() > (timeout-flamerisetime)            
            If mody>0 Then mody=0
            incx-=Rnd(0.2,0.9)
            mody -= Rnd(0.3)
            incy += mody
        End If
        
        ' if burned out then delete the flame
        If Millisecs() > timeout Then delete = True
        For Local i:=Eachin flame
            If i.delete = True Then flame.Remove i
        Next
    End Method
    Method draw()
        SetColor col,40,10
        DrawOval x,y,radius,radius
    End Method
End Class

Global flame:List<flames> = New List<flames>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        If firestart = False And Millisecs() > firetime
            firestart = True
            firetime = Millisecs() + Rnd(500,2000)
        End If
        If KeyDown(KEY_SPACE) Or firestart = True
            If Millisecs() > firetime Then 
                firestart = False
                firetime = Millisecs()+Rnd(500,1000)
            End If
            flame.AddLast(New flames(px+32,py+10))                
        End If
        For Local i:=Eachin flame
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawRect px,py,pw,ph 
        For Local i:=Eachin flame
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Press space to fire flame thrower..",0,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
