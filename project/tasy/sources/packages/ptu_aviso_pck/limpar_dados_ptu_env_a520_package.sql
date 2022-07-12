-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_aviso_pck.limpar_dados_ptu_env_a520 ( nr_seq_lote_p ptu_lote_aviso.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Varre o lote, verificando quais arquivos foram gerados com contas sem itens.

	Esta situacao pode ocorrer devido a algumas restricoes de negocio, entao ao inves de gerar diversos
	bloqueios ja no momento de geracao da conta (e do protocolo), o que pode ocasionar em codigo repetido ou
	perda de performance, e deixado a geracao seguir o fluxo dela, e no final entao e verificado as contas, que 
	terao um volume de dados menor e sera mais performatico.
	
	sera chamado nesta ordem as rotinas para
	1 - Apagar as contas sem itens
	2 - Apagar os protocolos sem contas
	3 - Apagar os arquivos sem protocolos
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


BEGIN

-- limpa as contas

CALL ptu_aviso_pck.limpar_contas_sem_item_a520(nr_seq_lote_p);

-- limpa os protocolos sem contas

CALL ptu_aviso_pck.limpar_prot_sem_conta_a520(nr_seq_lote_p);

-- limpa os arquivos sem contas

CALL ptu_aviso_pck.limpar_arquivo_sem_prot_a520(nr_seq_lote_p);

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_aviso_pck.limpar_dados_ptu_env_a520 ( nr_seq_lote_p ptu_lote_aviso.nr_sequencia%type) FROM PUBLIC;