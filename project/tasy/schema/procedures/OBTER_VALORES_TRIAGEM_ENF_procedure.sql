-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valores_triagem_enf ( nr_atendimento_p bigint, dt_prov_parto_p INOUT timestamp, dt_ultima_menstruacao_p INOUT timestamp, qt_ig_sem_us_p INOUT bigint, qt_ig_dia_us_p INOUT bigint) AS $body$
DECLARE

		 
dt_prov_parto_w 	timestamp;
dt_ultima_menst_w 	timestamp;
qt_ig_sem_us_w		smallint;
qt_ig_dia_us_w		smallint;
qt_dif_data_w		double precision;
		

BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	begin	 
	select	max(dt_prov_parto), 
		max(dt_ultima_menstruacao) 
	into STRICT	dt_prov_parto_w, 
		dt_ultima_menst_w 
	from	med_pac_pre_natal 
	where	nr_atendimento = nr_atendimento_p 
	and	coalesce(dt_inativacao::text, '') = '' 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	 
	select 	max(a.qt_ig_sem_us), 
		max(a.qt_ig_dia_us) 
	into STRICT	qt_ig_sem_us_w, 
		qt_ig_dia_us_w 
	from	med_pac_pre_natal a 
	where	a.nr_sequencia = ( 
			SELECT	max(b.nr_sequencia) 
			from	med_pac_pre_natal b 
			where	b.nr_atendimento = nr_atendimento_p) 
	and	coalesce(a.dt_inativacao::text, '') = '' 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
	end;
	 
	if (coalesce(dt_ultima_menst_w::text, '') = '') then 
	 
		Select 	max(dt_ultima_menstruacao) 
		into STRICT	dt_ultima_menst_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_p;
		 
		 
		if (dt_ultima_menst_w IS NOT NULL AND dt_ultima_menst_w::text <> '') then 
		 
			qt_dif_data_w := trunc(clock_timestamp()) - trunc(dt_ultima_menst_w);
			 
			qt_ig_sem_us_w := floor(qt_dif_data_w / 7);
			qt_ig_dia_us_w := mod(qt_dif_data_w,7);
			 
		end if;
	 
	end if;
	 
end if;
 
dt_prov_parto_p 	:= dt_prov_parto_w;
dt_ultima_menstruacao_p := dt_ultima_menst_w;
qt_ig_sem_us_p		:= qt_ig_sem_us_w;
qt_ig_dia_us_p		:= qt_ig_dia_us_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valores_triagem_enf ( nr_atendimento_p bigint, dt_prov_parto_p INOUT timestamp, dt_ultima_menstruacao_p INOUT timestamp, qt_ig_sem_us_p INOUT bigint, qt_ig_dia_us_p INOUT bigint) FROM PUBLIC;

