-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_cal_escala ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_equip_calib_escala_w				bigint;			
qt_erro_max_permitido_w				    double precision;
qt_erro_total_w					        double precision;
ds_retorno_w					        varchar(1) := 'A';


BEGIN

select	coalesce(max(nr_seq_equip_calib_escala),0)
into STRICT	nr_seq_equip_calib_escala_w
from	man_calibracao
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_equip_calib_escala_w > 0) then

    qt_erro_max_permitido_w	:= coalesce(obter_qt_erro_max_permitido(nr_seq_equip_calib_escala_w),0);
    qt_erro_total_w		:= coalesce(obter_qt_erro_total_cal_escala(nr_sequencia_p),0);

	if (qt_erro_total_w > qt_erro_max_permitido_w) then
		ds_retorno_w := 'R';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_cal_escala ( nr_sequencia_p bigint) FROM PUBLIC;
