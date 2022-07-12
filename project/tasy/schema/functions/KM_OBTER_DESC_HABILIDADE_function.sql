-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION km_obter_desc_habilidade ( nr_seq_habilidade_p km_habilidade_tecnica.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

select	substr(obter_desc_expressao(ht.cd_exp_habilidade, ht.ds_habilidade), 1, 255)
into STRICT	ds_retorno_w
from	km_habilidade_tecnica ht
where	ht.nr_sequencia = nr_seq_habilidade_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION km_obter_desc_habilidade ( nr_seq_habilidade_p km_habilidade_tecnica.nr_sequencia%type) FROM PUBLIC;

