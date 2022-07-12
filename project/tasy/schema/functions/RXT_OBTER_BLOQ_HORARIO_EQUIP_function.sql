-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_bloq_horario_equip (nr_seq_equip_p bigint, dt_agenda_p timestamp, hr_horario_p timestamp) RETURNS varchar AS $body$
DECLARE


se_bloqueado_w         		varchar(1)    := 'N';
nr_seq_bloqueio_w		bigint;
hr_inicial_bloqueio_w		timestamp;
hr_final_bloqueio_w		timestamp;
dt_inicial_bloqueio_w		timestamp;
dt_final_bloqueio_w		timestamp;
ie_gerar_hor_bloq_w  		varchar(1) := 'N';
cd_dia_semana_agenda_w		integer;
ie_dia_trabalho_w		varchar(1);

c01 CURSOR FOR
	SELECT  nr_sequencia,
		trunc(dt_inicial),
		trunc(dt_final),
		to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicio_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
		to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final_bloqueio,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss'),
		ie_gerar_hor_bloq
	from	rxt_agenda_bloqueio 
	where	1 = 1
	and	nr_seq_equipamento = nr_seq_equip_p
	and (trunc(dt_agenda_p) between trunc(dt_inicial) and trunc(dt_final))
	and	((ie_dia_semana		= cd_dia_semana_agenda_w) OR (ie_dia_semana = 9 AND ie_dia_trabalho_w = 'S'));



BEGIN

se_bloqueado_w := 'N';

select	Obter_Cod_Dia_Semana(dt_agenda_p)
into STRICT	cd_dia_semana_agenda_w
;

select CASE WHEN pkg_date_utils.is_business_day(dt_agenda_p)=0 THEN  'N' WHEN pkg_date_utils.is_business_day(dt_agenda_p)=1 THEN  'S' END
into STRICT ie_dia_trabalho_w
;


OPEN c01;
LOOP
FETCH c01 INTO	nr_seq_bloqueio_w,
	dt_inicial_bloqueio_w,
	dt_final_bloqueio_w,
	hr_inicial_bloqueio_w,
	hr_final_bloqueio_w,
	ie_gerar_hor_bloq_w;
		
	EXIT WHEN NOT FOUND OR (se_bloqueado_w = 'S' or se_bloqueado_w = 'G');  /* apply on c01 */
		BEGIN
		IF (	(dt_agenda_p >= dt_inicial_bloqueio_w AND dt_agenda_p <= dt_final_bloqueio_w) AND
			( (hr_inicial_bloqueio_w = dt_agenda_p AND hr_final_bloqueio_w = dt_agenda_p) OR (hr_horario_p >= hr_inicial_bloqueio_w AND hr_final_bloqueio_w = dt_agenda_p) OR (hr_inicial_bloqueio_w = dt_agenda_p AND hr_horario_p <= hr_final_bloqueio_w ) OR (hr_horario_p >= hr_inicial_bloqueio_w AND hr_horario_p <= hr_final_bloqueio_w))) THEN
			IF ie_gerar_hor_bloq_w = 'S' THEN
				se_bloqueado_w := 'G';
			ELSE
				se_bloqueado_w := 'S';
			END IF;
			
		ELSE
			se_bloqueado_w := 'N';
		END IF;					
	END;
			
END LOOP;
CLOSE C01;

return	se_bloqueado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_bloq_horario_equip (nr_seq_equip_p bigint, dt_agenda_p timestamp, hr_horario_p timestamp) FROM PUBLIC;

