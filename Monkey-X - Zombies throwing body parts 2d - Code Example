Import mojo

Class agent
    Field x:Float,y:Float
    Field w:Int=20+Rnd(20)
    Field h:Int=20+Rnd(20)
    Field incx:Float
    Method New(x:Int,incx:Float)        
        Self.x = x
        Self.y = 272-h
        Self.incx = incx
    End Method
    Method update()
        x += incx
        If Rnd(60*60) < 10 Then
            incx = -incx
        End If
        If x<100 Then incx=-incx
        If x>640-100 Then incx=-incx
        If Rnd(60*60)<10
            Local ix:Float=Rnd(-6,6)
            If ix >-0.5 And ix <0.5 Then ix = ix*2
            mybodypart.AddLast(New bodypart(x-9+Rnd(w),
                                            y-h+Rnd(h/2),
                                            ix,Rnd(-4,-2)))
        End If
    End Method
    Method draw()
        SetColor 255,255,255
        DrawRect x,y,w,h
    End Method
End Class

Class bodypart
    Field w:Int,h:Int
    Field x:Float,y:Float
    Field incx:Float,incy:Float
    Field mdf:Float
    Field stopped:Bool=False
    Field timeout:Int,delete:Bool=False
    Method New(x:Int,y:Int,incx:Float,incy:Float)
        Self.x = x
        Self.y = y
        Self.incx = incx
        Self.incy = incy
        w = Rnd(3,9)
        h = Rnd(3,9)
        mdf = 0.09
    End Method
    Method update()
        If stopped = False
            x+=incx
            y+=incy
            If incx>0 Then incx-=mdf
            If incx<0 Then incx+=mdf
            If mdf>0.01 Then mdf-=0.001
            incy+=0.1            
            If y>272 Then 
                incy=-(Rnd(incy/2))
                incx = Rnd(-incy,incy)
            End If
            
            If y>273                
                If incx >-0.2 And incx <0.2
                    If incy>-0.2 And incy<0.2
                        stopped=True
                    End If
                End If
            End If
        End If
        If stopped = True
            timeout+=1
            If timeout > 60*20
                delete = True
            End If
        End If
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x,y,w,h
    End Method
End Class

Global mybodypart:List<bodypart> = New List<bodypart>
Global myagent:List<agent> = New List<agent>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until 10
            Local incx:Float=Rnd(-1.5,1.5)
            If incx>-0.3 And incx<0.3
                incx=incx*2
            End If
            myagent.AddLast(New agent(Rnd(100,640-100),incx))
        Next
    End Method
    Method OnUpdate()   
        For Local i:=Eachin myagent
            i.update
        Next     
        For Local i:=Eachin mybodypart
            i.update
            If i.delete = True
                mybodypart.Remove i
            End If
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin myagent
            i.draw
        Next
        For Local i:=Eachin mybodypart
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Monkey-X - Zombies throwing body parts Example",10,10
    End Method
End Class


Function Main()
    New MyGame()
End Function
