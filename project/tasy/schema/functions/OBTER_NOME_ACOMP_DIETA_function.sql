-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_acomp_dieta (nr_seq_nut_acomp_p bigint) RETURNS varchar AS $body$
DECLARE

 
nm_acompanhante_w			varchar(80);
			

BEGIN 
 
select	coalesce(substr(obter_nome_pf(cd_pessoa_fisica),1,80), nm_pessoa_fisica) 
into STRICT	nm_acompanhante_w 
from	nut_atend_acompanhante 
where	nr_sequencia = nr_seq_nut_acomp_p;
 
return	nm_acompanhante_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_acomp_dieta (nr_seq_nut_acomp_p bigint) FROM PUBLIC;
