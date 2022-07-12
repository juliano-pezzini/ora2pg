-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_contrato (cd_material_p bigint, ie_restringe_estab_p text default 'N', cd_estabelecimento_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
qt_registro_w			bigint;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	select count(1)
	into STRICT	qt_registro_w
	from   (SELECT	1
		from	contrato_regra_nf a,
			contrato b
		where	a.nr_seq_contrato = b.nr_sequencia
		and	coalesce(a.cd_material, cd_material_p) = cd_material_p
		and	substr(obter_dados_pf_pj(null,b.cd_cgc_contratado,'S'),1,1) = 'A'
		and	((coalesce(a.dt_inicio_vigencia::text, '') = '') or (trunc(a.dt_inicio_vigencia,'dd') <= trunc(clock_timestamp(),'dd')))
		and	((coalesce(a.dt_fim_vigencia::text, '') = '') or (trunc(a.dt_fim_vigencia,'dd') >= trunc(clock_timestamp(),'dd')))
        and (coalesce(a.ie_situacao::text, '') = '' or a.ie_situacao = 'A')
		and	coalesce(cd_pessoa_contratada::text, '') = ''
		and	coalesce(b.ie_situacao,'A') = 'A'
		and	coalesce(a.ie_tipo_regra,'NF') = 'NF'
		and (ie_restringe_estab_p = 'N' 
			or ((a.cd_estab_regra IS NOT NULL AND a.cd_estab_regra::text <> '') and a.cd_estab_regra = cd_estabelecimento_p)
			or (exists (	select	1
					from	contrato_regra_nf_estab x
					where	x.cd_estab_regra = cd_estabelecimento_p
					and	x.nr_seq_regra_nf = a.nr_sequencia))
		     or (coalesce(a.cd_estab_regra::text, '') = '' and b.cd_estabelecimento = cd_estabelecimento_p)
			)
		
union all

		SELECT	1
		from	contrato_regra_nf a,
			contrato b
		where	a.nr_seq_contrato = b.nr_sequencia
		and	coalesce(a.cd_material, cd_material_p) = cd_material_p
		and	((coalesce(a.dt_inicio_vigencia::text, '') = '') or (trunc(a.dt_inicio_vigencia,'dd') <= trunc(clock_timestamp(),'dd')))
		and	((coalesce(a.dt_fim_vigencia::text, '') = '') or (trunc(a.dt_fim_vigencia,'dd') >= trunc(clock_timestamp(),'dd')))
        and (coalesce(a.ie_situacao::text, '') = '' or a.ie_situacao = 'A')
		and	(cd_pessoa_contratada IS NOT NULL AND cd_pessoa_contratada::text <> '')
		and	coalesce(b.ie_situacao,'A') = 'A'
		and	coalesce(a.ie_tipo_regra,'NF') = 'NF'
		and (ie_restringe_estab_p = 'N' 
			 or ((a.cd_estab_regra IS NOT NULL AND a.cd_estab_regra::text <> '') and a.cd_estab_regra = cd_estabelecimento_p)
				 or (exists (	select	1
						from	contrato_regra_nf_estab x
						where	x.cd_estab_regra = cd_estabelecimento_p
						and	x.nr_seq_regra_nf = a.nr_sequencia))
			 or (coalesce(a.cd_estab_regra::text, '') = '' and b.cd_estabelecimento = cd_estabelecimento_p)
			)) alias58;

	if (qt_registro_w > 0) then
		ds_retorno_w := 'S';
	end if;
end if;
return	ds_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_contrato (cd_material_p bigint, ie_restringe_estab_p text default 'N', cd_estabelecimento_p bigint default 0) FROM PUBLIC;

