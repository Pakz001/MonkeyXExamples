Import mojo

Class MyGame Extends App
    Global ang:Float=0
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate() 
        ang+=1
        If ang>360 Then ang=0
    End Method
    Method OnRender()
        Cls 0,0,0 
        'center of the image is 0,0 on screen
        'here we create the poly shape_coords
        Local vorm1:Float[]=[    -5.0,-5.0,
                                5.0,0.0,
                                -5.0,5.0]                                
        SetColor 255,255,255
        PushMatrix()
        ' we draw the poly to translated coords
        Translate DeviceWidth()/2,DeviceHeight()/2
        ' rotate in reverse
        Rotate(-ang)
        ' enlarge times
        Scale(4,4)
        ' draw the poly
           DrawPoly(vorm1)
           PopMatrix()
           'translate back to 0,0           
           Translate 0,0
           SetColor 255,0,0
           DrawLine     DeviceWidth()/2,
                       DeviceHeight()/2,
                       DeviceWidth()/2+Cos(ang)*64,
                       DeviceHeight()/2+Sin(ang)*64
                       SetColor 255,255,255
           DrawText "MonkeyX - Space game Rotate Poly and Cos Sin example",0,0
           DrawText "angle:"+ang,0,20
    End Method
End Class


Function Main()
    New MyGame()
End Function
