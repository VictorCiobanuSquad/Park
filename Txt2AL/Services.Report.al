report 31009751 Services
{
    DefaultLayout = RDLC;
    RDLCLayout = './Services.rdlc';
    Caption = 'Services';

    dataset
    {
        dataitem("Student Ledger Entry";"Student Ledger Entry")
        {
            DataItemTableView = SORTING("Service Code","Student No.");
            RequestFilterFields = "Student No.",Class;
            column(CINFO_Name;CompanyInfo.Name)
            {
            }
            column(CAddr2;CompanyAddr[2])
            {
            }
            column(CAddr3;CompanyAddr[3])
            {
            }
            column(CINFO_Picture;CompanyInfo.Picture)
            {
            }
            column(CINFO_PhoneNo;CompanyInfo."Phone No.")
            {
            }
            column(Workdate_Formated;Format(WorkDate,0,'<day> de <month text> de <year4>'))
            {
            }
            column(Filtros;Filtros)
            {
            }
            column(StudentNo_SLE;"Student No.")
            {
            }
            column(Class_SLE;Class)
            {
            }
            column(ServiceCode_SLE;"Service Code")
            {
            }
            column(Description_SLE;Description)
            {
            }
            column(ServiceType_SLE;"Service Type")
            {
            }
            column(UnitPrice_SLE;"Unit Price")
            {
            }
            column(Quantity_SLE;Quantity)
            {
            }
            column(PostingDate_SLE;"Posting Date")
            {
            }
            column(LineDiscountPerc_SLE;"Line Discount %")
            {
            }
            column(LineDiscAmount_SLE;"Line Discount Amount")
            {
            }
            column(Amount_SLE;Amount)
            {
            }
            column(TotalFor_Class;TotalFor + FieldCaption(Class))
            {
            }
            column(TotalFor_Student;TotalFor + FieldCaption("Student No."))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Class);
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
        StudentsSF = 'STUDENTS - FIXED SERVICES';
        FiltersCap = 'Filters:';
        StudentNoCap = 'Student No.';
        ClassCap = 'Class';
        ServCode = 'Service Code';
        Description = 'Description';
        ServiceType = 'Service Type';
        PriceExcVat = 'Sales Price Excl. Vat';
        Quantity = 'Quantity';
        DateRegister = 'Date Register';
        LinePDiscount = 'Line Discount %';
        LineDiscountAmt = 'Line Discount Amount';
        Amount = 'Amount';
        Total = 'Total';
        SalesTotal = 'Sales Total';
        DiscountTotal = 'Discount Total';
        GeneralTotal = 'General Total';
        Page = 'Page';
        Phone = 'Phone';
    }

    trigger OnPreReport()
    begin

        if CompanyInfo.Get() then begin
          CompanyInfo.CalcFields(CompanyInfo.Picture);
          FormatAddr.Company(CompanyAddr,CompanyInfo);
        end;

        Filtros := "Student Ledger Entry".GetFilters +  ' ; ';
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array [8] of Text[50];
        Filtros: Text[1024];
        TotalFor: Label 'Total ';
}

