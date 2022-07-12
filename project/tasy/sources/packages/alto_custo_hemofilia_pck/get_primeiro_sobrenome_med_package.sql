-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_hemofilia_pck.get_primeiro_sobrenome_med (nr_atendimento_p atendimento_paciente.nr_atendimento%type) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w varchar(255);

BEGIN
    begin
      select  alto_custo_pck.get_primeiro_sobrenome(a.cd_medico_resp)
      into STRICT    ds_retorno_w
      from    atendimento_paciente a
      where   a.nr_atendimento = nr_atendimento_p;
    exception
      when no_data_found then
        ds_retorno_w := '';
    end;

    return ds_retorno_w;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_hemofilia_pck.get_primeiro_sobrenome_med (nr_atendimento_p atendimento_paciente.nr_atendimento%type) FROM PUBLIC;
