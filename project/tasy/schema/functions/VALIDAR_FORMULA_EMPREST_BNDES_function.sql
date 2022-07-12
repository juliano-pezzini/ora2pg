-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION validar_formula_emprest_bndes (DS_FORMULA_P text) RETURNS char AS $body$
DECLARE


query_execucao_p varchar(4000);
recebe_p varchar(4000);
ie_erro_p char;


BEGIN

  ie_erro_p	:= 'N';

  if (ds_formula_p IS NOT NULL AND ds_formula_p::text <> '') then
    select REGEXP_REPLACE(ds_formula_p, '(#:(C|B|P|V|A|R|I):#\S*(@|!))', '1 ') into STRICT query_execucao_p;
    begin
      EXECUTE 'select ' || query_execucao_p || ' from dual' into STRICT recebe_p;
      exception
      when others then
        ie_erro_p	:= 'S';
    end;
  end if;

return ie_erro_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION validar_formula_emprest_bndes (DS_FORMULA_P text) FROM PUBLIC;
