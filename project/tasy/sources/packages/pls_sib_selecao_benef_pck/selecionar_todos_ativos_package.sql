-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sib_selecao_benef_pck.selecionar_todos_ativos ( dt_referencia_p pls_sib_lote.dt_referencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


indice_w	bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_segurado
	from	pls_segurado a,
		pls_contrato b
	where	b.nr_sequencia = a.nr_seq_contrato
	and	b.cd_estabelecimento = cd_estabelecimento_p
	and	a.ie_tipo_segurado in ('B','R')
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and (coalesce(a.dt_rescisao::text, '') = '' or a.dt_rescisao > clock_timestamp())
	and	b.ie_tipo_beneficiario <> 'ENB';

BEGIN
indice_w := 0;
for r_c01_w in C01 loop
	current_setting('pls_sib_selecao_benef_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table(indice_w) := r_c01_w.nr_seq_segurado;
	indice_w := indice_w + 1;
	if (indice_w = pls_util_pck.qt_registro_transacao_w) then
		CALL pls_sib_selecao_benef_pck.inserir_sib_selecao();
		indice_w := 0;
	end if;
end loop;

if (indice_w > 0) then
	CALL pls_sib_selecao_benef_pck.inserir_sib_selecao();
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_selecao_benef_pck.selecionar_todos_ativos ( dt_referencia_p pls_sib_lote.dt_referencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
