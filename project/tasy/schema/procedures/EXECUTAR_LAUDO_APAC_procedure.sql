-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_laudo_apac (nr_seq_laudo_p sus_laudo_paciente.nr_laudo_sus%type, nm_usuario_p sus_laudo_paciente.nm_usuario%type) AS $body$
DECLARE


NR_INTEGRATION_CODE     constant smallint := 1000;
nr_seq_laudo_json_w     varchar(255);


BEGIN

nr_seq_laudo_json_w := '{"NrSequenciaInterno": ' || nr_seq_laudo_p || '}';
CALL execute_bifrost_integration(NR_INTEGRATION_CODE,nr_seq_laudo_json_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_laudo_apac (nr_seq_laudo_p sus_laudo_paciente.nr_laudo_sus%type, nm_usuario_p sus_laudo_paciente.nm_usuario%type) FROM PUBLIC;
