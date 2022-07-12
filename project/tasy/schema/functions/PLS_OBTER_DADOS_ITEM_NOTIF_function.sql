-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_item_notif ( nr_seq_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/*	ie_opcao_p 
	VJ - Valor de juros 
	VM - Valor de multa 
	VP - Valor a pagar 
	DL - Data de liquidação 
	S - Situação do título 
	DM - Data mensalidade 
	QD - Variação de dias entre a data do lote e a data de vencimento do título 
	VS - Valor do saldo do título 
	DRM - Data Referência da Mensalidade*/
 
	 
ds_retorno_w			varchar(255);
ds_situacao_w			varchar(50);
ie_data_base_w			varchar(10);
vl_juros_w			double precision;
vl_multa_w			double precision;
vl_saldo_titulo_w		double precision;
nr_titulo_w			bigint;
nr_seq_mensalidade_w		bigint;
nr_seq_regra_w			bigint;
dt_liquidacao_w			timestamp;
dt_ref_mensalidade_w		timestamp;
dt_lote_w			timestamp;
dt_pagamento_previsto_w		timestamp;
dt_ref_mensal_segur_w		timestamp;


BEGIN 
select	max(a.dt_lote), 
	max(a.nr_seq_regra) 
into STRICT	dt_lote_w, 
	nr_seq_regra_w 
from	pls_notificacao_lote	a, 
	pls_notificacao_pagador	b, 
	pls_notificacao_item	c 
where	a.nr_sequencia	= b.nr_seq_lote 
and	b.nr_sequencia	= c.nr_seq_notific_pagador 
and	c.nr_sequencia	= nr_seq_item_p;
 
select	nr_titulo,--substr(pls_obter_titulo_mensalidade(nr_seq_mensalidade,null),1,255), 
	nr_seq_mensalidade 
into STRICT	nr_titulo_w, 
	nr_seq_mensalidade_w 
from	pls_notificacao_item 
where	nr_sequencia	= nr_seq_item_p;
 
select 	coalesce(max(ie_data_base),'VA') 
into STRICT  	ie_data_base_w 
from  pls_notificacao_regra 
where  nr_sequencia  = nr_seq_regra_w 
and   ie_situacao   = 'A';
 
/*select	obter_juros_multa_titulo(nr_titulo,sysdate,'R','J'), 
	obter_juros_multa_titulo(nr_titulo,sysdate,'R','M'), 
	vl_saldo_titulo, 
	dt_liquidacao, 
	substr(obter_valor_dominio(710,ie_situacao),1,50), 
	dt_pagamento_previsto 
into	vl_juros_w, 
	vl_multa_w, 
	vl_saldo_titulo_w, 
	dt_liquidacao_w, 
	ds_situacao_w, 
	dt_pagamento_previsto_w 
from	titulo_receber 
where	nr_titulo	= nr_titulo_w; 
 
select	trunc(dt_referencia,'month') 
into	dt_ref_mensalidade_w 
from	pls_mensalidade 
where	nr_sequencia	= nr_seq_mensalidade_w;*/
 
 
if (ie_opcao_p = 'VJ') then 
	select	obter_juros_multa_titulo(nr_titulo,clock_timestamp(),'R','J') 
	into STRICT	vl_juros_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= to_char(vl_juros_w);
elsif (ie_opcao_p = 'VM') then 
	select	obter_juros_multa_titulo(nr_titulo,clock_timestamp(),'R','M') 
	into STRICT	vl_multa_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= to_char(vl_multa_w);
elsif (ie_opcao_p = 'VP') then 
	select	obter_juros_multa_titulo(nr_titulo,clock_timestamp(),'R','J'), 
		obter_juros_multa_titulo(nr_titulo,clock_timestamp(),'R','M'), 
		vl_saldo_titulo 
	into STRICT	vl_juros_w, 
		vl_multa_w, 
		vl_saldo_titulo_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= to_char(vl_saldo_titulo_w + vl_multa_w + vl_juros_w);
elsif (ie_opcao_p = 'DL') then 
	select	dt_liquidacao 
	into STRICT	dt_liquidacao_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= to_char(dt_liquidacao_w,'dd/mm/yyyy');
elsif (ie_opcao_p = 'S') then 
	select	substr(obter_valor_dominio(710,ie_situacao),1,50) 
	into STRICT	ds_situacao_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= ds_situacao_w;
elsif (ie_opcao_p = 'DM') then 
	select	trunc(dt_referencia,'month') 
	into STRICT	dt_ref_mensalidade_w 
	from	pls_mensalidade 
	where	nr_sequencia	= nr_seq_mensalidade_w;
	 
	ds_retorno_w	:= to_char(dt_ref_mensalidade_w,'dd/mm/yyyy');
elsif (ie_opcao_p = 'QD') then 
	select	CASE WHEN ie_data_base_w='VA' THEN dt_pagamento_previsto  ELSE dt_vencimento END  
	into STRICT	dt_pagamento_previsto_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= to_char(dt_lote_w - dt_pagamento_previsto_w);
elsif (ie_opcao_p = 'VS') then 
	select	vl_saldo_titulo 
	into STRICT	vl_saldo_titulo_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
	 
	ds_retorno_w	:= to_char(vl_saldo_titulo_w);
elsif (ie_opcao_p = 'DRM') then	 
	select	trunc(b.dt_mesano_referencia,'month') 
	into STRICT	dt_ref_mensal_segur_w 
	from	pls_lote_mensalidade	b, 
		pls_mensalidade		a 
	where	b.nr_sequencia		= nr_seq_lote 
	and	a.nr_sequencia		= nr_seq_mensalidade_w;	
	 
	ds_retorno_w	:= to_char(dt_ref_mensal_segur_w,'dd/mm/yyyy');	
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_item_notif ( nr_seq_item_p bigint, ie_opcao_p text) FROM PUBLIC;

