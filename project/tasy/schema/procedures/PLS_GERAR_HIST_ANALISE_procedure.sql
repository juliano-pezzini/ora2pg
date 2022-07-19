-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_hist_analise ( nr_seq_resumo_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*
IE_ACAO_P
Conforme dominio  3784
*/
BEGIN

insert into pls_analise_conta_hist(nm_usuario_exec, dt_historico, nr_sequencia,
	 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
	 nm_usuario_nrec, cd_guia_referencia, nr_seq_resumo_conta,
	 cd_item, ie_origem_proced, ie_tipo_historico)
	(SELECT	 nm_usuario_p, clock_timestamp(), nextval('pls_analise_conta_hist_seq'),
		 clock_timestamp(), nm_usuario_p, clock_timestamp(),
		 nm_usuario_p, coalesce(cd_guia_referencia, cd_guia), nr_sequencia,
		 cd_item, ie_origem_proced, ie_acao_p
	 from	 w_pls_resumo_conta
	 where	 nr_sequencia = nr_seq_resumo_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_hist_analise ( nr_seq_resumo_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

