-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_formula_emprest_bndes (ds_formula_p text, ie_erro_p INOUT text) AS $body$
DECLARE


query_execucao_p varchar(4000);
teste_p varchar(4000);


BEGIN

  ie_erro_p	:= 'N';

  if (ds_formula_p IS NOT NULL AND ds_formula_p::text <> '') then
    select REGEXP_REPLACE(ds_formula_p, '(\#:I:#\S*?\!|\#\S*?\@)', '1') into STRICT query_execucao_p;
    begin
      EXECUTE 'select ' || query_execucao_p || ' from dual' into STRICT teste_p;
      exception
      when others then
        ie_erro_p	:= 'S';
    end;
  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_formula_emprest_bndes (ds_formula_p text, ie_erro_p INOUT text) FROM PUBLIC;
