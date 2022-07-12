-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION substituir_macros_ordem_serv ( ds_texto_p text, nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE

 
dt_atual_w		timestamp;
nr_hora_atual_w		bigint;				
ds_texto_w		varchar(8000);
nm_solicitante_w	varchar(255);
ds_periodo_w		varchar(255);
cd_pessoa_solicitante_w	varchar(10);
				

BEGIN 
ds_texto_w 		:= ds_texto_p;
dt_atual_w		:= clock_timestamp();
nr_hora_atual_w 	:= (to_char(dt_atual_w,'hh24'))::numeric;
 
select	max(a.cd_pessoa_solicitante) 
into STRICT	cd_pessoa_solicitante_w 
from	man_ordem_servico	a 
where	a.nr_sequencia	= nr_seq_ordem_p;
 
select	substr(obter_primeiro_nome(obter_nome_pf(cd_pessoa_solicitante_w)),1,120) nm_solicitante 
into STRICT	nm_solicitante_w
;
 
if (nr_hora_atual_w >= 6) and (nr_hora_atual_w < 12) then 
	ds_periodo_w	:= wheb_mensagem_pck.get_texto(318817);
elsif (nr_hora_atual_w >= 12) and (nr_hora_atual_w <18) then 
	ds_periodo_w	:= wheb_mensagem_pck.get_texto(318818);	
else 
	ds_periodo_w	:= wheb_mensagem_pck.get_texto(318819);
end if;
 
ds_texto_w	:= substr(replace_macro(ds_texto_w,'@nm_solicitante_os', nm_solicitante_w),1,8000);
ds_texto_w	:= substr(replace_macro(ds_texto_w,'@periodo_dia', ds_periodo_w),1,8000);
 
return	ds_texto_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION substituir_macros_ordem_serv ( ds_texto_p text, nr_seq_ordem_p bigint) FROM PUBLIC;

