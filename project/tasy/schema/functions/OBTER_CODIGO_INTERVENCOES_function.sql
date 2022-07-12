-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_intervencoes (nr_seq_interv_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(15);


BEGIN 
 
select	cd_nic 
into STRICT	ds_retorno_w 
from	pe_procedimento 
where	nr_sequencia	= nr_seq_interv_p;
 
Return ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_intervencoes (nr_seq_interv_p bigint) FROM PUBLIC;
