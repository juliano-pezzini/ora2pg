-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION uc_obter_desc_frasco_amostra ( nr_seq_exame_p bigint, nr_seq_amostra_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w varchar(255):=null;


BEGIN

select 	max(substr(OBTER_DESC_FRASCO(nr_seq_frasco),1,160))
into STRICT	ds_retorno_w
from   	exame_lab_frasco
where  	nr_seq_exame = 		nr_seq_exame_p
and		nr_seq_amostra = 	nr_seq_amostra_p
and		coalesce(ie_situacao,'A') = 'A';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION uc_obter_desc_frasco_amostra ( nr_seq_exame_p bigint, nr_seq_amostra_p bigint) FROM PUBLIC;

