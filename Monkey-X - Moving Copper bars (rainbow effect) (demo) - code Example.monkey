Import mojo

Global bar1y:Float=0
Global bar1d:String="down"
Global bar2y:Float=100
Global bar2d:String="down"

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        If bar1d="down"
            bar1y+=2.5
        Else
            bar1y-=2.5
        End If
        If bar2d="down"
            bar2y+=4
        Else
            bar2y-=4
        End If
        If bar1y<0 Then bar1d="down"
        If bar1y>DeviceHeight()-90 Then bar1d="up"
        If bar2y<0 Then bar2d="down"
        If bar2y>DeviceHeight()-90 Then bar2d="up"        
    End Method
    Method OnRender()
          Cls 0,0,0 
        Local ypos:Int=bar1y
        For Local n:Int=0 To 1
        If n=1 Then ypos=bar2y
          Local r:Float=0
          Local g:Float=0
          Local b:Float=0
          For Local i=0 Until 45
              SetColor r,g,b
              DrawLine 0,ypos+i,DeviceWidth(),ypos+i
              r+=2.5
              g+=0.5
              b+=0.2
              If n=1 Then g+=2
          Next
          For Local i=0 Until 45
              SetColor r,g,b
              DrawLine 0,ypos+i+45,DeviceWidth(),ypos+i+45
              r-=2.5
              g-=0.5
              b-=0.2
              If n=1 Then g-=2
          Next
          Next
          
        SetColor 255,255,255
        DrawText "Monkey-X - Copperbar) Example.",10,10
    End Method
End Class


Function Main()
    New MyGame()
End Function
