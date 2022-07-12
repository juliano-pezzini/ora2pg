-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_gerar_titulo_pck.valida_se_gera_titulos ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) AS $body$
DECLARE


ds_mensagem_w	varchar(255);


BEGIN

ds_mensagem_w	:= pls_pp_gerar_titulo_pck.obter_prest_sem_nf_pgto(nr_seq_lote_p);

if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then
	-- Existe prestadore(s) sem nota fiscal#@#@

	CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_mensagem_w,'');
end if;

-- verifica quais prestadores nao possuem dados para pagamento

ds_mensagem_w := pls_pp_gerar_titulo_pck.obter_prest_sem_dado_pgto(nr_seq_lote_p);

-- se retornou algum prestador entao para o processo

if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then

	-- Nao foram encontrados dados para pagamento vigentes do(s) prestador(es): #@NR_SEQ_PRESTADOR#@

	CALL wheb_mensagem_pck.exibir_mensagem_abort(457921,'NR_SEQ_PRESTADOR=' || ds_mensagem_w);
end if;

if (current_setting('pls_pp_gerar_titulo_pck.cd_tipo_taxa_juro_w')::parametro_contas_receber.cd_tipo_taxa_juro%coalesce(type::text, '') = '') or (current_setting('pls_pp_gerar_titulo_pck.cd_tipo_taxa_multa_w')::parametro_contas_receber.cd_tipo_taxa_multa%coalesce(type::text, '') = '') or (current_setting('pls_pp_gerar_titulo_pck.cd_tipo_portador_w')::parametro_contas_receber.cd_tipo_portador%coalesce(type::text, '') = '') or (current_setting('pls_pp_gerar_titulo_pck.cd_portador_w')::parametro_contas_receber.cd_portador%coalesce(type::text, '') = '') then

	-- Nao foram encontrados os parametros do contas a receber, por favor verifique.

	-- (Tipo taxa juros/Tipo taxa multa/Tipo portador/Portador)

	CALL wheb_mensagem_pck.exibir_mensagem_abort(178535);
end if;

-- verifica se algum tributo do lote ficou sem regra de calculo de tributo

ds_mensagem_w := pls_pp_tributacao_pck.obter_prest_tributo_sem_regra(	nr_seq_lote_p);

if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then

	-- Nao e possivel gerar os titulos, existem tributos sem regra de contas a pagar, favor verificar.

	-- #@DS_MENSAGEM#@

	CALL wheb_mensagem_pck.exibir_mensagem_abort(458114,'DS_MENSAGEM=' || ds_mensagem_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_gerar_titulo_pck.valida_se_gera_titulos ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type) FROM PUBLIC;
