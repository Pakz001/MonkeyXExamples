Import mojo

Class player
    Field x:Int=50,y:Int=50
    Field w:Int=48,h:Int=48
    Field level:Int=1
    Field currentlevel:Int=0
    Field nextlevel:Int=100
    Field inventory:Int[9][]
    Method New()
         For Local i = 0 Until 9
            inventory[i] = New Int[7]
        Next
        ' sword 1 (takes 3 inventory slots
        ' 3 vertical
        inventory[0][0] = 1
        inventory[0][1] = 1
        inventory[0][2] = 1
        ' healing potion 2
        ' takes one inventory slot
        inventory[1][0] = 2
        ' add more items here (every item 1 
        ' unique number. 
    End Method
    Method update()
        ' movement by input
        Local nx:Int=x,ny:Int=y
        For Local i:Int = 0 Until 4
            If KeyDown(KEY_LEFT)
                nx-=1
            End If
            If KeyDown(KEY_RIGHT)
                nx+=1
            End If
            If KeyDown(KEY_UP)
                ny-=1
            End If
            If KeyDown(KEY_DOWN)
                ny+=1
            End If
            If nx > 0 And nx < 640-w Then x = nx
            If ny > 16 And ny <(480-48)-16 Then y = ny
        Next
    End Method
    Method draw()
        SetColor 255,0,0
        DrawRect x,y,w,h
    End Method
    Method rectsoverlap:Bool(    x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method     
End Class

Class inventory
    Field minimized:Bool=True
    Field itemmouse:Int=0
    ' button that says inventory
    Field invbuttonx:Int=10
    Field invbuttony:Int=480-32
    Field invbuttonw:Int=96
    Field invbuttonh:Int=16
    Field invbuttont:String="Inventory"
    ' inventory things
    Field invwindowx:Int=0
    Field invwindowy:Int=16
    Field invwindowh:Int=480-32
    Field invwindoww:Int=320
    Field invwindowt:String="Player Inventory"
    Method update()
        ' Minimized button <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        If minimized = True Then
            If rectsoverlap(    MouseX(),MouseY(),
                                1,1,
                                invbuttonx,
                                invbuttony,
                                invbuttonw,
                                invbuttonh) = True And
                                MouseDown(MOUSE_LEFT) = True
                minimized = False
                Return
            End If
            If KeyHit(KEY_I) = True
                minimized = False
                Return
            End If
        End If
        ' Inventory screen <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        If minimized = False
            If KeyDown(KEY_ESCAPE) = True Or
                            KeyHit(KEY_I) = True
                minimized = True
                Return
            End If
            If MouseDown(MOUSE_LEFT) = True
                If itemmouse=0
                    If itemundermouse() > 0
                        itemmouse=itemundermouse()
                        Return
                    End If
                End If
            End If
        End If
        ' here you drop the item
        'in the inventory screen (manage)
        If MouseDown(MOUSE_LEFT) = False
            If itemmouse > 0
                moveiteminventory()
                itemmouse = 0
            End If
        End If
    End Method
    Method moveiteminventory()
        Local x:Int=(MouseX()-16)/32
        Local y:Int=(MouseY()-32)/32
        If x<0 Or x>8 Then Return
        If y<0 Or y>6 Then Return
        
        Select itemmouse
            Case 1 ' do not drop outside window
                    ' and can drop on same sword
                    '                      
                If y>7-3 Then Return
                For Local i:Int=0 Until 3
                    If myplayer.inventory[x][y+i]>0 And
                        myplayer.inventory[x][y+i] <> itemmouse Then 
                        Return
                    End If
                Next
            Case 2 ' drop on a free slot
                If myplayer.inventory[x][y]<>0 Then Return
        End Select
        ' erase all of this item
        For Local y:Int=0 Until 7
        For Local x:Int=0 Until 9
            If myplayer.inventory[x][y] = itemmouse
                myplayer.inventory[x][y] = 0
            End If
        Next
        Next
        ' drop the item here
        Select itemmouse
            Case 1 ' sword 3 vertical
                myplayer.inventory[x][y] = itemmouse
                myplayer.inventory[x][y+1] = itemmouse
                myplayer.inventory[x][y+2] = itemmouse
            Case 2 ' potion 1 slot
                myplayer.inventory[x][y] = itemmouse
        End Select
    End Method
    Method itemundermouse:Int()
        For Local y:Int = 0 Until 7
        For Local x:Int = 0 Until 9
            If rectsoverlap(MouseX(),MouseY(),
                            1,1,
                            x*32+16,
                            y*32+32,
                            32,32) = True
                If myplayer.inventory[x][y] > 0
                    Return myplayer.inventory[x][y]
                End If
            End If
        Next
        Next
        Return 0
    End Method
    Method draw()
        If minimized = True Then
            drawbutton(    invbuttont,
                        invbuttonx,
                        invbuttony,
                        invbuttonw,
                        invbuttonh)
        End If
        If minimized = False
            drawwindow(    invwindowt,
                        invwindowx,
                        invwindowy,
                        invwindoww,
                        invwindowh)
            ' draw the intemscreen
            drawitems    
            If itemmouse>0
                Select itemmouse
                    Case 1
                        SetColor 150,150,150
                        DrawRect     MouseX(),MouseY(),
                                    32,32*3
                    Case 2
                        SetColor 255,0,0
                        DrawRect    MouseX(),MouseY(),
                                    32,32
                End Select
            End If                        
        End If
    End Method
    Method drawitems()        
        For Local y:Int = 0 Until 7
        For Local x:Int = 0 Until 9
            If myplayer.inventory[x][y] = 0            
            SetColor 0,0,0
            DrawRect x*32+16,y*32+32,31,31            
            Else
            Select myplayer.inventory[x][y]            
                Case 1;SetColor 55,55,55
                Case 2;SetColor 255,0,0
            End Select
            DrawRect x*32+16,y*32+32,32,32
            End If            
        Next
        Next
    End Method
    Method drawbutton(t:String,x:Int,y:Int,w:Int,h:Int)
        SetColor 150,150,150
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawLine x,y,x+w,y
        DrawLine x,y,x,y+h
        SetColor 20,20,20
        DrawLine x+1,y+h,x+w,y+h
        DrawLine x+w,y+1,x+w,y+h
        SetColor 255,255,255
        DrawText t,x+w/2,y+h/2,.5,.5
    End Method
    Method drawwindow(t:String,x:Int,y:Int,w:Int,h:Int)
        SetColor 150,150,150
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawLine x,y,x+w,y
        DrawLine x,y,x,y+h
        SetColor 20,20,20
        DrawLine x+1,y+h,x+w,y+h
        DrawLine x+w,y+1,x+w,y+h
        SetColor 255,255,255
        DrawText t,x+w/2,y+2,.5,0
    End Method
    Method rectsoverlap:Bool(      x1:Int, y1:Int, w1:Int, 
                                h1:Int, x2:Int, y2:Int, 
                                w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method
End Class

Global myplayer:player = New player()
Global myinventory:inventory = New inventory()

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        myplayer.update
        myinventory.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Rpg Inventory - Use Mouse to move items around..",0,0
        DrawText "Press i and esc for inventory screen on/off",320,480-16
        myplayer.draw
        myinventory.draw
    End Method
End Class


Function Main()
    New MyGame()
End Function
