-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION avf_obter_se_nota_se_aplica ( nr_seq_nota_item_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);


BEGIN

/* Feito este tratamento para inverter o retorno pois, */

/* caso o campo esteja como N, significa que a nota se aplica e, */

/* portanto, a function deve retornar S */

select	CASE WHEN coalesce(max(ie_nao_se_aplica),'N')='S' THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	avf_tipo_nota_item
where	nr_sequencia = nr_seq_nota_item_p;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION avf_obter_se_nota_se_aplica ( nr_seq_nota_item_p bigint) FROM PUBLIC;
