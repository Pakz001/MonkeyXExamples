Import mojo

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Line seperation (Less wide code / blog posts) example code",0,0
        Local val:Int=addinteger(10,20)
        ' Here you can see that one line has become more lines resulting
        ' in less longs lines.
        DrawText "10+20 = " +
                            val,
                            100,
                            20
        
    End Method
End Class

' Function example on multiple lines
Function addinteger:Int(val1:Int,
                        val2:Int)
    Return val1+val2
End Function

Function Main()
    New MyGame()
End Function
