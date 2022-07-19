-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_regra_desc_estab () AS $body$
DECLARE


nr_seq_plano_w			bigint;
cd_estab_plano_w		bigint;
nr_seq_contrato_w		bigint;
cd_estab_contrato_w		bigint;
nr_seq_proposta_w		bigint;
cd_estab_proposta_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_plano
	from	pls_regra_desconto
	where	(nr_seq_plano IS NOT NULL AND nr_seq_plano::text <> '')
	and	coalesce(cd_estabelecimento::text, '') = '';

C02 CURSOR FOR
	SELECT	nr_seq_contrato
	from	pls_regra_desconto
	where	(nr_seq_contrato IS NOT NULL AND nr_seq_contrato::text <> '')
	and	coalesce(cd_estabelecimento::text, '') = '';

C03 CURSOR FOR
	SELECT	nr_seq_proposta
	from	pls_regra_desconto
	where	(nr_seq_proposta IS NOT NULL AND nr_seq_proposta::text <> '')
	and	coalesce(cd_estabelecimento::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_plano_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(cd_estabelecimento)
	into STRICT	cd_estab_plano_w
	from	pls_plano
	where	nr_sequencia	= nr_seq_plano_w;

	if (cd_estab_plano_w IS NOT NULL AND cd_estab_plano_w::text <> '') then
		update	pls_regra_desconto
		set	cd_estabelecimento	= cd_estab_plano_w
		where	nr_seq_plano		= nr_seq_plano_w
		and	coalesce(cd_estabelecimento::text, '') = '';
	end if;
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into
	nr_seq_contrato_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	select	max(cd_estabelecimento)
	into STRICT	cd_estab_contrato_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;

	if (cd_estab_contrato_w IS NOT NULL AND cd_estab_contrato_w::text <> '') then
		update	pls_regra_desconto
		set	cd_estabelecimento	= cd_estab_contrato_w
		where	nr_seq_contrato		= nr_seq_contrato_w
		and	coalesce(cd_estabelecimento::text, '') = '';
	end if;

	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	nr_seq_proposta_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin

	select	max(cd_estabelecimento)
	into STRICT	cd_estab_proposta_w
	from	pls_proposta_adesao
	where	nr_sequencia	= nr_seq_proposta_w;

	if (cd_estab_proposta_w IS NOT NULL AND cd_estab_proposta_w::text <> '') then
		update	pls_regra_desconto
		set	cd_estabelecimento	= cd_estab_proposta_w
		where	nr_seq_proposta		= nr_seq_proposta_w
		and	coalesce(cd_estabelecimento::text, '') = '';
	end if;

	end;
end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_regra_desc_estab () FROM PUBLIC;

