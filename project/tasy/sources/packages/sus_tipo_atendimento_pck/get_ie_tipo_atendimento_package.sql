-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sus_tipo_atendimento_pck.get_ie_tipo_atendimento () RETURNS ATENDIMENTO_PACIENTE.IE_TIPO_ATENDIMENTO%TYPE AS $body$
BEGIN
        return current_setting('sus_tipo_atendimento_pck.ie_tipo_atendimento')::atendimento_paciente.ie_tipo_atendimento%type;
        end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_tipo_atendimento_pck.get_ie_tipo_atendimento () FROM PUBLIC;