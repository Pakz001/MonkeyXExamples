Import mojo

Class myfuncs
    Function drawvalue(val:Int,x:Int,y:Int)
        DrawText "value is : " + val,x,y
    End Function
    Function drawdistance(x1:Int,y1:Int,x2:Int,y2:Int,x:Int,y:Int)
        Local d:Int=Abs(x2-x1)+Abs(y2-y1)
        DrawText "distance is : "+d,x,y
    End Function
End Class

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        myfuncs.drawvalue(10,0,15)
        myfuncs.drawdistance(0,0,10,10,0,30)
    End Method
End Class


Function Main()
    New MyGame()
End Function
