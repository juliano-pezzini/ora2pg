-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_ins_sinal_vital_controle ( nr_atendimento_p bigint, qt_temperatura_axiliar_p bigint, qt_pulso_p bigint, qt_pa_sistolica_p bigint, qt_pa_diastolica_p bigint, qt_dextro_p bigint, qt_insulina_p bigint, qt_glicose_adm_p bigint, nr_seq_sinal_vital_p INOUT bigint, dt_sinal_vital_p timestamp, nm_usuario_p text) AS $body$
DECLARE

					
dt_sinal_vital_w 	timestamp;
dt_formato_date_time_w   varchar(100);
dt_formato_date_w   varchar(100);


BEGIN
	
	select	nextval('atendimento_sinal_vital_seq')
	into STRICT	nr_seq_sinal_vital_p
	;

    SELECT pkg_date_formaters.localize_mask('timestamp',
                                             pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)
								)
	INTO STRICT   dt_formato_date_time_w 
	;

    SELECT pkg_date_formaters.localize_mask('shortDate',
                                             pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)
								)
	INTO STRICT   dt_formato_date_w 
	;
	
	dt_sinal_vital_w := dt_sinal_vital_p;
	
	if (to_char(dt_sinal_vital_p, dt_formato_date_w) <> to_char(clock_timestamp(), dt_formato_date_w)) then
		SELECT to_date((TO_char(clock_timestamp(),dt_formato_date_w)
		                || SUBSTR(TO_char(dt_sinal_vital_p, dt_formato_date_time_w),11,19)),dt_formato_date_time_w) 
		                dt_sinal_vital
		into STRICT dt_sinal_vital_w
		;
	end if;
	
	insert into atendimento_sinal_vital(
		nr_sequencia,  
		nr_atendimento,  
		dt_sinal_vital,  
		dt_atualizacao,
		dt_liberacao,
		nm_usuario,
		cd_pessoa_fisica,		
		qt_temp,
		qt_freq_cardiaca,
		qt_pa_sistolica,
		qt_pa_diastolica,
		qt_glicemia_capilar,
		qt_insulina,
		qt_glicose_adm,
		ie_situacao
	) values ( 
		nr_seq_sinal_vital_p,
		nr_atendimento_p, 
		dt_sinal_vital_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		obter_pf_usuario(nm_usuario_p, 'C'),		
		qt_temperatura_axiliar_p,
		qt_pulso_p,
		qt_pa_sistolica_p,
		qt_pa_diastolica_p,
		qt_dextro_p,
		qt_insulina_p,
		qt_glicose_adm_p,
		'A'
	);
		
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_ins_sinal_vital_controle ( nr_atendimento_p bigint, qt_temperatura_axiliar_p bigint, qt_pulso_p bigint, qt_pa_sistolica_p bigint, qt_pa_diastolica_p bigint, qt_dextro_p bigint, qt_insulina_p bigint, qt_glicose_adm_p bigint, nr_seq_sinal_vital_p INOUT bigint, dt_sinal_vital_p timestamp, nm_usuario_p text) FROM PUBLIC;

