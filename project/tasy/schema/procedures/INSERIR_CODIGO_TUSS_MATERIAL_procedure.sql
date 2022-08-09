-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_codigo_tuss_material ( cd_material_p bigint, cd_material_tuss_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			tuss_material_item.nr_sequencia%type;
nr_seq_carga_tuss_w		tuss_material_item.nr_seq_carga_tuss%type;


BEGIN

select	coalesce(max(b.nr_sequencia),0)
into STRICT	nr_sequencia_w
from	tuss_material a,
	tuss_material_item b
where	a.nr_sequencia = b.nr_seq_carga_tuss
and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	b.cd_material_tuss = cd_material_tuss_p;

if (nr_sequencia_w > 0) then

	select	coalesce(max(nr_seq_carga_tuss),0)
	into STRICT	nr_seq_carga_tuss_w
	from	tuss_material a,
		tuss_material_item b
	where	a.nr_sequencia = b.nr_seq_carga_tuss
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	b.nr_sequencia = nr_sequencia_w;

	if (nr_sequencia_w > 0) then

		insert into material_tuss(
			nr_sequencia,
			cd_material,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_vigencia_inicial,
			nr_seq_tuss_mat,
			nr_seq_tuss_mat_item,
			cd_material_tuss,
			ie_situacao)
		values (	nextval('material_tuss_seq'),
			cd_material_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			trunc(clock_timestamp(),'dd'),
			nr_seq_carga_tuss_w,
			nr_sequencia_w,
			cd_material_tuss_p,
			'A');
	end if;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_codigo_tuss_material ( cd_material_p bigint, cd_material_tuss_p bigint, nm_usuario_p text) FROM PUBLIC;
