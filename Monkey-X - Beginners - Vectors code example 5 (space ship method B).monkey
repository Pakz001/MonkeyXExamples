Import mojo

Class player
    Field x:Float,y:Float
    Field thrustmax:Float=0.1
    Field speedmax:Float=5
    Field rotatemax:Float=4
    Field thrustx:Float,thrusty:Float,angle:Int
    Field velocityx:Float,velocityy:Float
    Field thrusting:Bool=False
    Field speed:Float,heading:int
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
    End Method
    Method update()
        If KeyDown(KEY_LEFT) Then angle-=rotatemax
        If KeyDown(KEY_RIGHT) Then angle+=rotatemax
        If angle<0 Then angle=angle+360
        If angle>359 Then angle=angle-360
        thrusting = False
        If KeyDown(KEY_UP) 
            thrustx = vectorx(thrustmax,angle)
            thrusty = vectory(thrustmax,angle)
            thrusting = True
        End If
        If KeyDown(KEY_DOWN)
            thrustx = vectorx(-thrustmax,angle)
            thrusty = vectory(-thrustmax,angle)
            thrusting = True
        End If
        If Not thrusting 
            thrustx = 0
            thrusty = 0
        End If
        velocityx += thrustx
        velocityy += thrusty
        speed = vectordistance(velocityx,velocityy)
        heading = vectorangle(velocityx,velocityy)
        If speed > speedmax Then speed = speedmax
        If KeyDown(KEY_SPACE) Then speed = 0
        velocityx = vectorx(speed,heading)
        velocityy = vectory(speed,heading)
        x+=velocityx
        If x<0 Then x=640
        If x>640 Then x=0
        y+=velocityy
        If y<0 Then y=480
        If y>480 Then y=0
    End Method
    Method draw()
         SetColor 0,127,255
          DrawOval x-10,y-10,21,21
         SetColor 127,255,127
          DrawLine x,y,x+vectorx(10,heading),y+vectory(10,heading)
          SetColor 255,255,255
          DrawLine x,y,x+vectorx(20,angle),y+vectory(20,angle)
        SetColor 255,255,255
        DrawText "Vector example 5 - space ship method b.",0,0
          DrawText " Angle: " + angle,0,15        
          DrawText "Speed: " + Int(speed) + " Heading: " + heading,0,30
    End Method
End Class

Global players:List<player> = New List<player>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
           players.AddLast(New player(640/2,480/2))
    End Method
    Method OnUpdate()
        For Local i:=Eachin players
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin players
            i.draw
        Next
    End Method
End Class

' Thanks to Blitzcoder for the functions
';= Get horizontal size of vector using distance and angle
Function vectorx:Float(distance:Float,angle:Float)
    Return Sin(angle)*distance
End Function
';= Get vertical size of vector using distance and angle
Function vectory:Float(distance:Float,angle:Float)
    Return Sin(angle-90)*distance
End Function
';= Get True length of a vector
Function vectordistance:Float(x:Float,y:Float)
    Return Sqrt(x*x+y*y)
End Function
';= Get True angle of a vector
Function vectorangle:Float(x:Float,y:Float)
    Return -ATan2(x,y)+180
End Function


Function Main()
    New MyGame()
End Function
