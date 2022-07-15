-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_ata_envio ( nm_usuario_p text, nr_sequencia_p bigint, ds_email_destino_cc_p text, ds_observacao_p text) AS $body$
BEGIN
insert into proj_ata_envio(
		nr_sequencia,
		nr_seq_ata, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		dt_envio, 
		ds_destino,
		ds_observacao) 
	values (nextval('proj_ata_envio_seq'), 
		nr_sequencia_p, 
		clock_timestamp(), 
		nm_usuario_p,
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		substr(ds_email_destino_cc_p,1,255), 
		ds_observacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_ata_envio ( nm_usuario_p text, nr_sequencia_p bigint, ds_email_destino_cc_p text, ds_observacao_p text) FROM PUBLIC;

