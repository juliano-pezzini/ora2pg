-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_desc_grupo_tipo ( nr_Seq_grupo_p text) RETURNS varchar AS $body$
DECLARE


ds_Retorno_w	varchar(255);


BEGIN

select	max(ds_grupo)
into STRICT	ds_Retorno_w
from	QT_GRUPO_ITEM_AGENDA
where	nr_sequencia	= nr_seq_grupo_p;

return	ds_Retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_desc_grupo_tipo ( nr_Seq_grupo_p text) FROM PUBLIC;

