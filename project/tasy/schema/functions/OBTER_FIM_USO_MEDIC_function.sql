-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_fim_uso_medic ( nr_seq_medic_p bigint) RETURNS varchar AS $body$
DECLARE


ie_uso_continuo_w	varchar(1);
dt_inicio_w		timestamp;
nr_dias_uso_w		integer;
dt_suspensao_w		timestamp;
ds_retorno_w		varchar(255);


BEGIN

select	ie_uso_continuo,
	dt_inicio,
	nr_dias_uso,
	dt_suspensao
into STRICT	ie_uso_continuo_w,
	dt_inicio_w,
	nr_dias_uso_w,
	dt_suspensao_w
from	medic_uso_continuo
where	nr_sequencia	= nr_seq_medic_p;

if (dt_suspensao_w IS NOT NULL AND dt_suspensao_w::text <> '') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309111); -- Suspenso
elsif (ie_uso_continuo_w = 'S') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309113); -- Uso contínuo
elsif (ie_uso_continuo_w = 'N') then
	dt_inicio_w	:= dt_inicio_w + nr_dias_uso_w;
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(309114, 'DT_INICIO=' || to_char(dt_inicio_w, 'dd/mm/yyyy')); -- Usar até o dia #@DT_INICIO#@
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_fim_uso_medic ( nr_seq_medic_p bigint) FROM PUBLIC;
