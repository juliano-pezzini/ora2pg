-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_vl_total_rel_4534 ( dt_inicio_p text, nr_contrato_p bigint, ie_estipulante_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

vl_retorno_w		varchar(255);

BEGIN
/*
T = Total títular + dependentes
TT = Total títular
TD = Total dependentes
TA = Total agregados
*/
if (ie_opcao_p = 'T') then
	select	campo_mascara_virgula(to_char(sum(vl_beneficiario)))
	into STRICT	vl_retorno_w
	from	(	SELECT	(pls_obter_valor_segurado(e.nr_sequencia,'VCD'))::numeric  vl_beneficiario
			from	pls_segurado	e,
				pls_contrato	a
			where	a.nr_sequencia	= e.nr_seq_contrato
			and	coalesce(e.nr_seq_titular::text, '') = ''
			and (a.nr_contrato = nr_contrato_p or coalesce(nr_contrato_p,0) = 0)
			and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
			and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))
			
union all

			SELECT	(pls_obter_valor_segurado(e.nr_sequencia,'VCD'))::numeric  vl_beneficiario
			from	pls_segurado	e,
				pls_contrato	a
			where	a.nr_sequencia		= e.nr_seq_contrato
			and	e.nr_seq_titular in (	select	e.nr_sequencia
							from	pls_segurado		e,
								pls_contrato		a
							where	a.nr_sequencia	= e.nr_seq_contrato
							and	coalesce(e.nr_seq_titular::text, '') = ''
							and (a.nr_contrato = nr_contrato_p or coalesce(nr_contrato_p,0) = 0)
							and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
							and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy')) )
			and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
			and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))
			and (a.nr_contrato = nr_contrato_p or coalesce(nr_contrato_p,0) = 0)
			and	((ie_estipulante_p = 'PF' and (a.cd_pf_estipulante IS NOT NULL AND a.cd_pf_estipulante::text <> '')) or (ie_estipulante_p = 'PJ' and (a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')) or (ie_estipulante_p = 'A'))) alias41;
elsif (ie_opcao_p = 'TT') then
	select	rpad(count(1),8) || lpad(campo_mascara_virgula(to_char(coalesce(sum((pls_obter_valor_segurado(e.nr_sequencia,'VCD'))::numeric ),0))),20)
	into STRICT	vl_retorno_w
	from	pls_segurado	e,
		pls_contrato	a
	where	a.nr_sequencia	= e.nr_seq_contrato
	and	coalesce(e.nr_seq_titular::text, '') = ''
	and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
	and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))
	and (a.nr_contrato = nr_contrato_p or coalesce(nr_contrato_p,0) = 0)
	and	((ie_estipulante_p = 'PF' and (a.cd_pf_estipulante IS NOT NULL AND a.cd_pf_estipulante::text <> '')) or (ie_estipulante_p = 'PJ' and (a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')) or (ie_estipulante_p = 'A'));
elsif (ie_opcao_p = 'TD') then
	select	rpad(count(1),8) || lpad(campo_mascara_virgula(to_char(coalesce(sum((pls_obter_valor_segurado(e.nr_sequencia,'VCD'))::numeric ),0))),20)
	into STRICT	vl_retorno_w
	from	pls_segurado		e,
		pls_contrato		a
	where  	a.nr_sequencia		= e.nr_seq_contrato
	and	e.nr_seq_titular in (	SELECT	e.nr_sequencia
					from	pls_segurado	e,
						pls_contrato	a
					where	a.nr_sequencia	= e.nr_seq_contrato
					and (a.nr_contrato = nr_contrato_p or coalesce(nr_contrato_p,0) = 0)
					and	coalesce(e.nr_seq_titular::text, '') = ''
					and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
					and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))  )
	and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
	and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))
	and	((ie_estipulante_p = 'PF' and (a.cd_pf_estipulante IS NOT NULL AND a.cd_pf_estipulante::text <> '')) or (ie_estipulante_p = 'PJ' and (a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')) or (ie_estipulante_p = 'A'))
	and (select	ie_tipo_parentesco
		 from	grau_parentesco
		 where	nr_sequencia	= e.nr_seq_parentesco) = '1';
elsif (ie_opcao_p = 'TA') then
	select	rpad(count(1),8) || lpad(campo_mascara_virgula(to_char(coalesce(sum((pls_obter_valor_segurado(e.nr_sequencia,'VCD'))::numeric ),0))),20)
	into STRICT	vl_retorno_w
	from	grau_parentesco		f,
		pls_segurado		e,
		pls_contrato		a
	where	a.nr_sequencia		= e.nr_seq_contrato
	and	f.nr_sequencia		= e.nr_seq_parentesco
	and	e.nr_seq_titular in (	SELECT	e.nr_sequencia
					from	pls_segurado	e,
						pls_contrato	a
					where	a.nr_sequencia	= e.nr_seq_contrato
					and (a.nr_contrato = nr_contrato_p or coalesce(nr_contrato_p,0) = 0)
					and	coalesce(e.nr_seq_titular::text, '') = ''
					and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
					and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))  )
	and	trunc(e.dt_contratacao, 'month') <= to_date(dt_inicio_p,'mm/yyyy')
	and (coalesce(e.dt_rescisao::text, '') = '' or trunc(e.dt_rescisao, 'month') = to_date(dt_inicio_p,'mm/yyyy'))
	and	((ie_estipulante_p = 'PF' and (a.cd_pf_estipulante IS NOT NULL AND a.cd_pf_estipulante::text <> '')) or (ie_estipulante_p = 'PJ' and (a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')) or (ie_estipulante_p = 'A'))
	and (select	ie_tipo_parentesco
		 from	grau_parentesco
		 where	nr_sequencia	= e.nr_seq_parentesco) <> '1';
end if;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_vl_total_rel_4534 ( dt_inicio_p text, nr_contrato_p bigint, ie_estipulante_p text, ie_opcao_p text) FROM PUBLIC;

