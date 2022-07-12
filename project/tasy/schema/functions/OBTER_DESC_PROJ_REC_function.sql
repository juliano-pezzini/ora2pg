-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_proj_rec (nr_seq_proj_rec_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255)	:= null;

BEGIN

/*select	substr(decode(ds_convenio_ano,'',ds_projeto, ds_projeto || ' - ' || ds_convenio_ano),1,255)
into	ds_retorno_w
from	projeto_recurso
where	nr_sequencia = nr_seq_proj_rec_p;*/
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_proj_rec (nr_seq_proj_rec_p text) FROM PUBLIC;
