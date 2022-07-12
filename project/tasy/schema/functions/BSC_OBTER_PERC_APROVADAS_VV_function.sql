-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_perc_aprovadas_vv (dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE



qt_total_w		double precision;
qt_aprovadas_w		double precision;
qt_reprovadas_w		double precision;
pr_aprovadas_w		double precision;


BEGIN

select 	count(*) qt_total,
	sum(CASE WHEN b.nr_seq_tipo=117 THEN  1  ELSE 0 END ) qt_aprovada,
	sum(CASE WHEN b.nr_seq_tipo=118 THEN  1  ELSE 0 END ) qt_nao_aprovada
into STRICT	qt_total_w,
	qt_aprovadas_w,
	qt_reprovadas_w
from 	man_ordem_servico a,
	man_ordem_serv_tecnico b
where 	a.nr_sequencia = b.nr_seq_ordem_serv
and 	b.dt_historico between dt_inicial_p and dt_final_p
and	coalesce(b.dt_inativacao::text, '') = ''
and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
and 	NR_SEQ_TIPO in (117,118)
and	exists (	SELECT	1
			from	os_recebida_gerencia_desenv_v c
			where	c.nr_sequencia		= a.nr_sequencia
			and	c.ie_area_gerencia	= 'DES');


pr_aprovadas_w	:= (qt_aprovadas_w * 100) / qt_total_w;


return	pr_aprovadas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_perc_aprovadas_vv (dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
