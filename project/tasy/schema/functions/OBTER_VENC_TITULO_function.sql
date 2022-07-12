-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_venc_titulo (nr_titulo_pagar_p bigint, nr_titulo_receber_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w		timestamp;

cd_estabelecimento_w	smallint;
dt_vencimento_w		timestamp;
ie_tratar_fim_semana_w	varchar(1);
qt_dia_tit_rec_bloqueto_w	smallint;


BEGIN


if (nr_titulo_pagar_p IS NOT NULL AND nr_titulo_pagar_p::text <> '') then

	begin
	select	trunc(CASE WHEN coalesce(b.ie_tratar_fim_semana, 'S')='N' THEN  a.dt_vencimento_atual  ELSE obter_proximo_dia_util(a.cd_estabelecimento, a.dt_vencimento_atual) END ,'dd')
	into STRICT	dt_retorno_w
	FROM titulo_pagar a
LEFT OUTER JOIN parametro_fluxo_caixa b ON (a.cd_estabelecimento = b.cd_estabelecimento)
WHERE a.nr_titulo		= nr_titulo_pagar_p;
	exception
		when others then
			dt_retorno_w	:= null;
	end;

elsif (nr_titulo_receber_p IS NOT NULL AND nr_titulo_receber_p::text <> '') then
	begin
	begin
	select	trunc(coalesce(a.dt_pagamento_previsto, a.dt_vencimento),'dd'),
		cd_estabelecimento
	into STRICT	dt_vencimento_w,
		cd_estabelecimento_w
	from	titulo_receber a
	where	nr_titulo = nr_titulo_receber_p;
	exception
	when others then
		dt_vencimento_w := null;
	end;

	select	coalesce(max(qt_dia_tit_rec_bloqueto),0),
		coalesce(max(ie_tratar_fim_semana),'N')
	into STRICT	qt_dia_tit_rec_bloqueto_w,
		ie_tratar_fim_semana_w
	from	parametro_fluxo_caixa
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ie_tratar_fim_semana_w = 'S') then
		dt_vencimento_w := obter_proximo_dia_util(cd_estabelecimento_w, dt_vencimento_w);
	end if;

	if (qt_dia_tit_rec_bloqueto_w > 0) then
		dt_vencimento_w := dt_vencimento_w + qt_dia_tit_rec_bloqueto_w;
	end if;

	dt_retorno_w := dt_vencimento_w;
	end;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_venc_titulo (nr_titulo_pagar_p bigint, nr_titulo_receber_p bigint) FROM PUBLIC;

