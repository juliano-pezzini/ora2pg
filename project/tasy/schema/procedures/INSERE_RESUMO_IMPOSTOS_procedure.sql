-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insere_resumo_impostos ( NR_SEQ_CONTA_PAC_RESUMO_P CONTA_PACIENTE_RESUMO_IMP.NR_SEQ_CONTA_PAC_RESUMO%TYPE, NR_INTERNO_CONTA_P CONTA_PACIENTE_RESUMO_IMP.NR_INTERNO_CONTA%TYPE, CD_TRIBUTO_P CONTA_PACIENTE_RESUMO_IMP.CD_TRIBUTO%TYPE, VL_IMPOSTO_P CONTA_PACIENTE_RESUMO_IMP.VL_IMPOSTO%TYPE, CD_CONVENIO_PARAMETRO_P CONTA_PACIENTE_RESUMO_IMP.CD_CONVENIO_PARAMETRO%TYPE, CD_PROCEDIMENTO_P CONTA_PACIENTE_RESUMO_IMP.CD_PROCEDIMENTO%TYPE, CD_MATERIAL_P CONTA_PACIENTE_RESUMO_IMP.CD_MATERIAL%TYPE, IE_ORIGEM_PROCED_P CONTA_PACIENTE_RESUMO_IMP.IE_ORIGEM_PROCED%TYPE DEFAULT NULL) AS $body$
DECLARE


nm_usuario_s     constant    conta_paciente_resumo_imp.nm_usuario%type := 'BACA_CALC_IMP';
dt_atualizacao_s constant    conta_paciente_resumo_imp.dt_atualizacao%type := clock_timestamp();


BEGIN

INSERT INTO CONTA_PACIENTE_RESUMO_IMP(
   NR_SEQUENCIA,
   DT_ATUALIZACAO,
   DT_ATUALIZACAO_NREC,
   NM_USUARIO,
   NM_USUARIO_NREC,
   NR_SEQ_CONTA_PAC_RESUMO,
   NR_INTERNO_CONTA,
   CD_TRIBUTO,
   VL_IMPOSTO,
   CD_CONVENIO_PARAMETRO,
   CD_MATERIAL,
   CD_PROCEDIMENTO,
   IE_ORIGEM_PROCED
  )
VALUES (
   nextval('conta_paciente_resumo_imp_seq'),
   dt_atualizacao_s,
   dt_atualizacao_s,
   nm_usuario_s,
   nm_usuario_s,
   NR_SEQ_CONTA_PAC_RESUMO_P,
   NR_INTERNO_CONTA_P,
   CD_TRIBUTO_P,
   VL_IMPOSTO_P,
   CD_CONVENIO_PARAMETRO_P,
   CD_MATERIAL_P,
   CD_PROCEDIMENTO_P,
   IE_ORIGEM_PROCED_P
  );

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insere_resumo_impostos ( NR_SEQ_CONTA_PAC_RESUMO_P CONTA_PACIENTE_RESUMO_IMP.NR_SEQ_CONTA_PAC_RESUMO%TYPE, NR_INTERNO_CONTA_P CONTA_PACIENTE_RESUMO_IMP.NR_INTERNO_CONTA%TYPE, CD_TRIBUTO_P CONTA_PACIENTE_RESUMO_IMP.CD_TRIBUTO%TYPE, VL_IMPOSTO_P CONTA_PACIENTE_RESUMO_IMP.VL_IMPOSTO%TYPE, CD_CONVENIO_PARAMETRO_P CONTA_PACIENTE_RESUMO_IMP.CD_CONVENIO_PARAMETRO%TYPE, CD_PROCEDIMENTO_P CONTA_PACIENTE_RESUMO_IMP.CD_PROCEDIMENTO%TYPE, CD_MATERIAL_P CONTA_PACIENTE_RESUMO_IMP.CD_MATERIAL%TYPE, IE_ORIGEM_PROCED_P CONTA_PACIENTE_RESUMO_IMP.IE_ORIGEM_PROCED%TYPE DEFAULT NULL) FROM PUBLIC;
