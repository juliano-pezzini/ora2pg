-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_os_passou_desenv ( nr_ordem_servico_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(15);


BEGIN

ie_retorno_w			:= 'N';

select	coalesce(max('S'),'N')
into STRICT	ie_retorno_w
from	man_estagio_processo b,
	Man_ordem_serv_estagio a
where	a.nr_seq_ordem		= nr_ordem_servico_p
and	a.nr_seq_estagio	= b.nr_sequencia
and	b.ie_desenv		= 'S';

RETURN ie_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_os_passou_desenv ( nr_ordem_servico_p bigint) FROM PUBLIC;

