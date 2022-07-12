-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ehr_obter_se_tipo_reg_lib ( nr_seq_tipo_reg_p bigint, cd_perfil_p bigint, cd_especialidade_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
qt_regra_w		bigint;
ds_retorno_w		varchar(1);
ie_liberar_w		varchar(1);

C01 CURSOR FOR 
	SELECT	ie_liberar 
	into STRICT	ie_liberar_w 
	from	ehr_tipo_reg_lib 
	where	nr_seq_tipo_reg	= nr_seq_tipo_reg_p 
	and	coalesce(cd_perfil,coalesce(cd_perfil_p,0))		= coalesce(cd_perfil_p,0) 
	--and	nvl(cd_especialidade,nvl(cd_especialidade_p,0))	= nvl(cd_especialidade_p,0) 
	and	coalesce(cd_pessoa_fisica,coalesce(cd_pessoa_fisica_p,0))	= coalesce(cd_pessoa_fisica_p,0) 
	and	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_pessoa_fisica_p,cd_especialidade)	= 'S')) 
	order by coalesce(cd_pessoa_fisica,0), 
		coalesce(cd_especialidade,0), 
		coalesce(cd_perfil,0);


BEGIN 
 
select	count(*) 
into STRICT	qt_regra_w 
from	ehr_tipo_reg_lib 
where	nr_seq_tipo_reg	= nr_seq_tipo_reg_p;
 
if (qt_regra_w = 0) then 
	begin 
	ds_retorno_w	:= 'S';
	end;
else 
	begin 
	ds_retorno_w	:= 'N';
	open C01;
	loop 
	fetch C01 into	 
		ie_liberar_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_retorno_w	:= ie_liberar_w;
		end;
	end loop;
	close C01;
	end;
end if;
 
return ds_retorno_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ehr_obter_se_tipo_reg_lib ( nr_seq_tipo_reg_p bigint, cd_perfil_p bigint, cd_especialidade_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
