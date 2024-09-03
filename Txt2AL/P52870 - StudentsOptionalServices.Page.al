#pragma implicitwith disable
page 52870 "Students Optional Services"
{
    Caption = 'Students Optional Services';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Registration;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SchoolYear; SchoolYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'School Year';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec.Reset;
                        if PAGE.RunModal(0, rSchoolYear) = ACTION::LookupOK then begin
                            SchoolYear := rSchoolYear."School Year";
                            SchoolingYear := '';
                            CourseCode := '';
                            ServicePlanCode := '';

                            Rec.DeleteAll;
                            CurrPage.Update(false);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SchoolYearOnAfterValidate;
                    end;
                }
                field(SchoolingYear; SchoolingYear)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Schooling Year';
                    TableRelation = "Structure Education Country"."Schooling Year";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rCompanyInfo.Get;
                        rStructureEducationCountry.Reset;
                        rStructureEducationCountry.SetRange(Country, rCompanyInfo."Country/Region Code");
                        //rStructureEducationCountry.SETRANGE(Type,rStructureEducationCountry.Type::Multi);

                        if PAGE.RunModal(0, rStructureEducationCountry) = ACTION::LookupOK then begin
                            SchoolingYear := rStructureEducationCountry."Schooling Year";
                            CourseCode := '';
                            ServicePlanCode := '';

                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SchoolingYearOnAfterValidate;
                    end;
                }
                field(ServicePlanCode; ServicePlanCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Services Plan Code';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        rServicesPlanHead.Reset;
                        rServicesPlanHead.SetRange("School Year", SchoolYear);
                        rServicesPlanHead.SetRange("Schooling Year", SchoolingYear);
                        if PAGE.RunModal(0, rServicesPlanHead) = ACTION::LookupOK then
                            ServicePlanCode := rServicesPlanHead.Code;
                        UpdateFilters;
                    end;

                    trigger OnValidate()
                    begin
                        ServicePlanCodeOnAfterValidate;
                    end;
                }
                field(TextORCode; TextORCode)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Text';
                }
            }
            repeater(TableBox)
            {
                field("Student Code No."; Rec."Student Code No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(StudentName; GetStudentName)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    Editable = false;
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Txt1; IsSubcrived[1])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(1, TextORCode);
                    Visible = Txt1Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived1OnAfterValidate;
                    end;
                }
                field(Txt2; IsSubcrived[2])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(2, TextORCode);
                    Visible = Txt2Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived2OnAfterValidate;
                    end;
                }
                field(Txt3; IsSubcrived[3])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(3, TextORCode);
                    Visible = Txt3Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived3OnAfterValidate;
                    end;
                }
                field(Txt4; IsSubcrived[4])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(4, TextORCode);
                    Visible = Txt4Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived4OnAfterValidate;
                    end;
                }
                field(Txt5; IsSubcrived[5])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(5, TextORCode);
                    Visible = Txt5Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived5OnAfterValidate;
                    end;
                }
                field(Txt6; IsSubcrived[6])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(6, TextORCode);
                    Visible = Txt6Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived6OnAfterValidate;
                    end;
                }
                field(Txt7; IsSubcrived[7])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(7, TextORCode);
                    Visible = Txt7Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived7OnAfterValidate;
                    end;
                }
                field(Txt8; IsSubcrived[8])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(8, TextORCode);
                    Visible = Txt8Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived8OnAfterValidate;
                    end;
                }
                field(Txt9; IsSubcrived[9])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(9, TextORCode);
                    Visible = Txt9Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived9OnAfterValidate;
                    end;
                }
                field(Txt10; IsSubcrived[10])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(10, TextORCode);
                    Visible = Txt10Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived10OnAfterValidate;
                    end;
                }
                field(Txt11; IsSubcrived[11])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(11, TextORCode);
                    Visible = Txt11Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived11OnAfterValidate;
                    end;
                }
                field(Txt12; IsSubcrived[12])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(12, TextORCode);
                    Visible = Txt12Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived12OnAfterValidate;
                    end;
                }
                field(Txt13; IsSubcrived[13])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(13, TextORCode);
                    Visible = Txt13Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived13OnAfterValidate;
                    end;
                }
                field(Txt14; IsSubcrived[14])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(14, TextORCode);
                    Visible = Txt14Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived14OnAfterValidate;
                    end;
                }
                field(Txt15; IsSubcrived[15])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(15, TextORCode);
                    Visible = Txt15Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived15OnAfterValidate;
                    end;
                }
                field(Txt16; IsSubcrived[16])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(16, TextORCode);
                    Visible = Txt16Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived16OnAfterValidate;
                    end;
                }
                field(Txt17; IsSubcrived[17])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(17, TextORCode);
                    Visible = Txt17Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived17OnAfterValidate;
                    end;
                }
                field(Txt18; IsSubcrived[18])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(18, TextORCode);
                    Visible = Txt18Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived18OnAfterValidate;
                    end;
                }
                field(Txt19; IsSubcrived[19])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(19, TextORCode);
                    Visible = Txt19Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived19OnAfterValidate;
                    end;
                }
                field(Txt20; IsSubcrived[20])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(20, TextORCode);
                    Visible = Txt20Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived20OnAfterValidate;
                    end;
                }
                field(Txt21; IsSubcrived[21])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(21, TextORCode);
                    Visible = Txt21Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived21OnAfterValidate;
                    end;
                }
                field(Txt22; IsSubcrived[22])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(22, TextORCode);
                    Visible = Txt22Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived22OnAfterValidate;
                    end;
                }
                field(Txt23; IsSubcrived[23])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(23, TextORCode);
                    Visible = Txt23Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived23OnAfterValidate;
                    end;
                }
                field(Txt24; IsSubcrived[24])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(24, TextORCode);
                    Visible = Txt24Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived24OnAfterValidate;
                    end;
                }
                field(Txt25; IsSubcrived[25])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(25, TextORCode);
                    Visible = Txt25Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived25OnAfterValidate;
                    end;
                }
                field(Txt26; IsSubcrived[26])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(26, TextORCode);
                    Visible = Txt26Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived26OnAfterValidate;
                    end;
                }
                field(Txt27; IsSubcrived[27])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(27, TextORCode);
                    Visible = Txt27Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived27OnAfterValidate;
                    end;
                }
                field(Txt28; IsSubcrived[28])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(28, TextORCode);
                    Visible = Txt28Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived28OnAfterValidate;
                    end;
                }
                field(Txt29; IsSubcrived[29])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(29, TextORCode);
                    Visible = Txt29Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived29OnAfterValidate;
                    end;
                }
                field(Txt30; IsSubcrived[30])
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '1,5,,' + getCaptionLabel(30, TextORCode);
                    Visible = Txt30Visible;

                    trigger OnValidate()
                    begin
                        IsSubcrived30OnAfterValidate;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        InsertColunm;
        EditableFuction;
    end;

    trigger OnInit()
    begin
        Txt30Visible := true;
        Txt29Visible := true;
        Txt28Visible := true;
        Txt27Visible := true;
        Txt26Visible := true;
        Txt25Visible := true;
        Txt24Visible := true;
        Txt23Visible := true;
        Txt22Visible := true;
        Txt21Visible := true;
        Txt20Visible := true;
        Txt19Visible := true;
        Txt18Visible := true;
        Txt17Visible := true;
        Txt16Visible := true;
        Txt15Visible := true;
        Txt14Visible := true;
        Txt13Visible := true;
        Txt12Visible := true;
        Txt11Visible := true;
        Txt10Visible := true;
        Txt9Visible := true;
        Txt8Visible := true;
        Txt7Visible := true;
        Txt6Visible := true;
        Txt5Visible := true;
        Txt4Visible := true;
        Txt3Visible := true;
        Txt2Visible := true;
        Txt1Visible := true;
    end;

    var
        rSchoolYear: Record "School Year";
        rStudyPlanHeader: Record "Study Plan Header";
        rStudyPlanLines: Record "Study Plan Lines";
        rCourseHeader: Record "Course Header";
        rCourseLines: Record "Course Lines";
        rRegistration: Record Registration;
        rCompanyInfo: Record "Company Information";
        rStructureEducationCountry: Record "Structure Education Country";
        rScoolingYear1: Record "Structure Education Country";
        rScoolingYear2: Record "Structure Education Country";
        rEduConfiguration: Record "Edu. Configuration";
        rServicesPlanHead: Record "Services Plan Head";
        rServicesPlanLine: Record "Services Plan Line";
        rStudentServicePlan: Record "Student Service Plan";
        SchoolYear: Code[20];
        SchoolingYear: Code[20];
        StudyPlanCode: Code[20];
        CourseCode: Code[20];
        ServicePlanCode: Code[20];
        IsSubcrived: array[30] of Boolean;
        CaptionCode: array[30] of Text[30];
        CaptionText: array[30] of Text[100];
        TextORCode: Boolean;
        Text001: Label 'The Subject %1 is %2. In this status can not be modified.';
        Text002: Label 'Do you wish to enroll the student %1 in the class %2?';
        cStudentsRegistration: Codeunit "Students Registration";
        [InDataSet]
        Txt1Visible: Boolean;
        [InDataSet]
        Txt2Visible: Boolean;
        [InDataSet]
        Txt3Visible: Boolean;
        [InDataSet]
        Txt4Visible: Boolean;
        [InDataSet]
        Txt5Visible: Boolean;
        [InDataSet]
        Txt6Visible: Boolean;
        [InDataSet]
        Txt7Visible: Boolean;
        [InDataSet]
        Txt8Visible: Boolean;
        [InDataSet]
        Txt9Visible: Boolean;
        [InDataSet]
        Txt10Visible: Boolean;
        [InDataSet]
        Txt11Visible: Boolean;
        [InDataSet]
        Txt12Visible: Boolean;
        [InDataSet]
        Txt13Visible: Boolean;
        [InDataSet]
        Txt14Visible: Boolean;
        [InDataSet]
        Txt15Visible: Boolean;
        [InDataSet]
        Txt16Visible: Boolean;
        [InDataSet]
        Txt17Visible: Boolean;
        [InDataSet]
        Txt18Visible: Boolean;
        [InDataSet]
        Txt19Visible: Boolean;
        [InDataSet]
        Txt20Visible: Boolean;
        [InDataSet]
        Txt21Visible: Boolean;
        [InDataSet]
        Txt22Visible: Boolean;
        [InDataSet]
        Txt23Visible: Boolean;
        [InDataSet]
        Txt24Visible: Boolean;
        [InDataSet]
        Txt25Visible: Boolean;
        [InDataSet]
        Txt26Visible: Boolean;
        [InDataSet]
        Txt27Visible: Boolean;
        [InDataSet]
        Txt28Visible: Boolean;
        [InDataSet]
        Txt29Visible: Boolean;
        [InDataSet]
        Txt30Visible: Boolean;

    //[Scope('OnPrem')]
    procedure GetStudentName(): Text[250]
    var
        rStudents: Record Students;
    begin
        if rStudents.Get(Rec."Student Code No.") then
            exit(rStudents.Name)
        else
            exit('');
    end;

    //[Scope('OnPrem')]
    procedure UpdateFilters()
    var
        l_rSchoolYear: Record "School Year";
        i: Integer;
        k: Integer;
    begin
        if SchoolingYear <> '' then begin
            Rec.Reset;
            Rec.DeleteAll;

            rRegistration.Reset;
            if ServicePlanCode = '' then
                rRegistration.SetFilter("Services Plan Code", '<>%1', '')
            else
                rRegistration.SetFilter("Services Plan Code", ServicePlanCode);
            rRegistration.SetRange("Schooling Year", SchoolingYear);
            rRegistration.SetRange("School Year", SchoolYear);
            if rRegistration.Find('-') then begin
                repeat
                    Rec.TransferFields(rRegistration);
                    Rec.Insert;
                until rRegistration.Next = 0;
            end;


            Clear(CaptionCode);
            Clear(CaptionText);
            rServicesPlanHead.Reset;
            rServicesPlanHead.SetRange(Code, ServicePlanCode);
            rServicesPlanHead.SetRange("School Year", SchoolYear);
            rServicesPlanHead.SetRange("Schooling Year", SchoolingYear);
            if rServicesPlanHead.Find('-') then begin
                rServicesPlanLine.Reset;
                rServicesPlanLine.SetRange(Code, rServicesPlanHead.Code);
                rServicesPlanLine.SetRange("School Year", rServicesPlanHead."School Year");
                rServicesPlanLine.SetRange("Schooling Year", rServicesPlanHead."Schooling Year");
                rServicesPlanLine.SetRange("Service Type", rServicesPlanLine."Service Type"::Optional);
                if rServicesPlanLine.Find('-') then begin
                    repeat
                        i += 1;
                        if i < 31 then begin
                            CaptionCode[i] := rServicesPlanLine."Service Code";
                            CaptionText[i] := rServicesPlanLine.Description;
                        end;
                    until rServicesPlanLine.Next = 0;
                end;
            end;
            CurrPage.Update(false);
        end;
    end;

    //[Scope('OnPrem')]
    procedure getCaptionLabel(label: Integer; IsTextOrCode: Boolean) out: Text[100]
    begin
        if IsTextOrCode then
            exit(CaptionText[label])
        else
            exit(CaptionCode[label]);
    end;

    //[Scope('OnPrem')]
    procedure InsertColunm()
    var
        i: Integer;
    begin
        i := 0;

        for i := 1 to ArrayLen(CaptionCode) do begin
            if CaptionCode[i] <> '' then
                IsSubcrived[i] := GetStudentRegister(Rec."Student Code No.", CaptionCode[i]);
        end;
    end;

    //[Scope('OnPrem')]
    procedure GetStudentRegister(p_StudentCode: Code[20]; p_ServiceCode: Code[20]): Boolean
    begin
        if (p_StudentCode <> '') and (p_ServiceCode <> '') then begin
            rStudentServicePlan.Reset;
            rStudentServicePlan.SetRange("Student No.", p_StudentCode);
            rStudentServicePlan.SetRange("School Year", rSchoolYear."School Year");
            rStudentServicePlan.SetRange("Services Plan Code", ServicePlanCode);
            rStudentServicePlan.SetRange("Service Code", p_ServiceCode);
            if rStudentServicePlan.Find('-') then
                exit(rStudentServicePlan.Selected)
            else
                exit(false);
        end else
            exit(false);
    end;

    //[Scope('OnPrem')]
    procedure ModifyStudentRegister(p_StudentCode: Code[20]; p_ServiceCode: Code[20]; p_Status: Boolean): Boolean
    begin
        if (p_StudentCode <> '') and (p_ServiceCode <> '') then begin
            rStudentServicePlan.Reset;
            rStudentServicePlan.SetRange("Student No.", p_StudentCode);
            rStudentServicePlan.SetRange("School Year", rSchoolYear."School Year");
            rStudentServicePlan.SetRange("Service Code", p_ServiceCode);
            if rStudentServicePlan.Find('-') then begin
                rStudentServicePlan.Validate(Selected, p_Status);
                rStudentServicePlan.Modify;
                //EXIT(p_Status);
            end else
                exit(false);
        end else
            exit(false);

        InsertColunm;
    end;

    //[Scope('OnPrem')]
    procedure EditableFuction()
    begin
        if (CaptionCode[1] <> '') then
            Txt1Visible := true
        else
            Txt1Visible := false;

        if (CaptionCode[2] <> '') then
            Txt2Visible := true
        else
            Txt2Visible := false;

        if (CaptionCode[3] <> '') then
            Txt3Visible := true
        else
            Txt3Visible := false;

        if (CaptionCode[4] <> '') then
            Txt4Visible := true
        else
            Txt4Visible := false;

        if (CaptionCode[5] <> '') then
            Txt5Visible := true
        else
            Txt5Visible := false;

        if (CaptionCode[6] <> '') then
            Txt6Visible := true
        else
            Txt6Visible := false;

        if (CaptionCode[7] <> '') then
            Txt7Visible := true
        else
            Txt7Visible := false;

        if (CaptionCode[8] <> '') then
            Txt8Visible := true
        else
            Txt8Visible := false;

        if (CaptionCode[9] <> '') then
            Txt9Visible := true
        else
            Txt9Visible := false;

        if (CaptionCode[10] <> '') then
            Txt10Visible := true
        else
            Txt10Visible := false;

        if (CaptionCode[11] <> '') then
            Txt11Visible := true
        else
            Txt11Visible := false;

        if (CaptionCode[12] <> '') then
            Txt12Visible := true
        else
            Txt12Visible := false;

        if (CaptionCode[13] <> '') then
            Txt13Visible := true
        else
            Txt13Visible := false;

        if (CaptionCode[14] <> '') then
            Txt14Visible := true
        else
            Txt14Visible := false;

        if (CaptionCode[15] <> '') then
            Txt15Visible := true
        else
            Txt15Visible := false;

        if (CaptionCode[16] <> '') then
            Txt16Visible := true
        else
            Txt16Visible := false;

        if (CaptionCode[17] <> '') then
            Txt17Visible := true
        else
            Txt17Visible := false;

        if (CaptionCode[18] <> '') then
            Txt18Visible := true
        else
            Txt18Visible := false;

        if (CaptionCode[19] <> '') then
            Txt19Visible := true
        else
            Txt19Visible := false;

        if (CaptionCode[20] <> '') then
            Txt20Visible := true
        else
            Txt20Visible := false;

        if (CaptionCode[21] <> '') then
            Txt21Visible := true
        else
            Txt21Visible := false;

        if (CaptionCode[22] <> '') then
            Txt22Visible := true
        else
            Txt22Visible := false;

        if (CaptionCode[23] <> '') then
            Txt23Visible := true
        else
            Txt23Visible := false;

        if (CaptionCode[24] <> '') then
            Txt24Visible := true
        else
            Txt24Visible := false;

        if (CaptionCode[25] <> '') then
            Txt25Visible := true
        else
            Txt25Visible := false;

        if (CaptionCode[26] <> '') then
            Txt26Visible := true
        else
            Txt26Visible := false;

        if (CaptionCode[27] <> '') then
            Txt27Visible := true
        else
            Txt27Visible := false;

        if (CaptionCode[28] <> '') then
            Txt28Visible := true
        else
            Txt28Visible := false;

        if (CaptionCode[29] <> '') then
            Txt29Visible := true
        else
            Txt29Visible := false;

        if (CaptionCode[30] <> '') then
            Txt30Visible := true
        else
            Txt30Visible := false;
    end;

    local procedure IsSubcrived1OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[1], IsSubcrived[1]) then;
    end;

    local procedure IsSubcrived2OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[2], IsSubcrived[2]) then;
    end;

    local procedure IsSubcrived3OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[3], IsSubcrived[3]) then;
    end;

    local procedure IsSubcrived4OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[4], IsSubcrived[4]) then;
    end;

    local procedure IsSubcrived5OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[5], IsSubcrived[5]) then;
    end;

    local procedure IsSubcrived6OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[6], IsSubcrived[6]) then;
    end;

    local procedure IsSubcrived7OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[7], IsSubcrived[7]) then;
    end;

    local procedure IsSubcrived8OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[8], IsSubcrived[8]) then;
    end;

    local procedure IsSubcrived9OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[9], IsSubcrived[9]) then;
    end;

    local procedure IsSubcrived10OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[10], IsSubcrived[10]) then;
    end;

    local procedure IsSubcrived11OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[11], IsSubcrived[11]) then;
    end;

    local procedure IsSubcrived12OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[12], IsSubcrived[12]) then;
    end;

    local procedure IsSubcrived13OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[13], IsSubcrived[13]) then;
    end;

    local procedure IsSubcrived14OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[14], IsSubcrived[14]) then;
    end;

    local procedure IsSubcrived15OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[15], IsSubcrived[15]) then;
    end;

    local procedure IsSubcrived16OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[16], IsSubcrived[16]) then;
    end;

    local procedure IsSubcrived17OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[17], IsSubcrived[17]) then;
    end;

    local procedure IsSubcrived18OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[18], IsSubcrived[18]) then;
    end;

    local procedure IsSubcrived19OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[19], IsSubcrived[19]) then;
    end;

    local procedure IsSubcrived20OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[20], IsSubcrived[20]) then;
    end;

    local procedure IsSubcrived21OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[21], IsSubcrived[21]) then;
    end;

    local procedure IsSubcrived22OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[22], IsSubcrived[22]) then;
    end;

    local procedure IsSubcrived23OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[23], IsSubcrived[23]) then;
    end;

    local procedure IsSubcrived24OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[24], IsSubcrived[24]) then;
    end;

    local procedure IsSubcrived25OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[25], IsSubcrived[25]) then;
    end;

    local procedure IsSubcrived26OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[26], IsSubcrived[26]) then;
    end;

    local procedure IsSubcrived27OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[27], IsSubcrived[27]) then;
    end;

    local procedure IsSubcrived28OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[28], IsSubcrived[28]) then;
    end;

    local procedure IsSubcrived29OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[29], IsSubcrived[29]) then;
    end;

    local procedure IsSubcrived30OnAfterValidate()
    begin
        if ModifyStudentRegister(Rec."Student Code No.", CaptionCode[30], IsSubcrived[30]) then;
    end;

    local procedure SchoolingYearOnAfterValidate()
    begin
        CourseCode := '';
        ServicePlanCode := '';
    end;

    local procedure ServicePlanCodeOnAfterValidate()
    begin
        rServicesPlanHead.Reset;
        rServicesPlanHead.SetRange("School Year", SchoolYear);
        rServicesPlanHead.SetRange("Schooling Year", SchoolingYear);
        if PAGE.RunModal(0, rServicesPlanHead) = ACTION::LookupOK then
            ServicePlanCode := rServicesPlanHead.Code;
        UpdateFilters;
    end;

    local procedure SchoolYearOnAfterValidate()
    begin
        UpdateFilters;
        SchoolingYear := '';
        CourseCode := '';
        ServicePlanCode := '';

        Rec.DeleteAll;
        CurrPage.Update(false);
    end;
}

#pragma implicitwith restore

