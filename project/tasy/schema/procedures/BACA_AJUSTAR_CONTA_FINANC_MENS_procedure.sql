-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_conta_financ_mens (nm_usuario_p text) AS $body$
DECLARE


nr_titulo_w		bigint;
nr_seq_nota_fiscal_w	bigint;
cd_estabelecimento_w	bigint;
nr_seq_mensalidade_w	bigint;
cd_conta_financ_w	bigint;

c01 CURSOR FOR
SELECT	a.nr_titulo,
	a.nr_seq_mensalidade,
	a.nr_seq_nf_saida,
	a.cd_estabelecimento
from	titulo_receber a
where	(a.nr_seq_mensalidade IS NOT NULL AND a.nr_seq_mensalidade::text <> '')
and	exists (select	1
		from	titulo_receber_classif x
		where	x.nr_titulo	= a.nr_titulo
		and	coalesce(x.cd_conta_financ::text, '') = '');


BEGIN

open c01;
loop
fetch c01 into
	nr_titulo_w,
	nr_seq_mensalidade_w,
	nr_seq_nota_fiscal_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	cd_conta_financ_w := pls_obter_conta_financ_regra(	'M', nr_seq_mensalidade_w, cd_estabelecimento_w, null, null, null, null, null, null, null, null, null, null, null, null, null, null, cd_conta_financ_w);

	if (cd_conta_financ_w IS NOT NULL AND cd_conta_financ_w::text <> '') then
		/*insert into logxxx_tasy(nm_usuario,
				dt_atualizacao,
				cd_log,
				ds_log)
		values	(nm_usuario_p,
			sysdate,
			55844,
			't=' || nr_titulo_w || ' cf= ' || cd_conta_financ_w);*/
		update	titulo_receber_classif
		set	cd_conta_financ	= cd_conta_financ_w
		where	nr_titulo	= nr_titulo_w
		and	coalesce(cd_conta_financ::text, '') = '';

		if (nr_seq_nota_fiscal_w IS NOT NULL AND nr_seq_nota_fiscal_w::text <> '') then
			update	nota_fiscal_item
			set	nr_seq_conta_financ	= cd_conta_financ_w
			where	nr_sequencia	= nr_seq_nota_fiscal_w
			and	coalesce(nr_seq_conta_financ::text, '') = '';
		end if;
	end if;

	end;
end loop;
close c01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_conta_financ_mens (nm_usuario_p text) FROM PUBLIC;
