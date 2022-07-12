-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_se_apresenta_valor (nr_seq_indicador bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);


BEGIN

select 	coalesce(ie_valor,'S')
into STRICT	ie_retorno_w
from 	resultado_indicador
where	nr_sequencia = nr_seq_indicador;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_se_apresenta_valor (nr_seq_indicador bigint) FROM PUBLIC;

