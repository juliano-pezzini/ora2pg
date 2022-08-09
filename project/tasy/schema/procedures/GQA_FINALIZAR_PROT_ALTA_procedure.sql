-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gqa_finalizar_prot_alta (nr_atendimento_p bigint ,nm_usuario_p text) AS $body$
DECLARE

  ds_motivo gqa_protocolo_pac.ds_justificativa%TYPE;

  c1 CURSOR FOR
    SELECT t.nr_sequencia
      FROM gqa_protocolo_pac t
     WHERE t.nr_atendimento = nr_atendimento_p
       AND t.ie_situacao = 'A'
       AND coalesce(t.dt_termino::text, '') = '';
BEGIN
  ds_motivo := obter_param_usuario(355, 10, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_motivo);

  FOR r1 IN c1 LOOP
    CALL gqa_finalizar_protocolo(r1.nr_sequencia, null, ds_motivo);
  END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gqa_finalizar_prot_alta (nr_atendimento_p bigint ,nm_usuario_p text) FROM PUBLIC;
