-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_tipo_trib_retido (nr_seq_nota_p bigint, ie_tipo_valor_p text, ie_tipo_tributo_p text) RETURNS bigint AS $body$
DECLARE

 
/* 
Tipos de Valores: 
	V - Valor do Tributo 
	B - Data base calculo 
	X - Taxa de tributo 
	R - Código de Retenção 
	D - Deduções 
	C - Dedução da base de calculo 
*/
 
 
 
vl_retorno_w		double precision := 0;
vl_tributo_w		double precision := 0;
vl_base_calculo_w	double precision := 0;
tx_tributo_w		double precision := 0;
vl_reducao_base_w	double precision := 0;
vl_reducao_w		double precision := 0;
ds_darf_w		varchar(255);
qt_servico_w		bigint;
ie_gerar_trib_nfse_w	varchar(1);

BEGIN
 
select	count(*) 
into STRICT	qt_servico_w 
from	operacao_nota o, 
	nota_fiscal n 
where	o.cd_operacao_nf = n.cd_operacao_nf 
and	n.nr_sequencia = nr_seq_nota_p 
and	o.ie_nf_eletronica = 'S' 
and	o.ie_servico = 'S';
 
select	coalesce(sum(x.vl_tributo),0), 
	coalesce(sum(x.vl_base_calculo),0), 
	coalesce(sum(x.tx_tributo),0), 
	coalesce(sum(x.vl_reducao_base),0), 
	coalesce(sum(x.vl_reducao),0), 
	max(ie_gerar_trib_nfse) 
into STRICT	vl_tributo_w, 
	vl_base_calculo_w, 
	tx_tributo_w, 
	vl_reducao_base_w, 
	vl_reducao_w, 
	ie_gerar_trib_nfse_w 
from	tributo t, 
	nota_fiscal_trib x 
where	x.cd_tributo = t.cd_tributo 
and (t.ie_tipo_tributo = ie_tipo_tributo_p or coalesce(ie_tipo_tributo_p,'X') = 'X') 
and	coalesce(x.ie_retencao,'D') in ('S','D') 
and	x.nr_sequencia  = nr_seq_nota_p;
 
if (ie_tipo_valor_p = 'R') then 
	begin 
	select 	coalesce(cd_darf,SUBSTR(obter_codigo_darf(x.cd_tributo, (obter_descricao_padrao('NOTA_FISCAL','CD_ESTABELECIMENTO',nr_seq_nota_p))::numeric , 
		obter_descricao_padrao('NOTA_FISCAL','CD_CGC',nr_seq_nota_p), obter_descricao_padrao('NOTA_FISCAL','CD_PESSOA_FISICA',nr_seq_nota_p)),1,10)) 
	into STRICT	ds_darf_w 
	from	nota_fiscal_trib x, 
		tributo t 
	where	nr_sequencia = nr_seq_nota_p 
	and	x.cd_tributo = t.cd_tributo 
	and (t.ie_tipo_tributo = ie_tipo_tributo_p or coalesce(ie_tipo_tributo_p,'X') = 'X');	
	end;
end if;
 
if (ie_gerar_trib_nfse_w = 'N') and (qt_servico_w > 0) then 
	vl_retorno_w  := 0;
elsif (ie_tipo_valor_p = 'V') then 
	vl_retorno_w  := vl_tributo_w;
elsif (ie_tipo_valor_p = 'B') then 
	vl_retorno_w  := vl_base_calculo_w;
elsif (ie_tipo_valor_p = 'X') then 
	vl_retorno_w  := tx_tributo_w;
elsif (ie_tipo_valor_p = 'R') then 
	vl_retorno_w  := ds_darf_w;
elsif (ie_tipo_valor_p = 'D') then 
	vl_retorno_w	:= vl_reducao_base_w;
elsif (ie_tipo_valor_p = 'C') then 
	vl_retorno_w	:= vl_reducao_w;
end if;
 
return vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_tipo_trib_retido (nr_seq_nota_p bigint, ie_tipo_valor_p text, ie_tipo_tributo_p text) FROM PUBLIC;

