page 70147 "BAC Run All Objects"
{
    caption = 'Run All Objects';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = AllObjWithCaption;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where("Object Type" = filter(Table | Page | Report | Codeunit | XMLport));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Object Type"; "Object Type")
                {
                    ApplicationArea = All;
                }
                field("Object ID"; "Object ID")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; "Object Name")
                {
                    ApplicationArea = All;
                }
                field("Object Caption"; "Object Caption")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Object Subtype"; "Object Subtype")
                {
                    ApplicationArea = All;
                }
                field("App Package ID"; "App Package ID")
                {
                    ApplicationArea = All;
                }
                field("App Package Name"; GetNavAppName("App Package ID"))
                {
                    Caption = 'App Package Name';
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Run Object")
            {
                Caption = 'Run Object';
                ApplicationArea = All;
                Image = ExecuteBatch;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Scope = "Repeater";
                ShortcutKey = 'Ctrl+F5';

                trigger OnAction();
                begin
                    RunObject();
                end;
            }
        }
    }
    local procedure GetNavAppName(inAppPackageID: Guid): Text
    var
        NavApp: Record "NAV App Installed App";
    begin
        NavApp.SetRange("Package ID", inAppPackageID);
        if NavApp.FindFirst() then
            exit(NavApp.Name);
    end;

    local procedure RunObject()
    begin
        case "Object Type" of
            "Object Type"::Page:
                PAGE.RUN("Object ID");
            "Object Type"::Report:
                REPORT.RUN("Object ID");
            "Object Type"::Codeunit:
                CODEUNIT.RUN("Object ID");
            "Object Type"::XMLport:
                XMLPORT.RUN("Object ID");
            "Object Type"::Table:
                Hyperlink(GetUrl(ClientType::Current, CompanyName, ObjectType::Table, "Object ID"));
            else
                Message('Object type ' + Format("Object Type") + ' ' + "Object Name" + ' cant be run');
        end;
    end;
}