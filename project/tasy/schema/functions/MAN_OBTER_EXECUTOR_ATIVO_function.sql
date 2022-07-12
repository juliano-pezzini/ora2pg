-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_executor_ativo (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_ativ_w   varchar(15);


BEGIN

	select		max(b.nm_usuario_exec)
	into STRICT		nm_usuario_ativ_w
	from		man_ordem_serv_ativ b,
		man_ordem_servico a
	where		a.nr_sequencia = b.nr_seq_ordem_serv
	and		a.nr_sequencia = nr_sequencia_p
	and		coalesce(b.dt_fim_atividade::text, '') = ''
	and exists ( SELECT  1 from man_ordem_servico_exec c
		   	 		 where a.nr_sequencia = c.nr_seq_ordem
					 and b.nm_usuario_exec = c.nm_usuario_exec
					 and coalesce(dt_fim_execucao::text, '') = '');

return nm_usuario_ativ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_executor_ativo (nr_sequencia_p bigint) FROM PUBLIC;
