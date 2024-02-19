
page 31009821 "Timetable List"
{
    Caption = 'Timetable Template List';
    CardPageID = Timetable;
    DelayedInsert = true;
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Timetable;

    layout
    {
        area(content)
        {
            repeater(Control1101490000)
            {
                ShowCaption = false;
                field("Timetable Code"; Rec."Timetable Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Timetable Type"; Rec."Timetable Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Start Period"; Rec."Start Period")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("End Period"; Rec."End Period")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Study Plan"; Rec."Study Plan")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Study Plan';
                    Editable = false;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("PlanIt Import"; Rec."PlanIt Import")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'PlanIt Import';
                    Visible = "PlanIt ImportVisible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."PlanIt Import" then begin
            "Start PeriodEditable" := true;
            "End PeriodEditable" := true;
        end else begin
            "Start PeriodEditable" := false;
            "End PeriodEditable" := false;
        end;
    end;

    trigger OnInit()
    begin
        TimeTableEnable := true;
        "PlanIt ImportVisible" := true;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;

        if CurrPage.LookupMode then begin
            if not visible then begin
                "PlanIt ImportVisible" := true;
                TimeTableEnable := false;
                CurrPage.Editable(true);
            end else begin
                "PlanIt ImportVisible" := false;
                TimeTableEnable := false;
                CurrPage.Editable(false);
            end;
        end else begin
            "PlanIt ImportVisible" := false;
            TimeTableEnable := true;
            CurrPage.Editable(false);
        end;
    end;

    var
        cUserEducation: Codeunit "User Education";
        visible: Boolean;
        [InDataSet]
        "Start PeriodEditable": Boolean;
        [InDataSet]
        "End PeriodEditable": Boolean;
        [InDataSet]
        "PlanIt ImportVisible": Boolean;
        [InDataSet]
        TimeTableEnable: Boolean;

    //[Scope('OnPrem')]
    procedure GetSelectionFilter(): Code[80]
    var
        TabHorario: Record Timetable;
        FirstVend: Code[30];
        LastVend: Code[30];
        SelectionFilter: Code[250];
        VendCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(TabHorario);
        VendCount := TabHorario.Count;
        if VendCount > 0 then begin
            TabHorario.Find('-');
            while VendCount > 0 do begin
                VendCount := VendCount - 1;
                TabHorario.MarkedOnly(false);
                FirstVend := TabHorario."Timetable Code";
                LastVend := FirstVend;
                More := (VendCount > 0);
                while More do
                    if TabHorario.Next = 0 then
                        More := false
                    else
                        if not TabHorario.Mark then
                            More := false
                        else begin
                            LastVend := TabHorario."Timetable Code";
                            VendCount := VendCount - 1;
                            if VendCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstVend = LastVend then
                    SelectionFilter := SelectionFilter + FirstVend
                else
                    SelectionFilter := SelectionFilter + FirstVend + '..' + LastVend;
                if VendCount > 0 then begin
                    TabHorario.MarkedOnly(true);
                    TabHorario.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;

    //[Scope('OnPrem')]
    // procedure CleanEmptyTags(XMLNode: Automation)
    // var
    //     XMLChildNode: Automation;
    //     XMLDomNodeList: Automation;
    //     i: Integer;
    // begin
    //     if XMLNode.nodeTypeString = 'element' then begin
    //         if (XMLNode.hasChildNodes = false) then begin
    //             if (XMLNode.xml = '<' + XMLNode.nodeName + '/>') then
    //                 XMLNode := XMLNode.parentNode.removeChild(XMLNode)
    //         end else begin
    //             XMLDomNodeList := XMLNode.childNodes;
    //             for i := 1 to XMLDomNodeList.length do begin
    //                 XMLChildNode := XMLDomNodeList.nextNode();
    //                 CleanEmptyTags(XMLChildNode);
    //             end;
    //         end;
    //     end;
    // end;

    //[Scope('OnPrem')]
    procedure TextReplace(SourceFileName: Text[250]; DestinationFileName: Text[250]; TextToFind: Text[250]; TextToReplace: Text[250]; TextToFind2: Text[250]; TextToReplace2: Text[250])
    var
        TextFile: File;
        InStream: InStream;
        OutStream: OutStream;
        InputText: BigText;
        OutputText: BigText;
        OutputText2: BigText;
        SubText: BigText;
        TextPosition: Integer;
        TextPosition2: Integer;
    begin
        TextFile.TextMode(false);
        TextFile.Open(SourceFileName);
        TextFile.CreateInStream(InStream);
        InputText.Read(InStream);
        TextFile.Close;

        TextPosition := InputText.TextPos(TextToFind);
        while TextPosition <> 0 do begin
            InputText.GetSubText(SubText, 1, TextPosition - 1);
            OutputText.AddText(SubText);
            OutputText.AddText(TextToReplace);
            InputText.GetSubText(InputText, TextPosition + StrLen(TextToFind));
            TextPosition2 := InputText.TextPos(TextToFind2);
            InputText.GetSubText(SubText, 1, TextPosition2 - 1);
            OutputText.AddText(SubText);
            OutputText.AddText(TextToReplace2);
            InputText.GetSubText(InputText, TextPosition2 + StrLen(TextToFind2));
            TextPosition := InputText.TextPos(TextToFind);
        end;

        OutputText.AddText(InputText);

        TextFile.TextMode(false);
        TextFile.Create(DestinationFileName);
        TextFile.CreateOutStream(OutStream);
        OutputText.Write(OutStream);
        TextFile.Close;
    end;

    //[Scope('OnPrem')]
    procedure PlanitUnVisible(pUnVisible: Boolean)
    begin
        visible := pUnVisible;
    end;

    local procedure PlanItImportOnActivate()
    begin
        if Rec."PlanIt Import" then begin
            "Start PeriodEditable" := false;
            "End PeriodEditable" := false;
        end else begin
            "Start PeriodEditable" := true;
            "End PeriodEditable" := true;
        end;
    end;
}


