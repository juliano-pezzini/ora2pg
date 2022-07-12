-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hc_obter_dias_devolucao (dt_fim_utilizacao timestamp, dt_devolucao_equip timestamp, dt_entrega_equip timestamp) RETURNS bigint AS $body$
DECLARE


ds_retorno_w    bigint;

BEGIN

if (coalesce(dt_devolucao_equip::text, '') = ''
      and (dt_entrega_equip IS NOT NULL AND dt_entrega_equip::text <> '') ) then

   select (dt_fim_utilizacao - clock_timestamp())
   into STRICT   ds_retorno_w
;
else
  ds_retorno_w := null;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hc_obter_dias_devolucao (dt_fim_utilizacao timestamp, dt_devolucao_equip timestamp, dt_entrega_equip timestamp) FROM PUBLIC;

