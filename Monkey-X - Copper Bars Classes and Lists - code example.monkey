Import mojo

Global numbars:Int=6

Class bar
    Field y:Float
    Field height:Int
    Field yspeed:Float
    Field direction:String
    Field incr:Float,incg:Float
    Field incb:Float
    Method New(ri:Float,gi:Float,bi:Float)
        height=Rnd(16,90)
        y = Rnd(height,DeviceHeight()-height)
        incr = 255/height
        incg = gi
        incb = bi
        If Rnd(10)<5 Then 
            direction="up"
        Else
            direction="down"
        End If
        yspeed = Rnd(1,4)
    End Method
    Method update()
        If direction = "down"
            y+=yspeed
        Else
            y-=yspeed
        End If
        If y<0 Then direction = "down"
        If y>DeviceHeight()-90 Then direction = "up"
    End Method
    Method draw()
        Local ypos:Int=y
        Local r:Float,g:Float,b:Float
        For Local n:Int=0 To 1
          For Local i=0 Until height/2
              SetColor r,g,b
              DrawLine 0,ypos+i,DeviceWidth(),ypos+i
              r+=incr
              g+=incg
              b+=incb
          Next
          For Local i=0 Until height/2
              SetColor r,g,b
              DrawLine     0,ypos+i+height/2,
                          DeviceWidth(),ypos+i+height/2
              r-=incr
              g-=incg
              b-=incb
          Next
          Next
        
    End Method
End Class

Global mybar:List<bar> = New List<bar>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until numbars
            mybar.AddLast(New bar(Rnd(155,255)/45,Rnd(0.5,2),Rnd(0.2,2)))
           Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin mybar
            i.update
        Next
    End Method
    Method OnRender()
          Cls 0,0,0           
        For Local i:=Eachin mybar
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Monkey-X - Copper Bars and Classes/Lists Example.",10,10
    End Method
End Class


Function Main()
    New MyGame()
End Function
