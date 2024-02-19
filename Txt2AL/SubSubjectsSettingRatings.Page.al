#pragma implicitwith disable
page 31009927 "Sub Subjects Setting Ratings"
{
    Caption = 'Setting Ratings';
    PageType = Card;
    SourceTable = "Setting Ratings Sub-Subjects";
    SourceTableView = WHERE(Type = CONST(Header));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Moment Code"; Rec."Moment Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Study Plan Code"; Rec."Study Plan Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("School Year"; Rec."School Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Schooling Year"; Rec."Schooling Year")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Subject Code"; Rec."Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub-Subject Code"; Rec."Sub-Subject Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sub-Subject Description"; Rec."Sub-Subject Description")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Assessment Code"; Rec."Assessment Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Moment Ponder"; Rec."Moment Ponder")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = "Moment PonderEditable";
                }
            }
            part(SubformAspects; "Aspects Sub")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                separator(Action1110017)
                {
                }
                action("Copy of another Moment")
                {
                    Caption = 'Copy of another Moment';
                    Image = Copy;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.CopyAssessmentConf;
                    end;
                }
                separator(Action1102065000)
                {
                }
                action("&Delete Aspects")
                {
                    Caption = '&Delete Aspects';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    var
                        l_Aspects: Record Aspects;
                    begin
                        l_Aspects.Reset;
                        if Rec."Type Education" = Rec."Type Education"::Simple then
                            l_Aspects.SetRange(Type, l_Aspects.Type::"Study Plan");
                        if Rec."Type Education" = Rec."Type Education"::Multi then
                            l_Aspects.SetRange(Type, l_Aspects.Type::Course);
                        l_Aspects.SetRange("School Year", Rec."School Year");
                        l_Aspects.SetRange("Type No.", Rec."Study Plan Code");
                        l_Aspects.SetRange(Subjects, Rec."Subject Code");
                        l_Aspects.SetRange("Sub Subjects", Rec."Sub-Subject Code");
                        l_Aspects.SetRange("Moment Code", Rec."Moment Code");
                        if l_Aspects.Find('-') then begin
                            Rec.DeleteAspects(l_Aspects, Rec);

                            CurrPage.SubformAspects.PAGE.SetTableView(l_Aspects);

                            CurrPage.SubformAspects.PAGE.FormUpdate;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetPonderEditable;
        SetSubformFilter;
    end;

    trigger OnInit()
    begin
        "Moment PonderEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Header;
    end;

    trigger OnOpenPage()
    begin
        GetPonderEditable;
    end;

    var
        rSettingRatings: Record "Setting Ratings";
        rMomentAssements: Record "Moments Assessment";
        [InDataSet]
        "Moment PonderEditable": Boolean;

    //[Scope('OnPrem')]
    procedure SetSubformFilter()
    var
        l_Aspects: Record Aspects;
    begin

        l_Aspects.Reset;
        if Rec."Type Education" = Rec."Type Education"::Simple then
            l_Aspects.SetRange(Type, l_Aspects.Type::"Study Plan");
        if Rec."Type Education" = Rec."Type Education"::Multi then
            l_Aspects.SetRange(Type, l_Aspects.Type::Course);
        l_Aspects.SetRange("School Year", Rec."School Year");
        l_Aspects.SetRange("Type No.", Rec."Study Plan Code");
        l_Aspects.SetRange("Schooling Year", Rec."Schooling Year");
        l_Aspects.SetRange(Subjects, Rec."Subject Code");
        l_Aspects.SetRange("Sub Subjects", Rec."Sub-Subject Code");
        l_Aspects.SetRange("Moment Code", Rec."Moment Code");
        if l_Aspects.Find('-') then;

        CurrPage.SubformAspects.PAGE.SetTableView(l_Aspects);


        CurrPage.SubformAspects.PAGE.FormUpdate;
    end;

    //[Scope('OnPrem')]
    procedure GetPonderEditable()
    begin
        rMomentAssements.Reset;
        rMomentAssements.SetRange("Moment Code", Rec."Moment Code");
        rMomentAssements.SetRange("School Year", Rec."School Year");
        rMomentAssements.SetRange("Schooling Year", Rec."Schooling Year");
        if rMomentAssements.FindFirst then
            if rMomentAssements."Evaluation Moment" = rMomentAssements."Evaluation Moment"::"Final Year" then
                "Moment PonderEditable" := false
            else
                "Moment PonderEditable" := true;
    end;
}

#pragma implicitwith restore

