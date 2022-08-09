-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gravar_envio_ata ( nr_seq_ata_p bigint, ds_destino_p text, nm_usuario_p text, ds_observacao_p text default null) AS $body$
BEGIN


insert into proj_ata_envio(	nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_ata,
			dt_envio,
			ds_destino,
			ds_observacao)
	values (	nextval('proj_ata_envio_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_ata_p,
			clock_timestamp(),
			substr(ds_destino_p,1,255),
			ds_observacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gravar_envio_ata ( nr_seq_ata_p bigint, ds_destino_p text, nm_usuario_p text, ds_observacao_p text default null) FROM PUBLIC;
