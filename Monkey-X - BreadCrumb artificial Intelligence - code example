Import mojo

Global tilewidth:Int=16
Global tileheight:Int=16
Global aiwidth:Int=16
Global aiheight:Int=16

Class ai
    Field x:Int,y:Int
    Field readcountdown:Int
    Field state:String
    Field bcx:Int,bcy:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
        readcountdown=Rnd(0,60)
        state="search"
    End Method
    Method update()
        If state="search" And 
            distance(x,y,myplayer.x,myplayer.y) > 16
            '
            readcountdown-=1
            If readcountdown<0
                readcountdown=60
                For Local i:=Eachin myplayercrumb
                    If distance(i.x,i.y,x,y) < 32
                        DebugLog "Found crumbs"
                        state="following"
                        bcx = i.x
                        bcy = i.y
                        Exit
                    End If                    
                Next
            End If
        End If
        If state="following"
            If x < bcx Then x+=1
            If x > bcx Then x-=1
            If y < bcy Then y+=1
            If y > bcy Then y-=1
            If x = bcx And y = bcy
                setnextbread()
                If distance(x,y,bcx,bcy) > 32
                    DebugLog "Out of range.."
                    state="search"                     
                End If
                If distance(x,y,myplayer.x,myplayer.y) < 16
                    DebugLog "engaging player.."
                    state="search"                                         
                End If
            End If
        End If
    End Method
    Method setnextbread()
        Local prx:Int
        Local pry:Int
        For Local i:=Eachin myplayercrumb
            If i.x = x And i.y = y
                bcx = prx
                bcy = pry
                Return
            End If
            prx = i.x
            pry = i.y
        Next
    End Method
    Method draw()
        SetColor 255,0,0
        DrawOval x,y,aiwidth,aiheight
    End Method
    Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
        Return Abs(x2-x1)+Abs(y2-y1)
    End Function    
End Class

Class player
    Field x:Int,y:Int
    Field playerwidth:Int=16
    Field playerheight:Int=16
    Field playerspeed:Int=4
    Field otx:Int,oty:Int
    Method New(x:Int,y:Int)
        otx = x
        oty = y
        Self.x = x*tilewidth
        Self.y = y*tileheight        
    End Method
    Method update()
        For Local i=0 Until playerspeed
            Local newx:Int=x
            Local newy:Int=y
            If KeyDown(KEY_RIGHT)
                newx+=1
            End If
            If KeyDown(KEY_LEFT)
                newx-=1
            End If
            If KeyDown(KEY_UP)
                newy-=1
            End If
            If KeyDown(KEY_DOWN)
                newy+=1
            End If
            If newx>0 And 
                newx<DeviceWidth()-playerwidth
            If newy>0 And 
                newy<DeviceHeight()-playerheight
                x = newx
                y = newy
            End If
            End If
            If x = otx And y=oty
            Else
                myplayercrumb.AddFirst(New crumb(x,y))
                If myplayercrumb.Count() > 196 Then
                    myplayercrumb.RemoveLast()
                End If
                otx = x
                oty = y
            End If
            
        Next
    End Method
    Method draw()
        SetColor 0,0,255
        DrawOval x,y,playerwidth,playerheight
    End Method
End Class

Class crumb
    Field x:Int,y:Int
    Method New(x:Int,y:Int)
        Self.x = x
        Self.y = y
    End Method
End Class

Global myplayercrumb:List<crumb> = New List<crumb>
Global myplayer:player = New player(10,10)
Global myai:List<ai> = New List<ai>

Class MyApp Extends App
    
    Method OnCreate()
        SetUpdateRate(60)
        myai.AddLast(New ai(100,100))
    End Method

    Method OnUpdate()
        myplayer.update
        For Local i:=Eachin myai
            i.update
        Next
    End Method
    
    Method OnRender()
        Cls 0,0,0
        drawplayerbreadcrumbs()
        For Local i:=Eachin myai
            i.draw
        Next
        myplayer.draw
        SetColor 255,255,255
        DrawText "Monkey-X Bread crumb ai.",10,10
        DrawText "Use cursors to move (blue) and leave trail..",10,25
    End Method
    
End Class

Function drawplayerbreadcrumbs:Void()
    SetColor 100,100,100
    For Local i:=Eachin myplayercrumb
        DrawPoint     i.x+tilewidth/2,i.y+tileheight/2
    Next
End Function

Function Main()
    New MyApp
End Function
