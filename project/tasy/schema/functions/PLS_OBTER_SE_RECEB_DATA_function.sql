-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_receb_data ( nr_seq_segurado_p bigint, dt_recebimento_de_p timestamp, dt_recebimento_ate_p timestamp, ie_tipo_lote_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1);
qt_receb_data_w		smallint	:= 0;


BEGIN 
 
ds_retorno_w := 'N';
 
select	count(*) 
into STRICT	qt_receb_data_w 
from	pls_carteira_emissao a, 
	pls_lote_carteira b 
where	a.nr_seq_lote = b.nr_sequencia 
and	trunc(a.dt_recebimento,'dd') between trunc(dt_recebimento_de_p,'dd') and trunc(dt_recebimento_ate_p,'dd') 
and	(substr(pls_obter_dados_carteira(a.nr_seq_seg_carteira,null,'S'),1,10))::numeric  = nr_seq_segurado_p 
and	b.ie_tipo_lote = ie_tipo_lote_p;
 
if (qt_receb_data_w > 0) then 
	ds_retorno_w := 'S';
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_receb_data ( nr_seq_segurado_p bigint, dt_recebimento_de_p timestamp, dt_recebimento_ate_p timestamp, ie_tipo_lote_p text) FROM PUBLIC;

