-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_atend_regra ( cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE

 
cd_perfil_w		bigint := obter_perfil_ativo;
nr_atendimento_w	bigint;	
ie_tipo_atendimento_w	bigint;
CD_CLASSIF_SETOR_w	varchar(10);

C01 CURSOR FOR 
	SELECT	IE_TIPO_ATENDIMENTO, 
		CD_CLASSIF_SETOR 
	from	REGRA_UTL_ATEND_PEP 
	where	coalesce(cd_perfil,cd_perfil_w) = cd_perfil_w 
	order by coalesce(cd_perfil,0) desc, 
			NR_SEQ_PRIOR;

BEGIN
nr_atendimento_w	:= null;
 
 
open C01;
loop 
fetch C01 into	 
	ie_tipo_atendimento_w, 
	CD_CLASSIF_SETOR_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	max(a.nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from	resumo_atendimento_paciente_v a 
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	coalesce(a.dt_cancelamento::text, '') = '' 
	and	coalesce(a.dt_alta::text, '') = '' 
	and	((coalesce(ie_tipo_atendimento_w::text, '') = '') or (a.ie_tipo_atendimento = ie_tipo_atendimento_w)) 
	and	((coalesce(CD_CLASSIF_SETOR_w::text, '') = '') or (a.CD_CLASSIF_SETOR = cd_classif_setor_w));
	 
	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
		exit;
	end if;
	 
	end;
end loop;
close C01;
 
 
if (coalesce(nr_atendimento_w::text, '') = '') then 
	select	max(a.nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from	resumo_atendimento_paciente_v a 
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	coalesce(a.dt_cancelamento::text, '') = '' 
	and	coalesce(a.dt_alta::text, '') = '';
end if;
 
 
return	nr_atendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_atend_regra ( cd_pessoa_fisica_p text) FROM PUBLIC;

