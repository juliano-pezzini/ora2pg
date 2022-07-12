-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_qt_servico_prod ( nr_ficha_tecnica_p bigint, cd_estabelecimento_p bigint, nr_seq_componente_p bigint, dt_referencia_p timestamp, qt_producao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_servico_w		double precision;


BEGIN

if (nr_ficha_tecnica_p <> 0) and (nr_seq_componente_p <> 0) then
	begin

	select	coalesce(max(qt_item),0)
	into STRICT	qt_servico_w
	from	FICHA_TECNICA_COMP_PROD
	where	nr_ficha_tecnica	= nr_ficha_tecnica_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	nr_seq_componente	= nr_seq_componente_p
	and	qt_producao_p between qt_min_prod and qt_max_prod
	and	substr(obter_se_periodo_vigente(dt_inicio_vigencia, dt_fim_vigencia, dt_referencia_p),1,1) = 'S';
	end;
end if;

return	qt_servico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_qt_servico_prod ( nr_ficha_tecnica_p bigint, cd_estabelecimento_p bigint, nr_seq_componente_p bigint, dt_referencia_p timestamp, qt_producao_p bigint) FROM PUBLIC;
