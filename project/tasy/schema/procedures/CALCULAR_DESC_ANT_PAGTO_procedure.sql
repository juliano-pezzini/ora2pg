-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_desc_ant_pagto ( nr_titulo_p bigint, dt_Prev_Pagto_p timestamp, vl_desconto_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


vl_saldo_titulo_w                 	double precision  := 0;
vl_dia_antecipacao_w                double precision  := 0;
vl_desconto_w                		double precision  := 0;
tx_desc_antecipacao_w               double precision  := 0;
cd_tipo_taxa_antecipacao_w          bigint  := 0;
dt_limite_antecipacao_w             timestamp;
dt_vencimento_w                 	timestamp;
nr_dias_Desconto_w			integer;
ie_tipo_taxa_juros_w			varchar(1);
ie_desconto_dia_w				varchar(1);
cd_estabelecimento_w		smallint;
nr_seq_nota_fiscal_w		bigint;
pr_desc_financeiro_w		double precision;
ie_desconto_oc_w			varchar(1);


BEGIN

/* obter dados do titulo */

select	max(vl_saldo_titulo),
	max(vl_dia_antecipacao),
	max(tx_desc_antecipacao),
	max(cd_tipo_taxa_antecipacao),
	max(dt_limite_antecipacao),
	max(dt_vencimento_atual),
	coalesce(max(ie_desconto_dia),'N'),
	max(cd_estabelecimento),
	max(nr_seq_nota_fiscal)
into STRICT	vl_saldo_titulo_w,
	vl_dia_antecipacao_w,
	tx_desc_antecipacao_w,
	cd_tipo_taxa_antecipacao_w,
	dt_limite_antecipacao_w,
	dt_vencimento_w,
	ie_desconto_dia_w,
	cd_estabelecimento_w,
	nr_seq_nota_fiscal_w
from	titulo_pagar
where	nr_titulo	= nr_titulo_p;

ie_desconto_oc_w := obter_param_usuario(855, 50, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_desconto_oc_w);

/* obter nr. dias de juros  e  o tipo de taxa mensal/anual*/

select	max(ie_tipo_taxa)
into STRICT	ie_tipo_taxa_juros_w
from	tipo_taxa
where	cd_tipo_taxa	= cd_tipo_taxa_Antecipacao_w;

vl_desconto_w			:= 0;

if (coalesce(ie_desconto_oc_w,'N') = 'S') then

	select	coalesce(max(b.pr_desc_financeiro),0)
	into STRICT	pr_desc_financeiro_w
	from	ordem_compra b,
		nota_fiscal a
	where	a.nr_ordem_compra	= b.nr_ordem_compra
	and	a.nr_sequencia		= nr_seq_nota_fiscal_w;

	vl_desconto_w	:= (pr_desc_financeiro_w / 100) * vl_saldo_titulo_w;

elsif 	((coalesce(dt_limite_antecipacao_w::text, '') = '') or (dt_limite_antecipacao_w >= Trunc(dt_Prev_Pagto_p,'dd'))) or (dt_Prev_Pagto_p <= dt_vencimento_w) then
	begin
	nr_dias_desconto_w	:= dt_vencimento_w - trunc(dt_Prev_Pagto_p,'dd');
	if (vl_dia_antecipacao_w IS NOT NULL AND vl_dia_antecipacao_w::text <> '') and (vl_dia_antecipacao_w > 0) then
		begin
		if (ie_desconto_dia_w = 'S') then
			vl_desconto_w	:= vl_dia_antecipacao_w * nr_dias_desconto_w;
		else
			vl_desconto_w	:= vl_dia_antecipacao_w;
		end if;
		end;
	else if (tx_desc_antecipacao_w IS NOT NULL AND tx_desc_antecipacao_w::text <> '') then
		begin
	    	if (ie_tipo_taxa_juros_w = 'M') then
      		vl_desconto_w  := ((tx_desc_antecipacao_w/100) *
					vl_saldo_titulo_w );
	    	else
      	  	vl_desconto_w  := ((tx_desc_antecipacao_w / 1200) *
					vl_saldo_titulo_w);
		end if;
		end;
	end if;
	end if;
	if (vl_desconto_w > vl_saldo_titulo_w) then
		vl_desconto_w	:= vl_saldo_titulo_w;
	end if;
	end;
end if;

vl_desconto_p			:= vl_desconto_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_desc_ant_pagto ( nr_titulo_p bigint, dt_Prev_Pagto_p timestamp, vl_desconto_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
