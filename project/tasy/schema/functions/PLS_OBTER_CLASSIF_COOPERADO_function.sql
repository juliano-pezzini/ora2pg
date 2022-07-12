-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_classif_cooperado (nr_seq_classificacao_p text) RETURNS varchar AS $body$
DECLARE


ds_classificacao_w		varchar(255);


BEGIN
select	ds_classificacao
into STRICT	ds_classificacao_w
from	pls_classif_cooperado
where	nr_sequencia	= nr_seq_classificacao_p;

return	ds_classificacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_classif_cooperado (nr_seq_classificacao_p text) FROM PUBLIC;
