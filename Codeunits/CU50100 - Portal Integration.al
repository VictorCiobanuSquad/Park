codeunit 50100 "Portal Integration"
{
    //SQD-GCUI 03292023 
    //Webservices for Portal
    procedure GetStudent(email: Text): Text
    var
        UsersFamilyStudent: Record "Users Family / Students";
        JArray: JsonArray;
    begin
        if not FindStudents(email, UsersFamilyStudent) then
            exit;
        AddStudentsToJsonArray(UsersFamilyStudent, JArray);
        exit(FormatResponse(JArray));
    end;


    local procedure FindStudents(email: Text; var UsersFamilyStudent: Record "Users Family / Students"): Boolean
    var
        Family: Record "Users Family";
        SchoolYear: Record "School Year";
    begin
        if email <> '' then begin
            SchoolYear.Reset();
            SchoolYear.SetRange(Status, SchoolYear.Status::Active);
            SchoolYear.FindSet();

            Family.Reset();
            Family.SetRange("E-mail", email);
            Family.FindSet();

            UsersFamilyStudent.Reset();
            UsersFamilyStudent.SetRange("No.", Family."No.");
            UsersFamilyStudent.SetRange("School Year", SchoolYear."School Year");
            exit(UsersFamilyStudent.FindSet());
        end;
    end;

    local procedure AddStudentsToJsonArray(var UsersFamilyStudent: Record "Users Family / Students"; JArray: JsonArray)
    var
        JObject: JsonObject;
        Student: Record Students;
    begin
        repeat
            Clear(JObject);
            JObject.Add('No.', UsersFamilyStudent."Student Code No.");
            Student.Reset();
            Student.SetRange("No.", UsersFamilyStudent."Student Code No.");
            Student.FindSet();
            JObject.Add('StuentNo.', Student."No.");
            JObject.Add('Name', Student.Name);
            JObject.Add('CustomerNo.', Student."Customer No.");
            JArray.Add(JObject);
        until UsersFamilyStudent.Next() = 0;
    end;

    procedure GetCustomer(studentNo: Text): Text
    var
        UsersFamilyStudent: Record "Users Family / Students";
        JArray: JsonArray;
    begin
        if not FindCustomer(studentNo, UsersFamilyStudent) then
            exit;
        // Student.Get(studentNo);
        AddCustomerToJsonArray(UsersFamilyStudent, JArray);
        exit(FormatResponse(JArray));
    end;

    local procedure FindCustomer(studentNo: Text; var UsersFamilyStudent: Record "Users Family / Students"): Boolean
    begin
        UsersFamilyStudent.Reset();
        UsersFamilyStudent.SetRange("Student Code No.", studentNo);
        UsersFamilyStudent.SetRange("Paying Entity", true);
        exit(UsersFamilyStudent.FindSet());
    end;



    local procedure AddCustomerToJsonArray(var UsersFamilyStudent: Record "Users Family / Students"; JArray: JsonArray)
    var
        JObject: JsonObject;
        Student: Record Students;
        UsersFamily: record "Users Family";
    begin
        repeat
            Clear(JObject);
            // IF NOT EVALUATE(UsersFamilyStudent.Kinship, 'Himself') THEN
            //     MESSAGE('Type is invalid!');
            if (UsersFamilyStudent.Kinship = UsersFamilyStudent.Kinship::Himself) then begin
                Student.Reset();
                Student.SetRange("No.", UsersFamilyStudent."Student Code No.");
                Student.FindSet();
                JObject.Add('Name', Student.Name);
                JObject.Add('CustomerNo.', Student."Customer No.");
                JArray.Add(JObject);
            end else begin
                // if not Evaluate(UsersFamilyStudent.Kinship, 'Brother in School') then
                //     MESSAGE('Type is invalid!');
                if (UsersFamilyStudent.Kinship = UsersFamilyStudent.Kinship::"Brother in School") then begin
                    Student.Reset();
                    Student.SetRange("No.", UsersFamilyStudent."No.");
                    Student.FindSet();
                    JObject.Add('Name', Student.Name);
                    JObject.Add('CustomerNo.', Student."Customer No.");
                    JArray.Add(JObject);
                end else begin

                    UsersFamily.Reset();
                    UsersFamily.SetRange("No.", UsersFamilyStudent."No.");
                    UsersFamily.FindSet();
                    JObject.Add('Name', UsersFamily.Name);
                    JObject.Add('CustomerNo.', UsersFamily."Customer No.");
                    JArray.Add(JObject);
                end;
            end;
        until UsersFamilyStudent.Next() = 0;
    end;

    procedure GetItemCategories(): Text
    var
        ItemCategory: Record "Item Category";
        JArray: JsonArray;
    begin
        ItemCategory.SetFilter("Has Children", '1');
        AddToJsonArray(ItemCategory, JArray);
        exit(FormatResponse(JArray))
    end;

    procedure GetItemsGroups(number: Text): Text
    var
        ItemCategory: Record "Item Category";
        JArray: JsonArray;
    begin
        if number = '' then
            exit;
        ItemCategory.SetFilter("Parent Category", number);
        AddToJsonArray(ItemCategory, JArray);
        exit(FormatResponse(JArray))
    end;

    local procedure AddToJsonArray(var ItemCategory: Record "Item Category"; JArray: JsonArray)
    var
        JObject: JsonObject;
    begin
        repeat
            Clear(JObject);
            JObject.Add('No', ItemCategory.Code);
            JObject.Add('Description', ItemCategory.Description);
            JObject.Add('DescriptionENG', ItemCategory."Description ENG");
            JArray.Add(JObject);
        until ItemCategory.Next() = 0;
    end;

    procedure GetItemCategories(itemCode: Text; variantCode: Text): Text
    var
        JArray: JsonArray;
        Item: Record Item;
        ItemCategory: Record "Item Category";
        ItemVariant: Record "Item Variant";
    begin
        if not FindItemCategories(itemCode, variantCode, Item) then
            exit;
        //error(Item."Item Category Code");
        AddToJsonArray(itemCode, variantCode, Item, ItemCategory, ItemVariant, JArray);
        exit(FormatResponse(JArray));
    end;

    procedure FindItemCategories(itemCode: Text; variantCode: Text; var RecItem: Record Item): Boolean
    begin
        exit(RecItem.Get(itemCode));
    end;

    local procedure AddToJsonArray(
        itemCode: Text;
        variantCode: Text;
        var Item: Record Item;
        var ItemCategory: Record "Item Category";
        var ItemVariant: Record "Item Variant";
        JArray: JsonArray)
    var
        JObject: JsonObject;
    begin
        Clear(JObject);
        ItemVariant.Get(itemCode, variantCode);
        JObject.Add('ItemNo', ItemVariant."Item No.");
        JObject.Add('ItemVariant', ItemVariant.Description);
        ItemCategory.Get(Item."Item Category Code");

        if ItemCategory."Parent Category" <> '' then begin
            JObject.Add('ItemGroup', ItemCategory.Description);
            ItemCategory.Get(ItemCategory."Parent Category");
            JObject.Add('ItemCategory', ItemCategory.Description);
        end else begin
            JObject.Add('ItemCategory', ItemCategory.Description);
            JObject.Add('ItemGroup', 'No Group assigned');
        end;
        JArray.Add(JObject);
    end;

    procedure GetSalesInvoices(customerNo: Text): Text
    var
        JArray: JsonArray;
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("Sell-to Customer No.", customerNo);
        SalesInvoiceHeader.FindSet();
        AddInvoiceToJsonArray(SalesInvoiceHeader, JArray);
        exit(FormatResponse(JArray));
    end;

    local procedure AddInvoiceToJsonArray(var SalesInvoiceHeader: Record "Sales Invoice Header"; JArray: JsonArray)
    var
        Returned: Boolean;
        ReturnedOrder: Record "Devolucoes Cab";
        JObject: JsonObject;
    begin
        repeat
            Clear(JObject);
            JObject.Add('InvoiceNo', SalesInvoiceHeader."No.");
            JObject.Add('PostingDate', SalesInvoiceHeader."Posting Date");
            JObject.Add('SellToCustomerNo', SalesInvoiceHeader."Sell-to Customer No.");
            JObject.Add('BillToCustomerNo', SalesInvoiceHeader."Bill-to Customer No.");
            JObject.Add('OrderNo', SalesInvoiceHeader."Order No.");
            JObject.Add('OrderDate', SalesInvoiceHeader."Order Date");
            SalesInvoiceHeader.CalcFields(Amount);
            JObject.Add('Amount', SalesInvoiceHeader.Amount);
            SalesInvoiceHeader.CalcFields("Amount Including VAT");
            JObject.Add('AmountIncludingVAT', SalesInvoiceHeader."Amount Including VAT");
            ReturnedOrder.Reset();
            ReturnedOrder.SetRange("Invoice No.", SalesInvoiceHeader."No.");
            if ReturnedOrder.FindSet() then
                Returned := true
            else
                Returned := false;
            JObject.Add('Returned', Returned);
            JArray.Add(JObject);
        until SalesInvoiceHeader.Next() = 0;
    end;

    procedure GetSalesLines(documentType: Text; documentNo: Text): Text
    var
        JArray: JsonArray;
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCreditMemoLine: Record "Sales Cr.Memo Line";
        Item: Record Item;
        ItemCategory: Record "Item Category";
        ItemVariant: Record "Item Variant";
    begin
        if not FindLines(documentType, documentNo, SalesLine, SalesInvoiceLine, SalesCreditMemoLine) then
            exit;
        AddToJsonArray(documentType, SalesLine, SalesInvoiceLine, SalesCreditMemoLine, JArray);
        exit(FormatResponse(JArray));
    end;

    procedure FindLines(documentType: Text; documentNo: Text;
                        var SalesLine: Record "Sales Line";
                        var SalesInvoiceLine: Record "Sales Invoice Line";
                        var SalesCreditMemoLine: Record "Sales Cr.Memo Line"): Boolean
    begin
        case documentType of
            'Order':
                begin
                    IF NOT EVALUATE(SalesLine."Document Type", documentType) THEN
                        MESSAGE('Type is invalid!');
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesLine."Document Type");
                    SalesLine.SetRange("Document No.", documentNo);
                    //SalesLine.SetRange("Sell-to Customer No.", customerNo);
                    IF NOT EVALUATE(SalesLine.Type, 'Item') THEN
                        MESSAGE('Type is invalid!');
                    SalesLine.SetRange("Type", SalesLine.Type);
                    exit(SalesLine.FindSet());
                end;
            'Invoice':
                begin
                    SalesInvoiceLine.Reset();
                    SalesInvoiceLine.SetRange("Document No.", documentNo);
                    IF NOT EVALUATE(SalesInvoiceLine.Type, 'Item') THEN
                        MESSAGE('Type is invalid!');
                    SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type);
                    //SalesInvoiceLine.SetRange("Sell-to Customer No.", customerNo);
                    exit(SalesInvoiceLine.FindSet());
                end;
            'Credit Memo':
                begin
                    SalesCreditMemoLine.Reset();
                    SalesCreditMemoLine.SetRange("Document No.", documentNo);
                    IF NOT EVALUATE(SalesCreditMemoLine.Type, 'Item') THEN
                        MESSAGE('Type is invalid!');
                    SalesCreditMemoLine.SetRange(Type, SalesCreditMemoLine.Type);
                    //SalesCreditMemoLine.SetRange("Sell-to Customer No.", customerNo);
                    exit(SalesCreditMemoLine.FindSet());
                end;
        end;
    end;

    local procedure AddToJsonArray(
        documentType: Text;
        var SalesLine: Record "Sales Line";
        var SalesInvoiceLine: Record "Sales Invoice Line";
        var SalesCreditMemoLine: Record "Sales Cr.Memo Line";
        JArray: JsonArray)
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        ItemVariant: Record "Item Variant";
        ItemTranslation: Record "Item Translation";
        JObject: JsonObject;
    begin

        begin
            case documentType of
                'Order':
                    begin
                        repeat
                            Clear(JObject);
                            Item.Get(SalesLine."No.");
                            JObject.Add('ItemNo.', Item."No.");
                            JObject.Add('ItemDescription', Item.Description);
                            if ItemTranslation.Get(Item."No.", '', 'ENG') then
                                JObject.Add('ItemDescriptionENG', ItemTranslation.Description)
                            else
                                JObject.Add('ItemDescriptionENG', 'No translation');
                            if not ItemVariant.Get(Item."No.", SalesLine."Variant Code") then
                                JObject.Add('ItemVariant', 'No Variant')
                            else begin
                                JObject.Add('ItemVariant', ItemVariant.Description);
                                if ItemTranslation.Get(Item."No.", ItemVariant.Code, 'ENG') then
                                    JObject.Add('ItemVariantENG', ItemTranslation.Description)
                                else
                                    JObject.Add('ItemVariantENG', 'No translation');
                            end;
                            if ItemCategory.Get(Item."Item Category Code") then begin

                                if ItemCategory."Parent Category" <> '' then begin
                                    JObject.Add('ItemGroup', ItemCategory.Description);
                                    JObject.Add('ItemGroupENG', ItemCategory."Description ENG");
                                    ItemCategory.Get(ItemCategory."Parent Category");
                                    JObject.Add('ItemCategory', ItemCategory.Description);
                                    JObject.Add('ItemCategoryENG', ItemCategory."Description ENG");
                                end else begin
                                    JObject.Add('ItemCategory', ItemCategory.Description);
                                    JObject.Add('ItemCategoryENG', ItemCategory."Description ENG");
                                    JObject.Add('ItemGroup', 'No Group assigned')
                                end;
                            end else begin
                                JObject.Add('ItemCategory', 'No Category assigned');
                                JObject.Add('ItemGroup', 'No Group assigned');
                            end;
                            JObject.Add('Quantity', SalesLine.Quantity);
                            JObject.Add('Price', SalesLine."Unit Price");
                            JArray.Add(JObject);
                        until SalesLine.Next() = 0;
                    end;
                'Invoice':
                    begin
                        repeat
                            Clear(JObject);
                            Item.Get(SalesInvoiceLine."No.");
                            JObject.Add('ItemNo.', Item."No.");
                            JObject.Add('ItemDescription', Item.Description);
                            if ItemTranslation.Get(Item."No.", '', 'ENG') then
                                JObject.Add('ItemDescriptionENG', ItemTranslation.Description)
                            else
                                JObject.Add('ItemDescriptionENG', 'No translation');
                            if not ItemVariant.Get(Item."No.", SalesInvoiceLine."Variant Code") then
                                JObject.Add('ItemVariant', 'No Variant')
                            else begin
                                JObject.Add('ItemVariant', ItemVariant.Description);
                                if ItemTranslation.Get(Item."No.", ItemVariant.Code, 'ENG') then
                                    JObject.Add('ItemVariantENG', ItemTranslation.Description)
                                else
                                    JObject.Add('ItemVariantENG', 'No translation');
                            end;
                            if ItemCategory.Get(Item."Item Category Code") then begin

                                if ItemCategory."Parent Category" <> '' then begin
                                    JObject.Add('ItemGroup', ItemCategory.Description);
                                    JObject.Add('ItemGroupENG', ItemCategory."Description ENG");
                                    ItemCategory.Get(ItemCategory."Parent Category");
                                    JObject.Add('ItemCategory', ItemCategory.Description);
                                    JObject.Add('ItemCategoryENG', ItemCategory."Description ENG");

                                end else begin
                                    JObject.Add('ItemCategory', ItemCategory.Description);
                                    JObject.Add('ItemCategoryENG', ItemCategory."Description ENG");
                                    JObject.Add('ItemGroup', 'No Group assigned')
                                end;
                            end else begin
                                JObject.Add('ItemCategory', 'No Category assigned');
                                JObject.Add('ItemGroup', 'No Group assigned');
                            end;
                            JObject.Add('Quantity', SalesInvoiceLine.Quantity);
                            JObject.Add('Price', SalesInvoiceLine."Unit Price");
                            JArray.Add(JObject);
                        until SalesInvoiceLine.Next() = 0;
                    end;
                'Credit Memo':
                    begin
                        repeat
                            Clear(JObject);
                            Item.Get(SalesCreditMemoLine."No.");
                            JObject.Add('ItemNo.', Item."No.");
                            JObject.Add('ItemDescription', Item.Description);
                            if ItemTranslation.Get(Item."No.", '', 'ENG') then
                                JObject.Add('ItemDescriptionENG', ItemTranslation.Description)
                            else
                                JObject.Add('ItemDescriptionENG', 'No translation');
                            if not ItemVariant.Get(Item."No.", SalesCreditMemoLine."Variant Code") then
                                JObject.Add('ItemVariant', 'No Variant')
                            else begin
                                JObject.Add('ItemVariant', ItemVariant.Description);
                                if ItemTranslation.Get(Item."No.", ItemVariant.Code, 'ENG') then
                                    JObject.Add('ItemVariantENG', ItemTranslation.Description)
                                else
                                    JObject.Add('ItemVariantENG', 'No translation');
                            end;
                            if ItemCategory.Get(Item."Item Category Code") then begin

                                if ItemCategory."Parent Category" <> '' then begin
                                    JObject.Add('ItemGroup', ItemCategory.Description);
                                    JObject.Add('ItemGroupENG', ItemCategory."Description ENG");
                                    ItemCategory.Get(ItemCategory."Parent Category");
                                    JObject.Add('ItemCategory', ItemCategory.Description);
                                    JObject.Add('ItemCategoryENG', ItemCategory."Description ENG");

                                end else begin
                                    JObject.Add('ItemCategory', ItemCategory.Description);
                                    JObject.Add('ItemCategoryENG', ItemCategory."Description ENG");

                                    JObject.Add('ItemGroup', 'No Group assigned')
                                end;
                            end else begin
                                JObject.Add('ItemCategory', 'No Category assigned');
                                JObject.Add('ItemGroup', 'No Group assigned');
                            end;
                            JObject.Add('Quantity', SalesCreditMemoLine.Quantity);
                            JObject.Add('Price', SalesCreditMemoLine."Unit Price");
                            JArray.Add(JObject);
                        until SalesCreditMemoLine.Next() = 0;
                    end;
            end;
        end;

    end;

    procedure GetTempSalesOrderLines(orderNo: Integer): Text
    var
        TempSalesLines: Record "Encomendas Linhas";
        JArray: JsonArray;
    begin
        TempSalesLines.Reset();
        TempSalesLines.SetRange("No.", OrderNo);
        TempSalesLines.FindSet();
        AddItemsToJsonArray(TempSalesLines, JArray);
        exit(FormatResponse(JArray));

    end;

    local procedure AddItemsToJsonArray(var TempSalesLines: Record "Encomendas Linhas"; JArray: JsonArray)
    var
        JObject: JsonObject;
        Item: Record Item;
        ItemTranslation: Record "Item Translation";
        ItemVariant: Record "Item Variant";
    begin
        repeat
            Clear(JObject);
            Item.Get(TempSalesLines."Item No.");
            JObject.Add('ItemNo.', Item."No.");
            JObject.Add('ItemDescription', Item.Description);
            if ItemTranslation.Get(Item."No.", '', 'ENG') then
                JObject.Add('ItemDescriptionENG', ItemTranslation.Description)
            else
                JObject.Add('ItemDescriptionENG', 'No translation');
            if not ItemVariant.Get(Item."No.", TempSalesLines."Variant Code") then
                JObject.Add('ItemVariant', 'No Variant')
            else begin
                JObject.Add('ItemVariant', ItemVariant.Description);
                if ItemTranslation.Get(Item."No.", ItemVariant.Code, 'ENG') then
                    JObject.Add('ItemVariantENG', ItemTranslation.Description)
                else
                    JObject.Add('ItemVariantENG', 'No translation');
            end;
            JObject.Add('Quantity', TempSalesLines.Quantity);
            JObject.Add('Price', Item."Unit Price");
            JArray.Add(JObject);
        until TempSalesLines.Next() = 0;
    end;

    procedure UpsertTempSalesOrders(xmlInput: XmlPort UpsertTempOrders) success: Boolean
    begin
        if xmlInput.import() then begin
            success := true;
        end else begin
            Error(GetLastErrorText());
            success := false;
        end;
    end;

    procedure DeleteTempSalesOrders(number: Text) success: Boolean
    var
        TempOrder: Record "Encomendas cab";
    begin
        if number = '' then begin
            success := false;
            exit(success);
        end;
        TempOrder.Get(number);
        TempOrder.Delete(true);
        success := true;
    end;

    procedure CreateReturnOrders(postedInvoiceNo: Text; returnReason: Text;
    created: DateTime; createdby: Text; modified: DateTime; modifiedby: Text) success: Boolean
    var
        ReturnHeader: Record "Devolucoes Cab";
        ReturnLines: Record "Devolucoes Linhas";
        InvoiceHeader: Record "Sales Invoice Header";
        InvoiceLines: Record "Sales Invoice Line";
        Item: Record Item;
    begin
        ReturnHeader.Reset();
        ReturnHeader.SetRange("Invoice No.", postedInvoiceNo);
        if not ReturnHeader.FindSet() then begin
            InvoiceHeader.Get(postedInvoiceNo);
            ReturnHeader.Init();
            ReturnHeader."Sell-to Customer No." := InvoiceHeader."Sell-to Customer No.";
            ReturnHeader."Sell-to Customer Name" := InvoiceHeader."Sell-to Customer Name";
            ReturnHeader.Date := Today;
            ReturnHeader."Invoice No." := InvoiceHeader."No.";
            ReturnHeader.Created := created;
            ReturnHeader."Created by" := createdby;
            ReturnHeader.Modified := modified;
            ReturnHeader."Modified by" := modifiedby;
            ReturnHeader.Insert();

            InvoiceLines.Reset();
            InvoiceLines.SetRange("Document No.", InvoiceHeader."No.");
            InvoiceLines.FindSet();
            repeat
                ReturnLines."Sell-to Customer No." := InvoiceLines."Sell-to Customer No.";
                ReturnLines."Item No." := InvoiceLines."No.";
                if Item.Get(InvoiceLines."No.") then begin
                    ReturnLines."No." := ReturnHeader."No.";
                    ReturnLines."Line No." := InvoiceLines."Line No.";
                    ReturnLines."Item Description" := Item.Description;
                    ReturnLines."Variant Code" := InvoiceLines."Variant Code";
                    ReturnLines.Quantity := InvoiceLines.Quantity;
                    ReturnLines."Sales Invoice Line" := InvoiceLines."Line No.";
                    ReturnLines.Validate("Return Reason Code", returnReason);
                    ReturnLines."Return Reason Code" := returnReason;
                    ReturnLines.Insert(true);
                end;
            until InvoiceLines.Next() = 0;
            success := true;
        end;
    end;

    procedure GetUsersList(userType: Text): Text
    var
        RecPortalUser1: Record "Portal User";
        JArray1: JsonArray;
    begin
        if not FindUserList(userType, RecPortalUser1) then
            exit;
        AddToJsonArray1(UserType, RecPortalUser1, JArray1);
        exit(FormatResponse(JArray1));
    end;

    local procedure FindUserList(userType: Text; var RecPortalUser: Record "Portal User"): Boolean
    begin
        RecPortalUser.Reset();
        IF NOT EVALUATE(RecPortalUser.UserType, userType) THEN
            MESSAGE('Type is invalid!');
        RecPortalUser.SetFilter(UserType, userType);
        exit(RecPortalUser.FindSet());
    end;

    local procedure AddToJsonArray1(userType: Text; var PortalUser: Record "Portal User"; JArray: JsonArray)
    var
        JObject: JsonObject;
        RecUsersFamily: Record "Users Family";
    begin
        repeat
            Clear(JObject);
            JObject.Add('UserId', PortalUser.UserID);
            JObject.Add('UserName', PortalUser.Name);
            JObject.Add('UserEmail', PortalUser.Email);
            JObject.Add('Status', PortalUser.Status);
            if userType = 'Associado' then begin
                RecUsersFamily.Reset();
                RecUsersFamily.SetRange("E-mail", PortalUser.Email.ToLower());
                RecUsersFamily.FindSet();
                JObject.Add('NIF', RecUsersFamily."VAT Registration No.");
            end;
            JArray.Add(JObject);
        until PortalUser.Next() = 0;
    end;

    procedure CreateTempPortalUsers(xmlInput: XmlPort CreatePortalUser) success: Boolean
    begin
        if xmlInput.import() then begin
            success := true;
        end else begin
            Error(GetLastErrorText());
            success := false;
        end;
    end;

    procedure UpdateTempPortalUsers(xmlInput: XmlPort UpdatePortalUser) success: Boolean
    begin
        if xmlInput.import() then begin
            success := true;
        end else begin
            Error(GetLastErrorText());
            success := false;
        end;
    end;

    procedure DeletePortalUser(userId: Text; userTypeText: Text) success: Boolean
    var
        RecPortalUser: Record "Portal User";
    begin
        if (userId = '') then begin
            success := false;
            exit(success);
        end;
        IF NOT EVALUATE(RecPortalUser.UserType, userTypeText) THEN
            MESSAGE('Type is invalid!');
        RecPortalUser.Get(userId, RecPortalUser.UserType);
        RecPortalUser.Delete(true);
        success := true;
    end;

    procedure GetUser(nif: Text): Text
    var
        RecPortalUser: Record "Portal User";
        JArray: JsonArray;
    begin
        if not FindUser(nif, RecPortalUser) then
            exit;
        AddToJsonArray(nif, RecPortalUser, JArray);
        exit(FormatResponse(JArray));

    end;

    local procedure FindUser(nif: Text;
    var RecPortalUser: Record "Portal User"): Boolean
    var
        RecUsersFamily: Record "Users Family";
    begin
        if nif <> '' then begin
            RecUsersFamily.Reset();
            RecUsersFamily.SetRange("VAT Registration No.", nif);
            RecUsersFamily.FindSet();
            RecPortalUser.Reset();
            RecPortalUser.SetFilter(Email, RecUsersFamily."E-mail");
            exit(RecPortalUser.FindSet());
        end;
    end;

    local procedure AddToJsonArray(nif: Text; var PortalUser: Record "Portal User"; JArray: JsonArray)
    var
        JObject: JsonObject;
    begin
        Clear(JObject);
        JObject.Add('NIF', nif);
        JObject.Add('UserId', PortalUser.UserID);
        JObject.Add('UserName', PortalUser.Name);
        JObject.Add('UserEmail', PortalUser.Email);
        JObject.Add('Status', PortalUser.Status);
        JArray.Add(JObject);
    end;

    procedure GetItemAndVariant(itemNo: Text; categoryCode: Text): Text
    var
        Item: Record Item;
        JArray: JsonArray;
    begin
        Item.Reset();
        Item.SetRange(Blocked, false);
        if categoryCode <> '' then
            item.SetRange("Item Category Code", categoryCode);
        if itemNo <> '' then
            Item.SetRange("No.", itemNo);
        Item.FindSet();
        AddItemsToJsonArray(Item, JArray);
        exit(FormatResponse(JArray));
    end;

    local procedure AddItemsToJsonArray(var Item: Record Item; JArray: JsonArray)
    var
        JObject: JsonObject;
        JObject2: JsonObject;
        JArray2: JsonArray;
        ItemTranslation: Record "Item Translation";
        ItemVariant: record "Item Variant";
    begin
        repeat
            Clear(JObject);
            JObject.Add('No.', Item."No.");
            JObject.Add('Description', Item.Description);
            if ItemTranslation.Get(Item."No.", '', 'ENG') then
                JObject.Add('DescriptionENG', ItemTranslation.Description)
            else
                JObject.Add('DescriptionENG', 'No translation');
            JObject.Add('UnitPrice', Item."Unit Price");
            JObject.Add('ItemCategoryCode', Item."Item Category Code");
            ItemVariant.Reset();
            ItemVariant.SetRange("Item No.", Item."No.");
            ItemVariant.FindSet();
            Clear(JArray2);
            repeat
                Clear(JObject2);
                JObject2.Add('VariantNo', ItemVariant.Code);
                JObject2.Add('Description', ItemVariant.Description);
                if ItemTranslation.Get(Item."No.", ItemVariant.Code, 'ENG') then
                    JObject2.Add('DescriptionENG', ItemTranslation.Description);
                JArray2.Add(JObject2);
            until ItemVariant.Next() = 0;
            JObject.Add('ItemVariant', JArray2);
            JArray.Add(JObject);
        until Item.Next() = 0;
    end;

    local procedure FormatResponse(JArray: JsonArray): Text
    var
        JArrayText: Text;
    begin
        JArray.WriteTo(JArrayText);
        exit(JArrayText);
    end;
}