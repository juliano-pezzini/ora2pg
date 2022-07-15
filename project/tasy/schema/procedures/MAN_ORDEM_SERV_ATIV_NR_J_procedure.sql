-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_ordem_serv_ativ_nr_j ( nm_usuario_p text, nr_seq_ordem_serv_p bigint, nr_seq_classif_p bigint, ie_base_p text, ds_retorno_P INOUT text, nr_seq_grupo_des_p INOUT bigint, nr_seq_ativ_prev_p INOUT bigint) AS $body$
DECLARE


qt_w			bigint;


BEGIN


select	count(*)
into STRICT	qt_w
from	man_ordem_servico a,
	man_estagio_processo b
where	a.nr_sequencia = nr_seq_ordem_serv_p
and	a.nr_seq_estagio= b.nr_sequencia
and	b.ie_tecnologia = 'S';

if (qt_w > 0)
	and (coalesce(nr_seq_classif_p::text, '') = '')
	and (ie_base_p = 'C') then
	ds_retorno_P := obter_texto_tasy(121355, wheb_usuario_pck.get_nr_seq_idioma);
	goto final;
end if;


if (ie_base_p = 'C') then

	select	count(*)
	into STRICT	qt_w
	from	usuario_grupo_des
	where	nm_usuario_grupo = nm_usuario_p;

	if (qt_w > 0)	then
		select	max(nr_seq_grupo)
		into STRICT	nr_seq_grupo_des_p
		from	usuario_grupo_des
		where	nm_usuario_grupo = nm_usuario_p;
	end if;

	select	count(*)
	into STRICT	qt_w
	from	man_ordem_ativ_prev
	where	nr_seq_ordem_serv = nr_seq_ordem_serv_p
	and	nm_usuario_prev = nm_usuario_p
	and	coalesce(dt_real::text, '') = ''
	and	trunc(dt_prevista,'dd') = trunc(clock_timestamp(),'dd');

	if (qt_w = 1)	then
		select	nr_sequencia
		into STRICT	nr_seq_ativ_prev_p
		from	man_ordem_ativ_prev
		where	nr_seq_ordem_serv = nr_seq_ordem_serv_p
		and	nm_usuario_prev = nm_usuario_p
		and	coalesce(dt_real::text, '') = ''
		and	trunc(dt_prevista,'dd') = trunc(clock_timestamp(),'dd');
	end if;

end if;

<<final>>
qt_w := 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_ordem_serv_ativ_nr_j ( nm_usuario_p text, nr_seq_ordem_serv_p bigint, nr_seq_classif_p bigint, ie_base_p text, ds_retorno_P INOUT text, nr_seq_grupo_des_p INOUT bigint, nr_seq_ativ_prev_p INOUT bigint) FROM PUBLIC;

