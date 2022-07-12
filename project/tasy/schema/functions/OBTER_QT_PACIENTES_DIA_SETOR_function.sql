-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_pacientes_dia_setor ( dt_inicial_p timestamp, dt_final_p timestamp, cd_setor_p bigint) RETURNS bigint AS $body$
DECLARE




dt_dia_w			timestamp;
nr_seq_interno_w		bigint;
qt_total_pac_w		bigint := 0;
qt_existe_w		bigint;


c01 CURSOR FOR
SELECT	dt_dia
from  	dia_v
where	dt_dia between dt_inicial_p and dt_final_p;


c02 CURSOR FOR
SELECT		 nr_seq_interno
from		 unidade_atendimento
where 		 cd_setor_atendimento = cd_setor_p;


BEGIN


open C02;
loop
fetch C02 into
	nr_seq_interno_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	open C01;
	loop
	fetch C01 into
		dt_dia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	coalesce(max(1),0)
		into STRICT	qt_existe_w
		from	unidade_atend_hist
		where	to_date(to_char(dt_dia_w + 7/24,'dd/mm/yyyy hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')   between dt_historico and coalesce(dt_fim_historico,clock_timestamp())
		and	nr_seq_unidade = nr_seq_interno_w
		and 	ie_status_unidade = 'P';

		qt_total_pac_w	:= qt_total_pac_w  + qt_existe_w;

		end;
	end loop;
	close C01;

	end;
end loop;
close C02;

return qt_total_pac_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_pacientes_dia_setor ( dt_inicial_p timestamp, dt_final_p timestamp, cd_setor_p bigint) FROM PUBLIC;
