-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION integracao_dispensario_pck.get_se_setor_integracao ( cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
BEGIN
	
	select	coalesce(max('S'), 'N')
	into STRICT	current_setting('integracao_dispensario_pck.ie_existe_w')::varchar(1)
	from	far_setores_integracao
	where	nr_seq_empresa_int = 191
	and		cd_setor_atendimento = cd_setor_atendimento_p;
	
	return current_setting('integracao_dispensario_pck.ie_existe_w')::varchar(1);
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION integracao_dispensario_pck.get_se_setor_integracao ( cd_setor_atendimento_p bigint) FROM PUBLIC;