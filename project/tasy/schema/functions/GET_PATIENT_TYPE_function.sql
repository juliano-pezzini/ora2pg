-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_patient_type ( nr_atendimento_p bigint, cd_pessoa_fisica_p text default null) RETURNS varchar AS $body$
DECLARE

  ds_return_w varchar(10);

BEGIN
  select count(*)
  into STRICT ds_return_w
  from gestao_vaga
  where ie_status     in ('R')
  and ie_solicitacao  in ('I','TI')
  and ((nr_atendimento = nr_atendimento_p)
  or (cd_pessoa_fisica = cd_pessoa_fisica_p
  and coalesce(nr_atendimento::text, '') = ''));
  if (ds_return_w       = '0') then
    select CASE WHEN ie_tipo_atendimento=1 THEN 'IN'  ELSE 'OP' END
    into STRICT ds_return_w
    from atendimento_paciente
    where ((nr_atendimento = nr_atendimento_p)
    or (cd_pessoa_fisica   = cd_pessoa_fisica_p
    and coalesce(nr_atendimento::text, '') = ''));
    return ds_return_w;
  else
   ds_return_w := 'IN';
    return ds_return_w;
  end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_patient_type ( nr_atendimento_p bigint, cd_pessoa_fisica_p text default null) FROM PUBLIC;

