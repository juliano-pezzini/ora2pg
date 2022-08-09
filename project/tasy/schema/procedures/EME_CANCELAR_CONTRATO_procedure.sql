-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_cancelar_contrato (nr_sequencia_p bigint, nr_seq_motivo_cancel_p bigint default 0, ds_motivo_cancelamento_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then
	update	eme_contrato
	set	nr_seq_motivo_cancel = nr_seq_motivo_cancel_p,
		nm_usuario_cancel = nm_usuario_p,
		ds_motivo_cancelamento	= ds_motivo_cancelamento_p,
		dt_cancelamento = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_cancelar_contrato (nr_sequencia_p bigint, nr_seq_motivo_cancel_p bigint default 0, ds_motivo_cancelamento_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
