Import mojo

Const tilewidth = 32
Const tileheight = 32
Const mapwidth:Int=20
Const mapheight:Int=10
Global map:Int[][] = [      [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                            [1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
                            [1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1],
                            [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] ]

Class elevators
    Field id:Int
    Field x:Float,y:Float
    Field state:String
    Field waittime:Int
    Field waittime2:Int
    Method New(x:Float,y:Float,id:Int)
        Self.id = id
        Self.x = x
        Self.y = y
        state = "bottom"
    End Method
    Method update()
        If Millisecs() < waittime Then Return
        Select state
            Case "bottom"
            Case "top"
                If Millisecs() > waittime2 Then state="going down"
            Case "going up"
                Local x1:Int=x
                Local y1:Int=y-1
                x1/=tilewidth
                y1/=tileheight
                If map[y1][x1+1] = 1 Or map[y1][x1-1] = 1 Then 
                    y-=1 
                Else 
                    state="top"
                    waittime2 = Millisecs() + 5000
                    waittime = Millisecs() + 2000
                End If
            Case "going down"
                Local x1:Int=x
                Local y1:Int=y
                x1/=tilewidth
                y1/=tileheight
                If map[y1-1][x1] = 0
                    y+=1                    
                Else
                    state="bottom"
                    y=(y/tileheight)*tileheight-1
                    waittime = Millisecs()+ 2000
                End If
                y+=1
        End Select
    End Method
    Method draw()
        SetColor 0,0,200
        DrawRect x,y,tilewidth,10
    End Method
End Class

Class players
    Field x:Float = 640/2-16
    Field y:Float = 480/2
    Field pw:Int=32
    Field ph:Int=32
    Field incy:Float
    Field jump:Bool=False
    Field lockelevator:Bool=False
    Field elevatorid:Int
    Method New()
    End Method
    Method update()           
        playermovement
        playergravity
        playerelevator                     
    End Method
    Method playerelevator()
        For Local i:=Eachin elevator
            If lockelevator = False
                If i.state="going up" Or i.state="going down"
                    If rectsoverlap(x,y,pw,ph+1,i.x,i.y,tilewidth,1)
                        lockelevator = True
                        elevatorid = i.id
                    End If                    
                End If
            End If
            If i.state = "bottom" And Millisecs() > i.waittime            
            If rectsoverlap(x,y,pw,ph+1,i.x,i.y,tilewidth,1)
                i.state = "going up"
                lockelevator = True
                elevatorid = i.id
            End If
            End If
            If i.state = "top" And Millisecs() > i.waittime
            If rectsoverlap(x,y,pw,ph+1,i.x,i.y,tilewidth,1)
            If playertc2(0,1) = False
                i.state = "going down"
                lockelevator = True
                elevatorid = i.id
            End If
            End If
            End If
        Next
        If lockelevator = True
            For Local i:=Eachin elevator
                If i.id = elevatorid
                    If rectsoverlap(x,y,pw,ph+2,i.x,i.y,tilewidth,12) = False Then lockelevator = False
                    If i.state="top" Then lockelevator=False ; y=i.y-(tileheight+2)
                    If i.state="bottom" Then lockelevator = False ; y=i.y-(tileheight+2)
                    If i.state = "going up" Then y=(i.y-(tileheight+2))
                    If i.state = "going down" Then y=(i.y-(tileheight))
                End If
            Next
        End If
    End Method
    Method playergravity()
        If jump = False And playertc(0,1) = False And lockelevator=False
            jump = True
            incy = 0
        End If
        If jump = False And KeyDown(KEY_SPACE) = True
            lockelevator=False
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
    Method playertc2:Bool(x1:Int,y1:Int) 'player tile collision 2
        Local cx = (x + x1) / tilewidth
           Local cy = (y + y1) / tileheight
        For Local y2=cy-1 Until cy+2
        For Local x2=cx-1 Until cx+2
            If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
                If map[y2][x2] = 1
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
    Method playertc:Bool(x1:Int,y1:Int)
        Local cx = (x + x1) / tilewidth
           Local cy = (y + y1) / tileheight
        For Local y2=cy-1 Until cy+2
        For Local x2=cx-1 Until cx+2
            If x2>=0 And x2<mapwidth And y2>=0 And y2<mapheight
                If map[y2][x2] = 1
                    If rectsoverlap(x+x1,y+y1,pw,ph,x2*tilewidth,
                                    y2*tileheight,tilewidth,tileheight) = True
                        Return True
                    End If
                End If
            End If
        Next
        Next
        For Local i:=Eachin elevator
            If rectsoverlap(x+x1,y+y1,pw,ph,i.x,i.y,tilewidth,12) = True Then Return True
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
Global elevator:List<elevators> = New List<elevators>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        player.AddLast(New players())
        initelevators
    End
    Method OnUpdate()
        ' Player left and right movement
        For Local i:=Eachin player
            i.update
        Next
        For Local i:=Eachin elevator    
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
        For Local i:=Eachin elevator
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Platformer Elevators Example",10,10
        DrawText "Use cursor left/right and space bar",160,10
        For Local i:=Eachin player
            i.draw
        Next
    End
End


Function initelevators:Void()
    Local cnt:Int=0
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[y][x] = 2
            elevator.AddLast(New elevators(x*tilewidth,y*tileheight+tileheight,cnt))
            cnt+=1
        End If        
    Next
    Next
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 > (x2 + w2) Or (x1 + w1) < x2 Then Return False
    If y1 > (y2 + h2) Or (y1 + h1) < y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End
