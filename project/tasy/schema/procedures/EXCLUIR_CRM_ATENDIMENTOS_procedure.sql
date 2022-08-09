-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_crm_atendimentos () AS $body$
BEGIN

begin
delete 	from crm_atendimentos
where	to_date(dt_alta,'yyyy-mm-dd hh24:mi:ss') < add_months(clock_timestamp(),-2);
exception
when others then
	delete 	from crm_atendimentos
	where	to_date(dt_alta,'dd/mm/yyyy hh24:mi:ss') < add_months(clock_timestamp(),-2);
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_crm_atendimentos () FROM PUBLIC;
