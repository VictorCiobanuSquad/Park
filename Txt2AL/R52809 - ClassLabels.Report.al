report 52809 "Class Labels"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ClassLabels.rdlc';
    Caption = 'Class Lables';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem(integer1; "Integer")
        {
            DataItemTableView = SORTING(Number);
            dataitem(integer2; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(Addr_3__4_; Addr[3] [4])
                {
                }
                column(Addr_3__3_; Addr[3] [3])
                {
                }
                column(Addr_3__2_; Addr[3] [2])
                {
                }
                column(Addr_3__1_; Addr[3] [1])
                {
                }
                column(Addr_2__3_; Addr[2] [3])
                {
                }
                column(Addr_2__4_; Addr[2] [4])
                {
                }
                column(Addr_2__2_; Addr[2] [2])
                {
                }
                column(Addr_2__1_; Addr[2] [1])
                {
                }
                column(Addr_1__1_; Addr[1] [1])
                {
                }
                column(Addr_1__2_; Addr[1] [2])
                {
                }
                column(Addr_1__3_; Addr[1] [3])
                {
                }
                column(Addr_1__4_; Addr[1] [4])
                {
                }
                column(integer2_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                var
                    vName: Text[128];
                    vLastname: Text[50];
                    vPref: Text[30];
                    vSaludation: Text[30];
                    vAddress: Text[50];
                    vAddress2: Text[50];
                    vPostCode: Text[30];
                    vLocation: Text[30];
                begin
                    if rUsersFamily.Get(rUsersFamilyStudentsTEMP."No.") then begin

                        ColumnNo += 1;
                        RecordNo += 1;

                        if rUsersFamily.Name = '' then
                            vName := ''
                        else
                            vName := rUsersFamily.Name;

                        if vSaludationCode then begin
                            if rUsersFamily."Salutation Code" = '' then
                                vSaludation := ''
                            else
                                vSaludation := rUsersFamily."Salutation Code" + ' ';
                        end else
                            vSaludation := '';

                        case NameType of
                            NameType::LastnameAndName:
                                Addr[ColumnNo] [1] := vSaludation + Format(vLastname + ',' + vName);
                            NameType::LastName:
                                Addr[ColumnNo] [1] := vSaludation + Format(vLastname);
                            NameType::NameAndLastname:
                                Addr[ColumnNo] [1] := vSaludation + Format(vName + ' ' + vLastname);
                        end;

                        if rUsersFamily.Address = '' then
                            vAddress := ' '
                        else
                            vAddress := rUsersFamily.Address;
                        if rUsersFamily."Address 2" = '' then
                            vAddress2 := ' '
                        else
                            vAddress2 := rUsersFamily."Address 2";
                        if rUsersFamily."Post Code" = '' then
                            vPostCode := ' '
                        else
                            vPostCode := rUsersFamily."Post Code";
                        if rUsersFamily.Location = '' then
                            vLocation := ' '
                        else
                            vLocation := rUsersFamily.Location;


                    end else begin

                        if rStudent.Get(rUsersFamilyStudentsTEMP."No.") then begin
                            ColumnNo += 1;
                            RecordNo += 1;

                            if rStudent.Name = '' then
                                vName := ''
                            else
                                vName := rStudent.Name;


                            case NameType of
                                NameType::LastnameAndName:
                                    Addr[ColumnNo] [1] := Format(vLastname + ',' + vName);
                                NameType::LastName:
                                    Addr[ColumnNo] [1] := Format(vLastname);
                                NameType::NameAndLastname:
                                    Addr[ColumnNo] [1] := Format(vName + ' ' + vLastname);
                            end;

                            if rStudent.Address = '' then
                                vAddress := ' '
                            else
                                vAddress := rStudent.Address;
                            if rStudent."Address 2" = '' then
                                vAddress2 := ' '
                            else
                                vAddress2 := rStudent."Address 2";
                            if rStudent."Post Code" = '' then
                                vPostCode := ' '
                            else
                                vPostCode := rStudent."Post Code";
                            if rStudent.Location = '' then
                                vLocation := ' '
                            else
                                vLocation := rStudent.Location;

                        end;
                    end;

                    Addr[ColumnNo] [2] := Format(vAddress + ' ' + vAddress2);
                    Addr[ColumnNo] [3] := Format(vPostCode + ' ' + vLocation);
                    if vShowClass then begin
                        rClass.Reset;
                        rClass.SetRange(rClass.Class, rRegistrationClass.Class);
                        rClass.SetRange(rClass."School Year", rRegistrationClass."School Year");
                        if rClass.FindFirst then
                            Addr[ColumnNo] [4] := Format(rClass."Schooling Year" + ' - ' + rClass."Class Letter");
                    end;

                    CompressArray(Addr[ColumnNo]);


                    if RecordNo = NoOfRecords then begin
                        for i := ColumnNo + 1 to NoOfColumns do
                            Clear(Addr[i]);
                        ColumnNo := 0;
                    end else begin
                        if ColumnNo = NoOfColumns then
                            ColumnNo := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, integer1.Count);
                    NoOfRecords := integer1.Count;
                    NoOfColumns := 3;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if integer1.Number = 1 then
                    rUsersFamilyStudentsTEMP.Find('-')
                else
                    rUsersFamilyStudentsTEMP.Next(1);
            end;

            trigger OnPreDataItem()
            begin
                rRegistrationClass.Reset;
                if vClass <> '' then
                    rRegistrationClass.SetRange(Class, vClass);
                if vStudentNo <> '' then
                    rRegistrationClass.SetRange("Student Code No.", vStudentNo);
                if rRegistrationClass.FindSet then begin
                    repeat
                        rUsersFamilyStudents.Reset;
                        rUsersFamilyStudents.SetRange("Education Head", true);
                        if vSchoolYear <> '' then
                            rUsersFamilyStudents.SetRange("School Year", vSchoolYear);
                        rUsersFamilyStudents.SetRange("Student Code No.", rRegistrationClass."Student Code No.");
                        if rUsersFamilyStudents.FindSet then begin
                            rUsersFamilyStudentsTEMP.Reset;
                            rUsersFamilyStudentsTEMP.SetRange("Education Head", true);
                            rUsersFamilyStudentsTEMP.SetRange("Student Code No.", rUsersFamilyStudents."Student Code No.");
                            if not rUsersFamilyStudentsTEMP.FindSet then begin
                                rUsersFamilyStudentsTEMP.Init;
                                rUsersFamilyStudentsTEMP.TransferFields(rUsersFamilyStudents);
                                rUsersFamilyStudentsTEMP.Insert;
                            end;
                        end;
                    until rRegistrationClass.Next = 0;
                end;

                rUsersFamilyStudentsTEMP.Reset;
                vNumber := rUsersFamilyStudentsTEMP.Count;
                integer1.SetRange(Number, 1, vNumber);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(vSchoolYear; vSchoolYear)
                    {
                        Caption = 'School Year';
                        ApplicationArea = Basic, Suite;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            rClass: Record Class;
                            rShoolYear: Record "School Year";
                        begin
                            if PAGE.RunModal(PAGE::"School Year", rShoolYear) = ACTION::LookupOK then begin
                                vSchoolYear := rShoolYear."School Year";
                            end;
                        end;
                    }
                    field(vClass; vClass)
                    {
                        Caption = 'Class';
                        ApplicationArea = Basic, Suite;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            rClass: Record Class;
                            rRegistrationClass: Record "Registration Class";
                            rClassTemp: Record Class temporary;
                        begin
                            if vStudentNo = '' then begin
                                rClass.Reset;
                                if vSchoolYear <> '' then
                                    rClass.SetRange("School Year", vSchoolYear);
                                if PAGE.RunModal(PAGE::"Class List", rClass) = ACTION::LookupOK then
                                    vClass := rClass.Class;
                            end else begin
                                rRegistrationClass.Reset;
                                if vSchoolYear <> '' then
                                    rRegistrationClass.SetRange("School Year", vSchoolYear);
                                rRegistrationClass.SetRange("Student Code No.", vStudentNo);
                                if rRegistrationClass.Find('-') then begin
                                    repeat
                                        rClass.Reset;
                                        rClass.SetRange(Class, rRegistrationClass.Class);
                                        if rClass.Find('-') then begin
                                            repeat
                                                rClassTemp.Reset;
                                                rClassTemp.SetRange(Class, rRegistrationClass.Class);
                                                if not rClassTemp.Find('-') then begin
                                                    rClassTemp.Init;
                                                    rClassTemp.TransferFields(rClass);
                                                    rClassTemp.Insert;
                                                end;
                                            until rClass.Next = 0;
                                        end;
                                    until rRegistrationClass.Next = 0;
                                end;
                                if PAGE.RunModal(PAGE::"Class List", rClassTemp) = ACTION::LookupOK then
                                    vClass := rClassTemp.Class;
                            end;
                        end;
                    }
                    field(vStudentNo; vStudentNo)
                    {
                        Caption = 'Student Code No.';
                        ApplicationArea = Basic, Suite;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            rStudent: Record Students;
                        begin
                            if PAGE.RunModal(PAGE::"Students List", rStudent) = ACTION::LookupOK then
                                vStudentNo := rStudent."No.";
                        end;
                    }
                    field(vShowClass; vShowClass)
                    {
                        Caption = 'Show Class';
                        ApplicationArea = Basic, Suite;
                    }
                    field(vSaludationCode; vSaludationCode)
                    {
                        Caption = 'Salutation Code';
                        ApplicationArea = Basic, Suite;
                    }
                    field(NameType; NameType)
                    {
                        Caption = 'Label Type';
                        OptionCaption = 'Last Name,Last Name + Name,Name + Last Name';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Addr: array[3, 6] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        vClass: Code[20];
        vSchoolYear: Code[20];
        vShowClass: Boolean;
        vStudentNo: Code[20];
        vNumber: Integer;
        NameType: Option LastName,LastnameAndName,NameAndLastname;
        vSaludationCode: Boolean;
        rUsersFamily: Record "Users Family";
        rUsersFamilyStudents: Record "Users Family / Students";
        rUsersFamilyStudentsTEMP: Record "Users Family / Students" temporary;
        rRegistrationClass: Record "Registration Class";
        rClass: Record Class;
        rStudent: Record Students;
}

