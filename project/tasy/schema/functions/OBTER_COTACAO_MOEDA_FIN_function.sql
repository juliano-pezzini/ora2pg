-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cotacao_moeda_fin ( cd_moeda_p bigint, dt_cotacao_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_cotacao_w	cotacao_moeda.vl_cotacao%type;
qt_cotacao_w	double precision;


BEGIN
	if (cd_moeda_p IS NOT NULL AND cd_moeda_p::text <> '') then
		begin
					select 	a.vl_cotacao
					into STRICT 	vl_cotacao_w
					from 	cotacao_moeda a
					where 	a.cd_moeda = cd_moeda_p
					and 	to_char(a.dt_cotacao,'dd/mm/yyyy') = to_char(coalesce(dt_cotacao_p,clock_timestamp()),'dd/mm/yyyy')
					and 	a.dt_cotacao = (SELECT max(b.dt_cotacao)
											from cotacao_moeda b
											where b.cd_moeda = cd_moeda_p
											and to_char(b.dt_cotacao,'dd/mm/yyyy') = to_char(coalesce(dt_cotacao_p,clock_timestamp()),'dd/mm/yyyy'));
		end;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(339594);
	end if;

	return vl_cotacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cotacao_moeda_fin ( cd_moeda_p bigint, dt_cotacao_p timestamp) FROM PUBLIC;

