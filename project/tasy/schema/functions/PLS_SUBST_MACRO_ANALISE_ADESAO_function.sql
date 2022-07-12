-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_subst_macro_analise_adesao ( ds_macro_p text, nm_atributo_p text, nr_seq_analise_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
dt_incial_cpt_w			timestamp;
qt_dias_w			bigint;


BEGIN

if (ds_macro_p = '@NM_BENEFICIARIO') then
	select	max(b.nm_pessoa_fisica)
	into STRICT	ds_retorno_w
	from	pessoa_fisica		b,
		pls_analise_adesao	a
	where	a.CD_PESSOA_FISICA	= b.CD_PESSOA_FISICA
	and	a.nr_sequencia		= nr_seq_analise_p;

elsif (ds_macro_p = '@NR_CPF') then
	select	max(b.nr_cpf)
	into STRICT	ds_retorno_w
	from	pessoa_fisica		b,
		pls_analise_adesao	a
	where	a.CD_PESSOA_FISICA	= b.CD_PESSOA_FISICA
	and	a.nr_sequencia		= nr_seq_analise_p;

elsif (ds_macro_p in ('@DT_FINAL_CPT','@DT_EXTENSO_CPT')) then
	select	max(b.qt_dias)
	into STRICT	qt_dias_w
	from	PLS_CARENCIA			b,
		pls_analise_adesao		a
	where	b.NR_SEQ_PESSOA_PROPOSTA	= a.NR_SEQ_PESSOA_PROPOSTA
	and	a.nr_sequencia			= nr_seq_analise_p;

	if (qt_dias_w IS NOT NULL AND qt_dias_w::text <> '') then
		select	max(b.DT_INICIO_VIGENCIA)
		into STRICT	dt_incial_cpt_w
		from	PLS_CARENCIA			b,
			pls_analise_adesao		a
		where	b.NR_SEQ_PESSOA_PROPOSTA	= a.NR_SEQ_PESSOA_PROPOSTA
		and	a.nr_sequencia			= nr_seq_analise_p;

		if (coalesce(dt_incial_cpt_w::text, '') = '') then
			select	coalesce(b.DT_CONTRATACAO,c.DT_INICIO_PROPOSTA)
			into STRICT	dt_incial_cpt_w
			from	pls_proposta_beneficiario	b,
				pls_proposta_adesao		c,
				pls_analise_adesao		a
			where	b.nr_seq_proposta		= c.nr_sequencia
			and	b.nr_sequencia			= a.NR_SEQ_PESSOA_PROPOSTA
			and	a.nr_sequencia			= nr_seq_analise_p;
		end if;

		if (dt_incial_cpt_w IS NOT NULL AND dt_incial_cpt_w::text <> '') then
			if (ds_macro_p = '@DT_FINAL_CPT') then
				ds_retorno_w	:= to_char(dt_incial_cpt_w+qt_dias_w,'dd/mm/yyyy');
			elsif (ds_macro_p = '@DT_EXTENSO_CPT') then
				ds_retorno_w	:= to_char(dt_incial_cpt_w+qt_dias_w,'dd/Month/yyyy');
			end if;
		end if;
	end if;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_subst_macro_analise_adesao ( ds_macro_p text, nm_atributo_p text, nr_seq_analise_p bigint) FROM PUBLIC;
