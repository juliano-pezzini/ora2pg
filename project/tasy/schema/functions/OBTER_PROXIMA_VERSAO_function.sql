-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proxima_versao ( dt_referencia_p timestamp, nr_seq_local_p bigint default 0, ie_opcao_retorno_p text default 'E') RETURNS varchar AS $body$
DECLARE


/*	IE_OPCAO_RETORNO_P

	E: Extenso: Atualizar o sistema com a versão do dia dd/mm/yyyy.
	A: Abreviado (só a data): dd/mm/yyyy

*/
ds_dia_versao_w			varchar(100);
ie_dia_w				smallint;
dt_referencia_w			timestamp;
dt_versao_w			timestamp;
cd_estab_w			integer;
nr_seq_versao_alteracao_w		bigint;
ds_versao_mmed_w		varchar(80);

dt_prim_versao_quinzenal_w		timestamp := to_date('08/08/2014 17:00:00','dd/mm/yyyy hh24:mi:ss');
qt_dias_desde_ult_geracao_w	bigint;


BEGIN
	cd_estab_w := wheb_usuario_pck.get_cd_estabelecimento;

	/*  Liberação das versões do Tasy de 15 em 15 dias.  */

	dt_referencia_w	:= coalesce(dt_referencia_p,clock_timestamp());

	/* tratamento para versões no final dos anos (para colocar a data fixa do ano seguinte)  TODO ANO DEVERÁ SER INSERIDO UM NOVO IF */

	if	((dt_referencia_w >= to_date('28/11/2014 17:00:00','dd/mm/yyyy hh24:mi:ss')) and (dt_referencia_w <= to_date('09/01/2015 17:59:59','dd/mm/yyyy hh24:mi:ss'))) then
		dt_versao_w := to_date('27/01/2015','dd/mm/yyyy');
	elsif	((dt_referencia_w >= to_date('23/12/2015 17:00:00','dd/mm/yyyy hh24:mi:ss')) and (dt_referencia_w <= to_date('08/01/2016 17:59:59','dd/mm/yyyy hh24:mi:ss'))) then
		dt_versao_w := to_date('26/01/2016','dd/mm/yyyy');
	else
		/* a cada ano esta parte deverá ser alterada para definir o primeiro dia de versão do ano */

		case	extract(year from dt_referencia_w)
		when	2014 then dt_prim_versao_quinzenal_w := to_date('08/08/2014 17:00:00','dd/mm/yyyy hh24:mi:ss');
		when	2015 then dt_prim_versao_quinzenal_w := to_date('09/01/2015 17:00:00','dd/mm/yyyy hh24:mi:ss');
		when	2016 then dt_prim_versao_quinzenal_w := to_date('08/01/2016 17:00:00','dd/mm/yyyy hh24:mi:ss');
		else	-- caso a data do primeiro dia da versão do ano não for definida, assumirá o primeiro dia do ano, às 17:00
			dt_prim_versao_quinzenal_w := to_date('01/01/'||to_char(dt_referencia_w,'yyyy')||' 17:00:00','dd/mm/yyyy hh24:mi:ss');
		end case;

		/* calcula quantos dias passou desde a última geração da versão */

		select	mod(trunc(dt_referencia_w) - trunc(dt_prim_versao_quinzenal_w),14)
		into STRICT	qt_dias_desde_ult_geracao_w
		;

		/* 	considerando que a versão será liberada 18 dias após a geração da versão,
			a linha abaixo adiciona à data atual a diferença entre os 18 dias e a quantidade de dias que passou desde a última geração da versão */
		dt_versao_w	:= trunc(dt_referencia_w + (18 - qt_dias_desde_ult_geracao_w));

		if (qt_dias_desde_ult_geracao_w > 0) or						-- caso não for o dia da geração da versão, ou...
			((to_char(dt_referencia_w,'hh24'))::numeric  >= 17) then 			-- for o dia da geração da versão, mas passar das 17:00
			dt_versao_w	:= dt_versao_w + 14;						-- deverá adicionar 15 dias à data da próxima liberação ao cliente.
		end if;
	end if;

	if (ie_opcao_retorno_p = 'E') then
		ds_dia_versao_w	:= wheb_mensagem_pck.get_texto(795908) || ' ' || to_char(dt_versao_w, pkg_date_formaters.localize_mask('shortDate', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario))) || '.';
	elsif (ie_opcao_retorno_p = 'A') then
		ds_dia_versao_w := to_char(dt_versao_w,'dd/mm/yyyy');
	end if;


return	ds_dia_versao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proxima_versao ( dt_referencia_p timestamp, nr_seq_local_p bigint default 0, ie_opcao_retorno_p text default 'E') FROM PUBLIC;

