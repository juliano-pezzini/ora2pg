-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_regra_desconto ( cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_regra_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_desconto
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	coalesce(nr_seq_contrato::text, '') = ''
	and 	coalesce(nr_seq_plano::text, '') = ''
	and 	coalesce(nr_seq_proposta::text, '') = '';


BEGIN


open C01;
loop
fetch C01 into
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	delete	FROM pls_preco_regra_autom
	where	nr_seq_regra	= nr_seq_regra_w;

	delete	FROM pls_regra_simul_preco_desc
	where	nr_seq_regra	= nr_seq_regra_w;

	delete	FROM pls_preco_regra
	where	nr_seq_regra	= nr_seq_regra_w;

	delete	FROM pls_regra_desconto
	where	nr_sequencia	= nr_seq_regra_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_regra_desconto ( cd_estabelecimento_p bigint) FROM PUBLIC;

