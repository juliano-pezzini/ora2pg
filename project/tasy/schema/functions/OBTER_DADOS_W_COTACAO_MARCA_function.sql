-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_w_cotacao_marca ( nr_sequencia_p bigint, nr_seq_coluna_p bigint) RETURNS varchar AS $body$
DECLARE


ds_marca_w		varchar(30);



BEGIN

select	ds_marca
into STRICT	ds_marca_w
from	w_cotacao_item_coluna
where	nr_seq_cotacao_item	= nr_sequencia_p
and	nr_seq_coluna		= nr_seq_coluna_p;

return	ds_marca_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_w_cotacao_marca ( nr_sequencia_p bigint, nr_seq_coluna_p bigint) FROM PUBLIC;
