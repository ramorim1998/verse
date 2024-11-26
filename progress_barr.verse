using {/Fortnite.com/Devices}
using {/Fortnite.com/UI}
using {/UnrealEngine.com/Temporary/UI}
using {/UnrealEngine.com/Temporary/Diagnostics}
using {/Verse.org/Colors}
using {/Verse.org/Simulation}

slider333 := class(creative_device):
    MyLabel<localizes> : message = "SCORE"

    @editable
    MyTrigger: trigger_device = trigger_device{}

    @editable
    MyTriggerItem: []item_spawner_device = array{}

    @editable
    MySpawner: player_spawner_device = player_spawner_device{}
    @editable
    MySpawner2: player_spawner_device = player_spawner_device{}

    var MySlider: slider_regular = slider_regular {DefaultValue := 0.0}

    var progress: float = 0.0

    var itemPercentage: float = 0.0  

    OnBegin<override>()<suspends> : void =
        MySpawner.SpawnedEvent.Subscribe(MakeProgress)
        MySpawner2.SpawnedEvent.Subscribe(MakeProgress)
        set itemPercentage = 100.0 / (MyTriggerItem.Length * 1.0)
        for (Item : MyTriggerItem):
            Item.ItemPickedUpEvent.Subscribe(UpdateProgress)

    UpdateProgress(Item: agent): void =
        set progress = progress + itemPercentage
        MySlider.SetValue(progress)  
        

    MakeProgress(Agent: agent): void =
        if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
            NewUI := CreateMyUI()
            PlayerUI.AddWidget(NewUI)

    CreateMyUI() : overlay =
        MyTitle: text_block = text_block {DefaultText := MyLabel, DefaultTextColor := NamedColors.Gold}
        MySlider.SetMaxValue(100.0);
        MySlider.SetMinValue(0.0)
        MyOverlay: overlay = overlay :
            Slots := array:
                overlay_slot:
                    Widget := MyTitle
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin {Left := 0.0, Top := 0.0, Right := 0.0, Bottom := 100.0}
                overlay_slot:
                    Widget := MySlider
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Top
                    Padding := margin {Left := 0.0, Top := 40.0, Right := 0.0, Bottom := 0.0}
        return MyOverlay
