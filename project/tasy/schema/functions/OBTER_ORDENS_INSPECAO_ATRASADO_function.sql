-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ordens_inspecao_atrasado (nr_seq_registro_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_ordens_w		varchar(255);
nr_ordem_compra_w	bigint;

 
C01 CURSOR FOR 
	SELECT	distinct nr_ordem_compra 
	from	inspecao_recebimento 
	where 	obter_dt_prev_oci_inspecao(nr_sequencia) < trunc(clock_timestamp()) 
	and	dt_entrega_real = trunc(clock_timestamp()) 
	and	(nr_ordem_compra IS NOT NULL AND nr_ordem_compra::text <> '') 
	and	nr_seq_registro = nr_seq_registro_p;


BEGIN 
 
 
open C01;
loop 
fetch C01 into 
	nr_ordem_compra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_ordens_w := substr(ds_ordens_w || nr_ordem_compra_w || chr(13) || chr(10) || ',',1,255);
	end;
end loop;
close C01;
 
return	ds_ordens_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ordens_inspecao_atrasado (nr_seq_registro_p bigint) FROM PUBLIC;
