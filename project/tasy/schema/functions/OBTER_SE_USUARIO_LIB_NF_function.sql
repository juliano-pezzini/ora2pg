-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_lib_nf ( cd_operacao_nf_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(01) := 'S';
qt_regra_w		bigint;

/* ie_opcao_p
	1 - Consulta
	2 - Digitação
	3 - Calculo
*/
BEGIN

select	count(*)
into STRICT	qt_regra_w
from	grupo_operacao_nota_lib g,
	operacao_grupo_nota_lib x,
	usuario_grupo_nota_lib u
where	x.cd_operacao_nf 	= cd_operacao_nf_p
and	u.nm_usuario_lib	= nm_usuario_p
and	x.nr_seq_grupo	= u.nr_seq_grupo
and	g.nr_sequencia	= u.nr_seq_grupo
and	g.ie_situacao	= 'A';

if (qt_regra_w > 0) then /*Se existir regra do usuario*/
	select	coalesce(CASE WHEN ie_opcao_p='1' THEN 	max(ie_consulta) WHEN ie_opcao_p='2' THEN 	max(ie_digitacao) WHEN ie_opcao_p='3' THEN 	max(ie_calcular) END ,'S')
	into STRICT	ds_retorno_w
	from	grupo_operacao_nota_lib g,
		operacao_grupo_nota_lib x,
		usuario_grupo_nota_lib u
	where	x.cd_operacao_nf 	= cd_operacao_nf_p
	and	u.nm_usuario_lib	= nm_usuario_p
	and	x.nr_seq_grupo	= u.nr_seq_grupo
	and	g.nr_sequencia	= u.nr_seq_grupo
	and	g.ie_situacao	= 'A';
elsif (qt_regra_w = 0) then /*Se não existir do usuario, procura pelo perfil*/
	begin

	select	count(*)
	into STRICT	qt_regra_w
	from	grupo_operacao_nota_lib g,
		operacao_grupo_nota_lib x,
		usuario_grupo_nota_lib u
	where	x.cd_operacao_nf 	= cd_operacao_nf_p
	and	u.cd_perfil	= cd_perfil_p
	and	x.nr_seq_grupo	= u.nr_seq_grupo
	and	g.nr_sequencia	= u.nr_seq_grupo
	and	g.ie_situacao	= 'A';

	if (qt_regra_w > 0) then
		select	coalesce(CASE WHEN ie_opcao_p='1' THEN 	max(ie_consulta) WHEN ie_opcao_p='2' THEN 	max(ie_digitacao) WHEN ie_opcao_p='3' THEN 	max(ie_calcular) END ,'S')
		into STRICT	ds_retorno_w
		from	grupo_operacao_nota_lib g,
			operacao_grupo_nota_lib x,
			usuario_grupo_nota_lib u
		where	x.cd_operacao_nf 	= cd_operacao_nf_p
		and	u.cd_perfil	= cd_perfil_p
		and	x.nr_seq_grupo	= u.nr_seq_grupo
		and	g.nr_sequencia	= u.nr_seq_grupo
		and	g.ie_situacao	= 'A';
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_lib_nf ( cd_operacao_nf_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

