-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dirf_registro_fimdirf (nm_usuario_p text) AS $body$
BEGIN

insert 	into w_dirf_arquivo(nr_sequencia,
			     nm_usuario,
			     nm_usuario_nrec,
			     dt_atualizacao,
			     dt_atualizacao_nrec,
			     ds_arquivo,
			     nr_seq_apresentacao,
			     nr_seq_registro)
values (nextval('w_dirf_arquivo_seq'),
			     nm_usuario_p,
			     nm_usuario_p,
			     clock_timestamp(),
			     clock_timestamp(),
			     'FIMDirf|',
			     999999,
			     0);




commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dirf_registro_fimdirf (nm_usuario_p text) FROM PUBLIC;

