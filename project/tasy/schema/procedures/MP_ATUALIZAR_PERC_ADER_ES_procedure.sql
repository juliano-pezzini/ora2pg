-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mp_atualizar_perc_ader_es ( nr_seq_proc_obj_p bigint, nm_usuario_p text) AS $body$
DECLARE


pr_aderencia_w		double precision;


BEGIN

if (nr_seq_proc_obj_p IS NOT NULL AND nr_seq_proc_obj_p::text <> '') then

	select	avg(a.pr_aderencia)
	into STRICT	pr_aderencia_w
	from	mp_proc_obj_es a
	where	a.nr_seq_proc_obj	= nr_seq_proc_obj_p;

	update	mp_processo_objeto
	set	pr_aderencia_es	= pr_aderencia_w
	where	nr_sequencia	= nr_seq_proc_obj_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mp_atualizar_perc_ader_es ( nr_seq_proc_obj_p bigint, nm_usuario_p text) FROM PUBLIC;

