-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_protocolos_contidos (ds_parametro_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(2000);
nr_seq_protocolo_w	bigint;
nr_protocolo_w	varchar(40);
ds_separador_w	varchar(2);
			
C01 CURSOR FOR 
	SELECT	nr_seq_protocolo, 
		nr_protocolo 
	from	protocolo_convenio 
	where	obter_se_contido(nr_seq_protocolo, ds_parametro_p) = 'S' 
	order by nr_seq_protocolo;			
			 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_protocolo_w, 
	nr_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (coalesce(ds_retorno_w, '0') = '0') then 
		ds_separador_w	:= '';
	else 
		ds_separador_w := ', ';
	end if;
	ds_retorno_w := ds_retorno_w || ds_separador_w || nr_seq_protocolo_w || ' - ' || nr_protocolo_w;
	end;
end loop;
close C01;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_protocolos_contidos (ds_parametro_p text) FROM PUBLIC;
