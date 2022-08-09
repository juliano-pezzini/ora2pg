-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_fornec_mat_esp ( nr_prescricao_p bigint, nr_sequencia_p bigint, NR_SEQ_LOTE_FORNEC_P bigint) AS $body$
BEGIN

if (coalesce(nr_seq_lote_fornec_p,0) = 0) then
	update	prescr_material
	set	nr_seq_lote_fornec 	 = NULL
	where	nr_prescricao 		= nr_prescricao_p
	and	nr_sequencia		= nr_sequencia_p;
else
	update	prescr_material
	set	nr_seq_lote_fornec 	= nr_seq_lote_fornec_p
	where	nr_prescricao 		= nr_prescricao_p
	and	nr_sequencia		= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_fornec_mat_esp ( nr_prescricao_p bigint, nr_sequencia_p bigint, NR_SEQ_LOTE_FORNEC_P bigint) FROM PUBLIC;
