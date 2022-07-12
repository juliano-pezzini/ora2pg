-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_titulo_cobr ( nr_seq_titulo_cobr_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
/* 
ie_opcao_p 
	'T' = Título 
	'NM' = Nome pessoa título 
	'VLC' = Vl cobranca 
	'DT' = Data mensalidade 
*/
 
 
ds_retorno_w	varchar(255);


BEGIN 
 
if (ie_opcao_p = 'T') then 
	select	nr_titulo 
	into STRICT	ds_retorno_w 
	from	titulo_receber_cobr 
	where	nr_sequencia = nr_seq_titulo_cobr_p;
elsif (ie_opcao_p = 'NM') then 
	select	substr(obter_dados_titulo_receber(nr_titulo, 'N'),1,255) 
	into STRICT	ds_retorno_w 
	from	titulo_receber_cobr 
	where	nr_sequencia = nr_seq_titulo_cobr_p;
elsif (ie_opcao_p = 'VLC') then 
	select	vl_cobranca 
	into STRICT	ds_retorno_w 
	from	titulo_receber_cobr 
	where	nr_sequencia = nr_seq_titulo_cobr_p;
elsif (ie_opcao_p = 'DT') then 
	select	b.dt_remessa_retorno 
	into STRICT	ds_retorno_w 
	from	titulo_receber_cobr	a, 
		cobranca_escritural	b 
	where	a.nr_seq_cobranca	= b.nr_sequencia 
	and	a.nr_sequencia		= nr_seq_titulo_cobr_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_titulo_cobr ( nr_seq_titulo_cobr_p bigint, ie_opcao_p text) FROM PUBLIC;
