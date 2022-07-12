-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prox_seq_nrcheque ( nr_cheque_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(20);


BEGIN

ds_retorno_w := to_char(obter_somente_numero(nr_cheque_p)+1);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prox_seq_nrcheque ( nr_cheque_p text) FROM PUBLIC;

