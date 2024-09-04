xmlport 50047 "Export JDE Int. G/L Entries"
{
    /*
    init 20210805
    */
    Caption = 'Export JDE Int. G/L Entries';
    Direction = Export;
    Format = VariableText;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(NodeName1)
        {
            tableelement(Integer; Integer)
            {
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));

                textelement(ObjectAccount) { }
                textelement(Value) { }
                textelement(Date) { }
                textelement(ExplanationRemark) { }

                trigger OnAfterGetRecord()
                begin
                    Date := DateMsg;
                    ExplanationRemark := ExplanationRemarkMsg;
                    Value := ValueMsg;
                    ObjectAccount := ObjectAccountMsg;
                end;
            }
            tableelement(GLEntry; "G/L Entry")
            {
                SourceTableView = SORTING("Entry No.") WHERE("JDE Integrated" = CONST("Not Integrated"));

                textelement(accno) { }
                textelement(lamount) { }
                fieldelement(PostDate; GLEntry."Posting Date") { }
                fieldelement(DocNo; GLEntry."Document No.") { }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(Dim);
                    CLEAR(DimValue);
                    lamount := FORMAT(GLEntry.Amount, 0, '<Sign><Integer><Decimals,3><Comma,.>');
                    //BC_UPG START SQD RTV 20220906
                    //IF Dim.GET(DATABASE::"G/L Entry", GLEntry."Entry No.", 'SEGMENTOS') THEN
                    IF Dim.GET(GLEntry."Dimension Set ID", 'SEGMENTOS') THEN
                        //BC_UPG STOP SQD RTV 20220906
                        DimValue.GET('SEGMENTOS', Dim."Dimension Value Code");
                    accno := CompanyInfo."JDE Entity Number" + DimValue."JDE Code";
                    CLEAR(DimValue);
                    //BC_UPG START SQD RTV 20220906
                    //IF Dim.GET(DATABASE::"G/L Entry", GLEntry."Entry No.", 'PARK') THEN
                    IF Dim.GET(GLEntry."Dimension Set ID", 'PARK') THEN
                        //BC_UPG STOP SQD RTV 20220906
                        DimValue.GET('PARK', Dim."Dimension Value Code");
                    accno += DimValue."JDE Code" + '.';
                    CLEAR(DimValue);
                    //BC_UPG START SQD RTV 20220906
                    //IF Dim.GET(DATABASE::"G/L Entry", GLEntry."Entry No.", 'PROFITCENTER') THEN
                    IF Dim.GET(GLEntry."Dimension Set ID", 'PROFITCENTER') THEN
                        //BC_UPG STOP SQD RTV 20220906
                        DimValue.GET('PROFITCENTER', Dim."Dimension Value Code");
                    accno += DimValue."JDE Code";


                    CLEAR(Log);
                    Log.INIT;
                    Log.Type := Log.Type::"G/L Entry";
                    Log."G/L Entry No." := GLEntry."Entry No.";
                    Log."Document No." := GLEntry."Document No.";

                    Log.Filename := FileNameTxt;
                    Log."Integration Time" := CREATEDATETIME(TODAY, TIME);
                    Log.INSERT;
                    GLEntry.VALIDATE("JDE Integrated", GLEntry."JDE Integrated"::Integrated);
                    GLEntry.MODIFY(FALSE);
                end;
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        Log: Record "JDE Integration Log";
        Setup: Record "General Ledger Setup";
        IntNo: Text[2];
        Dim: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        FileNameTxt: Text[30];
        ObjectAccountMsg: Label 'Object Account';
        ValueMsg: Label 'Value';
        DateMsg: Label 'Date';
        ExplanationRemarkMsg: Label 'Explanation/Remark';

    trigger OnPreXmlPort()
    begin
        CompanyInfo.GET;
        Setup.GET;
        IF Setup."Last G/L Integration Date" <> TODAY THEN BEGIN
            Setup.VALIDATE("Last G/L Integration Date", TODAY);
            IntNo := '01';
        END ELSE
            IntNo := INCSTR(Setup."Last G/L Integration No.");
        Setup.VALIDATE("Last G/L Integration No.", IntNo);
        Setup.MODIFY;
        Setup.TESTFIELD("JDE File Path");

        FileNameTxt := CompanyInfo."JDE Entity Number" +
                                 FORMAT(TODAY, 0, '<Day,2><Month,2><Year,2>') + IntNo + '.csv';

        currXMLport.FILENAME := Setup."JDE File Path" + FileNameTxt;
    end;
}