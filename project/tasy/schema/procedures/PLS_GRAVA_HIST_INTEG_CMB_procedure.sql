-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_grava_hist_integ_cmb ( nr_seq_envio_p bigint, ds_mensagem_p text, dt_historico_p timestamp, nm_usuario_hist_p text, ie_tipo_p bigint, nr_seq_pendencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

insert into	pls_envio_ptu_hist(nr_sequencia, 				dt_atualizacao, 	nm_usuario,
					dt_atualizacao_nrec, 			nm_usuario_nrec,	ds_mensagem,
					dt_historico, 				nm_usuario_hist, 	ie_tipo,
					nr_seq_pendencia, 			cd_estabelecimento,	nr_seq_envio)	
		values (	nextval('pls_envio_ptu_hist_seq'),		clock_timestamp(), 		nm_usuario_p,
					clock_timestamp(), 				nm_usuario_p, 		ds_mensagem_p,
					dt_historico_p, 			nm_usuario_hist_p, 	ie_tipo_p,
					nr_seq_pendencia_p, 			cd_estabelecimento_p,	nr_seq_envio_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_grava_hist_integ_cmb ( nr_seq_envio_p bigint, ds_mensagem_p text, dt_historico_p timestamp, nm_usuario_hist_p text, ie_tipo_p bigint, nr_seq_pendencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

