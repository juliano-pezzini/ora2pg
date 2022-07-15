-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acerto_empresa_financ () AS $body$
DECLARE


cd_empresa_w			bigint;
nr_sequencia_w			bigint;
cd_estabelecimento_w		bigint;
cd_conta_financ_w		bigint;
cont_w				bigint;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_estabelecimento
from	transacao_financeira;

c02 CURSOR FOR
SELECT	cd_conta_financ,
	cd_estabelecimento
from	conta_financeira;

c03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_estabelecimento
from	estabelecimento b,
	transacao_financeira a
where	(a.cd_empresa IS NOT NULL AND a.cd_empresa::text <> '')
and	(a.cd_estabelecimento IS NOT NULL AND a.cd_estabelecimento::text <> '')
and	a.cd_estabelecimento	= b.cd_estabelecimento
and	a.cd_empresa		<> b.cd_empresa;


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	max(cd_empresa)
	into STRICT	cd_empresa_w
	from	estabelecimento
	where	cd_estabelecimento	= cd_estabelecimento_w;

	update	transacao_financeira
	set	cd_empresa	= cd_empresa_w
	where	nr_sequencia	= nr_sequencia_w
	and	coalesce(cd_empresa::text, '') = '';

	update	trans_financ_contab
	set	cd_estabelecimento	= cd_estabelecimento_w
	where	nr_seq_trans_financ	= nr_sequencia_w
	and	coalesce(cd_estabelecimento::text, '') = '';


end loop;
close c01;

commit;

open c03;
loop
fetch c03 into
	nr_sequencia_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c03 */

	select	max(cd_empresa)
	into STRICT	cd_empresa_w
	from	estabelecimento
	where	cd_estabelecimento	= cd_estabelecimento_w;

	update	transacao_financeira
	set	cd_empresa	= cd_empresa_w
	where	nr_sequencia	= nr_sequencia_w;

end loop;
close c03;


commit;

open c02;
loop
fetch c02 into
	cd_conta_financ_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	select	max(cd_empresa)
	into STRICT	cd_empresa_w
	from	estabelecimento
	where	cd_estabelecimento	= cd_estabelecimento_w;

	update	conta_financeira
	set	cd_empresa	= cd_empresa_w
	where	cd_conta_financ	= cd_conta_financ_w
	and	coalesce(cd_empresa::text, '') = '';

end loop;
close c02;

commit;

select	count(*)
into STRICT	cont_w
from	fluxo_caixa
where	coalesce(cd_empresa::text, '') = '';

while(cont_w	> 0) loop

	update	fluxo_caixa a
	set	a.cd_empresa	= (SELECT x.cd_empresa from estabelecimento x where x.cd_estabelecimento = a.cd_estabelecimento)
	where	coalesce(a.cd_empresa::text, '') = ''  LIMIT 5000;

	commit;

	cont_w	:= cont_w - 5000;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acerto_empresa_financ () FROM PUBLIC;

