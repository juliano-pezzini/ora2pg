-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_descartar_servico (nr_sequencia_p bigint, nm_usuario_p text, nr_seq_motivo_p bigint default null, ds_justificativa_p text default null) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	update	nut_atend_serv_dia
	set	dt_descarte = clock_timestamp(),
		nm_usuario_descarte = nm_usuario_p,
		nr_seq_motivo_cancel = nr_seq_motivo_p,
		ds_justif_cancel = ds_justificativa_p
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_descartar_servico (nr_sequencia_p bigint, nm_usuario_p text, nr_seq_motivo_p bigint default null, ds_justificativa_p text default null) FROM PUBLIC;

