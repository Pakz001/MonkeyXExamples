Import mojo

Global tilewidth = 32
Global tileheight = 32

Class box
    Field x:Float,y:Float
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x,y,tilewidth,tileheight
    End Method
End Class

Class player
    Field x:Float,y:Float
    Method update()
        If KeyDown(KEY_RIGHT)
            If pushbox(1,0) = True Then x+=1
        End If
        If KeyDown(KEY_LEFT)
            If pushbox(-1,0) = True Then x-=1
        End If
        If KeyDown(KEY_UP)
            If pushbox(0,-1) = True Then y-=1
        End If
        If KeyDown(KEY_DOWN)
            If pushbox(0,1) = True Then y+=1
        End If

    End Method
    Method pushbox:Bool(x1:Int,y1:Int)
        For Local i:=Eachin boxes
            If rectsoverlap(x+x1,y+y1,tilewidth,tileheight,
                            i.x,i.y,tilewidth,tileheight)
                For Local ii:=Eachin boxes
                    If i<>ii
                        If rectsoverlap(i.x+x1,i.y+y1,tilewidth,tileheight,
                                    ii.x,ii.y,tilewidth,tileheight)
                            Return False
                        End If
                    End If
                Next
                i.x+=x1
                i.y+=y1
            End If
        Next
        Return True
    End Method
    Method draw()
        SetColor 255,255,255
        DrawRect x,y,tilewidth,tileheight
    End Method
End Class

Global p:player = New player
Global boxes:List<box> = New List<box>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        p.x = 320
        p.y = 240
        boxes.AddLast(New box(360,240))
        boxes.AddLast(New box(400,240))
        boxes.AddLast(New box(400,300))
    End Method
    Method OnUpdate()        
        p.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Block Pushing example. Cursors move player.",0,0
        For Local i:=Eachin boxes
            i.draw
        Next
        p.draw
    End Method
End Class

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End Function
