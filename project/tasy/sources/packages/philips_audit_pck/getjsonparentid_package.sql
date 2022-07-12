-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_audit_pck.getjsonparentid (parentList text) RETURNS varchar AS $body$
DECLARE

      	EventId 	         varchar(100);
   		posicao 	         bigint;
         parentListIdAux   parentIdList_w%type;
         parentListRet     varchar(20000);
         parentListRecursive  parentListRet%type;
	
BEGIN
        posicao := position(';' in parentList);

        if (posicao > 0) then

            EventId := trim(both substr(parentList, 1, posicao - 1));

            if ((EventId IS NOT NULL AND EventId::text <> '') and length(EventId) > 0) then

               parentListIdAux   := substr(parentList, posicao + 1, length(parentList));

               parentListRet     := '"parentEvent" : {
					   				      "eventID" : "' || EventId || '"';

               if (position(';' in parentListIdAux) > 0) then
                  parentListRecursive  := philips_audit_pck.getjsonparentid(parentListIdAux);
                  if ((parentListRecursive IS NOT NULL AND parentListRecursive::text <> '') and length(parentListRecursive) > 0) then
                     parentListRet  := parentListRet || ',' || parentListRecursive;
                  end if;
               end if;

               parentListRet     := parentListRet || '}';
            end if;
        end if;

        return parentListRet;
	end;



$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION philips_audit_pck.getjsonparentid (parentList text) FROM PUBLIC;