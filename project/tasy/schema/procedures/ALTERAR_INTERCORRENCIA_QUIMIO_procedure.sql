-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_intercorrencia_quimio (nr_seq_intercor_p text, nm_usuario_p text, ds_motivo_p text, nr_tipo_intercor_p bigint) AS $body$
BEGIN

update	paciente_atend_interc
set	ds_motivo	= substr(ds_motivo_p,1,4000),
	nm_usuario 	= nm_usuario_p,
        nr_seq_tipo_interc = nr_tipo_intercor_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia 	= nr_seq_intercor_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_intercorrencia_quimio (nr_seq_intercor_p text, nm_usuario_p text, ds_motivo_p text, nr_tipo_intercor_p bigint) FROM PUBLIC;
