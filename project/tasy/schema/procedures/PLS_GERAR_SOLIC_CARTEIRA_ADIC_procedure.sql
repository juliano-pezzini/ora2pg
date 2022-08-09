-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_solic_carteira_adic ( nr_seq_carteira_p bigint, nr_seq_motivo_via_p bigint, cd_funcao_p bigint, ie_tipo_processo_p text, ie_criar_lote_via_adic_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Gerar solicitação da via adicional do cartão através do Portal
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ X]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
BEGIN
if (coalesce(nr_seq_carteira_p, 0) > 0) then
	insert into pls_solic_carteira_adic(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_carteira,
					nr_seq_motivo_via, cd_funcao, ie_tipo_processo,
					ie_criar_lote_via_adic, nm_usuario_solic, dt_solicitacao,
					ie_status)
				values (nextval('pls_solic_carteira_adic_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, nr_seq_carteira_p,
					nr_seq_motivo_via_p, cd_funcao_p, ie_tipo_processo_p,
					ie_criar_lote_via_adic_p, nm_usuario_p, clock_timestamp(),
					0);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_solic_carteira_adic ( nr_seq_carteira_p bigint, nr_seq_motivo_via_p bigint, cd_funcao_p bigint, ie_tipo_processo_p text, ie_criar_lote_via_adic_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
