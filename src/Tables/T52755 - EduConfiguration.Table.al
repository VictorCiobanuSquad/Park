table 52755 "Edu. Configuration"
{
    // IT001 - Parque - Idiomas - 2017.10.12
    //       - Novo campo: "Language Code" (50000)

    Caption = 'Edu. Configuration';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Student Nos."; Code[10])
        {
            Caption = 'Student Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Users Family Nos."; Code[10])
        {
            Caption = 'Users Family Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Teacher Nos."; Code[10])
        {
            Caption = 'Teacher Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Service Nos."; Code[10])
        {
            Caption = 'Service Nos.';
            TableRelation = "No. Series";
        }
        field(6; "Study Plan Nos."; Code[10])
        {
            Caption = 'Study Plan Nos';
            TableRelation = "No. Series";
        }
        field(7; "Class Nos."; Code[10])
        {
            Caption = 'Class Nos.';
            TableRelation = "No. Series";
        }
        field(8; "Timetable Nos."; Code[10])
        {
            Caption = 'Timetable Nos.';
            TableRelation = "No. Series";
        }
        field(9; "Service Plan Nos."; Code[10])
        {
            Caption = 'Service Plan Nos';
            TableRelation = "No. Series";
        }
        field(10; "Candidate Nos."; Code[10])
        {
            Caption = 'Candidate Nos.';
            TableRelation = "No. Series";
        }
        field(11; "Test Nos."; Code[10])
        {
            Caption = 'Test Nos.';
            TableRelation = "No. Series";
        }
        field(49; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(51; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(52; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(53; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(54; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(55; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(56; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(57; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(58; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(59; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(60; "No. Series Journals"; Code[10])
        {
            Caption = 'No. Series Journals';
            TableRelation = "No. Series";
        }
        field(63; "Course Nos."; Code[10])
        {
            Caption = 'Course Nos';
            TableRelation = "No. Series";
        }
        field(64; "Room Nos."; Code[10])
        {
            Caption = 'Room Nos.';
            TableRelation = "No. Series";
        }
        field(65; "Transport Nos."; Code[10])
        {
            Caption = 'Transport Nos.';
            TableRelation = "No. Series";
        }
        field(66; "Equipment Nos."; Code[10])
        {
            Caption = 'Equipment Nos.';
            TableRelation = "No. Series";
        }
        field(67; "Recover Test Nos."; Code[10])
        {
            Caption = 'Recover Test Nos.';
            TableRelation = "No. Series";
        }
        field(68; "Group Equipment Nos."; Code[10])
        {
            Caption = 'Group Equipment Nos.';
            TableRelation = "No. Series";
        }
        field(69; "Use Formation Component"; Boolean)
        {
            Caption = 'Use Formation Component';
        }
        field(70; "Placement Reser. Service Cod."; Code[20])
        {
            Caption = 'Placement Reser. Service Cod.';
            TableRelation = "Services ET"."No.";
        }
        field(80; "Daily Equity Absences"; Integer)
        {
            Caption = 'Daily Equity Absences';
            Description = 'Qts tempos de falta correspondem a 1 dia de falta de um professor';

            trigger OnValidate()
            var
                l_rTeacher: Record Teacher;
            begin

                if "Daily Equity Absences" <> xRec."Daily Equity Absences" then
                    if Confirm(Text0001) then begin
                        l_rTeacher.Reset;
                        l_rTeacher.ModifyAll(l_rTeacher."Daily Equity Absences", "Daily Equity Absences");
                    end;
            end;
        }
        field(81; "Use Student Disc. Group"; Boolean)
        {
            Caption = 'Use Student Discount Group';
            Description = 'Por defeito usa os descontos da entidade pag. Se este campo estiver assinalado usa sempre os desc. do Aluno';
        }
        field(82; "Send E-Mail Reminder"; Boolean)
        {
            Caption = 'Send E-Mail Reminder';
            Description = 'Não é usado em Multi-Company';

            trigger OnValidate()
            begin
                if "Send E-Mail Reminder" then begin
                    "Send E-Mail Invoice" := true;
                end;
            end;
        }
        field(83; "Send E-Mail Invoice"; Boolean)
        {
            Caption = 'Send E-Mail Invoice';
            Description = 'Não é usado em Multi-Company';

            trigger OnValidate()
            begin
                if "Send E-Mail Reminder" then begin
                    "Send E-Mail Invoice" := true;
                end;
            end;
        }
        field(84; "Send E-Mail Receipt"; Boolean)
        {
            Caption = 'Send E-Mail Receipt';
            Description = 'Não é usado em Multi-Company';
        }
        field(50000; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            Description = 'IT001';
            TableRelation = Language;
        }
        field(73100; "Domain 1"; Text[30])
        {
            Caption = 'Domain 1';
        }
        field(73101; "Domain 2"; Text[30])
        {
            Caption = 'Domain 2';
        }
        field(73102; "Domain 3"; Text[30])
        {
            Caption = 'Domain 3';
        }
        field(73103; "Domain 4"; Text[30])
        {
            Caption = 'Domain 4';
        }
        field(73104; "Domain 5"; Text[30])
        {
            Caption = 'Domain 5';
        }
        field(73105; "Aspects Max"; Integer)
        {
            Caption = 'Aspects Max';
        }
        field(73106; "Assessing Max"; Integer)
        {
            Caption = 'Assessing Max';
        }
        field(73107; "Rounding Aspects"; Integer)
        {
            Caption = 'Rounding Aspects';
        }
        field(73108; "Rounding Partial"; Integer)
        {
            Caption = 'Rounding Partial';
        }
        field(73112; "Student Photos"; Text[100])
        {
            Caption = 'Student Photos';
        }
        field(73113; "Candidate Photos"; Text[100])
        {
            Caption = 'Candidate Photos';
        }
        field(73114; "Teacher Photos"; Text[100])
        {
            Caption = 'Teacher Photos';
        }
        field(73115; "Users Family Photos"; Text[100])
        {
            Caption = 'Users Family Photos';
        }
        field(73116; "Order Class"; Option)
        {
            Caption = 'Order Class';
            OptionCaption = 'Name,Last Name,Last Name 2,Last Name+Last Name2+Name';
            OptionMembers = Name,"Last Name","Last Name 2","Last Name+Last Name2+Name";
        }
        field(73117; "Character not subscribed"; Text[5])
        {
            Caption = 'Character not subscribed';
        }
        field(73118; "No evaluation aspects"; Text[2])
        {
            Caption = 'No evaluation aspects';
        }
        field(73119; "Full Name syntax"; Option)
        {
            Caption = 'Full Name syntax';
            OptionCaption = 'Last name + Name,Name + Last name';
            OptionMembers = "Last Name + Name","Name + Last Name";
        }
        field(75500; "VERI Export Path"; Text[100])
        {
            Caption = 'VERI Export Path';
        }
        field(75501; "School Calendar"; Code[20])
        {
            Caption = 'School Calendar';
            TableRelation = "Base Calendar ChangeEDU"."Base Calendar Code" WHERE(Type = FILTER(Header));
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        rIncidenceType: Record "Incidence Type";
        rSchoolYear: Record "School Year";
        cMasterTableWEB: Codeunit InsertNAVMasterTable;
        Text0001: Label 'Replace this value in all forms of Teachers?';
        Text0002: Label 'Completed process.';


    procedure UpdateInvoiceData()
    var
        l_Students: Record Students;
        l_UsersFamily: Record "Users Family";
        l_Candidates: Record Candidate;
        IsModify: Boolean;
    begin
        l_Students.Reset;
        if l_Students.FindSet(true, true) then
            repeat
                IsModify := false;
                if (l_Students."Payment Terms Code" = '') and ("Payment Terms Code" <> '') then begin
                    l_Students."Payment Terms Code" := "Payment Terms Code";
                    IsModify := true;
                end;
                if (l_Students."Payment Method Code" = '') and ("Payment Method Code" <> '') then begin
                    l_Students."Payment Method Code" := "Payment Method Code";
                    IsModify := true;
                end;
                if (l_Students."Customer Disc. Group" = '') and ("Customer Disc. Group" <> '') then begin
                    l_Students."Customer Disc. Group" := "Customer Disc. Group";
                    IsModify := true;
                end;
                if (l_Students."Allow Line Disc." = false) and ("Allow Line Disc." = false) then begin
                    l_Students."Allow Line Disc." := "Allow Line Disc.";
                    IsModify := true;
                end;
                if (l_Students."Customer Posting Group" = '') and ("Customer Posting Group" <> '') then begin
                    l_Students."Customer Posting Group" := "Customer Posting Group";
                    IsModify := true;
                end;
                if (l_Students."Gen. Bus. Posting Group" = '') and ("Gen. Bus. Posting Group" <> '') then begin
                    l_Students."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                    IsModify := true;
                end;
                if (l_Students."VAT Bus. Posting Group" = '') and ("VAT Bus. Posting Group" <> '') then begin
                    l_Students."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                    IsModify := true;
                end;

                if IsModify then
                    l_Students.Modify(true);

            until l_Students.Next = 0;

        l_UsersFamily.Reset;
        if l_UsersFamily.FindSet(true, true) then
            repeat
                IsModify := false;
                if (l_UsersFamily."Payment Terms Code" = '') and ("Payment Terms Code" <> '') then begin
                    l_UsersFamily."Payment Terms Code" := "Payment Terms Code";
                    IsModify := true;
                end;
                if (l_UsersFamily."Payment Method Code" = '') and ("Payment Method Code" <> '') then begin
                    l_UsersFamily."Payment Method Code" := "Payment Method Code";
                    IsModify := true;
                end;
                if (l_UsersFamily."Customer Disc. Group" = '') and ("Customer Disc. Group" <> '') then begin
                    l_UsersFamily."Customer Disc. Group" := "Customer Disc. Group";
                    IsModify := true;
                end;
                if (l_UsersFamily."Allow Line Disc." = false) and ("Allow Line Disc." <> false) then begin
                    l_UsersFamily."Allow Line Disc." := "Allow Line Disc.";
                    IsModify := true;
                end;
                if (l_UsersFamily."Customer Posting Group" = '') and ("Customer Posting Group" <> '') then begin
                    l_UsersFamily."Customer Posting Group" := "Customer Posting Group";
                    IsModify := true;
                end;
                if (l_UsersFamily."Gen. Bus. Posting Group" = '') and ("Gen. Bus. Posting Group" <> '') then begin
                    l_UsersFamily."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                    IsModify := true;
                end;
                if (l_UsersFamily."VAT Bus. Posting Group" = '') and ("VAT Bus. Posting Group" <> '') then begin
                    l_UsersFamily."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                    IsModify := true;
                end;

                if IsModify then
                    l_UsersFamily.Modify(true);

            until l_UsersFamily.Next = 0;

        l_Candidates.Reset;
        if l_Candidates.FindSet(true, true) then
            repeat
                IsModify := false;
                if (l_Candidates."Payment Terms Code" = '') and ("Payment Terms Code" <> '') then begin
                    l_Candidates."Payment Terms Code" := "Payment Terms Code";
                    IsModify := true;
                end;
                if (l_Candidates."Payment Method Code" = '') and ("Payment Method Code" <> '') then begin
                    l_Candidates."Payment Method Code" := "Payment Method Code";
                    IsModify := true;
                end;
                if (l_Candidates."Customer Disc. Group" = '') and ("Customer Disc. Group" <> '') then begin
                    l_Candidates."Customer Disc. Group" := "Customer Disc. Group";
                    IsModify := true;
                end;
                if (l_Candidates."Allow Line Disc." = false) and ("Allow Line Disc." = false) then begin
                    l_Candidates."Allow Line Disc." := "Allow Line Disc.";
                    IsModify := true;
                end;
                if (l_Candidates."Customer Posting Group" = '') and ("Customer Posting Group" <> '') then begin
                    l_Candidates."Customer Posting Group" := "Customer Posting Group";
                    IsModify := true;
                end;
                if (l_Candidates."Gen. Bus. Posting Group" = '') and ("Gen. Bus. Posting Group" <> '') then begin
                    l_Candidates."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                    IsModify := true;
                end;
                if (l_Candidates."VAT Bus. Posting Group" = '') and ("VAT Bus. Posting Group" <> '') then begin
                    l_Candidates."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                    IsModify := true;
                end;

                if IsModify then
                    l_Candidates.Modify(true);

            until l_Candidates.Next = 0;

        Message(Text0002);
    end;
}

