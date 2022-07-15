-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_tit_receber_classif (nr_titulo_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
vl_titulo_w		double precision;
vl_classificacao_w	double precision;
ds_erro_w		varchar(255);


BEGIN 
 
select	(obter_dados_titulo_receber(nr_titulo_p,'V'))::numeric  
into STRICT	vl_titulo_w
;
 
select	coalesce(sum(vl_classificacao),0) 
into STRICT	vl_classificacao_w 
from	titulo_receber_classif 
where	nr_titulo	= nr_titulo_p;
 
if (vl_titulo_w		<> vl_classificacao_w) and (vl_classificacao_w	> 0) then 
	ds_erro_w		:= wheb_mensagem_pck.get_texto(279257, 'VL_TITULO_P=' || vl_titulo_w || ';VL_CLASSIFICACAO_P=' || vl_classificacao_w);
end if;
 
ds_erro_p		:= ds_erro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_tit_receber_classif (nr_titulo_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

