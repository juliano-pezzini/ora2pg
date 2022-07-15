-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integrar_infusao_bb ( nr_atendimento_p bigint, nr_sequencia_p bigint, nr_seq_solucao_p bigint, nr_prescricao_p bigint, ie_tipo_dosagem_p text, qt_vel_infusao_p bigint, ie_evento_p text ) AS $body$
DECLARE


    json_aux_bb         philips_json;
    json_label          philips_json_list;
    json_label_aux_bb   philips_json;
    json_cell           philips_json_list;
    json_cell_aux_bb    philips_json;

    envio_integracao_bb text;
    retorno_integracao_bb text;

    bb_count_readmissao bigint := 0;
    cd_setor_atendimento_anterior atend_paciente_unidade.cd_setor_atendimento%type;

    result_item_c CURSOR FOR
      SELECT  m.cd_material, 
              aft.ie_variavel
      FROM    prescr_material pm,
              material m,
              algoritmos_var_ficha_tec aft
      WHERE   pm.cd_material = m.cd_material
      AND     m.nr_seq_ficha_tecnica = aft.nr_seq_ficha_tecnica
      AND     coalesce(dt_suspensao::text, '') = ''
      AND     nr_sequencia_solucao = nr_seq_solucao_p
      AND     nr_prescricao = nr_prescricao_p;

BEGIN
  json_aux_bb := philips_json();
  json_label := philips_json_list();
  json_cell := philips_json_list();

  json_aux_bb.put('typeID', 'VSIFS');
  json_aux_bb.put('messageDateTime', TO_CHAR((CURRENT_TIMESTAMP AT TIME ZONE 'UTC'), 'YYYY-MM-DD HH24:MI:SS.SSSSS'));
  json_aux_bb.put('plCategoryObjectID', '4cc5ae8ab8de6c88078d83bb56dd7d5c');
  json_aux_bb.put('plCategoryName', 'Continuous Infusions');

  

  json_aux_bb.put('patientHealthSystemStayID', LPAD(nr_atendimento_p, 32, 0));
  json_aux_bb.put('columnDate', TO_CHAR(f_extract_utc_bb(CURRENT_TIMESTAMP), 'YYYY-MM-DD"T"HH24:MI'));
  json_aux_bb.put('columnDateGMTOffset', '0');

  FOR item IN result_item_c LOOP
    json_label_aux_bb := philips_json();
    json_cell_aux_bb := philips_json();

    json_label_aux_bb.put('objectID', LPAD(item.cd_material, 32, 0));
    CASE
      WHEN coalesce(item.ie_variavel::text, '') = '' THEN
        json_label_aux_bb.put('label', 'Other');
      WHEN item.ie_variavel = 1 THEN
        json_label_aux_bb.put('label', 'Dobutamine');
      WHEN item.ie_variavel = 2 THEN
        json_label_aux_bb.put('label', 'Dopamine');
      WHEN item.ie_variavel = 3 THEN
        json_label_aux_bb.put('label', 'Epinephrine');
      WHEN item.ie_variavel = 4 THEN
        json_label_aux_bb.put('label', 'Isoproterenol');
      WHEN item.ie_variavel = 5 THEN
        json_label_aux_bb.put('label', 'Norepinephrine');
      WHEN item.ie_variavel = 6 THEN
        json_label_aux_bb.put('label', 'Milrinone');
      WHEN item.ie_variavel = 7 THEN
        json_label_aux_bb.put('label', 'Phenylephrine');
      WHEN item.ie_variavel = 8 THEN
        json_label_aux_bb.put('label', 'Vasopressin');
      WHEN item.ie_variavel = 9 THEN
        json_label_aux_bb.put('label', 'Nitroglycerin');
      WHEN item.ie_variavel = 10 THEN
        json_label_aux_bb.put('label', 'Nicardipine');
      WHEN item.ie_variavel = 11 THEN
        json_label_aux_bb.put('label', 'Labetalol');
      WHEN item.ie_variavel = 12 THEN
        json_label_aux_bb.put('label', 'Nitroprusside');
      WHEN item.ie_variavel = 13 THEN
        json_label_aux_bb.put('label', 'Vecuronium');
      WHEN item.ie_variavel = 14 THEN
        json_label_aux_bb.put('label', 'Rocuronium');
      WHEN item.ie_variavel = 15 THEN
        json_label_aux_bb.put('label', 'Pancuronium');
      WHEN item.ie_variavel = 16 THEN
        json_label_aux_bb.put('label', 'Cistracurium');
      WHEN item.ie_variavel = 17 THEN
        json_label_aux_bb.put('label', 'Atracurium');
      WHEN item.ie_variavel = 18 THEN
        json_label_aux_bb.put('label', 'Fentanyl');
      WHEN item.ie_variavel = 19 THEN
        json_label_aux_bb.put('label', 'Hydromorphone');
      WHEN item.ie_variavel = 20 THEN
        json_label_aux_bb.put('label', 'Morphine');
      WHEN item.ie_variavel = 21 THEN
        json_label_aux_bb.put('label', 'Meperidine');
      WHEN item.ie_variavel = 22 THEN
        json_label_aux_bb.put('label', 'Lorazepam');
      WHEN item.ie_variavel = 23 THEN
        json_label_aux_bb.put('label', 'Midazolam');
      WHEN item.ie_variavel = 24 THEN
        json_label_aux_bb.put('label', 'Dexmedetomidine');
      WHEN item.ie_variavel = 25 THEN
        json_label_aux_bb.put('label', 'Propofol');
      WHEN item.ie_variavel = 26 THEN
        json_label_aux_bb.put('label', 'Fospropofol');
      WHEN item.ie_variavel = 27 THEN
        json_label_aux_bb.put('label', 'Remifentanyl');
      ELSE
        json_label_aux_bb.put('label', 'Other');
    END CASE;
    json_label.append(json_label_aux_bb.to_json_value());

    json_cell_aux_bb.put('cellLabelID', LPAD(item.cd_material, 32, 0));
    json_cell_aux_bb.put('cellTypeCatID', '4cc5ae8ab8de6c88078d83bb56dd7d5c');
    json_cell_aux_bb.put('cellResultStatusID', '9ef5ea20a97045fcb26dc3fcb86b6c24');
    json_cell_aux_bb.put('attributeObjectID', LPAD(nr_sequencia_p, 32, 0));
    json_cell_aux_bb.put('attributeCellTypeValueID', '8560399070e94d7488b4be3b8912fc5b');
    json_cell_aux_bb.put('attributeResultStatusID', '39d8f36dc43045c8b04a0a06f20b6351');
    json_cell_aux_bb.put('attributeUnitsID', '37e41851a3cc46238f37bd8386bccadf');

    IF (ie_evento_p = 'F') THEN
      json_cell_aux_bb.put('attributeValue', '0');
    ELSE
      IF (ie_tipo_dosagem_p = 'gtm') THEN
        json_cell_aux_bb.put('attributeValue', TO_CHAR(qt_vel_infusao_p * 60 / 20, 'FM99999999999999990D99999', 'NLS_NUMERIC_CHARACTERS =''.,'''));
      ELSE
        json_cell_aux_bb.put('attributeValue', TO_CHAR(qt_vel_infusao_p, 'FM99999999999999990D99999', 'NLS_NUMERIC_CHARACTERS =''.,'''));
      END IF;
    END IF;


    json_cell.append(json_cell_aux_bb.to_json_value());

  END LOOP;

  IF (json_label.count > 0) THEN

    json_aux_bb.put('labels', json_label);
    json_aux_bb.put('cells', json_cell);
    dbms_lob.createtemporary(envio_integracao_bb, TRUE);
    json_aux_bb.(envio_integracao_bb);

    SELECT BIFROST.SEND_INTEGRATION_CONTENT('Blackboard_Continuous_Infusion',envio_integracao_bb,wheb_usuario_pck.get_nm_usuario) into STRICT retorno_integracao_bb;

  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integrar_infusao_bb ( nr_atendimento_p bigint, nr_sequencia_p bigint, nr_seq_solucao_p bigint, nr_prescricao_p bigint, ie_tipo_dosagem_p text, qt_vel_infusao_p bigint, ie_evento_p text ) FROM PUBLIC;

