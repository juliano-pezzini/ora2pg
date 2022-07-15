-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE far_fechamento_mensal_conv ( nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
dt_dia_atual_w		smallint;
dt_ult_dia_w		smallint;

c01 CURSOR FOR
SELECT	nr_sequencia
from	far_contrato_conv a
where	trunc(clock_timestamp()) between dt_inicio_vigencia and dt_final_vigencia
and	coalesce(dt_dia_fechamento,0) > 0
and	((dt_dia_fechamento = dt_dia_atual_w) or
	((dt_dia_fechamento > dt_ult_dia_w) and (trunc(clock_timestamp()) = pkg_date_utils.get_datetime(pkg_date_utils.end_of(clock_timestamp(),'MONTH',0),clock_timestamp(), 0))));


BEGIN

dt_dia_atual_w		:= (to_char(clock_timestamp(),'dd'))::numeric;
dt_ult_dia_w		:= (to_char(pkg_date_utils.end_of(clock_timestamp(),'MONTH',0),'dd'))::numeric;

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	CALL far_gerar_fechamento_convenio(
		nr_sequencia_w,
		pkg_date_utils.start_of(pkg_date_utils.add_month(clock_timestamp(),-1,0),'MONTH',0),
		nm_usuario_p);

	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE far_fechamento_mensal_conv ( nm_usuario_p text) FROM PUBLIC;

