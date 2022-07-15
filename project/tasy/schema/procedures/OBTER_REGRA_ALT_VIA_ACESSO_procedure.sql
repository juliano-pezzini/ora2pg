-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_alt_via_acesso ( nr_sequencia_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_retorno_p INOUT text, cd_funcao_p bigint) AS $body$
DECLARE


ds_retorno_w		varchar(1);
qt_registros_w		integer;
qt_regra_w		integer;
cd_area_procedimento_w	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;


BEGIN
select	count(*)
into STRICT	qt_registros_w
from	regra_via_acesso;

ie_retorno_p	:= 'N';

if (qt_registros_w > 0) then

	select	cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;

	select	count(*)
	into STRICT	qt_regra_w
	from	regra_alteracao_via_acesso
	where	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_p))
	and	((coalesce(cd_procedimento::text, '') = '') or (ie_origem_proced = ie_origem_proced_p))
	and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = cd_area_procedimento_w))
	and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = cd_especialidade_w))
	and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = cd_grupo_proc_w))
	and	((coalesce(cd_funcao::text, '') = '') or (coalesce(cd_funcao_p,0) = coalesce(cd_funcao,coalesce(cd_funcao_p,0))))
	and	ie_situacao		= 'A'
	order by coalesce(cd_procedimento, 0),
		 coalesce(cd_grupo_proc, 0),
		 coalesce(cd_especialidade, 0),
		 coalesce(cd_area_procedimento, 0),
		coalesce(cd_funcao_p,0);

	if (qt_regra_w > 0) then
		ie_retorno_p := 'S';
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_alt_via_acesso ( nr_sequencia_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_retorno_p INOUT text, cd_funcao_p bigint) FROM PUBLIC;

