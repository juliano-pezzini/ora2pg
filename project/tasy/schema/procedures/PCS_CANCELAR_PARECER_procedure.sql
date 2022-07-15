-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_cancelar_parecer ( nr_seq_reclassif_item_p bigint, nr_seq_motivo_p bigint, nr_sequencia_p bigint, ie_tipo_parecer_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_tipo_parecer_p = 'R') then
	update	pcs_parecer
	set 	nm_usuario_cancel = nm_usuario_p,
			dt_cancelamento = clock_timestamp(),
			ie_status = 'C',
			nr_seq_motivo_cancel = nr_seq_motivo_p,
			ie_tipo_parecer  = 'R'
	where	nr_sequencia = nr_sequencia_p;

	CALL pcs_cancelamento_email_parecer(nr_seq_reclassif_item_p,nr_sequencia_p,nm_usuario_p);

elsif (ie_tipo_parecer_p = 'L') then
	update	pcs_parecer
	set 	nm_usuario_cancel = nm_usuario_p,
			dt_cancelamento = clock_timestamp(),
			ie_status = 'C',
			nr_seq_motivo_cancel = nr_seq_motivo_p,
			ie_tipo_parecer  = 'L'
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_cancelar_parecer ( nr_seq_reclassif_item_p bigint, nr_seq_motivo_p bigint, nr_sequencia_p bigint, ie_tipo_parecer_p text, nm_usuario_p text) FROM PUBLIC;

