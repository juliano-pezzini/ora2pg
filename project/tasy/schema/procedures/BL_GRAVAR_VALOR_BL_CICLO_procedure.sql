-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bl_gravar_valor_bl_ciclo ( nr_seq_ciclo_p bigint, qt_valor_p bigint, ds_justificativa_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_ciclo_p IS NOT NULL AND nr_seq_ciclo_p::text <> '') then

	update	bl_ciclo
	set	qt_valor = qt_valor_p,
		ds_justificativa = ds_justificativa_p
	where	nr_sequencia = nr_seq_ciclo_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bl_gravar_valor_bl_ciclo ( nr_seq_ciclo_p bigint, qt_valor_p bigint, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
