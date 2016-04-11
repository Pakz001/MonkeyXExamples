Import mojo

Class player
    Field inventory:String[] =     [    "Wooden Sword","Wooden Shield"]
    Field gold:Int=362
End Class

Class shop
    Field items:String[] =     [    "Wooden Sword","Iron Sword",
                                "Steel Sword","Wooden Shield",
                                "Iron Shield","Steel Shield"]
    Field prices:Int[] =    [    10,20,30,15,30,40]
    Field buyarrowindex:Int=0
    Method update()
        ' navigate through the screen
        If KeyHit(KEY_DOWN)
            buyarrowindex+=1
        End If
        If KeyHit(KEY_UP)
            buyarrowindex-=1
        End If
        ' keep arrow inside options
        If buyarrowindex < 0 Then buyarrowindex = 0
        If buyarrowindex > 7 Then buyarrowindex = 7
        If KeyHit(KEY_ENTER)            
            If buyarrowindex < 6 'in the buy part of the screen
                If hastomanyitems()=False
                    buyitem(items[buyarrowindex])
                End If
            End If
            If buyarrowindex > 5 ' if in the sell part ot screen
                sellitem(buyarrowindex-6)
            End If
        End If
    End Method
    Method draw()
        SetColor 255,255,255
        PushMatrix()
        Scale 10,10
        Translate 50,50
        Rotate 45
        Translate -50,-50
        DrawText "Shop",35,-10
        PopMatrix()
        PushMatrix()
        Scale 2,2
        DrawText "Weapon",340/2,32
        DrawText "Price",550/2,32
        For Local y=0 Until items.Length
            If buyarrowindex = y
            DrawText ">",230/2,32+15+y*15
            End If
            DrawText "Buy",250/2,32+15+y*15
            DrawText items[y],340/2,32+15+y*15
            DrawText prices[y],550/2,32+15+y*15
        Next
        DrawText "Player gold",20,200/2+32+15
        DrawText p.gold,20,200/2+64
        DrawText "Player carying",340/2,200/2+32+15
        For Local y=0 Until p.inventory.Length
            If buyarrowindex - 6 = y
                DrawText ">",230/2,200/2+y*15+64
            End If
            DrawText "Sell",250/2,200/2+y*15+64
            DrawText p.inventory[y],340/2,200/2+y*15+64
            DrawText sellprice(p.inventory[y]),550/2,200/2+y*15+64
        Next
        PopMatrix()
    End Method
    Method sellitem:Void(index:Int)        
        p.gold += sellprice(p.inventory[index])
        p.inventory[index] = ""
    End Method
    Method buyitem:Void(item:String)
        If p.gold >= itemprice(item) Then 
            If p.inventory[0] = "" Then 
                p.inventory[0] = item
            Else
                p.inventory[1] = item
            End If
            p.gold -= itemprice(item)
        End If
    End Method
    Method itemprice:Int(item:String)
        For Local i=0 Until items.Length
            If item = items[i] Then Return prices[i]
        Next
    End Method
    Method hastomanyitems:Bool()
        If p.inventory[0] <> "" And p.inventory[1] <> "" Then Return True
        Return False
    End Method
    Method sellprice:Int(item:String)
        For Local i=0 Until items.Length
            If items[i] = item Then Return prices[i]/3
        Next
        Return 0
    End Method
End Class

Global p:player = New player
Global s:shop = New shop

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        s.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255        
        s.draw
        DrawText "Use arrow up/down and enter.",320,0,0.5,0
    End Method
End Class


Function Main()
    New MyGame()
End Function
