Import mojo

Class ball
    Field x:Float
    Field y:Float
    Field radius:Float = 32
    Field ballbounce:Float
    Field direction:String
    Field incy:Float=0
    Field delete:Bool=False
    Method New(_x:Int,_y:Int,_direction:String,_radius:Int,_ballbounce:Float)
        x = _x
        y = _y
        radius = _radius
        ballbounce = _ballbounce
        direction = _direction
    End Method
    Method update()
        If incy >= 0 Then 
            If incy < Abs(ballbounce) Then incy+=.1
            For Local i=0 Until incy
                y+=0.5
                If y+radius > 288 Then incy=ballbounce
            Next
        End If
        If incy < 0 Then
            incy+=.1
            For Local i=0 Until Abs(incy)
                y-=0.5                
            Next
        End If
        If direction = "left"
            x-=1
            If x-radius<=0 Then direction="right"
        Else
            x+=1
            If x+radius>=640 Then direction="left"
        End If
        For Local i:=Eachin r
            If circlerectcollide(x,y,radius,i.x,i.y-i.height,i.width,i.height) = True
                r.Remove i
                delete = True
                Select radius
                    Case 32
                        b.AddLast(New ball(x,y,"left",20,-6))
                        b.AddLast(New ball(x+20,y,"right",20,-6))
                    Case 20
                        b.AddLast(New ball(x,y,"left",10,-5))
                        b.AddLast(New ball(x+10,y,"right",10,-5))
                    Case 10
                        b.AddLast(New ball(x,y,"left",6,-4))
                        b.AddLast(New ball(x+6,y,"right",6,-4))                    
                End Select
            End If
        Next
        For Local i:=Eachin b
            If i.delete = True Then
                b.Remove i
            End If
        Next
    End Method
    Method draw()
        SetColor 255,0,0
        DrawCircle x,y,radius
    End Method
End Class

Class rope
    Field x:Float
    Field y:Float
    Field height:Int
    Field width
    Field incy:Float=5
    Field state:String="Nothing"
    Method New(_x:Int,_y:Int)
        x = _x
        y = _y
        state="expanding"
        height=0
        width=8
    End Method
    Method draw()
        SetColor 255,255,0
        DrawRect x,y-height,width,height
    End Method
    Method update()
        Select state
            Case "expanding"
                For Local i=0 Until incy
                    height+=1
                    If y-height < 0 Then 
                        state = "remove"
                        Exit
                    End If
                Next
            Case "remove"
                For    Local i:=Eachin r
                    If i.state = "remove" Then r.Remove i
                Next
        End Select
    End Method
End Class

Class player
    Field x:Float = 640/2
    Field y:Float = 480/2
    Field width:Int = 32
    Field height:Int = 48
    Field wait:Bool=False
    Method update()
        If KeyDown(KEY_RIGHT)
            For Local i=0 Until 3
                If x+width < 640
                    x+=1
                End If
            Next
        End If
        If KeyDown(KEY_LEFT)
            For Local i=0 Until 3
                If x > 0
                    x-=1
                End If
            Next
        End If
        If KeyHit(KEY_SPACE)
            r.AddFirst(New rope(x+12,y+48))
        End If
    End Method
    Method draw()
        SetColor 255,255,255
        DrawRect x,y,width,height        
    End Method
End Class

Global r:List<rope> = New List<rope>
Global b:List<ball> = New List<ball>
Global p:player = New player

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        b.AddFirst(New ball(100,100,"left",32,-8))
    End Method
    Method OnUpdate()        
        For Local i:=Eachin r
            i.update
        Next
        For Local i:=Eachin b
            i.update
        Next
        If b.IsEmpty() = True Then
            b.AddLast(New ball(100,100,"left",32,-8))
        End If
        p.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin b
            i.draw
        Next
        For Local i:=Eachin r
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Use cursor left/right to move, space to shoot rope.",0,0
        DrawRect 0,288,640,480-288
        p.draw
    End Method
End Class


Function circlerectcollide:Bool(cx:Int,cy:Int,cr:Int, rx:Int,ry:Int,rw:Int,rh:Int)
    Local closestx:Float = Clamp(cx, rx, rx+rw)
    Local closesty:Float = Clamp(cy, ry, ry+rh)
    Local distancex :Float = cx - closestx
    Local distancey:Float = cy - closesty
    Local distancesquared:Float = (distancex * distancex) + (distancey * distancey)
    Return distancesquared < (cr * cr)
End Function

Function Main()
    New MyGame()
End Function
