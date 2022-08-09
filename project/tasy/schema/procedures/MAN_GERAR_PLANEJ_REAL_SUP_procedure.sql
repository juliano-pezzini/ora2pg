-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_planej_real_sup ( dt_mes_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_grupo_suporte_w		bigint;
qt_usuario_grupo_w		bigint;
qt_ordem_planej_real_w		bigint;
qt_usuario_grupo_div_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	grupo_suporte
	where	ie_situacao = 'A';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_grupo_suporte_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	/* Qt. ordens de serviço no mês */

	select	count(*)
	into STRICT	qt_ordem_planej_real_w
	FROM man_ordem_servico a
LEFT OUTER JOIN grupo_suporte b ON (a.nr_seq_grupo_sup = b.nr_sequencia)
WHERE exists ( SELECT 1
			from	man_estagio_processo c,
				man_ordem_serv_estagio d
			where	c.nr_sequencia = d.nr_seq_estagio
			and	d.nr_seq_ordem = a.nr_sequencia
			and	c.ie_suporte = 'S') and a.ie_classificacao	in ('D','E') and trunc(a.dt_ordem_servico,'month') = dt_mes_referencia_p and a.nr_seq_grupo_sup	= nr_seq_grupo_suporte_w;

	/* Qt. usuários no grupo de suporte */

	select	count(*)
	into STRICT	qt_usuario_grupo_w
	from	usuario_grupo_sup
	where	nr_seq_grupo	= nr_seq_grupo_suporte_w;

	if (qt_usuario_grupo_w = 0) then
		qt_usuario_grupo_div_w	:= 1;
	else
		qt_usuario_grupo_div_w	:= qt_usuario_grupo_w;
	end if;

	update	man_planejamento_meta
	set	qt_ordem_planej_real			= qt_ordem_planej_real_w,
		qt_colaborador_planej_real		= CASE WHEN coalesce(qt_colaborador_planej_real,0)=0 THEN coalesce(qt_usuario_grupo_w,1)  ELSE qt_colaborador_planej_real END ,
		qt_ordem_colaborador			= round((coalesce(qt_ordem_planej_real_w,1)/CASE WHEN coalesce(qt_colaborador_planej_real,0)=0 THEN qt_usuario_grupo_div_w  ELSE coalesce(qt_colaborador_planej_real,1) END )::numeric,2)
	where	trunc(dt_mes_referencia,'month')	= dt_mes_referencia_p
	and	nr_seq_grupo_sup			= nr_seq_grupo_suporte_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_planej_real_sup ( dt_mes_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
