-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_responsavel_nf (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

responsavel_w	varchar(10);


BEGIN

select	cd_pessoa_fisica
into STRICT	responsavel_w
from	titulo_receber
where   nr_seq_nf_saida = nr_sequencia_p;


RETURN responsavel_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_responsavel_nf (nr_sequencia_p bigint) FROM PUBLIC;

