-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pc_obter_precaucao ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(4000);

c0 CURSOR FOR
  SELECT  distinct b.ds_precaucao
  from  atendimento_precaucao a, cih_precaucao b
  where  a.nr_atendimento = nr_atendimento_p
  and    (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
  and    coalesce(a.dt_inativacao::text, '') = ''
  and   ((clock_timestamp() > a.dt_inicio and clock_timestamp() < a.dt_termino)
          or (coalesce(a.dt_inicio::text, '') = '' and coalesce(a.dt_termino::text, '') = '' and clock_timestamp() > a.dt_registro)
          or (clock_timestamp() > a.dt_inicio and coalesce(a.dt_termino::text, '') = ''))
  and ((coalesce(a.dt_final_precaucao::text, '') = '') or (clock_timestamp() < a.dt_final_precaucao))
  and ((coalesce(a.dt_fim_acompanhamento::text, '') = '') or (clock_timestamp() < a.dt_fim_acompanhamento))
  and b.nr_sequencia = nr_seq_precaucao;

BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

  for precaucao in c0 loop
    if (precaucao.ds_precaucao IS NOT NULL AND precaucao.ds_precaucao::text <> '') then
      ds_retorno_w := ds_retorno_w || precaucao.ds_precaucao || ', ';
    end if;
  end loop;

  if (substr((ds_retorno_w),1,length(ds_retorno_w)-2) is not null) then
    ds_retorno_w := substr((ds_retorno_w),1,length(ds_retorno_w)-2) || '.';
  else
    ds_retorno_w := substr((ds_retorno_w),1,length(ds_retorno_w)-2);
  end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pc_obter_precaucao ( nr_atendimento_p bigint) FROM PUBLIC;
