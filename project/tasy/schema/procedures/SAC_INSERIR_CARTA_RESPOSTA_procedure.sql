-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sac_inserir_carta_resposta ( nm_usuario_p text, ds_email_destino_p text, ds_texto_p text, nr_seq_bo_p bigint) AS $body$
BEGIN
insert 	into	sac_carta_resposta(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_email_destino,
		ds_texto,
		nr_seq_bo)
	values (nextval('sac_carta_resposta_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		substr(ds_email_destino_p,1,255),
		substr(ds_texto_p,1,4000),
		nr_seq_bo_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sac_inserir_carta_resposta ( nm_usuario_p text, ds_email_destino_p text, ds_texto_p text, nr_seq_bo_p bigint) FROM PUBLIC;
