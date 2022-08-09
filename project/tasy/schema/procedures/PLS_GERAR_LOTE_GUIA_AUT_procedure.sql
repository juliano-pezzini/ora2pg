-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_guia_aut ( cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_lote_p INOUT bigint) AS $body$
BEGIN

    insert into pls_lote_protocolo_conta(nr_sequencia, dt_atualizacao, nm_usuario,
					 dt_atualizacao_nrec, nm_usuario_nrec, dt_lote,
					 cd_estabelecimento, nr_seq_prestador, ie_tipo_lote,
					 nr_seq_congenere, dt_geracao_analise, ie_status)
		values (nextval('pls_lote_protocolo_conta_seq'), clock_timestamp(), nm_usuario_p,
					 clock_timestamp(), nm_usuario_p, clock_timestamp(),
					 cd_estabelecimento_p, null, 'P',
					 null,null, 'U') returning nr_sequencia into nr_seq_lote_p;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_guia_aut ( cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_lote_p INOUT bigint) FROM PUBLIC;
