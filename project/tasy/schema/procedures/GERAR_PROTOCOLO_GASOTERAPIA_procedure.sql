-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_gasoterapia (cd_protocolo_dest_p bigint , nr_seq_destino_p bigint , item_gasoterapia_p text) AS $body$
DECLARE

 nm_usuario_w varchar(255);
 nr_sequencia_gas_w bigint;

 
  t RECORD;

BEGIN
   nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
 
   SELECT nextval('protocolo_medic_gas_seq') 
   INTO STRICT  nr_sequencia_gas_w 
;
 
   IF (item_gasoterapia_p IS NOT NULL AND item_gasoterapia_p::text <> '') THEN 
    INSERT INTO protocolo_medic_gas(cd_protocolo 
           , nr_seq_protocolo 
           , nr_sequencia 
           , dt_atualizacao 
           , nm_usuario 
           , dt_atualizacao_nrec 
           , nm_usuario_nrec 
           , ie_respiracao 
           , ie_disp_resp_esp 
           , cd_modalidade_vent 
           , nr_seq_gas 
           , ie_modo_adm 
           , ie_inicio 
           , ie_unidade_medida 
           , qt_gasoterapia 
           , qt_freq_vent 
           , ds_observacao 
           , cd_intervalo 
           , ie_rotina) 
    SELECT cd_protocolo_dest_p 
        , nr_seq_destino_p 
        , nr_sequencia_gas_w 
        , clock_timestamp() 
        , nm_usuario_w 
        , clock_timestamp() 
        , nm_usuario_w 
        , ie_respiracao 
        , ie_disp_resp_esp 
        , cd_modalidade_vent 
        , nr_seq_gas 
        , ie_modo_adm 
        , ie_inicio 
        , ie_unidade_medida 
        , qt_gasoterapia 
        , qt_freq_vent 
        , ds_observacao 
        , cd_intervalo 
        , 'N' 
    FROM  cpoe_gasoterapia 
    WHERE nr_sequencia = item_gasoterapia_p;
   END IF;
 
   FOR t IN ( 
    SELECT cd_mat_equip 
       , qt_dose 
       , cd_unid_med_dose 
     FROM (SELECT nr_sequencia 
             , cd_mat_equip1   AS cd_mat_equip 
             , qt_dose_mat1   AS qt_dose 
             , cd_unid_med_dose1 AS cd_unid_med_dose 
         FROM  cpoe_gasoterapia 
		 where	(cd_mat_equip1 IS NOT NULL AND cd_mat_equip1::text <> '') 
         
UNION
 
         SELECT nr_sequencia 
             , cd_mat_equip2   AS cd_mat_equip 
             , qt_dose_mat2   AS qt_dose 
             , cd_unid_med_dose2 AS cd_unid_med_dose 
         FROM  cpoe_gasoterapia 
		 where	(cd_mat_equip2 IS NOT NULL AND cd_mat_equip2::text <> '') 
         
UNION
 
         SELECT nr_sequencia 
             , cd_mat_equip3   AS cd_mat_equip 
             , qt_dose_mat3   AS qt_dose 
             , cd_unid_med_dose3 AS cd_unid_med_dose 
         FROM  cpoe_gasoterapia 
		 where	(cd_mat_equip3 IS NOT NULL AND cd_mat_equip3::text <> '')) alias3 
     WHERE nr_sequencia = item_gasoterapia_p 
   ) LOOP 
    CALL Incluir_prot_derivado_material( 
     cd_protocolo_dest_p, 
     nr_seq_destino_p, 
     t.cd_mat_equip, 
     NULL, 
     15, -- Material associado a gasoterapia 
     t.qt_dose, 
     NULL, 
     NULL, 
     t.cd_unid_med_dose, 
     NULL, 
     NULL, 
     NULL, 
     NULL, 
     'N', 
     'N', 
     clock_timestamp(), 
     'N', 
     'N', 
     'N', 
     'N', 
     NULL, 
     NULL, 
     NULL, 
     NULL, 
     NULL, 
     nr_sequencia_gas_w 
    );
   END LOOP;
 COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_gasoterapia (cd_protocolo_dest_p bigint , nr_seq_destino_p bigint , item_gasoterapia_p text) FROM PUBLIC;
