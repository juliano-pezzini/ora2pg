-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_preco_beneficiario_pck.verificar_gerar_valor ( nr_seq_regra_desc_p pls_regra_desconto.nr_sequencia%type, nr_seq_regra_desc_ant_p pls_regra_desconto.nr_sequencia%type, nr_seq_plano_preco_p pls_plano_preco.nr_sequencia%type, nr_seq_plano_preco_ant_p pls_plano_preco.nr_sequencia%type, nr_seq_reaj_preco_p pls_reajuste_preco.nr_sequencia%type, nr_seq_reaj_preco_ant_p pls_reajuste_preco.nr_sequencia%type, nr_seq_seg_preco_ant_p pls_segurado_preco.nr_sequencia%type, nr_seq_regra_aprop_p pls_regra_apropriacao.nr_sequencia%type, nr_seq_regra_aprop_ant_p pls_regra_apropriacao.nr_sequencia%type, ie_acao_p text, dt_preco_p pls_segurado_preco.dt_reajuste%type, nr_seq_processo_p processo_judicial_liminar.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, vl_desconto_p pls_segurado_preco.vl_desconto%type, vl_desconto_ant_p pls_segurado_preco.vl_desconto%type) RETURNS varchar AS $body$
DECLARE


qt_registro_fx_proc_w	bigint;


BEGIN

if	(ie_acao_p = 'E' AND nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then
	select	count(1)
	into STRICT	qt_registro_fx_proc_w
	from	pls_segurado_preco
	where	nr_seq_segurado = nr_seq_segurado_p
	and	nr_seq_processo = nr_seq_processo_p
	and	dt_reajuste	= dt_preco_p
	and	cd_motivo_reajuste = 'E';
	
	if (qt_registro_fx_proc_w > 0) then
		return 'N';
	end if;
end if;

if	((coalesce(nr_seq_regra_desc_p, 0) 	= coalesce(nr_seq_regra_desc_ant_p, 0)) and (coalesce(nr_seq_plano_preco_p, 0) 	= coalesce(nr_seq_plano_preco_ant_p, 0)) and (coalesce(nr_seq_reaj_preco_p, 0) 	= coalesce(nr_seq_reaj_preco_ant_p, 0)) and (coalesce(nr_seq_regra_aprop_p, 0) 	= coalesce(nr_seq_regra_aprop_ant_p, 0)) and (coalesce(vl_desconto_p, 0) 		= coalesce(vl_desconto_ant_p,0))) then
	return 'N';
end if;

return 'S';

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_preco_beneficiario_pck.verificar_gerar_valor ( nr_seq_regra_desc_p pls_regra_desconto.nr_sequencia%type, nr_seq_regra_desc_ant_p pls_regra_desconto.nr_sequencia%type, nr_seq_plano_preco_p pls_plano_preco.nr_sequencia%type, nr_seq_plano_preco_ant_p pls_plano_preco.nr_sequencia%type, nr_seq_reaj_preco_p pls_reajuste_preco.nr_sequencia%type, nr_seq_reaj_preco_ant_p pls_reajuste_preco.nr_sequencia%type, nr_seq_seg_preco_ant_p pls_segurado_preco.nr_sequencia%type, nr_seq_regra_aprop_p pls_regra_apropriacao.nr_sequencia%type, nr_seq_regra_aprop_ant_p pls_regra_apropriacao.nr_sequencia%type, ie_acao_p text, dt_preco_p pls_segurado_preco.dt_reajuste%type, nr_seq_processo_p processo_judicial_liminar.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, vl_desconto_p pls_segurado_preco.vl_desconto%type, vl_desconto_ant_p pls_segurado_preco.vl_desconto%type) FROM PUBLIC;