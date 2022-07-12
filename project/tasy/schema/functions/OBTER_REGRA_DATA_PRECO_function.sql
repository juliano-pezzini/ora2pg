-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_data_preco ( ie_tipo_preco_p text, cd_convenio_p bigint, dt_entrada_p timestamp, dt_execucao_p timestamp, dt_alta_p timestamp, dt_conta_definitiva_p timestamp, dt_agenda_integrada_p timestamp, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_Preco_w			timestamp;
ie_regra_w			varchar(1);

c01 CURSOR FOR
	SELECT coalesce(ie_regra,'X')
	from	Convenio_regra_Data_Preco
	where 	coalesce(cd_convenio, cd_convenio_p) = cd_convenio_p
	and	ie_tipo_preco			= ie_tipo_preco_p
	order by 	coalesce(cd_convenio, 0),
		1 desc;


BEGIN
dt_preco_w			:= dt_execucao_p;

open	c01;
loop
fetch	c01 into ie_regra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ie_regra_w	:= ie_regra_w;

	end;
end loop;
close c01;

if (ie_regra_w	= 'X') then
	dt_preco_w		:= dt_execucao_p;
elsif (ie_regra_w	= 'E') then
	dt_preco_w		:= dt_entrada_p;
elsif (ie_regra_w	= 'A') then
	dt_preco_w		:= coalesce(dt_alta_p,clock_timestamp());
elsif (ie_regra_w	= 'D') then
	dt_preco_w		:= coalesce(dt_conta_definitiva_p,dt_execucao_p);
elsif (ie_regra_w	= 'G') then
	dt_preco_w		:= coalesce(dt_agenda_integrada_p,dt_execucao_p);
elsif (ie_regra_w	= 'I') then
	dt_preco_w		:= coalesce(dt_alta_p,dt_entrada_p);
elsif (ie_regra_w	= 'P') then
	dt_preco_w		:= coalesce(dt_periodo_inicial_p,clock_timestamp());
elsif (ie_regra_w	= 'F') then
	dt_preco_w		:= coalesce(dt_alta_p, coalesce(dt_periodo_final_p,clock_timestamp()));
elsif (ie_regra_w	= 'B') then
	dt_preco_w		:= coalesce(dt_periodo_final_p,clock_timestamp());
end if;

RETURN dt_preco_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_data_preco ( ie_tipo_preco_p text, cd_convenio_p bigint, dt_entrada_p timestamp, dt_execucao_p timestamp, dt_alta_p timestamp, dt_conta_definitiva_p timestamp, dt_agenda_integrada_p timestamp, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp) FROM PUBLIC;
