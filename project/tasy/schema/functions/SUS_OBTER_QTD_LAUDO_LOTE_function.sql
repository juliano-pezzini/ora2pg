-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_qtd_laudo_lote (nr_seq_lote_p bigint) RETURNS bigint AS $body$
DECLARE

 
ds_retorno_w	bigint;
			

BEGIN 
 
select	count(distinct nr_seq_interno) 
into STRICT	ds_retorno_w 
from	sus_laudo_paciente 
where	nr_seq_lote	= nr_seq_lote_p;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_qtd_laudo_lote (nr_seq_lote_p bigint) FROM PUBLIC;
