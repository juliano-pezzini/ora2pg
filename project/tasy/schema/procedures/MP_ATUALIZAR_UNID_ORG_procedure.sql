-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mp_atualizar_unid_org (nr_seq_proc_objeto_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_topo_objeto_w	bigint;
qt_topo_raia_w		bigint;
qt_altura_raia_w	bigint;
nr_seq_processo_w	bigint;
nr_seq_processo_ref_w	bigint;
qt_registro_w		bigint;
nr_seq_unid_org_w	bigint;


c01 CURSOR FOR
SELECT	qt_topo,
	qt_altura,
	nr_seq_unid_org
from	mp_processo_raia
where	nr_seq_processo	= nr_seq_processo_w
order by
	qt_topo;


BEGIN

if (nr_seq_proc_objeto_p IS NOT NULL AND nr_seq_proc_objeto_p::text <> '') then
	select	qt_topo,
		nr_seq_processo
	into STRICT	qt_topo_objeto_w,
		nr_seq_processo_w
	from	mp_processo_objeto
	where	nr_sequencia	= nr_seq_proc_objeto_p;

	open c01;
	loop
	fetch c01 into
		qt_topo_raia_w,
		qt_altura_raia_w,
		nr_seq_unid_org_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		if (qt_topo_objeto_w > qt_topo_raia_w) and (qt_topo_objeto_w < qt_topo_raia_w + qt_altura_raia_w) then

			select	max(nr_seq_processo_ref)
			into STRICT	nr_seq_processo_ref_w
			from	mp_processo_objeto
			where	nr_sequencia = nr_seq_proc_objeto_p;

			if (nr_seq_processo_ref_w IS NOT NULL AND nr_seq_processo_ref_w::text <> '') then
				select	count(*)
				into STRICT	qt_registro_w
				from	mp_processo_unid_org
				where	nr_seq_unid_org	= nr_seq_unid_org_w
				and	nr_seq_processo	= nr_seq_processo_ref_w;

				if (qt_registro_w = 0) then
					delete	from	mp_processo_unid_org
					where	nr_seq_processo	= nr_seq_processo_ref_w;

					insert	into	mp_processo_unid_org(nr_sequencia,
						nm_usuario,
						dt_atualizacao,
						nm_usuario_nrec,
						dt_atualizacao_nrec,
						nr_seq_unid_org,
						nr_seq_processo)
					values (nextval('mp_processo_unid_org_seq'),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nr_seq_unid_org_w,
						nr_seq_processo_ref_w);
				end if;
			else
				select	count(*)
				into STRICT	qt_registro_w
				from	mp_proc_obj_unid_org
				where	nr_seq_unid_org	= nr_seq_unid_org_w
				and	nr_seq_proc_obj = nr_seq_proc_objeto_p;


				if (qt_registro_w = 0) then
					delete	from	mp_proc_obj_unid_org
					where	nr_seq_proc_obj	= nr_seq_proc_objeto_p;

					insert	into	mp_proc_obj_unid_org(nr_sequencia,
						nm_usuario,
						dt_atualizacao,
						nm_usuario_nrec,
						dt_atualizacao_nrec,
						nr_seq_unid_org,
						nr_seq_proc_obj)
					values (nextval('mp_processo_unid_org_seq'),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nr_seq_unid_org_w,
						nr_seq_proc_objeto_p);
				end if;

			end if;
		else
			select	max(nr_seq_processo_ref)
			into STRICT	nr_seq_processo_ref_w
			from	mp_processo_objeto
			where	nr_sequencia = nr_seq_proc_objeto_p;

			if (nr_seq_processo_ref_w IS NOT NULL AND nr_seq_processo_ref_w::text <> '') then
				delete 	from 	mp_processo_unid_org
				where	nr_seq_unid_org	= nr_seq_unid_org_w
				and	nr_seq_processo	= nr_seq_processo_ref_w;
			else
				delete	from	mp_proc_obj_unid_org
				where	nr_seq_unid_org	= nr_seq_unid_org_w
				and	nr_seq_proc_obj = nr_seq_proc_objeto_p;
			end if;
		end if;

	end loop;
	close c01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mp_atualizar_unid_org (nr_seq_proc_objeto_p bigint, nm_usuario_p text) FROM PUBLIC;
