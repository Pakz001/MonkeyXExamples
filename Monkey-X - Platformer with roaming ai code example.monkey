Import mojo

Class ai
    Field x:Float
    Field y:Float
    Field state:String
    Field laststate:String
    Field incy:Float
    Method New()
        Local exitloop = False
        While exitloop = False
            Local x1 = Rnd(0,mapwidth)
            Local y1 = Rnd(0,mapheight-1)
            If map[y1][x1] = 0
            If map[y1+1][x1] = 1
                Local gothrough = True
                For Local i:ai = Eachin ailist
                    If i.x = x1 And i.y = y1 Then gothrough = False
                Next
                If gothrough = True
                    x = x1*tilewidth
                    y = y1*tileheight
                    exitloop = True
                End If
            End If
            End If
        Wend
        state = "Wait"
    End Method
End Class

Const numai:Int=10
Const aiwidth:Int = 32
Const aiheight:Int = 32
Const playerwidth:Int=32
Const playerheight:Int=32
Global playerx:Float = 640/2-16
Global playery:Float = 480/2
Global pincy:Float
Global playerjump:Bool=False
Const tilewidth = 32
Const tileheight = 32
Const mapwidth:Int=20
Const mapheight:Int=10
Global map:Int[][] = [      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                            [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Global ailist:List<ai> = New List<ai>


Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        Seed = 2
        For Local i:Int = 0 Until numai
            ailist.AddLast(New ai)
        Next

    End
    Method OnUpdate()
        updateai
        ' Player left and right movement
        playermovement()        
        ' player gravity
        playergravity()
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        ' draw the map
        For Local y:Int = 0 Until mapheight
        For Local x:Int = 0 Until mapwidth
            If map[y][x] = 1 Then DrawRect(x*tilewidth,y*tileheight,tilewidth,tileheight)
        End
        End
        SetColor 255,0,0
        For Local i:ai = Eachin ailist
            DrawRect i.x,i.y,aiwidth,aiheight
        Next
           SetColor 255,255,255
        DrawText "Platformer with ai Example",10,10
        DrawText "Use cursor left/right and space bar to move player",10,25
        ' draw the player
        SetColor 255,255,0        
        DrawOval playerx,playery,playerwidth,playerheight
    End
End

Function updateai:Void()
    For Local i:ai = Eachin ailist
        Select i.state
            Case "Wait"
                If Rnd(0,100) < 2
                    If Int(Rnd(0,2)) = 1
                        i.laststate="Wait"
                        i.state="Left"
                    Else
                        i.laststate="Wait"
                        i.state="Right"
                    End If
                End If
            Case "Left"
                If aitc(i.x,i.y,0,1) = False
                    i.laststate="Left"
                    i.state="Falling"
                    i.incy = 0
                End If
                If canjumpleftupfar(i.x,i.y) = True And Int(Rnd(0,18)) = 1
                    i.laststate="Left"
                    i.state="Jumpleftup"
                    i.incy=-4
                End If

                If aitc(i.x,i.y,-2,0) = False
                        i.x-=2
                Else
                    If canjumpleftup(i.x,i.y) = True And Int(Rnd(0,3)) = 1
                        i.laststate="Left"
                        i.state = "Jumpleftup"
                        i.incy = -4
                    Else 
                        i.laststate="Left"
                        i.state="Right"
                    End If
                End If
            Case "Right"
                If aitc(i.x,i.y,0,1) = False
                    i.laststate="Right"
                    i.state="Falling"
                    i.incy = 0
                End If
                If canjumprightupfar(i.x,i.y) = True And Int(Rnd(0,18)) = 1
                    i.laststate="Right"
                    i.state="Jumprightup"
                    i.incy=-4
                End If
                If aitc(i.x,i.y,2,0) = False
                    i.x+=2
                Else
                    If canjumprightup(i.x,i.y) = True And Int(Rnd(0,3)) = 1 Then
                        i.laststate="Right"
                        i.state = "Jumprightup"
                        i.incy = -4
                    Else
                    i.laststate="Right"
                    i.state="Left"
                    End If
                End If
            Case "Falling"
                If i.incy <= 3 Then i.incy +=.1
                For Local ii:Int = 0 Until i.incy
                    i.y += 1
                    If aitc(i.x,i.y,0,1) = True
                        i.state = i.laststate
                        i.laststate = "Falling"                        
                        Exit
                    End
                End
            Case "Jumprightup"
                If aitc(i.x,i.y,2,0) = False
                    i.x+=2
                End If
                i.incy += .1
                For Local ii:Int = 0 Until Abs(i.incy)
                    i.y -= 1
                    If aitc(i.x,i.y,0,-1) = True Or i.incy > 0
                        i.state="Fallrightdown"
                        Exit
                    End If        
                Next
            Case "Fallrightdown"
                If aitc(i.x,i.y,2,0) = False
                    i.x+=2
                End If
                i.incy+=.1
                For Local ii:Int = 0 Until i.incy
                    i.y += 1
                    If aitc(i.x,i.y,0,1) = True
                        i.state = i.laststate
                        i.laststate = "Fallrightdown"                        
                        Exit
                    End
                End
            Case "Jumpleftup"
                If aitc(i.x,i.y,-2,0) = False
                    i.x-=2
                End If
                i.incy += .1
                For Local ii:Int = 0 Until Abs(i.incy)
                    i.y -= 1
                    If aitc(i.x,i.y,0,-1) = True Or i.incy > 0
                        i.state="Fallleftdown"
                        Exit
                    End If        
                Next
            Case "Fallleftdown"
                If aitc(i.x,i.y,-2,0) = False
                    i.x-=2
                End If
                i.incy+=.1
                For Local ii:Int = 0 Until i.incy
                    i.y += 1
                    If aitc(i.x,i.y,0,1) = True
                        i.state = i.laststate
                        i.laststate = "Fallleftdown"                        
                        Exit
                    End
                End
                
        End Select
    Next
End Function

Function canjumpleftupfar:Bool(x:Int,y:Int)
    Local tx=x/tilewidth
    Local ty=y/tileheight
    If tx - 3 > 0
    If ty - 3 > 0
    If map[ty-1][tx-2] = 1
    If map[ty-2][tx-2] = 0
        Return True
    End If
    End If
    End If
    End If
    Return False
End Function


Function canjumprightupfar:Bool(x:Int,y:Int)
    Local tx=x/tilewidth
    Local ty=y/tileheight
    If tx + 3 < mapwidth
    If ty - 3 > 0
    If map[ty-1][tx+2] = 1
    If map[ty-2][tx+2] = 0
        Return True
    End If
    End If
    End If
    End If
    Return False
End Function

Function canjumprightup:Bool(x:Int,y:Int)
    Local tx=x/tilewidth
    Local ty=y/tileheight
    If map[ty-2][tx+1] = 0 Then Return True
    Return False
End Function

Function canjumpleftup:Bool(x:Int,y:Int)
    Local tx=x/tilewidth
    Local ty=y/tileheight
    If map[ty-2][tx-1] = 0 Then Return True
    Return False
End Function


Function playermovement:Void()
       If KeyDown(KEY_RIGHT)
           For Local i=0 Until 2
            If playertc(1,0) = False
                   playerx+=1
            End If
           Next
       End If
       If KeyDown(KEY_LEFT)
           For Local i=0 Until 2    
               If playertc(-1,0) = False
                   playerx-=1
               End If
           Next
       End If
End Function

Function playergravity:Void()
        ' If the player is on the ground and the space bar is pressed
        If playerjump = False And playertc(0,1) = False
            playerjump = True
            pincy = 0
        End If
        If playerjump = False And KeyDown(KEY_SPACE) = True
            pincy = -4
            playerjump = True
        End
        'If the player is in the jump
        If playerjump = True
            pincy += 0.1
            'if the player is going up
            If pincy <=0
                For Local i:Int = 0 Until Abs(pincy)                
                    playery -= 1
                    If playertc(0,-1) = True
                        pincy = 0
                        Exit
                    End If
                End
            End
            ' if the player if going down
            If pincy > 0
                For Local i:Int = 0 Until pincy
                    playery += 1
                    'if the player touches the ground
                    If playertc(0,1) = True
                        playerjump = False                        
                        Exit
                    End
                End
            End
        End
End Function

' Ai with tile collision
Function aitc:Bool(x:Int,y:Int,offsetx:Int=0,offsety:Int=0)
    Local cx = (x + offsetx) / tilewidth
    Local cy = (y + offsety) / tileheight
    For Local y2=cy-1 Until cy+2
    For Local x2=cx-1 Until cx+2
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] > 0
                If rectsoverlap(x+offsetx,y+offsety,aiwidth,aiheight,x2*tilewidth,y2*tileheight,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function

Function playertc:Bool(x1:Int=0,y1:Int=0)
    Local cx = (playerx + x1) / tilewidth
    Local cy = (playery + y1) / tileheight
    For Local y2=cy-1 Until cy+2
    For Local x2=cx-1 Until cx+2
        If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
            If map[y2][x2] > 0
                If rectsoverlap(playerx+x1,playery+y1,playerwidth,playerheight,x2*tilewidth,y2*tileheight,tilewidth,tileheight) = True
                    Return True
                End If
            End If
        End If
    Next
    Next
    Return False
End Function


Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End
