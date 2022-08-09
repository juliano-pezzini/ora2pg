-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mx_consistir_vinculo_nf ( nr_sequencia_p bigint, nr_seq_nf_p bigint, ds_msg_p INOUT text) AS $body$
DECLARE


ds_serie_w					nf_imp_nota.ds_serie%type;
ds_numero_w					nf_imp_nota.ds_numero%type;
dt_emissao_w				nf_imp_nota.dt_emissao%type;
vl_total_w					nf_imp_nota.vl_total%type;
nr_ident_emissor_w			nf_imp_nota.nr_ident_emissor%type;
cd_serie_nf_w				nota_fiscal.cd_serie_nf%type;
nr_nota_fiscal_w			nota_fiscal.nr_nota_fiscal%type;
dt_emissao_nf_w				nota_fiscal.dt_emissao%type;
vl_total_nota_w				nota_fiscal.vl_total_nota%type;
cd_cgc_emitente_w			nota_fiscal.cd_cgc_emitente%type;


BEGIN

	select	max(ds_serie),
			max(ds_numero),
			max(dt_emissao),
			max(vl_total),
			max(nr_ident_emissor)
	into STRICT	ds_serie_w,
			ds_numero_w,
			dt_emissao_w,
			vl_total_w,
			nr_ident_emissor_w
	from	nf_imp_nota
	where	nr_sequencia = nr_sequencia_p;

	select	max(n.cd_serie_nf),
			max(n.nr_nota_fiscal),
			max(n.dt_emissao),
			max(n.vl_total_nota),
			max(CASE WHEN coalesce(n.cd_cgc::text, '') = '' THEN (	select	max(pf.cd_rfc)										from	pessoa_fisica pf										where	pf.cd_pessoa_fisica = n.cd_pessoa_fisica)  ELSE (	select	max(pj.cd_rfc)										from	pessoa_juridica pj										where	pj.cd_cgc = n.cd_cgc) END )
	into STRICT	cd_serie_nf_w,
			nr_nota_fiscal_w,
			dt_emissao_nf_w,
			vl_total_nota_w,
			cd_cgc_emitente_w
	from	nota_fiscal n
	where	n.nr_sequencia = nr_seq_nf_p;

	if ( coalesce(ds_serie_w::text, '') = '' or ds_serie_w <> cd_serie_nf_w )then
		ds_msg_p := obter_desc_expressao(873853) || ';' || ds_msg_p;
	end if;
	if ( coalesce(ds_numero_w::text, '') = '' or ds_numero_w <> nr_nota_fiscal_w)then
		ds_msg_p := obter_desc_expressao(873857) || ';' || ds_msg_p;
	end if;
	if ( coalesce(dt_emissao_w::text, '') = '' or dt_emissao_w <> dt_emissao_nf_w )then
		ds_msg_p := obter_desc_expressao(873859) || ';' || ds_msg_p;
	end if;
	if ( coalesce(vl_total_w::text, '') = '' or vl_total_w <> vl_total_nota_w )then
		ds_msg_p := obter_desc_expressao(873861) || ';' || ds_msg_p;
	end if;
	if ( coalesce(nr_ident_emissor_w::text, '') = '' or nr_ident_emissor_w <> cd_cgc_emitente_w )then
		ds_msg_p := obter_desc_expressao(873863) || ';' || ds_msg_p;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mx_consistir_vinculo_nf ( nr_sequencia_p bigint, nr_seq_nf_p bigint, ds_msg_p INOUT text) FROM PUBLIC;
