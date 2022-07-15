-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_conta_ticket ( nr_seq_regra_ticket_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



cd_conta_contabil_w		varchar(20);

c01 CURSOR FOR
SELECT	c.cd_conta_contabil
from	ctb_cen_grupo_conta_conta c,
	ctb_cen_grupo_conta b,
	ctb_regra_ticket_medio a
where	a.nr_seq_grupo_conta	= b.nr_sequencia
and	b.nr_sequencia		= c.nr_seq_grupo
and coalesce(b.cd_estab_exclusivo, cd_estabelecimento_p) = cd_estabelecimento_p
and	a.nr_sequencia		= nr_seq_regra_ticket_p;


BEGIN

delete	from ctb_regra_tm_distrib
where	nr_seq_regra_ticket		= nr_seq_regra_ticket_p;

commit;

open C01;
loop
fetch C01 into
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into ctb_regra_tm_distrib(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_regra_ticket,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_conta_contabil,
		pr_valor)
	values (	nextval('ctb_regra_tm_distrib_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_regra_ticket_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_conta_contabil_w,
		0);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_conta_ticket ( nr_seq_regra_ticket_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

