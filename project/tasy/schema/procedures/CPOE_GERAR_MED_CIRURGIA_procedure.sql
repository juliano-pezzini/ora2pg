-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_med_cirurgia ( NR_ATENDIMENTO_P atendimento_paciente.nr_atendimento%type, NR_SEQ_MAT_CPOE_P cpoe_material.nr_sequencia%type, NR_SEQ_MAT_CPOE_NEW_P INOUT cpoe_material.nr_sequencia%type, NR_SEQ_CPOE_RP_P cpoe_material.nr_seq_cpoe_rp%type default null, NR_SEQ_CPOE_ORDER_UNIT_P cpoe_material.nr_seq_cpoe_order_unit%type default null) AS $body$
BEGIN

  if (NR_SEQ_MAT_CPOE_P > 0) THEN
    NR_SEQ_MAT_CPOE_NEW_P := CPOE_DUPLICAR_REGISTRO('CPOE_MATERIAL', wheb_usuario_pck.get_nm_usuario, NR_SEQ_MAT_CPOE_P, NR_SEQ_MAT_CPOE_NEW_P);
    CALL CPOE_ATUALIZAR_DATA_AGORA(NR_ATENDIMENTO_P, NR_SEQ_MAT_CPOE_NEW_P, 'M',  trunc(clock_timestamp() + interval '1 days'/24, 'hh24'), wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, null, 'N');

    UPDATE cpoe_material 
      SET cd_funcao_origem = 2314,
          nm_usuario_nrec = wheb_usuario_pck.get_nm_usuario,
          dt_suspensao  = NULL,
          dt_lib_suspensao  = NULL,
          nm_usuario_susp  = NULL,
          cd_perfil_ativo = WHEB_USUARIO_PCK.GET_CD_PERFIL,
          nr_seq_cpoe_anterior  = NULL,
          nr_seq_cpoe_rp = NR_SEQ_CPOE_RP_P,
          nr_seq_cpoe_order_unit = NR_SEQ_CPOE_ORDER_UNIT_P
    where nr_sequencia = NR_SEQ_MAT_CPOE_NEW_P;
    COMMIT;
  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_med_cirurgia ( NR_ATENDIMENTO_P atendimento_paciente.nr_atendimento%type, NR_SEQ_MAT_CPOE_P cpoe_material.nr_sequencia%type, NR_SEQ_MAT_CPOE_NEW_P INOUT cpoe_material.nr_sequencia%type, NR_SEQ_CPOE_RP_P cpoe_material.nr_seq_cpoe_rp%type default null, NR_SEQ_CPOE_ORDER_UNIT_P cpoe_material.nr_seq_cpoe_order_unit%type default null) FROM PUBLIC;
