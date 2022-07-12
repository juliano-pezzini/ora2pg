-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_atend_setor (nr_atendimento_p bigint, cd_setor_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

			 
qt_entrada_setor_w	bigint;
cd_setor_entrada_w	bigint;

BEGIN
 
if (coalesce(nr_atendimento_p,0) > 0) and (coalesce(cd_setor_atendimento_p,0) > 0) then 
 
	select	Obter_Unidade_Atendimento(nr_atendimento_p,'P','CS') 
	into STRICT	cd_setor_entrada_w 
	;
 
	select	count(*) 
	into STRICT	qt_entrada_setor_w 
	from	atend_paciente_unidade 
	where	nr_atendimento = nr_atendimento_p 
	and	cd_setor_atendimento = cd_setor_atendimento_p;
	 
	if (cd_setor_entrada_w = cd_setor_atendimento_p) then 
		 
		qt_entrada_setor_w := qt_entrada_setor_w -1;
	 
	end if;
	if (qt_entrada_setor_w > 1) then 
	 
		qt_entrada_setor_w := 1;
	 
	end if;
end if;
 
return	qt_entrada_setor_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_atend_setor (nr_atendimento_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

