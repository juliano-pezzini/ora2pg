-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_ds_tipo_lanc_comiss ( ie_tipo_lancamento_p pls_repasse_lanc.ie_tipo_lancamento%type, nr_titulo_p titulo_receber.nr_titulo%type) RETURNS varchar AS $body$
DECLARE

 
/* 
ie_tipo_lancamento_p: (domínio 5409) 
	1 - Desconto para geração do valor máximo para o canal de venda 
	2 - Lançamento adicional referente ao valor de repasse excedente 
	3 - Desconto referente ao desconto concedido no título a receber 
*/
 
	 
ds_retorno_w		varchar(255);
	

BEGIN 
 
select	substr(obter_valor_dominio(5409,ie_tipo_lancamento_p),1,255) 
into STRICT	ds_retorno_w
;
 
if (ie_tipo_lancamento_p = 3) then 
	ds_retorno_w := ds_retorno_w || ' ' || nr_titulo_p;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_ds_tipo_lanc_comiss ( ie_tipo_lancamento_p pls_repasse_lanc.ie_tipo_lancamento%type, nr_titulo_p titulo_receber.nr_titulo%type) FROM PUBLIC;
