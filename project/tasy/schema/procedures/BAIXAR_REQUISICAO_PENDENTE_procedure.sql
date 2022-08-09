-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_requisicao_pendente (qt_dias_p bigint) AS $body$
DECLARE


nr_requisicao_w				bigint;
nr_registros_w				bigint;


BEGIN

select count(distinct nr_requisicao), count(*)
into STRICT nr_requisicao_w, nr_registros_w
from item_requisicao_material
where dt_atualizacao < clock_timestamp() - qt_dias_p
and coalesce(dt_atendimento::text, '') = '';

update item_requisicao_material
set cd_motivo_baixa = 2,
   dt_atendimento = clock_timestamp(),
   qt_Material_atendida = 0
where dt_atualizacao < clock_timestamp() - qt_dias_p
and coalesce(dt_atendimento::text, '') = '';

update	requisicao_material a
set	a.dt_baixa = clock_timestamp()
where	exists (	SELECT	1
		from	item_requisicao_material x
		where	x.nr_requisicao = a.nr_requisicao)
and	not exists (	select	1
		from	item_requisicao_material x
		where	x.nr_requisicao = a.nr_requisicao
		and	coalesce(x.dt_atendimento::text, '') = '')
and 	coalesce(a.dt_baixa::text, '') = '';

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_requisicao_pendente (qt_dias_p bigint) FROM PUBLIC;
