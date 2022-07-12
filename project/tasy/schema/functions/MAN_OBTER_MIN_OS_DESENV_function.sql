-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_min_os_desenv (nr_seq_ordem_serv_p bigint) RETURNS bigint AS $body$
DECLARE



retorno_w	bigint;


BEGIN

select 	sum(QT_MINUTO)
	into STRICT	retorno_w
	from	MAN_ORDEM_SERV_ATIV a,
		usuario b,
		man_ordem_servico c,
		man_localizacao d
	where	a.NM_USUARIO_EXEC 	= b.nm_usuario
	and	a.nr_seq_ordem_serv 	= c.nr_sequencia
	and	c.nr_seq_localizacao	= d.nr_sequencia
	and	b.CD_SETOR_ATENDIMENTO 	= 2
	and	a.nr_seq_ordem_serv = nr_seq_ordem_serv_p;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_min_os_desenv (nr_seq_ordem_serv_p bigint) FROM PUBLIC;

