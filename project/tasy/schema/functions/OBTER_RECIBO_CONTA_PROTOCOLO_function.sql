-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_recibo_conta_protocolo ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE

 
nr_recibo_w			bigint;
ds_retorno_w			varchar(2000) := '';

C01 CURSOR FOR 
	SELECT	c.nr_recibo	 
	from	caixa_receb c, 
		titulo_receber_liq b, 
		titulo_receber a 
	where	a.nr_titulo = b.nr_titulo 
	and	c.nr_sequencia = b.nr_seq_caixa_rec 
	and	(a.nr_interno_conta IS NOT NULL AND a.nr_interno_conta::text <> '') 
	and	a.nr_interno_conta = nr_interno_conta_p 
	
union
 
	SELECT	c.nr_recibo	 
	from	caixa_receb c, 
		titulo_receber_liq b, 
		titulo_receber a 
	where	a.nr_titulo = b.nr_titulo 
	and	c.nr_sequencia = b.nr_seq_caixa_rec 
	and	(a.nr_seq_protocolo IS NOT NULL AND a.nr_seq_protocolo::text <> '') 
	and	a.nr_seq_protocolo = nr_seq_protocolo_p 
	order by 1;			
 

BEGIN 
 
if (coalesce(nr_interno_conta_p,0) <> 0) or (coalesce(nr_seq_protocolo_p,0) <> 0) then 
	begin 
	open C01;
	loop 
	fetch C01 into	 
		nr_recibo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		if (coalesce(nr_recibo_w,0) <> 0) and (length(coalesce(ds_retorno_w,'0')) < 1980) then 
			ds_retorno_w := ds_retorno_w || nr_recibo_w ||', ';
		end if;
	end loop;
	close C01;
 
	if (length(ds_retorno_w) > 2) then 
		ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w) - 2);
	end if;
	end;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_recibo_conta_protocolo ( nr_interno_conta_p bigint, nr_seq_protocolo_p bigint) FROM PUBLIC;
