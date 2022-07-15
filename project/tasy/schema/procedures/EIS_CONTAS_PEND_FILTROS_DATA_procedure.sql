-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eis_contas_pend_filtros_data ( nm_filtro_p text, ds_valor_filtro_p timestamp) AS $body$
BEGIN
if (upper(nm_filtro_p) = 'DT_INICIAL_P') then
	begin
		CALL eis_contas_pend_filtros_pck.set_dt_inicial(ds_valor_filtro_p);
	end;
elsif (upper(nm_filtro_p) = 'DT_FINAL_P') then
	begin
		CALL eis_contas_pend_filtros_pck.set_dt_final(ds_valor_filtro_p);
	end;
elsif (upper(nm_filtro_p) = 'DT_REF_PROTOCOLO_P') then
	begin
		CALL eis_contas_pend_filtros_pck.set_dt_ref_protocolo(ds_valor_filtro_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eis_contas_pend_filtros_data ( nm_filtro_p text, ds_valor_filtro_p timestamp) FROM PUBLIC;

