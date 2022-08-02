-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_dlp_utilizar_cpt_cobertura ( ie_cpt_agravo_p text, nr_seq_tipo_cpt_p bigint, nr_seq_agravo_p bigint, nr_seq_analise_preexist_p bigint, nr_seq_valor_agravo_p bigint, nr_seq_analise_adesao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_agravo_w			bigint;
qt_cpt_w			bigint;
nr_seq_analise_w		bigint;
nr_seq_pessoa_proposta_w	bigint;
qt_dias_w			bigint;
ie_classificacao_dlp_w		varchar(2);
qt_parcelas_w			bigint;
vl_agravo_w			double precision;
tx_agravo_w			double precision;
nr_seq_analise_agravo_w		bigint;


BEGIN

if (coalesce(nr_seq_analise_preexist_p,0) <> 0) then
	select	count(*)
	into STRICT	qt_agravo_w
	from	pls_analise_agravo
	where	nr_seq_analise_preexist = nr_seq_analise_preexist_p
	and	nr_seq_agravo		= nr_seq_agravo_p;

	select	count(*)
	into STRICT	qt_cpt_w
	from	pls_carencia
	where	nr_seq_analise_preexist = nr_seq_analise_preexist_p
	and	nr_seq_tipo_carencia	= nr_seq_tipo_cpt_p;

	if (qt_agravo_w > 0) and (ie_cpt_agravo_p = 'A') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(202365);
	elsif (qt_cpt_w > 0) and (ie_cpt_agravo_p = 'C') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(202366);
	end if;

	begin
	select	nr_seq_analise,
		ie_classificacao_dlp
	into STRICT	nr_seq_analise_w,
		ie_classificacao_dlp_w
	from	pls_analise_preexistencia
	where	nr_sequencia	= nr_seq_analise_preexist_p;
	exception
	when others then
		nr_seq_analise_w	:= null;
	end;

	if (ie_cpt_agravo_p = 'A') then
		if (coalesce(nr_seq_agravo_p,0) = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(202367);
		end if;

		begin
		select	qt_parcelas,
			vl_agravo,
			tx_agravo
		into STRICT	qt_parcelas_w,
			vl_agravo_w,
			tx_agravo_w
		from	pls_agravo_valor
		where	nr_sequencia	= nr_seq_valor_agravo_p;
		exception
		when others then
			qt_parcelas_w	:= null;
			vl_agravo_w	:= null;
			tx_agravo_w	:= null;
		end;

		select	nextval('pls_analise_agravo_seq')
		into STRICT	nr_seq_analise_agravo_w
		;

		insert	into	pls_analise_agravo(nr_sequencia, nr_seq_analise, cd_estabelecimento,
			nr_seq_agravo, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_analise_preexist,
			ie_tipo_agravo, qt_parcelas_agravo, vl_agravo,tx_agravo)
		values (nr_seq_analise_agravo_w, nr_seq_analise_w, cd_estabelecimento_p,
			nr_seq_agravo_p, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, nr_seq_analise_preexist_p,
			ie_classificacao_dlp_w, qt_parcelas_w, vl_agravo_w,tx_agravo_w);
		/*aaschlote 20/12/2010 - Gerar o agravo ao inseir na analise*/

		CALL pls_gerar_parc_agravo_analise(nr_seq_analise_agravo_w,'G',cd_estabelecimento_p,nm_usuario_p);
	elsif (ie_cpt_agravo_p = 'C') then
		if (coalesce(nr_seq_tipo_cpt_p,0) = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(202368);
		end if;

		select	max(qt_dias_padrao)
		into STRICT	qt_dias_w
		from	pls_tipo_carencia
		where	nr_sequencia = nr_seq_tipo_cpt_p;

		select	max(nr_seq_pessoa_proposta)
		into STRICT	nr_seq_pessoa_proposta_w
		from	pls_analise_adesao
		where	nr_sequencia	= nr_seq_analise_w;

		insert	into	pls_carencia(nr_sequencia, nr_seq_tipo_carencia,qt_dias,
			dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
			nm_usuario_nrec, nr_seq_analise_preexist, nr_seq_pessoa_proposta,
			nr_seq_analise_adesao)
			values (nextval('pls_carencia_seq'), nr_seq_tipo_cpt_p, coalesce(qt_dias_w,0),
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			nm_usuario_p, nr_seq_analise_preexist_p, nr_seq_pessoa_proposta_w,
			nr_seq_analise_adesao_p);
	end if;

	update	pls_analise_preexistencia
	set	ie_acao_preexistencia	= ie_cpt_agravo_p
	where	nr_sequencia	= nr_seq_analise_preexist_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dlp_utilizar_cpt_cobertura ( ie_cpt_agravo_p text, nr_seq_tipo_cpt_p bigint, nr_seq_agravo_p bigint, nr_seq_analise_preexist_p bigint, nr_seq_valor_agravo_p bigint, nr_seq_analise_adesao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

