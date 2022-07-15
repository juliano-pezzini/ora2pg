-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_add_fav_gasoterapia ( nr_seq_xml_p cpoe_parse_xml.nr_sequencia%type, nm_usuario_p cpoe_parse_xml.nm_usuario%type) AS $body$
DECLARE

				
cd_intervalo_w				cpoe_fav_gasoterapia.cd_intervalo%type;
cd_intervalo_mat1_w			cpoe_fav_gasoterapia.cd_intervalo_mat1%type;
cd_intervalo_mat2_w			cpoe_fav_gasoterapia.cd_intervalo_mat2%type;
cd_intervalo_mat3_w			cpoe_fav_gasoterapia.cd_intervalo_mat3%type;
cd_mat_equip1_w				cpoe_fav_gasoterapia.cd_mat_equip1%type;
cd_mat_equip2_w				cpoe_fav_gasoterapia.cd_mat_equip2%type;
cd_mat_equip3_w				cpoe_fav_gasoterapia.cd_mat_equip3%type;
cd_modalidade_vent_w		cpoe_fav_gasoterapia.cd_modalidade_vent%type;
cd_unid_med_dose1_w			cpoe_fav_gasoterapia.cd_unid_med_dose1%type;
cd_unid_med_dose2_w			cpoe_fav_gasoterapia.cd_unid_med_dose2%type;
cd_unid_med_dose3_w			cpoe_fav_gasoterapia.cd_unid_med_dose3%type;
ds_observacao_w				cpoe_fav_gasoterapia.ds_observacao%type;
dt_tempo_duracao_w			cpoe_fav_gasoterapia.dt_tempo_duracao%type;
ie_acm_w					cpoe_fav_gasoterapia.ie_acm%type;
ie_administracao_w			cpoe_fav_gasoterapia.ie_administracao%type;
ie_disp_resp_esp_w			cpoe_fav_gasoterapia.ie_disp_resp_esp%type;
ie_duracao_w				cpoe_fav_gasoterapia.ie_duracao%type;
ie_evento_unico_w			cpoe_fav_gasoterapia.ie_evento_unico%type;
ie_inicio_w					cpoe_fav_gasoterapia.ie_inicio%type;
ie_modo_adm_w				cpoe_fav_gasoterapia.ie_modo_adm%type;
ie_periodo_w				cpoe_fav_gasoterapia.ie_periodo%type;
ie_respiracao_w				cpoe_fav_gasoterapia.ie_respiracao%type;
ie_se_necessario_w			cpoe_fav_gasoterapia.ie_se_necessario%type;
ie_tipo_onda_w				cpoe_fav_gasoterapia.ie_tipo_onda%type;
ie_unidade_medida_w			cpoe_fav_gasoterapia.ie_unidade_medida%type;
ie_urgencia_w				cpoe_fav_gasoterapia.ie_urgencia%type;
ie_via_aplic1_w				cpoe_fav_gasoterapia.ie_via_aplic1%type;
ie_via_aplic2_w				cpoe_fav_gasoterapia.ie_via_aplic2%type;
ie_via_aplic3_w				cpoe_fav_gasoterapia.ie_via_aplic3%type;
nr_seq_gas_w				cpoe_fav_gasoterapia.nr_seq_gas%type;
qt_acima_peep_w				cpoe_fav_gasoterapia.qt_acima_peep%type;
qt_be_w						cpoe_fav_gasoterapia.qt_be%type;
qt_bic_w					cpoe_fav_gasoterapia.qt_bic%type;
qt_dose_mat1_w				cpoe_fav_gasoterapia.qt_dose_mat1%type;
qt_dose_mat2_w				cpoe_fav_gasoterapia.qt_dose_mat2%type;
qt_dose_mat3_w				cpoe_fav_gasoterapia.qt_dose_mat3%type;
qt_fluxo_insp_w				cpoe_fav_gasoterapia.qt_fluxo_insp%type;
qt_freq_vent_w				cpoe_fav_gasoterapia.qt_freq_vent%type;
qt_gasoterapia_w			cpoe_fav_gasoterapia.qt_gasoterapia%type;
qt_min_intervalo_w			cpoe_fav_gasoterapia.qt_min_intervalo%type;
qt_pco2_w					cpoe_fav_gasoterapia.qt_pco2%type;
qt_peep_w					cpoe_fav_gasoterapia.qt_peep%type;
qt_ph_w						cpoe_fav_gasoterapia.qt_ph%type;
qt_pip_w					cpoe_fav_gasoterapia.qt_pip%type;
qt_ps_w						cpoe_fav_gasoterapia.qt_ps%type;
qt_referencia_w				cpoe_fav_gasoterapia.qt_referencia%type;
qt_sato2_w					cpoe_fav_gasoterapia.qt_sato2%type;
qt_sensib_resp_w			cpoe_fav_gasoterapia.qt_sensib_resp%type;
qt_tempo_insp_w				cpoe_fav_gasoterapia.qt_tempo_insp%type;
qt_ti_te_w					cpoe_fav_gasoterapia.qt_ti_te%type;
qt_vc_prog_w				cpoe_fav_gasoterapia.qt_vc_prog%type;
QT_HORA_FASE_w				cpoe_fav_gasoterapia.QT_HORA_FASE%type;
qt_fracao_oxigenio_w		cpoe_fav_gasoterapia.qt_fracao_oxigenio%type;

c01 CURSOR FOR
SELECT	ExtractValue( value( pes ) , 'JSONOBJECT/CD_INTERVALO') cd_intervalo,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_INTERVALO_MAT1') cd_intervalo_mat1,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_INTERVALO_MAT2') cd_intervalo_mat2,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_INTERVALO_MAT3') cd_intervalo_mat3,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_MAT_EQUIP1') cd_mat_equip1,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_MAT_EQUIP2') cd_mat_equip2,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_MAT_EQUIP3') cd_mat_equip3,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_MODALIDADE_VENT') cd_modalidade_vent,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_UNID_MED_DOSE1') cd_unid_med_dose1,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_UNID_MED_DOSE2') cd_unid_med_dose2,
		ExtractValue( value( pes ) , 'JSONOBJECT/CD_UNID_MED_DOSE3') cd_unid_med_dose3,
		ExtractValue( value( pes ) , 'JSONOBJECT/DS_OBSERVACAO') ds_observacao,
		ExtractValue( value( pes ) , 'JSONOBJECT/DT_TEMPO_DURACAO') dt_tempo_duracao,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_ACM') ie_acm,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_ADMINISTRACAO') ie_administracao,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_DISP_RESP_ESP') ie_disp_resp_esp,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_DURACAO') ie_duracao,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_EVENTO_UNICO') ie_evento_unico,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_INICIO') ie_inicio,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_MODO_ADM') ie_modo_adm,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_PERIODO') ie_periodo,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_RESPIRACAO') ie_respiracao,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_SE_NECESSARIO') ie_se_necessario,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_TIPO_ONDA') ie_tipo_onda,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_UNIDADE_MEDIDA') ie_unidade_medida,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_URGENCIA') ie_urgencia,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_VIA_APLIC1') ie_via_aplic1,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_VIA_APLIC2') ie_via_aplic2,
		ExtractValue( value( pes ) , 'JSONOBJECT/IE_VIA_APLIC3') ie_via_aplic3,
		ExtractValue( value( pes ) , 'JSONOBJECT/NR_SEQ_GAS') nr_seq_gas,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_ACIMA_PEEP') qt_acima_peep,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_BE') qt_be,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_BIC') qt_bic,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_DOSE_MAT1') qt_dose_mat1,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_DOSE_MAT2') qt_dose_mat2,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_DOSE_MAT3') qt_dose_mat3,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_FLUXO_INSP') qt_fluxo_insp,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_FREQ_VENT') qt_freq_vent,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_GASOTERAPIA') qt_gasoterapia,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_MIN_INTERVALO') qt_min_intervalo,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_PCO2') qt_pco2,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_PEEP') qt_peep,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_PH') qt_ph,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_PIP') qt_pip,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_PS') qt_ps,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_REFERENCIA') qt_referencia,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_SATO2') qt_sato2,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_SENSIB_RESP') qt_sensib_resp,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_TEMPO_INSP') qt_tempo_insp,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_TI_TE') qt_ti_te,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_VC_PROG') qt_vc_prog,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_HORA_FASE') QT_HORA_FASE,
		ExtractValue( value( pes ) , 'JSONOBJECT/QT_FRACAO_OXIGENIO') qt_fracao_oxigenio
from 	cpoe_parse_xml ,
		table( XMLSequence( extract( ds_xml, '/JSONOBJECT' ) ) ) pes
where	nr_sequencia  = nr_seq_xml_p;


BEGIN

open c01;
loop
fetch c01 into	cd_intervalo_w,
				cd_intervalo_mat1_w,
				cd_intervalo_mat2_w,
				cd_intervalo_mat3_w,
				cd_mat_equip1_w,
				cd_mat_equip2_w,
				cd_mat_equip3_w,
				cd_modalidade_vent_w,
				cd_unid_med_dose1_w,
				cd_unid_med_dose2_w,
				cd_unid_med_dose3_w,
				ds_observacao_w,
				dt_tempo_duracao_w,
				ie_acm_w,
				ie_administracao_w,
				ie_disp_resp_esp_w,
				ie_duracao_w,
				ie_evento_unico_w,
				ie_inicio_w,
				ie_modo_adm_w,
				ie_periodo_w,
				ie_respiracao_w,
				ie_se_necessario_w,
				ie_tipo_onda_w,
				ie_unidade_medida_w,
				ie_urgencia_w,
				ie_via_aplic1_w,
				ie_via_aplic2_w,
				ie_via_aplic3_w,
				nr_seq_gas_w,
				qt_acima_peep_w,
				qt_be_w,
				qt_bic_w,
				qt_dose_mat1_w,
				qt_dose_mat2_w,
				qt_dose_mat3_w,
				qt_fluxo_insp_w,
				qt_freq_vent_w,
				qt_gasoterapia_w,
				qt_min_intervalo_w,
				qt_pco2_w,
				qt_peep_w,
				qt_ph_w,
				qt_pip_w,
				qt_ps_w,
				qt_referencia_w,
				qt_sato2_w,
				qt_sensib_resp_w,
				qt_tempo_insp_w,
				qt_ti_te_w,
				qt_vc_prog_w,
				QT_HORA_FASE_w,
				qt_fracao_oxigenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	insert into cpoe_fav_gasoterapia(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					cd_intervalo,
					cd_intervalo_mat1,
					cd_intervalo_mat2,
					cd_intervalo_mat3,
					cd_mat_equip1,
					cd_mat_equip2,
					cd_mat_equip3,
					cd_modalidade_vent,
					cd_unid_med_dose1,
					cd_unid_med_dose2,
					cd_unid_med_dose3,
					ds_observacao,
					dt_tempo_duracao,
					ie_acm,
					ie_administracao,
					ie_disp_resp_esp,
					ie_duracao,
					ie_evento_unico,
					ie_inicio,
					ie_modo_adm,
					ie_periodo,
					ie_respiracao,
					ie_se_necessario,
					ie_tipo_onda,
					ie_unidade_medida,
					ie_urgencia,
					ie_via_aplic1,
					ie_via_aplic2,
					ie_via_aplic3,
					nr_seq_gas,
					qt_acima_peep,
					qt_be,
					qt_bic,
					qt_dose_mat1,
					qt_dose_mat2,
					qt_dose_mat3,
					qt_fluxo_insp,
					qt_freq_vent,
					qt_gasoterapia,
					qt_min_intervalo,
					qt_pco2,
					qt_peep,
					qt_ph,
					qt_pip,
					qt_ps,
					qt_referencia,
					qt_sato2,
					qt_sensib_resp,
					qt_tempo_insp,
					qt_ti_te,
					qt_vc_prog,
					QT_HORA_FASE,
					qt_fracao_oxigenio)
				values (
					nextval('cpoe_fav_gasoterapia_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					cd_intervalo_w,
					cd_intervalo_mat1_w,
					cd_intervalo_mat2_w,
					cd_intervalo_mat3_w,
					cd_mat_equip1_w,
					cd_mat_equip2_w,
					cd_mat_equip3_w,
					cd_modalidade_vent_w,
					cd_unid_med_dose1_w,
					cd_unid_med_dose2_w,
					cd_unid_med_dose3_w,
					ds_observacao_w,
					dt_tempo_duracao_w,
					ie_acm_w,
					ie_administracao_w,
					ie_disp_resp_esp_w,
					ie_duracao_w,
					ie_evento_unico_w,
					ie_inicio_w,
					ie_modo_adm_w,
					ie_periodo_w,
					ie_respiracao_w,
					ie_se_necessario_w,
					ie_tipo_onda_w,
					ie_unidade_medida_w,
					ie_urgencia_w,
					ie_via_aplic1_w,
					ie_via_aplic2_w,
					ie_via_aplic3_w,
					nr_seq_gas_w,
					qt_acima_peep_w,
					qt_be_w,
					qt_bic_w,
					qt_dose_mat1_w,
					qt_dose_mat2_w,
					qt_dose_mat3_w,
					qt_fluxo_insp_w,
					qt_freq_vent_w,
					qt_gasoterapia_w,
					qt_min_intervalo_w,
					qt_pco2_w,
					qt_peep_w,
					qt_ph_w,
					qt_pip_w,
					qt_ps_w,
					qt_referencia_w,
					qt_sato2_w,
					qt_sensib_resp_w,
					qt_tempo_insp_w,
					qt_ti_te_w,
					qt_vc_prog_w,
					QT_HORA_FASE_w,
					qt_fracao_oxigenio_w);
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_add_fav_gasoterapia ( nr_seq_xml_p cpoe_parse_xml.nr_sequencia%type, nm_usuario_p cpoe_parse_xml.nm_usuario%type) FROM PUBLIC;

