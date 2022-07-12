-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_notes_pck.get_soap_consent ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) RETURNS varchar AS $body$
DECLARE

    ds_content_w varchar(32000);
    ds_consent_type varchar(255);
	ds_consent varchar(25000);
    ds_kinship varchar(255);
    ds_procedure varchar(255);
    ds_professional varchar(255);
    ds_title varchar(255);
   ds_explan_end varchar(255);
   ds_explan_start varchar(255);
  ds_explain_oth varchar(255);
  ds_explain_pat varchar(255);
  ds_side varchar(255);
  ds_record_date  varchar(255);

    c01 CURSOR FOR
    SELECT *
    from table(clinical_notes_pck.get_clinical_note_rule(nr_atendimento_p,ie_record_type_p,null,ie_soap_type_p,ie_stage_p));

BEGIN

 select obter_valor_dominio(3476,ie_tipo_consentimento)   ,
SUBSTR(CONVERT_LONG_TO_VARCHAR2('DS_TEXTO', 'PEP_PAC_CI', ' NR_SEQUENCIA = ' || nr_sequencia_p),1,4000),
(select DS_PARENTESCO from GRAU_PARENTESCO x where x.NR_SEQUENCIA= NR_SEQ_RELAT_RECEIVED_EXPL) ,
( SELECT ds_proc_exame FROM proc_interno pi WHERE pi.nr_sequencia = a.nr_seq_proc_interno) ,
Obter_medico_resp_atend(a.nr_atendimento,'N'),
DS_TITULO ,
pkg_date_formaters.to_varchar(a.dt_explanation_end, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
pkg_date_formaters.to_varchar(a.dt_explanation_start, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
substr(OBTER_DESC_CAMPO_GRID(336203, IE_EXPLAIN_OTHER_PERSON),1,255),
substr(OBTER_DESC_CAMPO_GRID(336203, IE_EXPLAIN_PATIENT),1,255),
obter_valor_dominio(1372,IE_LADO) ,
pkg_date_formaters.to_varchar(a.dt_atualizacao_nrec, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)
into STRICT
ds_consent_type ,
ds_consent ,
ds_kinship ,
ds_procedure ,
ds_professional ,
ds_title ,
ds_explan_end ,
ds_explan_start ,
ds_explain_oth ,
ds_explain_pat ,
ds_side ,
ds_record_date
from PEP_PAC_CI a
WHERE  nr_sequencia=nr_sequencia_p;
    for r_c01 in c01 loop
    if (ie_record_type_p = 'CONSENT') then
        if (r_c01.ie_field    = 'RECORD_DATE' and (ds_record_date IS NOT NULL AND ds_record_date::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_record_date;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_record_date;
          end if;
        end if;
        if (r_c01.ie_field    = 'DT_EXPLAN_START' and (ds_explan_start IS NOT NULL AND ds_explan_start::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explan_start;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explan_start;
          end if;
        end if;
         if (r_c01.ie_field    = 'DT_EXPLAN_END' and (ds_explan_end IS NOT NULL AND ds_explan_end::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explan_end;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explan_end;
          end if;
        end if;
        if (r_c01.ie_field    = 'DS_TITLE' and (ds_title IS NOT NULL AND ds_title::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w    := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_title;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_title;
          end if;
        end if;
        if (r_c01.ie_field   = 'DS_PROFESSIONAL' and (ds_professional IS NOT NULL AND ds_professional::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_professional;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_professional;
          end if;
        end if;
        if (r_c01.ie_field   = 'IE_EXPLAIN_PAT' and (ds_explain_pat IS NOT NULL AND ds_explain_pat::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explain_pat;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explain_pat;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_KINSHIP' and (ds_kinship IS NOT NULL AND ds_kinship::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_kinship;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_kinship;
          end if;
        end if;
		if (r_c01.ie_field   = 'CONSENT_TYPE' and (ds_consent_type IS NOT NULL AND ds_consent_type::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_consent_type;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_consent_type;
          end if;
        end if;
		if (r_c01.ie_field   = 'IE_SIDE' and (ds_side IS NOT NULL AND ds_side::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_side;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_side;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_PROCEDURE' and (ds_procedure IS NOT NULL AND ds_procedure::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_procedure;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_procedure;
          end if;
        end if;
		if (r_c01.ie_field   = 'DS_CONSENT' and (ds_consent IS NOT NULL AND ds_consent::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_consent;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_consent;
          end if;
        end if;
        if (r_c01.ie_field   = 'IE_EXPLAIN_OTH' and (ds_explain_oth IS NOT NULL AND ds_explain_oth::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(1004312) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explain_oth;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_explain_oth;
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
-- REVOKE ALL ON FUNCTION clinical_notes_pck.get_soap_consent ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type_p text, ie_stage_p bigint) FROM PUBLIC;
