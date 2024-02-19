pageextension 50131 "Pstd. Sales Shpt. Subform Ext." extends "Posted Sales Shpt. Subform"
{
    /*
    BC_UPG SQD RTV 20220817
        Updated dimension logic, just copy Dimension Set ID from one table to the other

    //IT001 - Parque - 2016.10.10 - Criar a ordem de transf. quando se anula Guias de remessa
    */
    procedure AnularOrdemTransf()
    var
        pSalesShipLine: Record "Sales Shipment Line";
        TransHeader: Record "Transfer Header";
        TransLines: Record "Transfer Line";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        Location: Record Location;
        Localizacao: Code[20];
        SalesLine: Record "Sales Line";
    begin
        //IT001 - Parque - 2016.10.10 - Criar a ordem de transf. quando se anula Guias de remessa
        pSalesShipLine.COPY(Rec);

        //Criar o cabeçalho da Transferência
        //-----------------------------------
        Localizacao := pSalesShipLine."Location Code";

        TransHeader.INIT;
        TransHeader.INSERT(TRUE);
        TransHeader.VALIDATE(TransHeader."Transfer-from Code", Localizacao);
        Location.RESET;
        Location.SETRANGE(Location."Armazem Geral", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader.VALIDATE(TransHeader."Transfer-to Code", Location.Code);
        TransHeader."Posting Date" := pSalesShipLine."Posting Date";
        TransHeader.VALIDATE(TransHeader."Shipment Date", pSalesShipLine."Posting Date");
        TransHeader.VALIDATE(TransHeader."Receipt Date", pSalesShipLine."Posting Date");
        TransHeader."PTSS Shipment Start Time" := 235900T;
        Location.RESET;
        Location.SETRANGE(Location."Use As In-Transit", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader."In-Transit Code" := Location.Code;
        TransHeader.MODIFY;

        //Criar as linhas da transferencia
        //-----------------------------------
        TransLines.INIT;
        TransLines."Document No." := TransHeader."No.";
        TransLines."Line No." := pSalesShipLine."Line No.";
        TransLines.VALIDATE(TransLines."Item No.", pSalesShipLine."No.");
        TransLines.VALIDATE(TransLines.Quantity, pSalesShipLine.Quantity);
        TransLines.VALIDATE(TransLines."Variant Code", pSalesShipLine."Variant Code");
        TransLines.Validate("Dimension Set ID", pSalesShipLine."Dimension Set ID");      //BC_UPG SQD RTV 20220817
        TransLines.INSERT(TRUE);


        /*//Criar as Dimensões
        DocDim.RESET;
        DocDim.SETRANGE(DocDim."Table ID",111);
        DocDim.SETRANGE(DocDim."Document No.",pSalesShipLine."Document No.");
        IF DocDim.FINDSET THEN BEGIN
            REPEAT
                DocDimNovo.INIT;
                DocDimNovo."Table ID" := 5741;
                DocDimNovo."Document Type" := 6;
                DocDimNovo."Document No." :=TransHeader."No.";
                DocDimNovo."Line No." := DocDim."Line No.";
                DocDimNovo."Dimension Code" := DocDim."Dimension Code";
                DocDimNovo."Dimension Value Code" := DocDim."Dimension Value Code";
                DocDimNovo.INSERT;
            UNTIL DocDim.NEXT=0;
        END;*/

        TransferPostShipment.RUN(TransHeader);
        //COMMIT;
        TransferPostReceipt.RUN(TransHeader);


        //Atualizar a qtd. transferida
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesShipLine."Order No.");
        SalesLine.SETRANGE(SalesLine."Line No.", pSalesShipLine."Order Line No.");
        IF SalesLine.FINDSET THEN BEGIN
            REPEAT
                SalesLine."Qtd. Transferida" := SalesLine."Qtd. Transferida" - pSalesShipLine.Quantity;
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;
        END;
    end;
}