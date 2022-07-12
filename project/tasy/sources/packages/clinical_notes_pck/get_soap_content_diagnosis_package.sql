-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clinical_notes_pck.get_soap_content_diagnosis ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type text, ie_stage_p bigint) RETURNS varchar AS $body$
DECLARE

    ds_content_w    varchar(32000);
    ds_cid_doenca_w varchar(255);
    cd_doenca_w diagnostico_doenca.cd_doenca%type;
    ds_classificacao_doenca_w varchar(255);
    ds_tipo_diagnostico_w     varchar(255);
    dt_inicio_w               varchar(255);
    dt_fim_w                  varchar(255);
    ds_diagnostico_w diagnostico_doenca.ds_diagnostico%type;
    ds_lado_w          varchar(255);
    c01 CURSOR FOR
      SELECT *
      from table(clinical_notes_pck.get_clinical_note_rule(nr_atendimento_p,ie_record_type_p,null,ie_soap_type,ie_stage_p));

BEGIN
          select coalesce(get_desc_modify_disease_epc(nr_seq_disease_number,ie_side_modifier,nr_seq_jap_pref_1,nr_seq_jap_pref_2,nr_seq_jap_pref_3, nr_seq_jap_sufi_1,nr_seq_jap_sufi_2,nr_seq_jap_sufi_3),obter_desc_cid(cd_doenca)),
          cd_doenca,
          obter_valor_dominio(1372,ie_classificacao_doenca) ,
          substr(obter_tipo_diagnostico(nr_atendimento,dt_diagnostico),1,100) ,
          pkg_date_formaters.to_varchar(dt_inicio, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
          pkg_date_formaters.to_varchar(dt_fim, 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario),
          ds_diagnostico,
          obter_valor_dominio(1372,ie_lado)
        into STRICT ds_cid_doenca_w,
          cd_doenca_w,
          ds_classificacao_doenca_w,
          ds_tipo_diagnostico_w,
          dt_inicio_w,
          dt_fim_w,
          ds_diagnostico_w,
          ds_lado_w
        from diagnostico_doenca
        where nr_seq_interno   = nr_sequencia_p;
    for r_c01 in c01
    loop
      if (ie_record_type_p = 'DIAGNOSIS')then

        if (r_c01.ie_field    = 'DIAG_DESC' and (ds_cid_doenca_w IS NOT NULL AND ds_cid_doenca_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w    := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w    := ds_content_w || '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_cid_doenca_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_cid_doenca_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DIAG_CODE' and (cd_doenca_w IS NOT NULL AND cd_doenca_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_doenca_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| cd_doenca_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DIAG_CLASSIF' and (ds_classificacao_doenca_w IS NOT NULL AND ds_classificacao_doenca_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w || '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_classificacao_doenca_w;
          else
            ds_content_w := ds_content_w || '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_classificacao_doenca_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DIAG_TYPE' and (ds_tipo_diagnostico_w IS NOT NULL AND ds_tipo_diagnostico_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w || '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_tipo_diagnostico_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_tipo_diagnostico_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DT_START' and (dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w || '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| dt_inicio_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| dt_inicio_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DT_END' and (dt_fim_w IS NOT NULL AND dt_fim_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| dt_fim_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| dt_fim_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DIAG_NOTES' and (ds_diagnostico_w IS NOT NULL AND ds_diagnostico_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_diagnostico_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_diagnostico_w;
          end if;
        end if;
        if (r_c01.ie_field   = 'DIAG_SIDE' and (ds_lado_w IS NOT NULL AND ds_lado_w::text <> ''))then
          if (coalesce(ds_content_w::text, '') = '' ) then
            ds_content_w   := '<b>' || obter_desc_expressao(10652160) || '</b>';
            ds_content_w   := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_lado_w;
          else
            ds_content_w := ds_content_w|| '</br>' || coalesce(r_c01.nm_field,r_c01.ds_expressao) || ' - '|| ds_lado_w;
          end if;
        end if;
      end if;
    end loop;
    return ds_content_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clinical_notes_pck.get_soap_content_diagnosis ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_record_type_p text, ie_soap_type text, ie_stage_p bigint) FROM PUBLIC;
