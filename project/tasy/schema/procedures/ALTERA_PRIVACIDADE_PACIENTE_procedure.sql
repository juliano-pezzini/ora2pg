-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_privacidade_paciente (p_nm_usuario text, p_nr_atendimento bigint) AS $body$
BEGIN
  CALL audio_video_pck.change_privacity(p_nm_usuario, p_nr_atendimento);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_privacidade_paciente (p_nm_usuario text, p_nr_atendimento bigint) FROM PUBLIC;
