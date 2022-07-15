-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_atualizar_lote_soluc ( nr_seq_mat_soluc_p bigint, ds_lote_fornec_p text) AS $body$
BEGIN

if (nr_seq_mat_soluc_p IS NOT NULL AND nr_seq_mat_soluc_p::text <> '') and (ds_lote_fornec_p IS NOT NULL AND ds_lote_fornec_p::text <> '') then

	update	hd_material_solucao_reuso
	set	ds_lote_fornec = ds_lote_fornec_p
	where	nr_sequencia = nr_seq_mat_soluc_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_atualizar_lote_soluc ( nr_seq_mat_soluc_p bigint, ds_lote_fornec_p text) FROM PUBLIC;

