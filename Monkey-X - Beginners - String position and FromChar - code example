Import mojo

Global sp:Int=0
Global str:String="Hello World."

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(5)
    End Method
    Method OnUpdate()        
        sp+=1
        If sp>=str.Length Then sp=0
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        PushMatrix()
        Scale 2.0,2.0
        DrawText "String Character example.",0,0
        DrawText String.FromChar(str[sp]),0,15
        DrawText "Character "+sp+ " of : "+str,0,30
        PopMatrix()
    End Method
End Class


Function Main()
    New MyGame()
End Function
