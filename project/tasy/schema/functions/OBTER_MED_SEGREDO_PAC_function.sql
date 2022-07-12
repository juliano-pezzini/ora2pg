-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_med_segredo_pac ( nr_seq_cliente_p bigint) RETURNS varchar AS $body$
DECLARE


qtd_w 		bigint  := 0;
retorno_w		varchar(1) := 'N';


BEGIN

 select count(*)
 into STRICT	qtd_w
 from 	med_consulta
 where 	nr_seq_cliente 	= nr_seq_cliente_p
 and 	ie_tipo_consulta  	= 7;

 if ( 	qtd_w > 0) then
	retorno_w := 'S';
 end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_med_segredo_pac ( nr_seq_cliente_p bigint) FROM PUBLIC;
