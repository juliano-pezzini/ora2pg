-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_atualizar_concil ( nr_seq_concil_p bigint) AS $body$
DECLARE


qt_total_mov_w			bigint;

c_contas CURSOR FOR
SELECT	a.cd_conta_contabil,
		count(b.nr_sequencia) nr_sequencia,
		sum(CASE WHEN b.ie_status_concil='NC' THEN 1  ELSE 0 END ) qt_nao_conciliado,
		sum(CASE WHEN b.ie_status_concil='C' THEN 1  ELSE 0 END ) qt_conciliado
from	ctb_registro_concil_conta a,
		ctb_movimento_v b
where	b.cd_conta_contabil	= a.cd_conta_contabil
and		b.nr_seq_reg_concil	= nr_seq_concil_p
and		a.nr_seq_reg_concil = b.nr_seq_reg_concil
group by a.cd_conta_contabil;

BEGIN

for vet in c_contas loop
	begin
	qt_total_mov_w	:= vet.qt_conciliado + vet.qt_nao_conciliado;

	update	ctb_registro_concil_conta
	set		qt_total_mov		= qt_total_mov_w,
			qt_mov_concil		= vet.qt_conciliado,
			qt_mov_pendente		= vet.qt_nao_conciliado
	where	nr_seq_reg_concil	= nr_seq_concil_p
	and		cd_conta_contabil	= vet.cd_conta_contabil;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_atualizar_concil ( nr_seq_concil_p bigint) FROM PUBLIC;
