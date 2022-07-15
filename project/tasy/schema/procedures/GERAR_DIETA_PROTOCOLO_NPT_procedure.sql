-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dieta_protocolo_npt ( nr_prescricao_p bigint, nr_seq_protocolo_p bigint) AS $body$
DECLARE

 
nr_sequencia_w		integer;
cd_dieta_w		bigint;
cd_intervalo_w		varchar(7);
ie_dose_espec_agora_w	varchar(1);
hr_prim_horario_w	varchar(5);
ds_justificativa_w	varchar(2000);
ds_observacao_w		varchar(4000);
dt_inicio_prescr_w	timestamp;
nr_horas_validade_w	integer;
nr_intervalo_w		bigint;
ds_horarios1_w		varchar(2000);
ds_horarios2_w		varchar(2000);
nm_usuario_w		varchar(15);
ie_via_aplicacao_w	varchar(50);
qt_parametro_w		double precision;
dt_inicio_dieta_w	timestamp;

c01 CURSOR FOR 
SELECT	cd_dieta, 
	cd_intervalo, 
	ie_dose_espec_agora, 
	hr_prim_horario, 
	ds_justificativa, 
	ds_observacao, 
	ie_via_aplicacao, 
	qt_parametro 
from	dieta_protocolo_npt 
where	nr_seq_protocolo = nr_seq_protocolo_p;


BEGIN 
 
select	max(dt_inicio_prescr), 
	coalesce(max(nr_horas_validade),24), 
	max(nm_usuario) 
into STRICT	dt_inicio_prescr_w, 
	nr_horas_validade_w, 
	nm_usuario_w 
from	prescr_medica 
where	nr_prescricao = nr_prescricao_p;
 
if	((coalesce(nr_prescricao_p,0) <> 0) and (coalesce(nr_seq_protocolo_p,0) <> 0)) then 
 
	open c01;
	loop 
	fetch c01 into 
		cd_dieta_w, 
		cd_intervalo_w, 
		ie_dose_espec_agora_w, 
		hr_prim_horario_w, 
		ds_justificativa_w, 
		ds_observacao_w, 
		ie_via_aplicacao_w, 
		qt_parametro_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		select	nextval('prescr_dieta_seq') 
		into STRICT	nr_sequencia_w 
		;
		 
		if (hr_prim_horario_w IS NOT NULL AND hr_prim_horario_w::text <> '') and (hr_prim_horario_w <> ' : ') then 
			dt_inicio_dieta_w := to_date(to_char(dt_inicio_prescr_w,'dd/mm/yyyy')||' '||hr_prim_horario_w||':00','dd/mm/yyyy hh24:mi:ss');
		end if;
		 
		nr_intervalo_w	:= 0;
		SELECT * FROM Calcular_Horario_Prescricao(nr_prescricao_p, cd_intervalo_w, dt_inicio_prescr_w, coalesce(dt_inicio_dieta_w,dt_inicio_prescr_w), nr_horas_validade_w, null, null, null, nr_intervalo_w, ds_horarios1_w, ds_horarios2_w, 'N', '') INTO STRICT nr_intervalo_w, ds_horarios1_w, ds_horarios2_w;
 
		insert	into prescr_dieta( 
			nr_sequencia, 
			cd_dieta, 
			cd_intervalo, 
			nr_prescricao, 
			ie_dose_espec_agora, 
			hr_prim_horario, 
			ds_justificativa, 
			ds_observacao, 
			ds_horarios, 
			nm_usuario, 
			dt_atualizacao, 
			ie_via_aplicacao, 
			qt_parametro) 
			values ( 
			nr_sequencia_w, 
			cd_dieta_w, 
			cd_intervalo_w, 
			nr_prescricao_p, 
			ie_dose_espec_agora_w, 
			hr_prim_horario_w, 
			ds_justificativa_w, 
			ds_observacao_w, 
			substr(ds_horarios1_w || ds_horarios2_w,1,255), 
			nm_usuario_w, 
			clock_timestamp(), 
			ie_via_aplicacao_w, 
			qt_parametro_w);
 
	end loop;
	close c01;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dieta_protocolo_npt ( nr_prescricao_p bigint, nr_seq_protocolo_p bigint) FROM PUBLIC;

