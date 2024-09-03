report 52808 "Pre invoice Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PreinvoiceDetail.rdlc';
    Caption = 'Pre invoice Detail';

    dataset
    {
        dataitem("Student Ledger Entry"; "Student Ledger Entry")
        {
            DataItemTableView = SORTING("Schooling Year", Class, "Student No.", "Entity ID") WHERE("Registed Invoice No." = FILTER(''));
            RequestFilterFields = "Posting Date", Class, "Student No.", Kinship, "Entity ID", "Schooling Year";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(USERID; UserId)
            {
            }
            column(Filters; Filters)
            {
            }
            column(rStructureEducationCountry__Education_Level_; rStructureEducationCountry."Education Level")
            {
            }
            column(Class____________rClass_Description; Class + ' -  ' + rClass.Description)
            {
            }
            column(Student_No_____________StudentName; "Student No." + ' - ' + StudentName)
            {
            }
            column(Entity_ID____________EntityName; "Entity ID" + ' - ' + EntityName)
            {
            }
            column(Student_Ledger_Entry__Service_Code_; "Service Code")
            {
            }
            column(Student_Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(Student_Ledger_Entry_Description; Description)
            {
            }
            column(Student_Ledger_Entry_Quantity; Quantity)
            {
            }
            column(Student_Ledger_Entry__Percent___; "Percent %")
            {
            }
            column(Student_Ledger_Entry_Amount; Amount)
            {
            }
            column(Student_Ledger_Entry__Line_Discount___; "Line Discount %")
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount_; "Line Discount Amount")
            {
            }
            column(Student_Ledger_Entry__Unit_Price_; "Unit Price")
            {
            }
            column(Line_Discount_Amount____Amount; "Line Discount Amount" + Amount)
            {
            }
            column(TotalFor___EntityName; TotalFor + EntityName)
            {
            }
            column(Student_Ledger_Entry_Amount_Control1102065056; Amount)
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount__Control1102065057; "Line Discount Amount")
            {
            }
            column(Amount___InvoiceAmountDisc; Amount - InvoiceAmountDisc)
            {
            }
            column(TotalFor___EntityName_Control1102065031; TotalFor + EntityName)
            {
            }
            column(InvoiceAmountDisc; InvoiceAmountDisc)
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount__Control1102065037; "Line Discount Amount")
            {
            }
            column(TextDiscount; TextDiscount)
            {
            }
            column(TotalFor___StudentName; TotalFor + StudentName)
            {
            }
            column(Student_Ledger_Entry_Amount_Control1102065059; Amount)
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount__Control1102065060; "Line Discount Amount")
            {
            }
            column(TotalFor_________Class_________rClass_Description; TotalFor + ' ' + Class + ' ' + rClass.Description)
            {
            }
            column(Student_Ledger_Entry_Amount_Control1102065062; Amount)
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount__Control1102065063; "Line Discount Amount")
            {
            }
            column(TotalFor___rStructureEducationCountry__Education_Level_; TotalFor + rStructureEducationCountry."Education Level")
            {
            }
            column(Student_Ledger_Entry_Amount_Control1102065065; Amount)
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount__Control1102065066; "Line Discount Amount")
            {
            }
            column(FinalTotal; FinalTotal)
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount__Control1102065026; "Line Discount Amount")
            {
            }
            column(Student_Ledger_Entry_Amount_Control1102065027; Amount)
            {
            }
            column(Pre_Billing_ValidationCaption; Pre_Billing_ValidationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Filters_Caption; Filters_CaptionLbl)
            {
            }
            column(Student_Ledger_Entry__Service_Code_Caption; FieldCaption("Service Code"))
            {
            }
            column(Student_Ledger_Entry__Posting_Date_Caption; FieldCaption("Posting Date"))
            {
            }
            column(Student_Ledger_Entry_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Student_Ledger_Entry_QuantityCaption; FieldCaption(Quantity))
            {
            }
            column(Student_Ledger_Entry__Percent___Caption; Student_Ledger_Entry__Percent___CaptionLbl)
            {
            }
            column(Student_Ledger_Entry_AmountCaption; Student_Ledger_Entry_AmountCaptionLbl)
            {
            }
            column(Student_Ledger_Entry__Line_Discount___Caption; FieldCaption("Line Discount %"))
            {
            }
            column(Student_Ledger_Entry__Line_Discount_Amount_Caption; FieldCaption("Line Discount Amount"))
            {
            }
            column(Student_Ledger_Entry__Unit_Price_Caption; Student_Ledger_Entry__Unit_Price_CaptionLbl)
            {
            }
            column(Line_Discount_Amount____AmountCaption; Line_Discount_Amount____AmountCaptionLbl)
            {
            }
            column(ClasseCaption; ClasseCaptionLbl)
            {
            }
            column("Núm__estudiantCaption"; Núm__estudiantCaptionLbl)
            {
            }
            column(Id__entitatCaption; Id__entitatCaptionLbl)
            {
            }
            column(Student_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            column(Student_Ledger_Entry_Schooling_Year; "Schooling Year")
            {
            }
            column(Student_Ledger_Entry_Class; Class)
            {
            }
            column(Student_Ledger_Entry_Student_No_; "Student No.")
            {
            }
            column(Student_Ledger_Entry_Entity_ID; "Entity ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if rStudent.Get("Student Ledger Entry"."Student No.") then begin
                    StudentName := rStudent.Name;
                end;

                rStructureEducationCountry.Reset;
                rStructureEducationCountry.SetRange("Schooling Year", "Student Ledger Entry"."Schooling Year");
                if rStructureEducationCountry.Find('-') then;

                if rClass.Get(Class, "School Year") then;

                EntityName := '';
                rUsersFamily.Reset;
                rUsersFamily.SetRange("Customer No.", "Student Ledger Entry"."Entity Customer No.");
                if rUsersFamily.Find('-') then begin
                    EntityName := rUsersFamily.Name;
                end;

                if rStudent."Customer No." = "Student Ledger Entry"."Entity Customer No." then begin
                    EntityName := rStudent.Name;
                end;

                if LastCustomer <> "Student Ledger Entry"."Entity Customer No." then begin
                    InvDisc := 0;
                    InvoiceAmount := 0;
                    if rCustomer2.Get("Student Ledger Entry"."Entity Customer No.") and (rCustomer2."Invoice Disc. Code" <> '') then begin
                        rCustInvoiceDisc.Reset;
                        rCustInvoiceDisc.SetRange(Code, rCustomer2."Invoice Disc. Code");
                        if rCustInvoiceDisc.Find('-') then
                            InvDisc := rCustInvoiceDisc."Discount %";
                    end;
                end;

                InvoiceAmount += "Student Ledger Entry".Amount;

                if InvDisc <> 0 then
                    InvoiceAmountDisc := Round(InvoiceAmount * (InvDisc / 100), 0.01);

                TextDiscount := StrSubstNo(TotalForDisc, InvDisc);

                LastCustomer := "Student Ledger Entry"."Entity Customer No.";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Entity ID");

                Filters := GetFilters;

                if GetFilter("Posting Date") = '' then
                    Error(Text0001);

                if cUserEducation.GetEducationFilter(UserId) <> '' then
                    SetRange("Responsibility Center", cUserEducation.GetEducationFilter(UserId));
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: Label 'Total of ';
        EntityName: Text[1024];
        StudentName: Text[1024];
        LastCustomer: Code[20];
        InvDisc: Decimal;
        Filters: Text[1024];
        InvoiceAmountDisc: Decimal;
        InvoiceAmount: Decimal;
        TextDiscount: Text[1024];
        rCustomer: Record Customer;
        rCustomer2: Record Customer;
        rStudent: Record Students;
        rStructureEducationCountry: Record "Structure Education Country";
        rClass: Record Class;
        rUsersFamily: Record "Users Family";
        FinalTotal: Label 'Global Total ';
        rCustInvoiceDisc: Record "Cust. Invoice Disc.";
        TotalForDisc: Label 'Comercial Discount %1 %';
        Text0001: Label 'You must define a date Filter.';
        cUserEducation: Codeunit "User Education";
        Pre_Billing_ValidationCaptionLbl: Label 'Pre Billing Validation';
        CurrReport_PAGENOCaptionLbl: Label 'Página';
        Filters_CaptionLbl: Label 'Filters:';
        Student_Ledger_Entry__Percent___CaptionLbl: Label 'Percent Dist. ';
        Student_Ledger_Entry_AmountCaptionLbl: Label 'Net Amount ';
        Student_Ledger_Entry__Unit_Price_CaptionLbl: Label 'Service Amount';
        Line_Discount_Amount____AmountCaptionLbl: Label 'Dist. Amount';
        ClasseCaptionLbl: Label 'Class';
        "Núm__estudiantCaptionLbl": Label 'Student No.';
        Id__entitatCaptionLbl: Label 'Entity ID';
}

