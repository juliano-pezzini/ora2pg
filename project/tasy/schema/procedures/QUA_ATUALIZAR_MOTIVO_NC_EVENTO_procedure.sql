-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_atualizar_motivo_nc_evento ( nr_sequencia_evento_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

update  qua_evento_paciente
set 	nr_seq_motivo_sem_rnc = nr_seq_motivo_p,
	    ds_observacao		  = substr(substr(ds_observacao,1,2000) || substr(ds_observacao_p,1,2000),1,2000),
		nm_usuario			  = nm_usuario_p,
		dt_atualizacao		  = clock_timestamp()
where	nr_sequencia		  = nr_sequencia_evento_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_atualizar_motivo_nc_evento ( nr_sequencia_evento_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

