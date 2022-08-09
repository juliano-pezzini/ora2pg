-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_procedimento_onc ( nr_atendimento_p bigint, nr_seq_paciente_p bigint) AS $body$
DECLARE

  cd_protocolo_w        paciente_setor.cd_protocolo%type;
  nr_seq_medicacao_w    paciente_setor.nr_seq_medicacao%type;
  cd_convenio_w         atend_categoria_convenio.cd_convenio%type;
  qt_regra_w            bigint;

BEGIN
  null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_procedimento_onc ( nr_atendimento_p bigint, nr_seq_paciente_p bigint) FROM PUBLIC;
