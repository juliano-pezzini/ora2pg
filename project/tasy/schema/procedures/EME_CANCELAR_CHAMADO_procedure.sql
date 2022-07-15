-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_cancelar_chamado ( nr_seq_chamado_p bigint, nr_seq_mot_cancel_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	eme_chamado
set		nr_seq_mot_cancel	= nr_seq_mot_cancel_p,
		dt_cancel_chamado	= clock_timestamp(),
		nm_usuario_cancel	= nm_usuario_p
where	nr_sequencia		= nr_seq_chamado_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_cancelar_chamado ( nr_seq_chamado_p bigint, nr_seq_mot_cancel_p bigint, nm_usuario_p text) FROM PUBLIC;

