-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_tiss_guia_operadora ( ie_tipo_atend_p bigint, ie_tiss_tipo_guia_p bigint, nm_usuario_p text, cd_convenio_p bigint, cd_setor_atendimento_p bigint, cd_area_proced_p bigint, cd_especialidade_proc_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_guia_operadora_p INOUT text) AS $body$
DECLARE


ie_guia_operadora_w	varchar(5);


C01 CURSOR FOR
	SELECT	ie_guia_operadora
	from	Tiss_Regra_Guia_Operadora
	where	coalesce(cd_area_procedimento,coalesce(cd_area_proced_p,0))   =  coalesce(cd_area_proced_p,0)
	and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))		     = 	coalesce(cd_convenio_p,0)
	and	coalesce(cd_especialidade_proc,coalesce(cd_especialidade_proc_p,0)) = coalesce(cd_especialidade_proc_p,0)
	and	cd_estabelecimento   			     = wheb_usuario_pck.get_cd_estabelecimento
	and	coalesce(cd_grupo_proc,coalesce(cd_grupo_proc_p,0))	     = coalesce(cd_grupo_proc_p,0)
	and	coalesce(cd_procedimento,coalesce(cd_procedimento_p,0))	     = coalesce(cd_procedimento_p,0)
	and	coalesce(cd_setor_atendimento,coalesce(cd_setor_atendimento_p,0)) = coalesce(cd_setor_atendimento_p,0)
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atend_p,0))    	 = coalesce(ie_tipo_atend_p,0)
	and	coalesce(ie_tiss_tipo_guia,coalesce(ie_tiss_tipo_guia_p,0))	 = coalesce(ie_tiss_tipo_guia_p,0)
	and	((coalesce(cd_procedimento::text, '') = '') or (ie_origem_proced = ie_origem_proced_p))
	and	coalesce(ie_situacao,'A') = 'A'
        order by coalesce(cd_procedimento,0),
		coalesce(cd_grupo_proc,0),
		coalesce(cd_especialidade_proc,0),
		coalesce(cd_area_procedimento,0),
		coalesce(cd_setor_atendimento,0),
		coalesce(cd_convenio,0),
		coalesce(ie_tiss_tipo_guia,0),
		coalesce(ie_tipo_atendimento,0);


c01_w	c01%rowtype;

BEGIN

open C01;
loop
fetch C01 into
	ie_guia_operadora_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ie_guia_operadora_w := ie_guia_operadora_w;
end loop;
close C01;

ie_guia_operadora_p := ie_guia_operadora_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_tiss_guia_operadora ( ie_tipo_atend_p bigint, ie_tiss_tipo_guia_p bigint, nm_usuario_p text, cd_convenio_p bigint, cd_setor_atendimento_p bigint, cd_area_proced_p bigint, cd_especialidade_proc_p bigint, cd_grupo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_guia_operadora_p INOUT text) FROM PUBLIC;

