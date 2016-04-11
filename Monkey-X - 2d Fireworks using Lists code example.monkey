Import mojo

Class sprite
    Field x#,incx#
    Field y#,incy#
    Method New()
        x = DeviceWidth/2
        y = DeviceHeight
        incx=Rnd(1,2);If Rnd(1)>=.5 incx=-incx
        incy=Rnd(-3,-15)
    End Method
End Class

Class MyGame Extends App
    Field spritelist:List<sprite> = New List<sprite>

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        spritelist.AddLast(New sprite)
        For Local i:=Eachin spritelist
            i.x += i.incx
            i.y += i.incy
            i.incy += 0.1
        Next
        For Local i:=Eachin spritelist
            If i.y > DeviceHeight Then spritelist.Remove i
        Next
        
    End Method
    Method OnRender()
        Local cnt:Int = 0
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i:=Eachin spritelist
            DrawCircle i.x,i.y,3
            cnt+=1
        Next
        DrawText "Count: "+cnt,10,10
    End
End

Function Main()
    New MyGame()
End
