-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_lider_grupo_des ( nm_usuario_p text, nr_seq_gerencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		bigint := '';


BEGIN
select	coalesce(to_char(max(a.nr_seq_grupo_des)),ds_retorno_w)
into STRICT	ds_retorno_w
from	man_ordem_servico  a,
	grupo_desenvolvimento b,
	gerencia_wheb c
where	c.nr_sequencia	= b.nr_seq_gerencia
and	b.nr_sequencia	= a.nr_seq_grupo_des
and (substr(obter_se_os_pend_cliente(a.nr_sequencia),1,1) = 'N')
and (substr(Obter_Se_OS_Desenv(a.nr_sequencia),1,1) = 'S')
and	a.ie_status_ordem	<> 3
and	c.nr_sequencia	<> 5
and	b.nm_usuario_lider = nm_usuario_p
and	c.nr_sequencia = nr_seq_gerencia_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_lider_grupo_des ( nm_usuario_p text, nr_seq_gerencia_p bigint) FROM PUBLIC;
