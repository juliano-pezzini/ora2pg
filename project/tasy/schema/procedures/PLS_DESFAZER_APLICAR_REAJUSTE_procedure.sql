-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_aplicar_reajuste ( nr_seq_reajuste_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_tabela_reaj_w		bigint;
nr_sequencia_w			bigint;
nr_seq_preco_w			bigint;
vl_reajustado_w			double precision;
nr_seq_tabela_w			bigint;
vl_preco_nao_subsid_reaj_w	double precision;
nr_seq_reajuste_preco_w		bigint;
vl_base_w			double precision;
pr_reajuste_w			double precision;
vl_atual_w			double precision;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_tabela
	from	pls_reajuste_tabela
	where	nr_seq_reajuste	= nr_seq_reajuste_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_preco,
		coalesce(vl_reajustado,0),
		coalesce(vl_preco_nao_subsidiado,0),
		coalesce(pr_reajustado,0)
	from	pls_reajuste_preco
	where	nr_seq_tabela	= nr_seq_tabela_reaj_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_tabela_reaj_w,
	nr_seq_tabela_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		nr_sequencia_w,
		nr_seq_preco_w,
		vl_reajustado_w,
		vl_preco_nao_subsid_reaj_w,
		pr_reajuste_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		if (coalesce(vl_preco_nao_subsid_reaj_w,0) > 0) then
			vl_preco_nao_subsid_reaj_w	:= vl_preco_nao_subsid_reaj_w - ((vl_preco_nao_subsid_reaj_w * pr_reajuste_w) / 100);
		end if;

		select	max(nr_sequencia)
		into STRICT	nr_seq_reajuste_preco_w
		from	pls_reajuste_preco
		where	nr_seq_preco	= nr_seq_preco_w
		and	nr_sequencia	<> nr_sequencia_w;

		if (coalesce(nr_seq_reajuste_preco_w,0)	= 0) then
			select	vl_base,
				vl_base
			into STRICT	vl_base_w,
				vl_atual_w
			from	pls_reajuste_preco
			where	nr_sequencia	= nr_sequencia_w;
		else
			select	vl_base,
				vl_reajustado
			into STRICT	vl_base_w,
				vl_atual_w
			from	pls_reajuste_preco
			where	nr_sequencia	= nr_seq_reajuste_preco_w;
		end if;

		update	pls_plano_preco
		set	vl_preco_inicial		= vl_base_w,
			vl_preco_atual			= vl_atual_w,
			vl_preco_nao_subsid_atual	= vl_preco_nao_subsid_reaj_w,
			dt_atualizacao			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	nr_sequencia			= nr_seq_preco_w;

		update	pls_reajuste_preco
		set	dt_liberacao	 = NULL,
			nm_usuario_lib	 = NULL
		where	nr_sequencia	= nr_sequencia_w;

		delete	from pls_reajuste_preco
		where	nr_sequencia	= nr_sequencia_w;

		end;
	end loop;
	close C02;

	update	pls_reajuste_tabela
	set	dt_liberacao	 = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_tabela_reaj_w;

	update	pls_segurado
	set	ie_tipo_valor	= 'I'
	where	nr_seq_tabela	= nr_seq_tabela_w;

	end;
end loop;
close C01;

update	pls_reajuste
set	ie_status	= '1',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_reajuste_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_aplicar_reajuste ( nr_seq_reajuste_p bigint, nm_usuario_p text) FROM PUBLIC;

