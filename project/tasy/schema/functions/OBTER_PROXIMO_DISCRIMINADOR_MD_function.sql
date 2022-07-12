-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proximo_discriminador_md (nr_classificacao_p bigint, nm_classificacao_p text, nr_sequencia_flow_p bigint) RETURNS bigint AS $body$
DECLARE


  result_w bigint;


BEGIN

  if (nr_sequencia_flow_p = 104) then
    if (nm_classificacao_p = 'LOW_URGENCY') then
      result_w := 7;
    elsif (nm_classificacao_p = 'DEATH') then
      result_w := 1;
    else
      result_w := 0;
    end if;

  elsif (nr_sequencia_flow_p = 105) then
    if (nm_classificacao_p = 'EMERGENCY') then
      result_w := 3;
    else
      result_w := nr_classificacao_p;
    end if;
  else
    result_w := nr_classificacao_p;
  end if;

  return result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proximo_discriminador_md (nr_classificacao_p bigint, nm_classificacao_p text, nr_sequencia_flow_p bigint) FROM PUBLIC;

