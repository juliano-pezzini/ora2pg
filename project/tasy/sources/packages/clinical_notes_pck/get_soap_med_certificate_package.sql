-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_notes_pck.get_soap_med_certificate ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) RETURNS varchar AS $body$
DECLARE

	ds_content_w varchar(32000);
    ds_atestado_date varchar(255);
    nm_physician_name_w varchar(255);
    ds_attested_days varchar(255);
    ds_end_date varchar(255);
    ds_med_dept_w varchar(255);
	ds_care_dept_w varchar(255);
	ds_insurace varchar(255);
	ds_cert_message varchar(4000);
    c01 CURSOR FOR
    SELECT *
    from table(clinical_notes_pck.get_clinical_note_rule(nr_atendimento_p,ie_record_type_p,null,ie_soap_type_p,ie_stage_p));

BEGIN

  select pkg_date_formaters.to_varchar(a.DT_ATESTADO, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
Obter_medico_resp_atend(a.nr_atendimento,'N'),
qt_dias_atestado,
pkg_date_formaters.to_varchar(a.DT_FIM, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
obter_nome_departamento_medico(a.cd_departamento),
obter_desc_setor_atend(a.cd_setor_atendimento),
(select ds_insurance_name_japanese from nais_insurance where nr_sequencia = nr_seq_nais_insurance),
SUBSTR(CONVERT_LONG_TO_VARCHAR2('DS_ATESTADO', 'ATESTADO_PACIENTE', ' NR_SEQUENCIA = ' || nr_sequencia_p),1,4000)
into STRICT
ds_atestado_date,
    nm_physician_name_w,
    ds_attested_days ,
    ds_end_date ,
    ds_med_dept_w ,
	ds_care_dept_w ,
	ds_insurace,
	ds_cert_message
from atestado_paciente a
where nr_sequencia=nr_sequencia_p;
    for r_c01 in c01 loop
    if (ie_record_type_p = 'MED_CERT') then
        if (r_c01.ie_field    = 'CD_WARD' and (ds_care_dept_w IS NOT NULL AND ds_care_dept_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_care_dept_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_care_dept_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'MED_DEPT' and (ds_med_dept_w IS NOT NULL AND ds_med_dept_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_med_dept_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_med_dept_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DS_INSURANCE' and (ds_insurace IS NOT NULL AND ds_insurace::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_insurace;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_insurace;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_CERTIFICATE' and (ds_cert_message IS NOT NULL AND ds_cert_message::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_cert_message;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_cert_message;
          end if;
        end if;
        if (r_c01.ie_field   = 'NR_DAYS_ATSTD' and (ds_attested_days IS NOT NULL AND ds_attested_days::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_attested_days;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_attested_days;
          end if;
        end if;
         if (r_c01.ie_field   = 'DT_RECORD' and (ds_atestado_date IS NOT NULL AND ds_atestado_date::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_atestado_date;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_atestado_date;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_PROFESSIONAL' and (nm_physician_name_w IS NOT NULL AND nm_physician_name_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| nm_physician_name_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| nm_physician_name_w;
          end if;
        end if;
		if (r_c01.ie_field   = 'DT_END' and (ds_end_date IS NOT NULL AND ds_end_date::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(283879) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_end_date;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_end_date;
          end if;
        end if;
      end if;
    end loop;
    return ds_content_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION clinical_notes_pck.get_soap_med_certificate ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) FROM PUBLIC;