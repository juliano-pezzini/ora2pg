-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_contrato_grupo ( nr_seq_contrato_p bigint, nr_seq_grupo_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_w			bigint;
ie_retorno_w			varchar(2)	:= 'N';


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	pls_contrato_grupo
where	nr_seq_contrato	= nr_seq_contrato_p
and	nr_seq_grupo 	= nr_seq_grupo_p;

if (qt_registro_w	> 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_contrato_grupo ( nr_seq_contrato_p bigint, nr_seq_grupo_p bigint) FROM PUBLIC;
