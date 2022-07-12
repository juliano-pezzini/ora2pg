-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_edicao (nr_seq_regra_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_edicao_amb_w		integer;
					

BEGIN 
 
select	cd_edicao_amb 
into STRICT	cd_edicao_amb_w 
from	pls_regra_preco_proc 
where	nr_sequencia = nr_seq_regra_p;
 
return	cd_edicao_amb_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_edicao (nr_seq_regra_p bigint) FROM PUBLIC;

