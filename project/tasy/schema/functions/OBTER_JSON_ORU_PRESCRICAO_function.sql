-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_json_oru_prescricao ( nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_seq_exame_p prescr_procedimento.nr_seq_exame%type, nr_sequencia_p prescr_procedimento.nr_sequencia%type, ie_status_atend_p prescr_procedimento.ie_status_atend%type) RETURNS varchar AS $body$
DECLARE


nr_prescricao_w         prescr_medica.nr_prescricao%type;
visit_id_w              prescr_medica.nr_atendimento%type;
nr_seq_exame_w          exame_laboratorio.nr_seq_exame%type;
cd_estabelecimento_w    prescr_medica.cd_estabelecimento%type;
exam_date_w             varchar(30);
dt_prescricao_w         varchar(30);
dt_envio_w              varchar(30);
exam_value_w            varchar(4000);
unit_of_measure_w       varchar(40);
nm_exame_w              exame_laboratorio.nm_exame%type;
exam_code_w             lab_exame_equip.cd_exame_equip%type;
patient_id_w            prescr_medica.cd_pessoa_fisica%type;
patientname_w           varchar(60);
patientbirthdate_w      varchar(14);



BEGIN

declare
	json_aux_w   philips_json;
	ds_message_w text;

begin
	json_aux_w := philips_json();

	begin
                select  a.cd_pessoa_fisica,
                        obter_nome_pf(a.cd_pessoa_fisica),
                        to_char(obter_data_nascto_pf(a.cd_pessoa_fisica),'YYYYMMDDHH24MISS'),
                        a.nr_atendimento,
                        a.nr_prescricao,
                        to_char(a.dt_prescricao ,'YYYYMMDDHH24MISS'),
                        elab.nm_exame,
                        to_char(elri.dt_coleta ,'YYYYMMDDHH24MISS'),
                        elab.nr_seq_exame,
                        lee.cd_exame_equip,
                        lab_obter_resultado_exame(elri.nr_seq_resultado,elri.nr_sequencia),
                        lab_obter_unidade_medida(elab.nr_seq_unid_med),
                        a.cd_estabelecimento,
                        to_char(clock_timestamp(),'YYYYMMDDHH24MISS')
		into STRICT    patient_id_w,
                        patientname_w,
                        patientbirthdate_w,
                        visit_id_w,
                        nr_prescricao_w,
                        dt_prescricao_w,
                        nm_exame_w,
                        exam_date_w,
                        nr_seq_exame_w,
                        exam_code_w,
                        exam_value_w,
                        unit_of_measure_w,
                        cd_estabelecimento_w,
                        dt_envio_w
		from    prescr_medica a
		inner join lab_exame_equip lee on lee.nr_seq_exame = nr_seq_exame_p
		inner join equipamento_lab el on el.cd_equipamento = lee.cd_equipamento and el.ds_sigla = 'EPIMED'
		inner join exame_lab_resultado elr on elr.nr_prescricao = nr_prescricao_p
		inner join exame_lab_result_item elri on elri.nr_seq_resultado = elr.nr_seq_resultado  and elri.nr_seq_prescr = nr_sequencia_p
		inner join material_exame_lab mel on mel.nr_sequencia = elri.nr_seq_material
		inner join exame_laboratorio elab on elab.nr_seq_exame = nr_seq_exame_p
		where   ie_status_atend_p>=35
		and     nr_prescricao_p = a.nr_prescricao
		and     a.CD_SETOR_ATENDIMENTO in (
                                SELECT  b.cd_setor_atendimento
                                from    SETOR_ATENDIMENTO b 
                                where   b.IE_EPIMED = 'S' 
                                and     b.ie_situacao = 'A' 
                                and     b.cd_setor_atendimento = a.cd_setor_atendimento)
		and	(((SELECT abs(coalesce(max(j.nr_min_mov_epimed),0)) from parametro_Atendimento j) = 0) 
			or (obter_data_entrada_setor(a.nr_atendimento) >= clock_timestamp() - (select abs(coalesce(max(j.nr_min_mov_epimed),0)) from parametro_Atendimento j)/1440))
		and     (elri.nr_seq_material IS NOT NULL AND elri.nr_seq_material::text <> '');

		json_aux_w.put('PATIENTID', patient_id_w);
		json_aux_w.put('PATIENTNAME', patientname_w);
		json_aux_w.put('BIRTHDATE', patientbirthdate_w);
		json_aux_w.put('VISIT_ID', visit_id_w);
		json_aux_w.put('NR_PRESCRICAO', nr_prescricao_w);
		json_aux_w.put('DT_PRESCRICAO',dt_prescricao_w);
		json_aux_w.put('EXAM_CODE',exam_code_w);
		json_aux_w.put('EXAM_NAME',nm_exame_w);
		json_aux_w.put('EXAM_VALUE',exam_value_w);
		json_aux_w.put('UNIT_OF_MEASURE',unit_of_measure_w);
		json_aux_w.put('EXAM_DATE',exam_date_w);
                json_aux_w.put('ESTABLISHMENTID',cd_estabelecimento_w);
		json_aux_w.put('SEND_DATE',dt_envio_w);

		dbms_lob.createtemporary(ds_message_w, TRUE);
		json_aux_w.(ds_message_w);

	exception
		when no_data_found OR too_many_rows then
			ds_message_w := '';
	end;

	return ds_message_w;
	end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_json_oru_prescricao ( nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_seq_exame_p prescr_procedimento.nr_seq_exame%type, nr_sequencia_p prescr_procedimento.nr_sequencia%type, ie_status_atend_p prescr_procedimento.ie_status_atend%type) FROM PUBLIC;

