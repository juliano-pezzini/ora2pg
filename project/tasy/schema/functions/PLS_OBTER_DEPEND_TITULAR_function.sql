-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_depend_titular ( nr_seq_titular_p bigint, nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE

 
nm_segurados_w				varchar(2000);
nm_segurado_temporario_w	varchar(255);
				
C01 CURSOR FOR 
	SELECT	substr(pls_obter_dados_segurado(nr_sequencia,'N'),1,255) 
	from	pls_segurado 
	where	nr_seq_titular 	= nr_seq_titular_p 
	and		nr_sequencia	<> nr_seq_segurado_p;


BEGIN 
open C01;
loop 
fetch C01 into 
	nm_segurado_temporario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	nm_segurados_w				:= nm_segurados_w || ', ' || nm_segurado_temporario_w;
	nm_segurado_temporario_w	:= '';
	end;
end loop;
close C01;
 
return	nm_segurados_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_depend_titular ( nr_seq_titular_p bigint, nr_seq_segurado_p bigint) FROM PUBLIC;

