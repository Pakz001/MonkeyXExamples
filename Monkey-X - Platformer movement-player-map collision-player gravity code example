Import mojo

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

Class players
    Field x:Float = 640/2-16
    Field y:Float = 480/2
    Field pw:Int=32
    Field ph:Int=32
    Field incy:Float
    Field jump:Bool=False
    Method New()
    End Method
    Method update()
        playermovement
        playergravity
    End Method
    Method playergravity()
        ' If the player is on the ground and the space bar is pressed
        If jump = False And playertc(0,1) = False
            jump = True
            incy = 0
        End If
        If jump = False And KeyDown(KEY_SPACE) = True
            incy = -4
            jump = True
        End
        'If the player is in the jump
        If jump = True
            incy += 0.1
            'if the player is going up
            If incy <=0
                For Local i:Int = 0 Until Abs(incy)                
                    y -= 1
                    If playertc(0,-1) = True
                        incy = 0
                        Exit
                    End If
                End
            End
            ' if the player if going down
            If incy > 0
                For Local i:Int = 0 Until incy
                    y += 1
                    'if the player touches the ground
                    If playertc(0,1) = True
                        jump = False                        
                        Exit
                    End
                End
            End
        End
    End Method
    Method playermovement()
       If KeyDown(KEY_RIGHT)
           For Local i=0 Until 2
            If playertc(1,0) = False
                   x+=1
            End If
           Next
       End If
       If KeyDown(KEY_LEFT)
           For Local i=0 Until 2    
               If playertc(-1,0) = False
                   x-=1
               End If
           Next
       End If        
    End Method
    Method playertc:Bool(x1:Int,y1:Int)
        Local cx = (x + x1) / tilewidth
           Local cy = (y + y1) / tileheight
        For Local y2=cy-1 Until cy+2
        For Local x2=cx-1 Until cx+2
            If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
                If map[y2][x2] > 0
                    If rectsoverlap(x+x1,y+y1,pw,ph,x2*tilewidth,
                                    y2*tileheight,tilewidth,tileheight) = True
                        Return True
                    End If
                End If
            End If
        Next
        Next
        Return False
    End Method
    Method draw()
        ' draw the player
        SetColor 255,255,0        
        DrawOval x,y,pw,ph        
    End Method
End Class

Global player:List<players> = New List<players>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        player.AddLast(New players())
    End
    Method OnUpdate()
        ' Player left and right movement
        For Local i:=Eachin player
            i.update
        Next
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
        DrawText "Platformer Example",10,10
        DrawText "Use cursor left/right and space bar",160,10
        For Local i:=Eachin player
            i.draw
        Next
    End
End



Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End
