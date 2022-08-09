-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE processar_conta_macro (ds_calculo_p text, ie_opcao_p text default 'P') AS $body$
DECLARE


ds_calculo_w		varchar(4000);
vl_resultado_w		double precision;
c001			integer;
retorno_w			integer;
vl_retorno_w		double precision;


BEGIN

/*	ie_opcao_p
	'T' - TESTE
	'P' - PROCESSAR_CONTA
*/
if ('T' = ie_opcao_p) then
	CALL processar_conta_pck.set_vl_honorario_conta(1);
	CALL processar_conta_pck.set_vl_base_com_imposto(1);
	CALL processar_conta_pck.set_vl_base_sem_imposto(1);
	CALL processar_conta_pck.set_vl_conta(1);
	CALL processar_conta_pck.set_pr_coseg_hosp_conta(1);
	CALL processar_conta_pck.set_pr_coseg_honor_conta(1);
	CALL processar_conta_pck.set_pr_coseg_nivel_hosp_conta(1);
	CALL processar_conta_pck.set_vl_coseg_hosp_conta(1);
	CALL processar_conta_pck.set_vl_coseg_honor_conta(1);
	CALL processar_conta_pck.set_vl_coseg_nivel_hosp_conta(1);
	CALL processar_conta_pck.set_vl_deduzido_conta(1);
	CALL processar_conta_pck.set_vl_max_coseguro_conta(1);
	CALL processar_conta_pck.set_vl_imposto(1);
	CALL processar_conta_pck.set_vl_desconto_deduzido(1);
	CALL processar_conta_pck.set_pr_imposto(1);
end if;

ds_calculo_w := upper(ds_calculo_p);

ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_MEDICO', processar_conta_pck.get_vl_honorario_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_ITEM_IMPOSTO', processar_conta_pck.get_vl_base_com_imposto),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_ITEM_SEM_IMPOSTO', processar_conta_pck.get_vl_base_sem_imposto),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_IMPOSTO', processar_conta_pck.get_vl_imposto),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_CONTA', processar_conta_pck.get_vl_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_DEDUZIDO', processar_conta_pck.get_vl_deduzido_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@PR_COSEG_HOSP_CONTA', processar_conta_pck.get_pr_coseg_hosp_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@PR_COSEG_HONOR_CONTA', processar_conta_pck.get_pr_coseg_honor_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@PR_COSEG_NIVEL_HOSP_CONTA', processar_conta_pck.get_pr_coseg_nivel_hosp_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_COSEG_HOSP_CONTA', processar_conta_pck.get_vl_coseg_hosp_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_COSEG_HONOR_CONTA', processar_conta_pck.get_vl_coseg_honor_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_COSEG_NIVEL_HOSP_CONTA', processar_conta_pck.get_vl_coseg_nivel_hosp_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_MAX_COSEGURO_CONTA', processar_conta_pck.get_vl_max_coseguro_conta),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@VL_DESCONTO', processar_conta_pck.get_vl_desconto_deduzido),1,4000);
ds_calculo_w := substr(replace_macro(ds_calculo_w, '@PR_IMPOSTO', processar_conta_pck.get_pr_imposto),1,4000);

ds_calculo_w := 'select ' || ds_calculo_w || ' from dual';

ds_calculo_w := replace(ds_calculo_w, ',', '.');

begin
c001 := dbms_sql.open_cursor;
dbms_sql.parse(c001, ds_calculo_w, dbms_sql.native);
if (upper(substr(ds_calculo_w,1,6)) = 'SELECT') then
	dbms_sql.define_column(c001, 1, vl_resultado_w);
end if;

retorno_w := dbms_sql.execute(c001);

if (upper(substr(ds_calculo_w,1,6)) = 'SELECT') then
	begin
	retorno_w := dbms_sql.fetch_rows(c001);
	dbms_sql.column_value(c001, 1, vl_resultado_w);
	end;
end if;
dbms_sql.close_cursor(c001);
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(333613, 'ds_calculo_p=' || ds_calculo_p);
	dbms_sql.close_cursor(c001);
end;

if coalesce(vl_resultado_w::text, '') = '' then
	CALL processar_conta_pck.set_vl_procedimento(0);
else
	CALL processar_conta_pck.set_vl_procedimento(vl_resultado_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_conta_macro (ds_calculo_p text, ie_opcao_p text default 'P') FROM PUBLIC;
