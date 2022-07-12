-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_leito_atend (nr_seq_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ds_leito_w			varchar(50);


BEGIN

select	cd_unidade_basica || '-' || cd_unidade_compl
into STRICT	ds_leito_w
from	atend_paciente_unidade
where	nr_seq_interno = nr_seq_interno_p;

return	ds_leito_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_leito_atend (nr_seq_interno_p bigint) FROM PUBLIC;
