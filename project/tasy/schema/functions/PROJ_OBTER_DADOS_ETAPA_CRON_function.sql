-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_dados_etapa_cron ( nr_seq_etapa_cron_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*ie_opcao_p
	A = Atividade
	O = Objetivo
	E = Etapa
	U = Oficialização deu uso
	P = Percentual
	HP - Hora Prevista
	HR - Hora Real
*/
ds_atividade_w		varchar(255);
ds_objetivo_w		varchar(255);
ds_etapa_w		varchar(255);
ds_retorno_w		varchar(255);
dt_oficializacao_w		timestamp;
pr_etapa_w		double precision;
qt_hora_prev_w		double precision;
qt_hora_real_w		double precision;


BEGIN
select	ds_atividade,
	ds_etapa,
	substr(obter_desc_etapa_cronograma(nr_seq_etapa),1,100),
	pr_etapa,
	QT_HORA_PREV,
	QT_HORA_REAL
into STRICT	ds_atividade_w,
	ds_objetivo_w,
	ds_etapa_w,
	pr_etapa_w,
	qt_hora_prev_w,
	qt_hora_real_w
from	proj_cron_etapa
where	nr_sequencia	= nr_seq_etapa_cron_p;

if (ie_opcao_p	= 'A') then
	ds_retorno_w	:= ds_atividade_w;
elsif (ie_opcao_p	= 'O') then
	ds_retorno_w	:= ds_objetivo_w;
elsif (ie_opcao_p	= 'E') then
	ds_retorno_w	:= ds_etapa_w;
elsif (ie_opcao_p	= 'HP') then
	ds_retorno_w	:= qt_hora_prev_w;
elsif (ie_opcao_p	= 'HR') then
	ds_retorno_w	:= qt_hora_real_w;
elsif (ie_opcao_p	= 'P') then
	ds_retorno_w	:= pr_etapa_w;
elsif (ie_opcao_p	= 'U') then
	begin
	select	dt_oficializacao
	into STRICT	dt_oficializacao_w
	from	proj_oficializacao_uso
	where	nr_seq_etapa_cron	= nr_seq_etapa_cron_p;

	if (dt_oficializacao_w IS NOT NULL AND dt_oficializacao_w::text <> '') then
		ds_retorno_w	:= 'S';
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_dados_etapa_cron ( nr_seq_etapa_cron_p bigint, ie_opcao_p text) FROM PUBLIC;

