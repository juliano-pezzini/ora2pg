-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_atualizar_data_usu_imp ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	a.nr_prescricao,
		a.nr_seq_prescr
	from	lab_lote_exame_item a
	where	a.nr_seq_lote = nr_seq_lote_p;

c01_w	c01%rowtype;


BEGIN

open c01;
loop
fetch c01 into c01_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	update	prescr_procedimento
	set	dt_imp_lote = clock_timestamp(),
		nm_usuario_imp_lote = nm_usuario_p
	where	nr_prescricao = c01_w.nr_prescricao
	and	nr_sequencia = c01_w.nr_seq_prescr;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_atualizar_data_usu_imp ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
