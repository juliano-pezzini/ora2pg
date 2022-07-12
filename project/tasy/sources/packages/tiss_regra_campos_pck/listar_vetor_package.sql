-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_regra_campos_pck.listar_vetor () AS $body$
DECLARE

i integer := 0;

BEGIN
RAISE NOTICE 'DBMS - OK';
if	current_setting('tiss_regra_campos_pck.regra_campos_tb_w')::regra_campos_tb_v.count > 0 then
	for i in current_setting('tiss_regra_campos_pck.regra_campos_tb_w')::regra_campos_tb_v.first .. current_setting('tiss_regra_campos_pck.regra_campos_tb_w')::regra_campos_tb_v.last loop
		RAISE NOTICE '% - % - %', current_setting('tiss_regra_campos_pck.regra_campos_tb_w')::regra_campos_tb_v[i].cd_convenio, current_setting('tiss_regra_campos_pck.regra_campos_tb_w')::regra_campos_tb_v[i].nm_atributo, current_setting('tiss_regra_campos_pck.regra_campos_tb_w')::regra_campos_tb_v[i].ie_tiss_tipo_guia;
	end loop;
end if;
end;		


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_regra_campos_pck.listar_vetor () FROM PUBLIC;