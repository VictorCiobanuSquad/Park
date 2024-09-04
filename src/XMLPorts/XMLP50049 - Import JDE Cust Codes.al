xmlport 50049 "Import JDE Cust Codes"
{
    Caption = 'Import JDE Cust Codes';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(NodeName1)
        {
            tableelement(Integer; Integer)
            {
                textelement(stdcode) { }
                textelement(pupilref) { }
                textelement(custcode) { }
                textelement(payorref) { }

                trigger OnAfterGetRecord()
                begin
                    CASE STRLEN(stdcode) OF
                        1:
                            std := '0000' + stdcode;
                        2:
                            std := '000' + stdcode;
                        3:
                            std := '00' + stdcode;
                        4:
                            std := '0' + stdcode;
                        5:
                            std := stdcode;
                    END;
                    IF Student.GET(std) THEN
                        IF (Student."Customer No." <> '') THEN BEGIN
                            Cust.GET(Student."Customer No.");
                            Cust."JDE Pupil No." := pupilref;
                            Cust.MODIFY(FALSE);
                        END;
                    IF Cust.GET(custcode) THEN BEGIN
                        Cust."JDE Payer No." := payorref;
                        Cust.MODIFY(FALSE);
                    END;
                end;
            }
        }
    }

    var
        Student: Record Students;
        Cust: Record Customer;
        std: Code[20];
}