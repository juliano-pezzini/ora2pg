-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_lote_preco_fed ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
dt_preco_w			timestamp;
vl_preco_w			double precision;
cd_moeda_w			smallint;
cd_fornecedor_fed_sc_w		bigint;
cd_produto_w			bigint;
cd_material_w			varchar(10);
nr_seq_mat_unimed_w		bigint;
ie_possui_preco_w		bigint;
cd_fornecedor_fed_sc_ww		bigint;
cd_cgc_fornec_w			varchar(14);
nr_seq_prestador_w		bigint;
nr_seq_material_w		bigint;
ie_possui_fornec_w		bigint;
ds_erro_w			varchar(255);
nr_seq_preco_w			bigint;
ie_situacao_w			varchar(1);
nr_seq_preco_ativo_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		dt_preco,
		coalesce(vl_preco,0),
		cd_moeda,
		cd_fornecedor_fed_sc,
		cd_material,
		nr_seq_mat_unimed,
		ie_situacao
	from	pls_mat_uni_sc_pre_imp
	where	nr_seq_lote = nr_seq_lote_p;
	--and	ie_inconsistente = 'N';	OS 541822 - UL
C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_mat_unimed_fed_sc		b,
		pls_mat_uni_fed_sc_preco	a
	where	a.nr_seq_mat_unimed	= b.nr_sequencia
	and	b.cd_material		= cd_produto_w
	and	a.cd_fornecedor_fed_sc	= cd_fornecedor_fed_sc_w
	and	a.nr_sequencia		<> nr_seq_preco_w;


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	dt_preco_w,
	vl_preco_w,
	cd_moeda_w,
	cd_fornecedor_fed_sc_w,
	cd_produto_w,
	nr_seq_mat_unimed_w,
	ie_situacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_preco_w
	from	pls_mat_unimed_fed_sc		b,
		pls_mat_uni_fed_sc_preco	a
	where	a.nr_seq_mat_unimed	= b.nr_sequencia
	and	b.cd_material		= cd_produto_w
	and	a.dt_preco		= dt_preco_w
	and	a.cd_fornecedor_fed_sc	= cd_fornecedor_fed_sc_w
	and	a.vl_preco		= vl_preco_w;

	if (coalesce(nr_seq_preco_w::text, '') = '') then
		select	nextval('pls_mat_uni_fed_sc_preco_seq')
		into STRICT	nr_seq_preco_w
		;

		insert into pls_mat_uni_fed_sc_preco(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			cd_moeda,
			dt_preco,
			vl_preco,
			cd_fornecedor_fed_sc,
			nr_seq_mat_unimed,
			ie_situacao)
		values (nr_seq_preco_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_moeda_w,
			dt_preco_w,
			vl_preco_w,
			cd_fornecedor_fed_sc_w,
			nr_seq_mat_unimed_w,
			ie_situacao_w);

		open C02;
		loop
		fetch C02 into
			nr_seq_preco_ativo_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			update	pls_mat_uni_fed_sc_preco
			set	ie_situacao	= 'I'
			where	nr_sequencia	= nr_seq_preco_ativo_w;
			end;
		end loop;
		close C02;

		update	pls_mat_uni_sc_pre_imp
		set	nr_seq_preco	= nr_seq_preco_w
		where	nr_sequencia	= nr_sequencia_w;

		update	pls_mat_unimed_fed_sc
		set	ie_opme		= 'S'
		where	nr_sequencia	= nr_seq_mat_unimed_w;

		select	max(cd_fornecedor_fed_sc)
		into STRICT	cd_fornecedor_fed_sc_ww
		from	pls_mat_uni_fed_sc_preco
		where	nr_seq_mat_unimed	= nr_seq_mat_unimed_w
		and	(cd_fornecedor_fed_sc IS NOT NULL AND cd_fornecedor_fed_sc::text <> '');

		if (cd_fornecedor_fed_sc_ww IS NOT NULL AND cd_fornecedor_fed_sc_ww::text <> '') then
			select	count(1)
			into STRICT	ie_possui_fornec_w
			from	pls_fornec_mat_fed_sc
			where	cd_fornecedor	= cd_fornecedor_fed_sc_ww  LIMIT 1;
		else
			ie_possui_fornec_w	:= 1;
		end if;

		if (ie_possui_fornec_w	= 0) then
			ds_erro_w	:= sqlerrm;
			ds_erro_w	:= 'Não foi importado o arquivo de fornecedores, isto impede o processo, favor verifique.';

			CALL wheb_mensagem_pck.exibir_mensagem_abort(188180,'DS_ERRO=' || ds_erro_w);
		end if;

		select	max(cd_cgc)
		into STRICT	cd_cgc_fornec_w
		from	pls_fornec_mat_fed_sc
		where	cd_fornecedor	= cd_fornecedor_fed_sc_w;

		select	max(nr_sequencia)
		into STRICT	nr_seq_prestador_w
		from	pls_prestador a
		where	a.cd_cgc	= cd_cgc_fornec_w;

		select	max(cd_material)
		into STRICT	cd_material_w
		from	pls_mat_unimed_fed_sc a
		where	a.nr_sequencia	= nr_seq_mat_unimed_w;

		select	max(nr_sequencia)
		into STRICT	nr_seq_material_w
		from	pls_material
		where	cd_material_ops	= cd_material_w;

		if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') and (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
			insert into pls_prestador_mat(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_prestador,
				nr_seq_material,
				ie_liberar)
			values (nextval('pls_prestador_mat_seq'),
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_prestador_w,
				nr_seq_material_w,
				'S');
		end if;
	--Caso haja preço cadastrado, atualiza os dados do mesmo
	elsif (nr_seq_preco_w IS NOT NULL AND nr_seq_preco_w::text <> '') then
		update	pls_mat_uni_fed_sc_preco a
		set	a.ie_situacao		= ie_situacao_w
		where	a.nr_sequencia		= nr_seq_preco_w;

		if (ie_situacao_w = 'A') then
			update	pls_mat_unimed_fed_sc
			set	ie_opme	= 'S'
			where	nr_sequencia	= nr_seq_material_w;
		end if;
	end if;
	end;
end loop;
close C01;

update	pls_lote_preco_unimed_sc
set	dt_liberacao	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_seq_lote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_lote_preco_fed ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

