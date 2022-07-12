-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_prest_tipo_guia ( nr_seq_prestador_p bigint, nr_seq_tipo_guia_p bigint, nr_seq_plano_p bigint, ie_portal_web_p text, cd_especialidade_p pls_tipo_guia_med_partic.cd_especialidade%type) RETURNS varchar AS $body$
DECLARE


ie_participa_w			varchar(3)	:= 'N';
ie_filtro_produto_w		varchar(2);
nr_seq_tipo_prestador_w		bigint;
nr_seq_classificacao_w		bigint;
nr_seq_grupo_prest_w		bigint;
qt_registros_w			integer;
cd_especialidade_w		pls_tipo_guia_med_partic.cd_especialidade%type;

C01 CURSOR FOR
	SELECT	CASE WHEN ie_portal_web_p='S' THEN coalesce(ie_entra_portal,'S')  ELSE coalesce(ie_entra_guia_medico,'N') END
	from	pls_tipo_guia_med_partic a
	where	a.nr_seq_tipo_guia						= coalesce(nr_seq_tipo_guia_p,a.nr_seq_tipo_guia)
	and	coalesce(nr_seq_prestador,coalesce(nr_seq_prestador_p,0))			= coalesce(nr_seq_prestador_p,0)
	and	coalesce(nr_seq_tipo_prestador,coalesce(nr_seq_tipo_prestador_w,0)) 	= coalesce(nr_seq_tipo_prestador_w,0)
	and	coalesce(nr_seq_classif_prestador,coalesce(nr_seq_classificacao_w,0)) 	= coalesce(nr_seq_classificacao_w,0)
	and	coalesce(nr_seq_grupo_prest,coalesce(nr_seq_grupo_prest_w,0)) 		= coalesce(nr_seq_grupo_prest_w,0)

	and	(coalesce(nr_seq_plano,coalesce(nr_seq_plano_p,0)) 			= coalesce(nr_seq_plano_p,0) or
		((coalesce(a.nr_seq_plano::text, '') = '') or (coalesce(nr_seq_prestador_p::text, '') = '') or
		exists (SELECT	1
			from	pls_prestador_plano x
			where	coalesce(x.ie_permite,'N') 	= 'S'
			and	coalesce(x.ie_situacao,'I')	= 'A'
			and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp())
			and	x.nr_seq_plano		= a.nr_seq_plano
			and	ie_filtro_produto_w	= 'PP'
			and	x.nr_seq_prestador 	= nr_seq_prestador_p
			
union all

			select	1
			from	pls_plano_rede_atend c,
				pls_rede_atendimento b,
				pls_prestador_rede_atend a
			where	a.nr_seq_rede_atend	= b.nr_sequencia
			and	c.nr_seq_rede		= b.nr_sequencia
			and	clock_timestamp() between coalesce(c.dt_inicio_vigencia,clock_timestamp()) and coalesce(c.dt_fim_vigencia,clock_timestamp())
			and	ie_filtro_produto_w	= 'RA'
			and	a.nr_seq_prestador	= nr_seq_prestador_p)))
	and	((coalesce(nr_seq_plano_p::text, '') = '') or (coalesce(nr_seq_prestador_p::text, '') = '') or
		exists (select	1
			from	pls_prestador_plano x
			where	coalesce(x.ie_permite,'N') 	= 'S'
			and	coalesce(x.ie_situacao,'I')	= 'A'
			and	clock_timestamp() between coalesce(x.dt_inicio_vigencia,clock_timestamp()) and coalesce(x.dt_fim_vigencia,clock_timestamp())
			and	x.nr_seq_plano		= nr_seq_plano_p
			and	ie_filtro_produto_w	= 'PP'
			and	x.nr_seq_prestador 	= nr_seq_prestador_p
			
union all

			select	1
			from	pls_plano_rede_atend c,
				pls_rede_atendimento b,
				pls_prestador_rede_atend a
			where	a.nr_seq_rede_atend	= b.nr_sequencia
			and	c.nr_seq_rede		= b.nr_sequencia
			and	clock_timestamp() between coalesce(c.dt_inicio_vigencia,clock_timestamp()) and coalesce(c.dt_fim_vigencia,clock_timestamp())
			and	ie_filtro_produto_w	= 'RA'
			and	a.nr_seq_prestador	= nr_seq_prestador_p))

	and	((coalesce(nr_seq_tipo_acomodacao::text, '') = '') or (coalesce(nr_seq_plano_p::text, '') = '') or
		exists (select 	1
			from	pls_plano_acomodacao x
			where	x.nr_seq_plano 		 = nr_seq_plano_p
			and	x.nr_seq_tipo_acomodacao = a.nr_seq_tipo_acomodacao))
	and	((coalesce(nr_seq_plano_p::text, '') = '') or
		exists (select	1
			from	pls_plano_area x
			where	x.nr_seq_plano 						= nr_seq_plano_p
			and	coalesce(a.cd_municipio_ibge,coalesce(x.cd_municipio_ibge,0)) 	= coalesce(x.cd_municipio_ibge,0)
			and	coalesce(a.sg_estado,coalesce(x.sg_estado,0)) 			= coalesce(x.sg_estado,0)
			and	coalesce(a.nr_seq_regiao,coalesce(x.nr_seq_regiao,0))		= coalesce(x.nr_seq_regiao,0)))
	and (coalesce(a.cd_especialidade::text, '') = '' or
		coalesce(nr_seq_prestador_p::text, '') = '' or
		exists (select 	1
			from	pls_prestador_med_espec x
			where	x.nr_seq_prestador	= nr_seq_prestador_p
			and	x.cd_especialidade	= a.cd_especialidade
			and	clock_timestamp() between trunc(coalesce(x.dt_inicio_vigencia, clock_timestamp())) and fim_dia(coalesce(x.dt_fim_vigencia, clock_timestamp()))))
	and	((pls_obter_se_prest_rede_atend(coalesce(nr_seq_prestador,nr_seq_prestador_p),nr_seq_rede_atend) = 'S') or (coalesce(nr_seq_rede_atend::text, '') = ''))
	and (a.cd_especialidade = cd_especialidade_p or coalesce(a.cd_especialidade::text, '') = '')
	order by
		coalesce(cd_especialidade,0),
		coalesce(nr_seq_tipo_prestador,0),
		coalesce(nr_seq_classif_prestador,0),
		coalesce(nr_seq_grupo_prest,0),
		coalesce(nr_seq_prestador,0),
		coalesce(nr_seq_plano,0),
		coalesce(nr_seq_rede_atend,0),
		coalesce(ie_entra_guia_medico,'N');


BEGIN

/* Verifica a forma de consulta dos produtos se deverá ser aplicado  pelos produtos do prestador ou pelo produto da rede de atendimento
PP - Filtrar pelo produto cadastrado para o prestador
RA - Filtrar pelo produto vinculado à rede de atendimento do pres
*/
if ( ie_portal_web_p = 'S' ) then
	ie_filtro_produto_w	:= pls_parametro_operadora_web('FPGM');
else
	ie_filtro_produto_w	:= coalesce(obter_valor_param_usuario(1230, 16, Obter_Perfil_Ativo, OBTER_USUARIO_ATIVO, 0), 'PP');
end if;

select	nr_seq_tipo_prestador,
	nr_seq_classificacao
into STRICT	nr_seq_tipo_prestador_w,
	nr_seq_classificacao_w
from	pls_prestador
where	nr_sequencia	= nr_seq_prestador_p;

select	max(a.nr_sequencia)
into STRICT	nr_seq_grupo_prest_w
from	pls_preco_grupo_prestador a
where	exists (	SELECT	1
			from	pls_preco_prestador x
			where	x.nr_seq_grupo		= a.nr_sequencia
			and	x.nr_seq_prestador	= nr_seq_prestador_p);

open C01;
loop
fetch C01 into
	ie_participa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return ie_participa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_prest_tipo_guia ( nr_seq_prestador_p bigint, nr_seq_tipo_guia_p bigint, nr_seq_plano_p bigint, ie_portal_web_p text, cd_especialidade_p pls_tipo_guia_med_partic.cd_especialidade%type) FROM PUBLIC;
