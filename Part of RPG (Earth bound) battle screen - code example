Import mojo

Class monster1
    Field name:String="Bubba"
    Field hp:Int=5
    Field pp:Int=7
    Field welcomemessage:String="Here I am to kick your ass.."
End Class

Class player
    Field name:String="Player"
    Field hp:Int=20
    Field pp:Int=10
End Class

Class battlescreen
    Field state:String="preparemonsterintro"
    Field nextstate:String
    Field selectindex:Int=0
    Field selecttext:String[]=["Bash","PSI","Goods","Defend","Auto Fight","Run Away"]
    Field keydowndelay:Int=0
    Field messagedelay:Int
    Field message:String
    Field damage:Int
    Method update()
        If state="selectaction"
            updateselect()
        End If
        If state="afterbash"
            If m1.hp<0
                messagedelay=100
                message="You wasted the monster."
                state="wait"
                nextstate="preparemonsterintro"
            End If
            If m1.hp>0
                state="selectaction"
            End If
        End If
        If state="wait"
            messagedelay-=1
            If messagedelay<0
                state=nextstate
            End If
        End If
        If state="bash"
            damage=Rnd(3)+2
            message="You hit the monster with "+damage+" damage."
            m1.hp-=damage
            messagedelay=50
            state="wait"
            nextstate="afterbash"
        End If
        If state="preparemonsterintro"
            state="monsterintro"
            messagedelay=100            
            m1.hp=Rnd(10)+5
            m1.pp=Rnd(10)+5
        End If
        If state="monsterintro"
            messagedelay-=1
            If messagedelay<0
                state="selectaction"
            End If
        End If
    End Method
    Method draw()
        If state="wait"
            drawmessage(message)            
            drawplayerinfo()            
        End If
        If state="monsterintro"
            drawmessage(m1.welcomemessage)            
            drawplayerinfo()
        End If
        If state="selectaction"
            drawselect()
            drawplayerinfo()
        End If
    End Method
    Method drawmessage(m:String)
        SetColor 255,255,255
        DrawLine 10,10,500,10
        DrawLine 10,10,10,100
        DrawLine 10,100,500,100
        DrawLine 500,10,500,100
        PushMatrix
        Scale 2.2,2.2
        DrawText m,15/2.2,15/2.2
        PopMatrix
    End Method
    Method drawselect()
        SetColor 255,255,255
        DrawLine 10,10,500,10
        DrawLine 10,10,10,100
        DrawLine 10,100,500,100
        DrawLine 500,10,500,100
        SetColor 0,0,0
        DrawRect 32,5,96,15
        SetColor 255,255,255
        DrawText p.name,32,0
        Local in:Int=0
        For Local x=0 To 2
        For Local y=0 To 1
            PushMatrix()
            Scale 2.2,2.2
            DrawText selecttext[in],(x*150+32)/2.2,(y*50+15)/2.2
            PopMatrix()
            If selectindex = in
                DrawRect x*150+20,y*50+25,10,10
            End If
            in+=1
        Next
        Next
    End Method
    Method drawplayerinfo()
        ' Here the player info is drawn
        SetColor 255,255,255
        DrawLine 320-50,300,320+50,300
        DrawLine 320-50,300,320-50,425
        DrawLine 320-50,425,320+50,425
        DrawLine 320+50,300,320+50,425
        PushMatrix()
        Scale 2.2,2.2
        DrawText p.name,320/2.2,320/2.2,0.5
        DrawText "HP",(320-40)/2.2,360/2.2
        DrawText p.hp,320/2.2,360/2.2
        DrawText "PP",(320-40)/2.2,390/2.2
        DrawText p.pp,320/2.2,390/2.2
        PopMatrix()        
    End Method
    Method updateselect()
        ' Here the selection for the player is updated
        If keydowndelay>0 Then keydowndelay-=1
        If keydowndelay>0 Then Return
        If KeyDown(KEY_RIGHT)
            If selectindex+2 < 6
                selectindex+=2
                keydowndelay=10                
            End If
        End If
        If KeyDown(KEY_LEFT)
            If selectindex-2>=0
                selectindex-=2
                keydowndelay=10
            End If
        End If
        If KeyDown(KEY_DOWN)
            If selectindex<5
                selectindex+=1
                keydowndelay=10
            End If
        End If
        If KeyDown(KEY_UP)
            If selectindex>0
                selectindex-=1
                keydowndelay=10
            End If
        End If
        If KeyDown(KEY_ENTER)
            ' If bash option selected
            If selectindex = 0
                state="bash"
            End If
        End If
    End Method
End Class

Global p:player = New player
Global bs:battlescreen = New battlescreen
Global m1:monster1 = New monster1

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        bs.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255        
        bs.draw
        SetColor 255,255,255
        DrawText "Use cursors and return key...",320,480-32
    End Method
End Class

Function Main()
    New MyGame()
End Function
