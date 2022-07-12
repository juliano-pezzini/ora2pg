-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_comissao_equipe_pck.obter_valor_qtd_item_comissao (nr_seq_comissao_p pls_comissao.nr_sequencia%type, ie_tipo_estipulante_p text, nr_seq_grupo_p pls_grupo_contrato.nr_sequencia%type, vl_comissao_retorno_p INOUT bigint, qt_itens_comissao_retorno_p INOUT bigint) AS $body$
BEGIN

if (ie_tipo_estipulante_p = 'PF') then
	if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
		select	sum(a.vl_comissao),
			count(1)
		into STRICT	vl_comissao_retorno_p,
			qt_itens_comissao_retorno_p
		from	pls_comissao_benef_item a,
			pls_comissao_beneficiario b
		where	b.nr_sequencia = a.nr_seq_comissao_benef
		and	b.nr_seq_comissao = nr_seq_comissao_p
		and 	exists (SELECT	1
				from	pls_segurado x,
					pls_contrato y,
					pls_contrato_grupo w
				where	y.nr_sequencia = x.nr_seq_contrato
				and	y.nr_sequencia = w.nr_seq_contrato
				and	x.nr_sequencia = b.nr_seq_segurado
				and	w.nr_seq_grupo = nr_seq_grupo_p
				and	(y.cd_pf_estipulante IS NOT NULL AND y.cd_pf_estipulante::text <> ''));
	else
		select	sum(a.vl_comissao),
			count(1)
		into STRICT	vl_comissao_retorno_p,
			qt_itens_comissao_retorno_p
		from	pls_comissao_benef_item a,
			pls_comissao_beneficiario b
		where	b.nr_sequencia = a.nr_seq_comissao_benef
		and	b.nr_seq_comissao = nr_seq_comissao_p
		and 	exists (SELECT	1
				from	pls_segurado x,
					pls_contrato y
				where	y.nr_sequencia = x.nr_seq_contrato
				and	x.nr_sequencia = b.nr_seq_segurado
				and	(y.cd_pf_estipulante IS NOT NULL AND y.cd_pf_estipulante::text <> ''));
	end if;
elsif (ie_tipo_estipulante_p = 'PJ') then
	if (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
		select	sum(a.vl_comissao),
			count(1)
		into STRICT	vl_comissao_retorno_p,
			qt_itens_comissao_retorno_p
		from	pls_comissao_benef_item a,
			pls_comissao_beneficiario b
		where	b.nr_sequencia = a.nr_seq_comissao_benef
		and	b.nr_seq_comissao = nr_seq_comissao_p
		and 	exists (SELECT	1
				from	pls_segurado x,
					pls_contrato y,
					pls_contrato_grupo w
				where	y.nr_sequencia = x.nr_seq_contrato
				and	y.nr_sequencia = w.nr_seq_contrato
				and	x.nr_sequencia = b.nr_seq_segurado
				and	w.nr_seq_grupo = nr_seq_grupo_p
				and 	(y.cd_cgc_estipulante IS NOT NULL AND y.cd_cgc_estipulante::text <> ''));
	else
		select	sum(a.vl_comissao),
			count(1)
		into STRICT	vl_comissao_retorno_p,
			qt_itens_comissao_retorno_p
		from	pls_comissao_benef_item a,
			pls_comissao_beneficiario b
		where	b.nr_sequencia = a.nr_seq_comissao_benef
		and	b.nr_seq_comissao = nr_seq_comissao_p
		and 	exists (SELECT	1
				from 	pls_segurado x,
					pls_contrato y
				where 	y.nr_sequencia = x.nr_seq_contrato
				and 	x.nr_sequencia = b.nr_seq_segurado
				and 	(y.cd_cgc_estipulante IS NOT NULL AND y.cd_cgc_estipulante::text <> ''));
	end if;
end if;
						
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_comissao_equipe_pck.obter_valor_qtd_item_comissao (nr_seq_comissao_p pls_comissao.nr_sequencia%type, ie_tipo_estipulante_p text, nr_seq_grupo_p pls_grupo_contrato.nr_sequencia%type, vl_comissao_retorno_p INOUT bigint, qt_itens_comissao_retorno_p INOUT bigint) FROM PUBLIC;