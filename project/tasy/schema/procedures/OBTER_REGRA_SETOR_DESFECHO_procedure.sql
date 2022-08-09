-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_setor_desfecho ( nr_atendimento_p bigint, cd_setor_estabelecimento_p INOUT bigint) AS $body$
DECLARE

				 
				 
ie_tipo_atendimento_w	smallint;
ie_clinica_w			integer;
cd_setor_atendimento_w integer;
cd_setor_parametro_w	integer;
cd_setor_parametro231_w	integer;

 
C01 CURSOR FOR 
	SELECT	cd_setor_atendimento 
	from	REGRA_SETOR_DESFECHO 
	where	coalesce(ie_clinica,ie_clinica_w)	= ie_clinica_w 
	and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_w)	= ie_tipo_atendimento_w 
	order by coalesce(ie_clinica,0), 
		 coalesce(ie_tipo_atendimento,0);


BEGIN 
begin 
 
cd_setor_parametro_w := obter_param_usuario(935, 51, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, cd_setor_parametro_w);
cd_setor_parametro231_w := obter_param_usuario(935, 231, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, cd_setor_parametro231_w);
 
 
select	ie_clinica, 
	ie_tipo_Atendimento 
into STRICT	ie_clinica_w, 
	ie_tipo_atendimento_w 
from	atendimento_paciente 
where	nr_Atendimento	= nr_atendimento_p;
exception 
	when others then 
	null;
	end;
 
open C01;
loop 
fetch C01 into	 
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;
 
if (cd_setor_parametro231_w > 0) and (cd_setor_parametro_w = 0) then 
	cd_setor_parametro_w := cd_setor_parametro231_w;
end if;
 
cd_setor_estabelecimento_p	:= coalesce(cd_setor_atendimento_w,coalesce(cd_setor_parametro_w,coalesce(cd_setor_parametro231_w,0)));
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_setor_desfecho ( nr_atendimento_p bigint, cd_setor_estabelecimento_p INOUT bigint) FROM PUBLIC;
