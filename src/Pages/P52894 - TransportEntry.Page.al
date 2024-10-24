#pragma implicitwith disable
page 52894 "Transport Entry"
{
    Caption = 'Transport & Lunch Entry';
    PageType = List;
    SourceTable = "Transport & Lunch Entry ";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(varSchoolYear; varSchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';
                    TableRelation = "School Year" WHERE(Status = FILTER(Active | Closing));

                    trigger OnValidate()
                    begin
                        Filter;
                        varSchoolYearOnAfterValidate;
                    end;
                }
                field(varOption; varOption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Entry Type';
                    OptionCaption = ' ,Driver Absence,Student Transport,Transport Alteration,Student Lunch';

                    trigger OnValidate()
                    begin
                        Filter;
                        varOptionOnAfterValidate;
                    end;
                }
                field(varStartingDate; varStartingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Start Period';

                    trigger OnValidate()
                    begin

                        varEndingDate := varStartingDate;
                        varStartingDateOnAfterValidate;
                    end;
                }
                field(varEndingDate; varEndingDate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'End Period';

                    trigger OnValidate()
                    begin
                        Filter;
                        varEndingDateOnAfterValidate;
                    end;
                }
            }
            repeater(Control1110000)
            {
                Editable = false;
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transports Absence"; Rec."Transports Absence")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Transports AbsenceVisible";
                }
                field("Student No."; Rec."Student No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Student No.Visible";
                }
                field("Student Name"; Rec."Student Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Student NameVisible";
                }
                field("Absence Day"; Rec."Absence Day")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transport No."; Rec."Transport No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Transport No.Visible";
                }
                field("Lunch Cancelled"; Rec."Lunch Cancelled")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Lunch CancelledVisible";
                }
                field("Transport Collect Cancelled"; Rec."Transport Collect Cancelled")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = TransportCollectCancelledVisib;
                }
                field("Transport Deliver Cancelled"; Rec."Transport Deliver Cancelled")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = TransportDeliverCancelledVisib;
                }
                field("Collect Time"; Rec."Collect Time")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Collect Time';
                    Visible = "Collect TimeVisible";
                }
                field("Collect Transport"; Rec."Collect Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Collect TransportVisible";
                }
                field("Deliver Transport"; Rec."Deliver Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Deliver TransportVisible";
                }
                field("Deliver Time"; Rec."Deliver Time")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "Deliver TimeVisible";
                }
                field("New Transport"; Rec."New Transport")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "New TransportVisible";
                }
                field(Driver; Rec.Driver)
                {
                    ApplicationArea = Basic, Suite;
                    Visible = DriverVisible;
                }
                field("New Driver"; Rec."New Driver")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = "New DriverVisible";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "New DriverVisible" := true;
        DriverVisible := true;
        "New TransportVisible" := true;
        "Transports AbsenceVisible" := true;
        "Transport No.Visible" := true;
        "Deliver TimeVisible" := true;
        "Deliver TransportVisible" := true;
        "Collect TimeVisible" := true;
        "Collect TransportVisible" := true;
        TransportDeliverCancelledVisib := true;
        TransportCollectCancelledVisib := true;
        "Lunch CancelledVisible" := true;
        "Student NameVisible" := true;
        "Student No.Visible" := true;
    end;

    trigger OnOpenPage()
    begin
        if cUserEducation.GetEducationFilter(UserId) <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            Rec.FilterGroup(0);
        end;
        Filter;
    end;

    var
        cUserEducation: Codeunit "User Education";
        varStartingDate: Date;
        varEndingDate: Date;
        varSchoolYear: Code[9];
        varOption: Option " ","Driver Absence","Student Transport","Transport Alteration","Student Lunch";
        [InDataSet]
        "Student No.Visible": Boolean;
        [InDataSet]
        "Student NameVisible": Boolean;
        [InDataSet]
        "Lunch CancelledVisible": Boolean;
        [InDataSet]
        TransportCollectCancelledVisib: Boolean;
        [InDataSet]
        TransportDeliverCancelledVisib: Boolean;
        [InDataSet]
        "Collect TransportVisible": Boolean;
        [InDataSet]
        "Collect TimeVisible": Boolean;
        [InDataSet]
        "Deliver TransportVisible": Boolean;
        [InDataSet]
        "Deliver TimeVisible": Boolean;
        [InDataSet]
        "Transport No.Visible": Boolean;
        [InDataSet]
        "Transports AbsenceVisible": Boolean;
        [InDataSet]
        "New TransportVisible": Boolean;
        [InDataSet]
        DriverVisible: Boolean;
        [InDataSet]
        "New DriverVisible": Boolean;


    procedure "Filter"()
    begin

        Rec.SetRange("Entry Type", varOption);
        if varSchoolYear <> '' then
            Rec.SetRange("School Year", varSchoolYear)
        else
            Rec.SetRange("School Year");

        if varStartingDate <> 0D then
            Rec.SetRange("Absence Day", varStartingDate, varEndingDate)
        else
            Rec.SetRange("Absence Day");




        "Student No.Visible" := true;
        "Student NameVisible" := true;
        "Lunch CancelledVisible" := true;
        TransportCollectCancelledVisib := true;
        TransportDeliverCancelledVisib := true;
        "Collect TransportVisible" := true;
        "Collect TimeVisible" := true;
        "Deliver TransportVisible" := true;
        "Deliver TimeVisible" := true;
        "Transport No.Visible" := true;
        "Transports AbsenceVisible" := true;
        "New TransportVisible" := true;
        DriverVisible := true;
        "New DriverVisible" := true;




        if varOption = varOption::"Student Lunch" then begin
            "Lunch CancelledVisible" := true;
            TransportCollectCancelledVisib := false;
            TransportDeliverCancelledVisib := false;
            "Collect TimeVisible" := false;
            "Deliver TransportVisible" := false;
            "Deliver TimeVisible" := false;
            "Transport No.Visible" := false;
            "New TransportVisible" := false;
            "Transports AbsenceVisible" := false;
            DriverVisible := false;
            "New DriverVisible" := false;

        end;

        if varOption = varOption::"Student Transport" then begin
            "Lunch CancelledVisible" := false;
            "New TransportVisible" := false;
            DriverVisible := false;
            "New DriverVisible" := false;
        end;

        if varOption = varOption::"Driver Absence" then begin
            "Student No.Visible" := false;
            "Student NameVisible" := false;
            "Lunch CancelledVisible" := false;
            TransportCollectCancelledVisib := false;
            TransportDeliverCancelledVisib := false;
            "Collect TimeVisible" := false;
            "Deliver TransportVisible" := false;
            "Deliver TimeVisible" := false;
            "Transports AbsenceVisible" := false;
            "New TransportVisible" := false;
        end;

        if varOption = varOption::"Transport Alteration" then begin
            "Student No.Visible" := false;
            "Student NameVisible" := false;
            "Lunch CancelledVisible" := false;
            TransportCollectCancelledVisib := false;
            TransportDeliverCancelledVisib := false;
            "Collect TimeVisible" := false;
            "Deliver TransportVisible" := false;
            "Deliver TimeVisible" := false;
            "Transports AbsenceVisible" := false;
            DriverVisible := false;
            "New DriverVisible" := false;

        end;
    end;

    local procedure varStartingDateOnAfterValidate()
    begin
        Filter;
        CurrPage.Update(false);
    end;

    local procedure varEndingDateOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure varOptionOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure varSchoolYearOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

