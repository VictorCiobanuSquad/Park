codeunit 50001 "Transferencias Armazens"
{
    /*
    BC_UPG SQD RTV 20220816
        Updated dimension logic, just copy Dimension Set ID from one table to the other
    */
    var
        TransHeader: Record "Transfer Header";
        TransLines: Record "Transfer Line";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        Location: Record Location;
        SalesLine: Record "Sales Line";
        Localizacao: Code[20];
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Text0001: Label 'Não pode registar Notas de Crédito com produtos de localização diferentes.';

    procedure CriarOrdemTransf(pSalesHeader: Record "Sales Header")
    begin
        //2016.10.17
        //Quando existem devoluções/trocas de produtos já faturados elas colocam uma nova linha com QTD a negativo
        //Isto faz com que a Ordem de transferencia destas linhas seja ao contrario, ou seja, do armazem em questão para o geral.
        //Então separou-se a Criação das ordens de transferencia das encomendas, em 2 partes: 
        //     - Linhas de produtos com qtd a enviar possitiva
        //     - Linhas de produtos com qtd a enviar negativa


        //Verifica se existem linhas a positivo
        //-----------------------------------
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        SalesLine.SETFILTER(SalesLine."Qty. to Ship", '>%1', 0);
        IF SalesLine.FINDFIRST THEN
            CriarOrdemTransfLinhasPositiva(pSalesHeader);


        /*Funcionalidade comentada a pedido do cliente
        //Verifica se existem linhas a negativo
        //-----------------------------------
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        SalesLine.SETFILTER(SalesLine."Qty. to Ship",'<%1',0);
        IF SalesLine.FINDFIRST THEN
        CriarOrdemTransfLinhasNegativa(pSalesHeader);
        */
    end;

    procedure CriarOrdemTransfNotaCred(pSalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        //Esta função é chamada pelo report 50059 e permite criar automaticamente ordens de transferencia
        //para as notas de crédito indicadas


        //Criar o cabeçalho da Transferência
        //-----------------------------------

        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE(SalesCrMemoLine."Document No.", pSalesCrMemoHeader."No.");
        SalesCrMemoLine.SETFILTER(SalesCrMemoLine."Location Code", '<>%1', '');
        IF SalesCrMemoLine.FINDFIRST THEN
            Localizacao := SalesCrMemoLine."Location Code";

        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE(SalesCrMemoLine."Document No.", pSalesCrMemoHeader."No.");
        SalesCrMemoLine.SETFILTER(SalesCrMemoLine."Location Code", '<>%1&<>%2', Localizacao, '');
        IF SalesCrMemoLine.FINDFIRST THEN
            ERROR(Text0001);

        TransHeader.INIT;
        TransHeader.INSERT(TRUE);
        TransHeader.VALIDATE(TransHeader."Transfer-from Code", Localizacao);
        Location.RESET;
        Location.SETRANGE(Location."Armazem Geral", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader.VALIDATE(TransHeader."Transfer-to Code", Location.Code);
        TransHeader."Posting Date" := pSalesCrMemoHeader."Posting Date";
        TransHeader.VALIDATE(TransHeader."Shipment Date", pSalesCrMemoHeader."Posting Date");
        TransHeader.VALIDATE(TransHeader."Receipt Date", pSalesCrMemoHeader."Posting Date");
        TransHeader."PTSS Shipment Start Time" := 235900T;
        Location.RESET;
        Location.SETRANGE(Location."Use As In-Transit", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader."In-Transit Code" := Location.Code;
        TransHeader."No. Encomenda Venda" := pSalesCrMemoHeader."No.";
        TransHeader.MODIFY;

        //Criar as linhas da transferencia
        //-----------------------------------
        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE(SalesCrMemoLine."Document No.", pSalesCrMemoHeader."No.");
        SalesCrMemoLine.SETFILTER(SalesCrMemoLine.Quantity, '<>%1', 0);
        IF SalesCrMemoLine.FINDSET THEN BEGIN
            REPEAT
                TransLines.INIT;
                TransLines."Document No." := TransHeader."No.";
                TransLines."Line No." := SalesCrMemoLine."Line No.";
                TransLines.VALIDATE(TransLines."Item No.", SalesCrMemoLine."No.");
                TransLines.VALIDATE(TransLines.Quantity, SalesCrMemoLine.Quantity);
                TransLines.VALIDATE(TransLines."Variant Code", SalesCrMemoLine."Variant Code");
                TransLines.INSERT(TRUE);
            UNTIL SalesCrMemoLine.NEXT = 0;
        END;


        TransferPostShipment.RUN(TransHeader);
        //COMMIT;
        TransferPostReceipt.RUN(TransHeader);
    end;

    procedure CriarOrdemTransfLinhasPositiva(pSalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        //Esta função é chamada no form das encomendas
        //antes de fazer o envio da encomenda, o utilizador deve seleccionar a opção transferencia de aramazem que faz correr esta rotina
        //Valida se a ordem de transferencia já existe e se existir apaga-a
        TransHeader.RESET;
        TransHeader.SETRANGE(TransHeader."No. Encomenda Venda", pSalesHeader."No.");
        IF TransHeader.FINDFIRST THEN
            TransHeader.DELETE(TRUE);



        //Criar o cabeçalho da Transferência
        //-----------------------------------

        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        IF SalesLine.FINDFIRST THEN
            Localizacao := SalesLine."Location Code";

        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        SalesLine.SETFILTER(SalesLine."Location Code", '<>%1', Localizacao);
        IF SalesLine.FINDFIRST THEN
            ERROR(Text0001);

        TransHeader.INIT;
        TransHeader.INSERT(TRUE);
        Location.RESET;
        Location.SETRANGE(Location."Armazem Geral", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader.VALIDATE(TransHeader."Transfer-from Code", Location.Code);
        TransHeader.VALIDATE(TransHeader."Transfer-to Code", Localizacao);
        TransHeader."Posting Date" := pSalesHeader."Posting Date";
        TransHeader.VALIDATE(TransHeader."Shipment Date", pSalesHeader."Shipment Date");
        TransHeader.VALIDATE(TransHeader."Receipt Date", pSalesHeader."Shipment Date");
        TransHeader."PTSS Shipment Start Time" := pSalesHeader."PTSS Shipment Start Time";
        Location.RESET;
        Location.SETRANGE(Location."Use As In-Transit", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader."In-Transit Code" := Location.Code;
        TransHeader."No. Encomenda Venda" := pSalesHeader."No.";
        TransHeader.MODIFY;

        //Criar as linhas da transferencia
        //-----------------------------------
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        SalesLine.SETFILTER(SalesLine."Qty. to Ship", '>%1', 0);
        IF SalesLine.FINDSET THEN BEGIN
            REPEAT
                TransLines.INIT;
                TransLines."Document No." := TransHeader."No.";
                TransLines."Line No." := SalesLine."Line No.";
                TransLines.VALIDATE(TransLines."Item No.", SalesLine."No.");
                TransLines.VALIDATE(TransLines.Quantity, SalesLine."Qty. to Ship");
                TransLines.VALIDATE(TransLines."Variant Code", SalesLine."Variant Code");
                TransLines.Validate("Dimension Set ID", SalesLine."Dimension Set ID");      //BC_UPG SQD RTV 20220816
                TransLines.INSERT(TRUE);

                /*//Criar as Dimensões
                DocDim.RESET;
                DocDim.SETRANGE(DocDim."Table ID", 37);
                DocDim.SETRANGE(DocDim."Document Type", DocDim."Document Type"::Order);
                DocDim.SETRANGE(DocDim."Document No.", pSalesHeader."No.");
                DocDim.SETRANGE(DocDim."Line No.", SalesLine."Line No.");
                IF DocDim.FINDSET THEN BEGIN
                    REPEAT
                        DocDimNovo.INIT;
                        DocDimNovo."Table ID" := 5741;
                        DocDimNovo."Document Type" := 6;
                        DocDimNovo."Document No." := TransHeader."No.";
                        DocDimNovo."Line No." := DocDim."Line No.";
                        DocDimNovo."Dimension Code" := DocDim."Dimension Code";
                        DocDimNovo."Dimension Value Code" := DocDim."Dimension Value Code";
                        DocDimNovo.INSERT;
                    UNTIL DocDim.NEXT = 0;
                END;*/

                TempSalesLine.INIT;
                TempSalesLine.TRANSFERFIELDS(SalesLine);
                TempSalesLine."Qtd. Transferida" := SalesLine."Qty. to Ship";
                TempSalesLine.INSERT;

            UNTIL SalesLine.NEXT = 0;
        END;


        TransferPostShipment.RUN(TransHeader);
        //COMMIT;
        TransferPostReceipt.RUN(TransHeader);

        //Atualizar a qtd. transferida
        TempSalesLine.RESET;
        IF TempSalesLine.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
                SalesLine.SETRANGE(SalesLine."Line No.", TempSalesLine."Line No.");
                IF SalesLine.FINDFIRST THEN BEGIN
                    SalesLine."Qtd. Transferida" := SalesLine."Qtd. Transferida" + TempSalesLine."Qtd. Transferida";
                    SalesLine.MODIFY;
                END;
            UNTIL TempSalesLine.NEXT = 0;
        END;
    end;

    procedure CriarOrdemTransfLinhasNegativa(pSalesHeader: Record "Sales Header")
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        //Esta função é chamada no form das encomendas
        //antes de fazer o envio da encomenda, o utilizador deve seleccionar a opção transferencia de aramazem que faz correr esta rotina
        //Valida se a ordem de transferencia já existe e se existir apaga-a
        TransHeader.RESET;
        TransHeader.SETRANGE(TransHeader."No. Encomenda Venda", pSalesHeader."No.");
        IF TransHeader.FINDFIRST THEN
            TransHeader.DELETE(TRUE);



        //Criar o cabeçalho da Transferência
        //-----------------------------------

        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        IF SalesLine.FINDFIRST THEN
            Localizacao := SalesLine."Location Code";

        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        SalesLine.SETFILTER(SalesLine."Location Code", '<>%1', Localizacao);
        IF SalesLine.FINDFIRST THEN
            ERROR(Text0001);

        TransHeader.INIT;
        TransHeader.INSERT(TRUE);
        Location.RESET;
        Location.SETRANGE(Location."Armazem Geral", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader.VALIDATE(TransHeader."Transfer-to Code", Location.Code);
        TransHeader.VALIDATE(TransHeader."Transfer-from Code", Localizacao);
        TransHeader."Posting Date" := pSalesHeader."Posting Date";
        TransHeader.VALIDATE(TransHeader."Shipment Date", pSalesHeader."Shipment Date");
        TransHeader.VALIDATE(TransHeader."Receipt Date", pSalesHeader."Shipment Date");
        TransHeader."PTSS Shipment Start Time" := pSalesHeader."PTSS Shipment Start Time";
        Location.RESET;
        Location.SETRANGE(Location."Use As In-Transit", TRUE);
        IF Location.FINDFIRST THEN
            TransHeader."In-Transit Code" := Location.Code;
        TransHeader."No. Encomenda Venda" := pSalesHeader."No.";
        TransHeader.MODIFY;

        //Criar as linhas da transferencia
        //-----------------------------------
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
        SalesLine.SETFILTER(SalesLine."Qty. to Ship", '<%1', 0);
        IF SalesLine.FINDSET THEN BEGIN
            REPEAT
                TransLines.INIT;
                TransLines."Document No." := TransHeader."No.";
                TransLines."Line No." := SalesLine."Line No.";
                TransLines.VALIDATE(TransLines."Item No.", SalesLine."No.");
                TransLines.VALIDATE(TransLines.Quantity, ABS(SalesLine."Qty. to Ship"));
                TransLines.VALIDATE(TransLines."Variant Code", SalesLine."Variant Code");
                TransLines.Validate("Dimension Set ID", SalesLine."Dimension Set ID");      //BC_UPG SQD RTV 20220816
                TransLines.INSERT(TRUE);

                /*//Criar as Dimensões
                DocDim.RESET;
                DocDim.SETRANGE(DocDim."Table ID", 37);
                DocDim.SETRANGE(DocDim."Document Type", DocDim."Document Type"::Order);
                DocDim.SETRANGE(DocDim."Document No.", pSalesHeader."No.");
                DocDim.SETRANGE(DocDim."Line No.", SalesLine."Line No.");
                IF DocDim.FINDSET THEN BEGIN
                    REPEAT
                        DocDimNovo.INIT;
                        DocDimNovo."Table ID" := 5741;
                        DocDimNovo."Document Type" := 6;
                        DocDimNovo."Document No." := TransHeader."No.";
                        DocDimNovo."Line No." := DocDim."Line No.";
                        DocDimNovo."Dimension Code" := DocDim."Dimension Code";
                        DocDimNovo."Dimension Value Code" := DocDim."Dimension Value Code";
                        DocDimNovo.INSERT;
                    UNTIL DocDim.NEXT = 0;
                END;*/


                TempSalesLine.INIT;
                TempSalesLine.TRANSFERFIELDS(SalesLine);
                TempSalesLine."Qtd. Transferida" := SalesLine."Qty. to Ship";
                TempSalesLine.INSERT;

            UNTIL SalesLine.NEXT = 0;
        END;


        TransferPostShipment.RUN(TransHeader);
        //COMMIT;
        TransferPostReceipt.RUN(TransHeader);

        //Atualizar a qtd. transferida
        TempSalesLine.RESET;
        IF TempSalesLine.FINDSET THEN BEGIN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE(SalesLine."Document Type", SalesLine."Document Type"::Order);
                SalesLine.SETRANGE(SalesLine."Document No.", pSalesHeader."No.");
                SalesLine.SETRANGE(SalesLine."Line No.", TempSalesLine."Line No.");
                IF SalesLine.FINDFIRST THEN BEGIN
                    SalesLine."Qtd. Transferida" := SalesLine."Qtd. Transferida" + TempSalesLine."Qtd. Transferida";
                    SalesLine.MODIFY;
                END;
            UNTIL TempSalesLine.NEXT = 0;
        END;
    end;
}