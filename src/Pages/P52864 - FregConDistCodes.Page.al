#pragma implicitwith disable
page 52864 "FregConDist Codes"
{
    Caption = 'Codes';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Legal Codes";

    layout
    {
        area(content)
        {
            repeater(Control1110000)
            {
                ShowCaption = false;
                field("Parish/Council/District Code"; Rec."Parish/Council/District Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = ParishCouncilDistrictCodeVisib;
                }
                field(Town; Rec.Town)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = TownVisible;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = CountyVisible;
                }
                field(District; Rec.District)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = DistrictVisible;
                }
                field("Code"; Rec."Parish/Council/District Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Code';
                    Visible = CodeVisible;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = DescriptionVisible;
                }
                field("School Name"; Rec."School Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "School NameVisible";
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = AddressVisible;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Address 2Visible";
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Post CodeVisible";
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = LocationVisible;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Phone No.Visible";
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "E-mailVisible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CodeVisible := true;
        DescriptionVisible := true;
        "E-mailVisible" := true;
        "Phone No.Visible" := true;
        LocationVisible := true;
        "Post CodeVisible" := true;
        "Address 2Visible" := true;
        AddressVisible := true;
        "School NameVisible" := true;
        DistrictVisible := true;
        CountyVisible := true;
        TownVisible := true;
        ParishCouncilDistrictCodeVisib := true;
    end;

    trigger OnOpenPage()
    begin
        /*
        IF NOT CurrPage.LOOKUPMODE THEN BEGIN
          Type := Rec.Type::School;
          SETRANGE(Type,Rec.Type::School);
        END;
        */
        case Rec.Type of
            0:
                begin
                    CurrPage.Caption(Text0001);
                    ShowCoumns(true);
                end;
            1:
                begin
                    CurrPage.Caption(Text0002);
                    ShowCoumns(false);
                end;
            2:
                begin
                    CurrPage.Caption(Text0003);
                    ShowCoumns(false);
                end;
            3:
                begin
                    CurrPage.Caption(Text0004);
                    ShowCoumns(false);
                end;
            4:
                begin
                    CurrPage.Caption(Text0005);
                    ShowCoumns(false);
                end;
            5:
                begin
                    CurrPage.Caption(Text0006);
                    ShowCoumns(false);
                end;
            6:
                begin
                    CurrPage.Caption(Text0007);
                    ShowCoumns(false);
                end;
            7:
                begin
                    CurrPage.Caption(Text0008);
                    ShowCoumns(false);
                end;

        end;

    end;

    var
        Text0001: Label 'Parish List';
        Text0002: Label 'Course List';
        Text0003: Label 'Subjects List';
        Text0004: Label 'Exams List';
        Text0005: Label 'Other Schools List';
        Text0006: Label 'IRS List';
        Text0007: Label 'Types Student List';
        Text0008: Label 'Province List';
        [InDataSet]
        ParishCouncilDistrictCodeVisib: Boolean;
        [InDataSet]
        TownVisible: Boolean;
        [InDataSet]
        CountyVisible: Boolean;
        [InDataSet]
        DistrictVisible: Boolean;
        [InDataSet]
        "School NameVisible": Boolean;
        [InDataSet]
        AddressVisible: Boolean;
        [InDataSet]
        "Address 2Visible": Boolean;
        [InDataSet]
        "Post CodeVisible": Boolean;
        [InDataSet]
        LocationVisible: Boolean;
        [InDataSet]
        "Phone No.Visible": Boolean;
        [InDataSet]
        "E-mailVisible": Boolean;
        [InDataSet]
        DescriptionVisible: Boolean;
        [InDataSet]
        CodeVisible: Boolean;


    procedure ShowCoumns(p_Value: Boolean)
    begin
        ParishCouncilDistrictCodeVisib := p_Value;
        TownVisible := p_Value;
        CountyVisible := p_Value;
        DistrictVisible := p_Value;
        CodeVisible := not p_Value;
        DescriptionVisible := not p_Value;

        if Rec.Type = Rec.Type::School then begin
            "School NameVisible" := true;
            AddressVisible := true;
            "Address 2Visible" := true;
            "Post CodeVisible" := true;
            LocationVisible := true;
            "Phone No.Visible" := true;
            "E-mailVisible" := true;
            DescriptionVisible := false;
        end else begin
            "School NameVisible" := false;
            AddressVisible := false;
            "Address 2Visible" := false;
            "Post CodeVisible" := false;
            LocationVisible := false;
            "Phone No.Visible" := false;
            "E-mailVisible" := false;
            DescriptionVisible := true;
        end;
    end;
}

#pragma implicitwith restore

