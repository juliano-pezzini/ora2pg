-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_observacao_alta (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_observacao_w		varchar(255);


BEGIN

select	ds_observacao
into STRICT	ds_observacao_w
from	atendimento_transf
where	nr_atendimento	=	nr_atendimento_p
and	nr_sequencia	=	(SELECT	max(x.nr_sequencia)
	   			from	atendimento_transf x
				where	x.nr_atendimento = nr_atendimento_p);


RETURN	ds_observacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_observacao_alta (nr_atendimento_p bigint) FROM PUBLIC;
