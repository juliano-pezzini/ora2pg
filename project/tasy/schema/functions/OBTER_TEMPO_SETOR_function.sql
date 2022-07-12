-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_setor (dt_inicial_p timestamp, dt_final_p timestamp, nr_atendimento_p bigint, cd_setor_atend_p bigint) RETURNS varchar AS $body$
DECLARE


qt_tempo_w		bigint;
dt_entrada_min_w	timestamp;
dif_data_w		varchar(100);


BEGIN

select	sum((coalesce(dt_saida_unidade,clock_timestamp()) - dt_entrada_unidade)*1440)
into STRICT	qt_tempo_w
from	atend_paciente_unidade
where	nr_atendimento = nr_atendimento_p
and	cd_setor_atendimento = cd_setor_atend_p
and	dt_entrada_unidade between dt_inicial_p and coalesce(dt_final_p,clock_timestamp());

select	min(dt_entrada_unidade)
into STRICT	dt_entrada_min_w
from	atend_paciente_unidade
where	nr_atendimento = nr_atendimento_p
and	cd_setor_atendimento = cd_setor_atend_p
and	dt_entrada_unidade between dt_inicial_p and coalesce(dt_final_p,clock_timestamp());

dif_data_w := substR(Obter_Dias_Entre_Datas_hora(dt_entrada_min_w, dt_entrada_min_w + (qt_tempo_w/1440)),1,20);

return	dif_data_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_setor (dt_inicial_p timestamp, dt_final_p timestamp, nr_atendimento_p bigint, cd_setor_atend_p bigint) FROM PUBLIC;
