Import mojo

Const tilewidth:Int=32
Const tileheight:Int=32
Const mapwidth:Int=20
Const mapheight:Int=10
Global map:Int[][] = [      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,2,1,3,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,2,1,0,0,3,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,1,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1],
                            [1,1,1,3,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Class player
    Field x:Float=10*32
    Field y:Float=7*32
    Field width:Int=32
    Field height:Int=32
    Field incy:Float=0
    Field isjumping:Bool = False
    Field isonleftslope:Bool=False
    Field isonrightslope:Bool=False
End Class

Global p:player = New player
 
Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        'p.x = MouseX()
        'p.y = MouseY()
        playergravity
        playermovement
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        drawplayer
        SetColor 255,255,255
        DrawText "Use cursor left/right and space to control player.",10,10
        If pmc() = True
            DrawText "Collision",10,20
        End If
    End Method
End Class

Function playermovement()
    If KeyDown(KEY_RIGHT)
        For Local i=0 Until 2
            ' if no tile is colliding one pixel ahead of player
            If pmc(1,0) = False
                p.x+=1
            End If
            ' if the tile one pixel ahead of player is a (2) left slope up
            If ptc(1,0) = 2
                p.isonleftslope = True
            End If
            ' if the player is on a left sided slope
            If p.isonleftslope = True
                p.y-=1
                p.x+=1
                If pmc(1,0) = False
                    p.isonleftslope = False
                End If
            End If
        Next
    End If
    If KeyDown(KEY_LEFT)
        For Local i=0 Until 2
            If pmc(-1,0) = False
                p.x-=1
            End If
            If ptc(-1,0) = 3
                p.isonrightslope = True
            End If
            If p.isonrightslope = True
                p.y-=1
                p.x-=1
                If pmc(-1,0) = False
                    p.isonrightslope=False
                End If
            End If
        Next
    End If
End Function


Function playergravity:Void()
        ' If the player is on the ground and the space bar is pressed
        If p.isjumping = False And pmc(0,1) = False
            p.isjumping = True
            p.incy = 0
        End If
        If p.isjumping = False And KeyDown(KEY_SPACE) = True
            p.incy = -4
            p.isjumping = True
        End
        'If the player is in the jump
        If p.isjumping = True
            p.incy += 0.1
            'if the player is going up
            If p.incy <=0
                For Local i:Int = 0 Until Abs(p.incy)                
                    p.y -= 1
                    If pmc(0,-1) = True
                        p.incy = 0
                        Exit
                    End If
                End
            End
            ' if the player if going down
            If p.incy > 0
                For Local i:Int = 0 Until p.incy
                    p.y += 1
                    'if the player touches the ground
                    If pmc(0,1) = True
                        p.isjumping = False                        
                        Exit
                    End
                End
            End
        End
End Function

' player map collision ((p)layer (m)ap (c)ollision
Function ptc:Int(x1:Int=0,y1:Int=0)
    Local cx = (p.x+x1)/tilewidth
    Local cy = (p.y+y1)/tileheight
    For Local y2=cy-1 To cy+1
    For Local x2=cx-1 To cx+1
        If x2>=0 And y2>=0 And x2<mapwidth And y2<mapheight
            Local x3 = (x2*tilewidth)
            Local y3 = (y2*tileheight)
            If map[y2][x2] > 0
                Select map[y2][x2]
                    Case 1
                        If rectsoverlap(p.x+x1,.p.y+y1,p.width,p.height,x3,y3,tilewidth,tileheight) = True
                            Return 1
                        End If
                    Case 2
                        If slopeleftcollision(p.x+x1,p.y+y1,x3,y3)=True
                            Return 2
                        End If
                    Case 3
                        If sloperightcollision(p.x+x1,p.y+y1,x3,y3) = True
                            Return 3
                        End If
                End Select
            End If
        End If
    Next
    Next
    Return 0
End Function


' player map collision ((p)layer (m)ap (c)ollision
Function pmc:Bool(x1:Int=0,y1:Int=0)
    Local cx = (p.x+x1)/tilewidth
    Local cy = (p.y+y1)/tileheight
    For Local y2=cy-1 To cy+1
    For Local x2=cx-1 To cx+1
        If x2>=0 And y2>=0 And x2<mapwidth And y2<mapheight
            Local x3 = (x2*tilewidth)
            Local y3 = (y2*tileheight)
            If map[y2][x2] > 0
                Select map[y2][x2]
                    Case 1
                        If rectsoverlap(p.x+x1,.p.y+y1,p.width,p.height,x3,y3,tilewidth,tileheight) = True
                            Return True
                        End If
                    Case 2
                        If slopeleftcollision(p.x+x1,p.y+y1,x3,y3)=True
                            Return True
                        End If
                    Case 3
                        If sloperightcollision(p.x+x1,p.y+y1,x3,y3) = True
                            Return True
                        End If
                End Select
            End If
        End If
    Next
    Next
    Return False
End Function

Function drawplayer:Void()
    SetColor 255,255,0
    DrawRect p.x,p.y,p.width,p.height
End Function

Function drawmap:Void()
    SetColor 255,255,255
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Local x1 = x*tilewidth
        Local y1 = y*tileheight
        Select map[y][x]
            Case 1;DrawRect x1,y1,tilewidth,tileheight
            Case 2;drawslopeleft x1,y1
            Case 3;drawsloperight x1,y1
        End Select
    Next
    Next
    
End Function

Function sloperightcollision:Bool(x1:Int,y1:Int,x2:Int,y2:Int)
    Local y3=y2
    For Local x3=x2 Until x2+tilewidth
        If rectsoverlap(x1,y1,p.width,p.height,x3,y3,1,1) = True Then Return True
        y3+=1
    Next
    Return False
End Function

Function slopeleftcollision:Bool(x1:Int,y1:Int,x2:Int,y2:Int)
    Local y3=tilewidth+y2
    For Local x3=x2 Until x2+tilewidth
        If rectsoverlap(x1,y1,p.width,p.height,x3,y3,1,1) = True Then Return True
        y3-=1
    Next
    Return False
End Function

Function drawslopeleft:Void(x:Int,y:Int)
    DrawPoly([Float(x),y+tileheight,x+tilewidth,y+tileheight,x+tilewidth,y])
End Function

Function drawsloperight:Void(x:Int,y:Int)
    DrawPoly([Float(x),y,x,y+tileheight,x+tilewidth,y+tileheight,x,y])
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function


Function Main()
    New MyGame()
End Function
