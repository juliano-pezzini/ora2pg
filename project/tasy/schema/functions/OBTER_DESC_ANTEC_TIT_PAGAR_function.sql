-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_antec_tit_pagar ( nr_titulo_p bigint, vl_pagamento_p bigint, dt_baixa_p timestamp) RETURNS bigint AS $body$
DECLARE


cd_tipo_taxa_antecipacao_w	bigint;
QT_DIAS_ANTECIPACAO_W		bigint;
vl_dia_antecipacao_w		double precision;
ie_desconto_dia_w		varchar(1);
ie_tipo_taxa_w			varchar(1);
tx_desc_antecipacao_w		double precision;
tx_desconto_w			double precision;
dt_limite_antecipacao_w		timestamp;
dt_vencimento_atual_w		timestamp;
vl_desconto_w			double precision;
vl_saldo_titulo_w		double precision;


BEGIN
select	cd_tipo_taxa_antecipacao,
	coalesce(vl_dia_antecipacao,0),
	coalesce(ie_desconto_dia,'N'),
	coalesce(tx_desc_antecipacao,0),
	obter_proximo_dia_util(cd_estabelecimento,coalesce(dt_limite_antecipacao, dt_vencimento_atual)),
	vl_saldo_titulo
into STRICT	cd_tipo_taxa_antecipacao_w,
	vl_dia_antecipacao_w,
	ie_desconto_dia_w,
	tx_desc_antecipacao_w,
	dt_limite_antecipacao_w,
	vl_saldo_titulo_w
from	titulo_pagar
where	nr_titulo = nr_titulo_p;

qt_dias_antecipacao_w		:=  trunc(dt_limite_antecipacao_w - dt_baixa_p);

if (vl_dia_antecipacao_w = 0) then

	select	coalesce(max(ie_tipo_taxa),null)
	into STRICT	ie_tipo_taxa_w
	from	tipo_taxa
	where	cd_tipo_taxa = cd_tipo_taxa_antecipacao_w;

	if (ie_tipo_taxa_w IS NOT NULL AND ie_tipo_taxa_w::text <> '') then
		if (ie_tipo_taxa_w = 'D') then
			tx_desconto_w	:= tx_desc_antecipacao_w;
		elsif (ie_tipo_taxa_w = 'M') then
			tx_desconto_w	:= dividir_sem_round((tx_desc_antecipacao_w)::numeric, 30);
		else
			tx_desconto_w	:= dividir_sem_round((tx_desc_antecipacao_w)::numeric, 365);
		end if;
	end if;

	tx_desconto_w		:= tx_desconto_w * qt_dias_antecipacao_w;

	vl_desconto_w		:= vl_pagamento_p * dividir_sem_round((tx_desconto_w)::numeric, 100);

else
	if (dt_baixa_p <= dt_limite_antecipacao_w) then
		if (ie_desconto_dia_w = 'S') then
			vl_desconto_w	:= vl_dia_antecipacao_w * qt_dias_antecipacao_w;
		else
			vl_desconto_w	:= vl_dia_antecipacao_w;
		end if;
	else
		vl_desconto_w	:= 0;
	end if;
end if;

if (vl_desconto_w > vl_saldo_titulo_w) then
	vl_desconto_w	:= vl_saldo_titulo_w;
end if;

if (vl_desconto_w < 0) then
	vl_desconto_w	:= 0;
end if;

RETURN 	coalesce(vl_desconto_w, 0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_antec_tit_pagar ( nr_titulo_p bigint, vl_pagamento_p bigint, dt_baixa_p timestamp) FROM PUBLIC;
