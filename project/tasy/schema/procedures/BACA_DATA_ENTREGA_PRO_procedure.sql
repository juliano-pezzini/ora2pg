-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_data_entrega_pro () AS $body$
DECLARE



dt_resultado_w		timestamp;
nr_prescricao_w		bigint;
nr_sequencia_w		integer;


/*Ajusta a data prevista de entrega do laudo, com base na data da prescr_procedimento */

C01 CURSOR FOR
	SELECT	b.dt_resultado,
		b.nr_prescricao,
		b.nr_sequencia
	from	prescr_procedimento b,
		laudo_paciente a
	where	a.nr_prescricao	= b.nr_prescricao
	and	(b.dt_resultado IS NOT NULL AND b.dt_resultado::text <> '')
	and	b.dt_resultado	> a.dt_prev_entrega;

BEGIN

open C01;
loop
fetch C01 into
	dt_resultado_w,
	nr_prescricao_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	begin

	if (dt_resultado_w IS NOT NULL AND dt_resultado_w::text <> '') then
		update	laudo_paciente
		set	dt_prev_entrega		= dt_resultado_w
		where	nr_prescricao		= nr_prescricao_w
		and	nr_seq_prescricao	= nr_sequencia_w;

		commit;

	end if;
	exception
	when others then
		dt_resultado_w	:= null;
	end;

end loop;
close C01;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_data_entrega_pro () FROM PUBLIC;

