Import mojo

Class MyGame Extends App
	Field r1:Int=255
	Field g1:Int=0
	Field b1:Int=0
	Field r2:Int=0
	Field g2:Int=255
	Field b2:Int=0
	Field r3:Int,g3:Int,b3:Int
    Method OnCreate()
        SetUpdateRate(1)
        ' tint rgb1 with 2 to create 3
        r3=r1/2+r2/2
        g3=g1/2+g2/2
        b3=b1/2+b2/2
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        ' what is tinting?
        ' If you wish to make a color look more like another color
        ' then you could tint it. Say you have a greyscale image
        ' and want to turn it into red. You could tint it red.
        ' you take each color value and halve it. The color where you want to 
        ' tint it with you halve to. Then you add them together to form the new color.
        SetColor r1,g1,b1
        DrawText "Color 1",0,0
        DrawRect 0,20,50,480
        SetColor r2,g2,b2
        DrawText "Color we tint with",200,0
        DrawRect 200,20,50,480
        SetColor r3,g3,b3
        DrawText "Resulting 'tinted' color",400,0
        DrawRect 400,20,50,480
    End Method
End Class


Function Main()
    New MyGame()
End Function
