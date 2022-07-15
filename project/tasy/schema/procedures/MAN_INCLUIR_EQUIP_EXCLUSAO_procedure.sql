-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_incluir_equip_exclusao ( nr_seq_equipamento_p bigint, nr_seq_planejamento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w	bigint;


BEGIN
select 	count(*)
into STRICT	qt_registro_w
from	man_planej_prev_equip_excl
where	nr_seq_equipamento = nr_seq_equipamento_p
and	nr_seq_planej_prev = nr_seq_planejamento_p;

if (qt_registro_w = 0)	then
	insert 	into 	man_planej_prev_equip_excl(	nr_sequencia,
			nr_seq_planej_prev,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nr_seq_equipamento,
			nm_usuario_nrec)
		values (	nextval('man_planej_prev_equip_excl_seq'),
			nr_seq_planejamento_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_equipamento_p,
			nm_usuario_p);
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_incluir_equip_exclusao ( nr_seq_equipamento_p bigint, nr_seq_planejamento_p bigint, nm_usuario_p text) FROM PUBLIC;

