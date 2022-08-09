-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_proc_estrutura ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_area_p bigint, cd_especialidade_p bigint, cd_grupo_p bigint, ie_estrutura_p INOUT text ) AS $body$
DECLARE


cd_area_procedimento_out_w	bigint;
cd_especialidade_out_w		bigint;
cd_grupo_proc_out_w		bigint;
ie_origem_proced_out_w		bigint;
ie_ok_estrutura_w		varchar(1):= 'S';

/*
CRIADO PARA SER UTILIZADO NAS REGRAS DE OCORRÊNCIA.;
*/
BEGIN

SELECT * FROM pls_obter_estrut_proc(	cd_procedimento_p, ie_origem_proced_p, cd_area_procedimento_out_w, cd_especialidade_out_w, cd_grupo_proc_out_w, ie_origem_proced_out_w) INTO STRICT cd_area_procedimento_out_w, cd_especialidade_out_w, cd_grupo_proc_out_w, ie_origem_proced_out_w;

if (coalesce( cd_area_p,0)>0) then
	if ( cd_area_p <> coalesce(cd_area_procedimento_out_w,0)) then
		ie_ok_estrutura_w	:= 'N';
		goto final;
	end if;
end if;

if (coalesce( cd_especialidade_p,0) >0) then
	if ( cd_especialidade_p <> coalesce( cd_especialidade_out_w,0)) then
		ie_ok_estrutura_w	:= 'N';
		goto final;
	end if;
end if;

if ( coalesce( cd_grupo_p,0)>0) then
	if ( cd_grupo_p <> coalesce(cd_grupo_proc_out_w,0)) then
		ie_ok_estrutura_w 	:= 'N';
		goto final;
	end if;
end if;

<<final>>
ie_estrutura_p	:= ie_ok_estrutura_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_proc_estrutura ( cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_area_p bigint, cd_especialidade_p bigint, cd_grupo_p bigint, ie_estrutura_p INOUT text ) FROM PUBLIC;
