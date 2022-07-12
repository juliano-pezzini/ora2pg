-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_modelo_quest_equip ( nr_seq_equipamento_p bigint, ie_tipo_ordem_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_modelo_w	bigint;


BEGIN
if (nr_seq_equipamento_p > 0) then
	select	max(nr_seq_modelo)
	into STRICT	nr_seq_modelo_w
	from	man_equipamento_quest
	where	nr_seq_equipamento = nr_seq_equipamento_p
	and	coalesce(ie_tipo_ordem, coalesce(ie_tipo_ordem_p,0)) = coalesce(ie_tipo_ordem_p,0)
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());

end if;

if (nr_seq_equipamento_p > 0) and (coalesce(nr_seq_modelo_w::text, '') = '') then
	select	max(nr_seq_modelo)
	into STRICT	nr_seq_modelo_w
	from	man_equipamento_quest
	where	nr_seq_tipo_equip = (	SELECT	nr_seq_tipo_equip
					from	man_equipamento
					where	nr_sequencia = nr_seq_equipamento_p)
	and	coalesce(ie_tipo_ordem, coalesce(ie_tipo_ordem_p,0)) = coalesce(ie_tipo_ordem_p,0)
	and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());
end if;

return	nr_seq_modelo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_modelo_quest_equip ( nr_seq_equipamento_p bigint, ie_tipo_ordem_p text) FROM PUBLIC;
