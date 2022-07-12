-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_os_maior_prioridade (nm_usuario_p text, nr_seq_ativ_prev_p bigint, nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


ie_prioridade_desen_w	smallint;
ie_retorno_w		varchar(255);


BEGIN

if (coalesce(nr_seq_ativ_prev_p,0) > 0) then


select	coalesce(max(ie_prioridade_desen),0)
into STRICT 	ie_prioridade_desen_w
from	man_ordem_ativ_prev
where	nr_sequencia = nr_seq_ativ_prev_p;

select	coalesce(max(a.nr_sequencia),0)
into STRICT 	ie_retorno_w
from	man_ordem_servico a,
		man_estagio_processo b,
		man_ordem_ativ_prev c
where	b.nr_sequencia 		= a.nr_seq_estagio
and		a.nr_sequencia		= c.nr_seq_ordem_serv
and (b.ie_desenv    	= 'S' or b.ie_tecnologia = 'S')
and		c.ie_prioridade_desen > ie_prioridade_desen_w
and		a.nr_sequencia		<> nr_seq_ordem_p
and		c.nm_usuario_prev	= nm_usuario_p
and		c.dt_prevista between trunc(clock_timestamp()) and fim_dia(clock_timestamp())
and		coalesce(dt_real::text, '') = '';

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_os_maior_prioridade (nm_usuario_p text, nr_seq_ativ_prev_p bigint, nr_seq_ordem_p bigint) FROM PUBLIC;
