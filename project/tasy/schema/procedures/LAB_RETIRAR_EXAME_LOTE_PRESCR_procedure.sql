-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_retirar_exame_lote_prescr ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_amostra_p text) AS $body$
DECLARE

nr_seq_prescr_w	integer;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	prescr_procedimento
	where	nr_prescricao = nr_prescricao_p
	and	nr_sequencia = coalesce(nr_seq_prescr_p,nr_sequencia)
	and	ie_status_atend <= 30
	and	((ie_amostra_p = 'N') or (ie_amostra = 'S'));


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_prescr_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	delete FROM lab_lote_exame_item
	where nr_prescricao = nr_prescricao_p
	  and nr_seq_prescr = nr_seq_prescr_w;


	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_retirar_exame_lote_prescr ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_amostra_p text) FROM PUBLIC;
