-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_a1200_80 ( nr_seq_pacote_p ptu_pacote.nr_sequencia%type, cd_interface_p interface.cd_interface%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ds_conteudo_w		varchar(4000);
nr_seq_linha_w		bigint := 0;
qt_tot_202_w		bigint := 0;
qt_tot_203_w		bigint := 0;
qt_tot_204_w		bigint := 0;
qt_tot_210_w		bigint := 0;
qt_tot_211_w		bigint := 0;
ds_arquivo_w		text;
ds_hash_w		ptu_pacote.ds_hash%type;

-- R201 ¿ HEADER (OBRIGATÓRIO)
c01 CURSOR(nr_seq_pacote_pc	ptu_pacote.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		lpad(coalesce(cd_unimed_origem,'0'),'4','0') cd_unimed_origem,
		lpad(coalesce(to_char(dt_geracao,'yyyymmdd'),' '),8,' ') dt_geracao,
		coalesce(ie_tipo_carga,1) ie_tipo_carga,
		coalesce(ie_tipo_informacao,1) ie_tipo_informacao,
		coalesce(nr_versao_transacao,'03') nr_versao_transacao
	from	ptu_pacote
	where	nr_sequencia	= nr_seq_pacote_pc;

-- R202 ¿ PACOTE (OBRIGATÓRIO)
c02 CURSOR(nr_seq_pacote_pc	ptu_pacote.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		lpad(coalesce(to_char(cd_pacote),'0'),8,'0') cd_pacote,
		rpad(substr(coalesce(nm_pacote,' '),1,60),60,' ') nm_pacote,
		lpad(coalesce(cd_unimed_prestador,'0'),'4','0') cd_unimed_prestador,
		lpad(coalesce(to_char(cd_prestador),'0'),8,'0') cd_prestador,
		rpad(substr(coalesce(nm_prestador,' '),1,40),40,' ') nm_prestador,
		lpad(coalesce(to_char(dt_negociacao,'yyyymmdd'),' '),8,' ') dt_negociacao,
		lpad(coalesce(to_char(dt_publicacao,'yyyymmdd'),' '),8,' ') dt_publicacao,
		rpad(coalesce(ie_tipo_acomodacao,' '),2,' ') ie_tipo_acomodacao,
		lpad(coalesce(to_char(ie_tipo_pacote),'0'),2,'0') ie_tipo_pacote,
		lpad(coalesce(to_char(cd_especialidade),'0'),2,'0') cd_especialidade,
		lpad(coalesce(to_char(dt_inicio_vigencia,'yyyymmdd'),' '),8,' ') dt_inicio_vigencia,
		lpad(coalesce(to_char(dt_fim_vigencia,'yyyymmdd'),' '),8,' ') dt_fim_vigencia,
		coalesce(ie_tipo_internacao,'0') ie_tipo_internacao,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_taxas,2),',',''),'.',''),'0'),14,'0') vl_tot_taxas,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_diarias,2),',',''),'.',''),'0'),14,'0') vl_tot_diarias,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_gases,2),',',''),'.',''),'0'),14,'0') vl_tot_gases,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_mat,2),',',''),'.',''),'0'),14,'0') vl_tot_mat,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_med,2),',',''),'.',''),'0'),14,'0') vl_tot_med,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_proc,2),',',''),'.',''),'0'),14,'0') vl_tot_proc,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_opme,2),',',''),'.',''),'0'),14,'0') vl_tot_opme,
		lpad(coalesce(replace(replace(campo_mascara(vl_tot_pacote,2),',',''),'.',''),'0'),14,'0') vl_tot_pacote,
		coalesce(ie_honorario,'N') ie_honorario,
		substr(ds_observacao,1,999) ds_observacao
	from	ptu_pacote_reg
	where	nr_seq_pacote		= nr_seq_pacote_pc
	and	ie_tipo_informacao	= 1;

-- R204 ¿ SERVIÇO - PACOTE (OBRIGATÓRIO)
c03 CURSOR(nr_seq_pacote_reg_pc	ptu_pacote_reg.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		coalesce(ie_tipo_item,'0') ie_tipo_item,
		coalesce(ie_tipo_tabela,'0') ie_tipo_tabela,
		lpad(coalesce(cd_servico,'0'),8,'0') cd_servico,
		coalesce(ie_principal,'1') ie_principal,
		coalesce(ie_honorario,'N') ie_honorario,
		coalesce(ie_tipo_participacao,'0') ie_tipo_participacao,
		lpad(coalesce(qt_servico*10000,'0'),8,'0') qt_servico,
		lpad(coalesce(replace(replace(campo_mascara(vl_servico,2),',',''),'.',''),'0'),14,'0') vl_servico,
		rpad(substr(coalesce(ds_servico,' '),1,80),80,' ') ds_servico
	from	ptu_pacote_servico
	where	nr_seq_pacote_reg	= nr_seq_pacote_reg_pc;

-- R210 ¿ TABELA CONTRATUALIZADA (OBRIGATÓRIO)
c04 CURSOR(nr_seq_pacote_pc	ptu_pacote.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		lpad(coalesce(cd_unimed_prestador,'0'),'4','0') cd_unimed_prestador,
		lpad(coalesce(to_char(cd_prestador),'0'),8,'0') cd_prestador,
		rpad(substr(coalesce(nm_prestador,' '),1,40),40,' ') nm_prestador,
		lpad(coalesce(to_char(dt_negociacao,'yyyymmdd'),' '),8,' ') dt_negociacao,
		lpad(coalesce(to_char(dt_publicacao,'yyyymmdd'),' '),8,' ') dt_publicacao
	from	ptu_pacote_reg
	where	nr_seq_pacote		= nr_seq_pacote_pc
	and	ie_tipo_informacao	= 2;

-- R211 ¿ SERVIÇO - TABELA CONTRATUALIZADA (OBRIGATÓRIO)
c05 CURSOR(nr_seq_pacote_reg_pc	ptu_pacote_reg.nr_sequencia%type) FOR
	SELECT	nr_sequencia,
		coalesce(ie_tipo_item,'0') ie_tipo_item,
		coalesce(ie_tipo_tabela,'0') ie_tipo_tabela,
		lpad(coalesce(cd_servico,'0'),8,'0') cd_servico,
		lpad(coalesce(replace(replace(campo_mascara(vl_servico,2),',',''),'.',''),'0'),14,'0') vl_servico
	from	ptu_pacote_servico
	where	nr_seq_pacote_reg	= nr_seq_pacote_reg_pc;
BEGIN
delete	FROM w_ptu_envio_arq
where	nm_usuario = nm_usuario_p;

-- R201 ¿ HEADER (OBRIGATÓRIO)
for r_C01_w in C01(nr_seq_pacote_p) loop
	nr_seq_linha_w	:=	nr_seq_linha_w + 1;
	ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
				'201' ||
				r_C01_w.cd_unimed_origem ||
				r_C01_w.dt_geracao ||
				r_C01_w.ie_tipo_carga ||
				r_C01_w.ie_tipo_informacao ||
				r_C01_w.nr_versao_transacao;
	ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;

	insert	into w_ptu_envio_arq(ds_conteudo,
		dt_atualizacao,
		nm_usuario,
		nr_seq_apres,
		nr_sequencia)
	values (ds_conteudo_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_linha_w,
		nextval('w_ptu_envio_arq_seq'));

	-- R202 ¿ PACOTE (OBRIGATÓRIO)
	for r_C02_w in C02(r_C01_w.nr_sequencia) loop
		qt_tot_202_w	:=	qt_tot_202_w + 1;
		nr_seq_linha_w	:=	nr_seq_linha_w + 1;
		ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
					'202' ||
					r_C02_w.cd_pacote ||
					r_C02_w.nm_pacote ||
					r_C02_w.cd_unimed_prestador ||
					r_C02_w.cd_prestador ||
					r_C02_w.nm_prestador ||
					r_C02_w.dt_negociacao ||
					r_C02_w.dt_publicacao ||
					r_C02_w.ie_tipo_acomodacao ||
					r_C02_w.ie_tipo_pacote ||
					r_C02_w.cd_especialidade ||
					r_C02_w.dt_inicio_vigencia ||
					r_C02_w.dt_fim_vigencia ||
					r_C02_w.ie_tipo_internacao ||
					r_C02_w.vl_tot_taxas ||
					r_C02_w.vl_tot_diarias ||
					r_C02_w.vl_tot_gases ||
					r_C02_w.vl_tot_mat ||
					r_C02_w.vl_tot_med ||
					r_C02_w.vl_tot_proc ||
					r_C02_w.vl_tot_opme ||
					r_C02_w.vl_tot_pacote ||
					r_C02_w.ie_honorario;
		ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;


		insert	into w_ptu_envio_arq(ds_conteudo,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_sequencia)
		values (ds_conteudo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_linha_w,
			nextval('w_ptu_envio_arq_seq'));

		-- R203 ¿ OBSERVAÇÃO (OPCIONAL)
		if ((trim(both r_C02_w.ds_observacao) IS NOT NULL AND (trim(both r_C02_w.ds_observacao))::text <> '')) then
			qt_tot_203_w	:=	qt_tot_203_w + 1;
			nr_seq_linha_w	:=	nr_seq_linha_w + 1;
			ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
						'203' ||
						r_C02_w.cd_pacote ||
						r_C02_w.ds_observacao;
			ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;


			insert	into w_ptu_envio_arq(ds_conteudo,
				dt_atualizacao,
				nm_usuario,
				nr_seq_apres,
				nr_sequencia)
			values (ds_conteudo_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_linha_w,
				nextval('w_ptu_envio_arq_seq'));
		end if;

		-- R204 ¿ SERVIÇO - PACOTE (OBRIGATÓRIO)
		for r_C03_w in C03(r_C02_w.nr_sequencia) loop
			qt_tot_204_w	:=	qt_tot_204_w + 1;
			nr_seq_linha_w	:=	nr_seq_linha_w + 1;
			ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
						'204' ||
						r_C03_w.ie_tipo_item ||
						r_C03_w.ie_tipo_tabela ||
						r_C03_w.cd_servico ||
						r_C03_w.ie_principal ||
						'  ' ||
						r_C03_w.qt_servico ||
						r_C03_w.vl_servico ||
						r_C03_w.ds_servico;
			ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;

			insert	into w_ptu_envio_arq(ds_conteudo,
				dt_atualizacao,
				nm_usuario,
				nr_seq_apres,
				nr_sequencia)
			values (ds_conteudo_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_linha_w,
				nextval('w_ptu_envio_arq_seq'));
		end loop;

	end loop;

	-- R210 ¿ TABELA CONTRATUALIZADA (OBRIGATÓRIO)
	for r_C04_w in C04(r_C01_w.nr_sequencia) loop
		qt_tot_210_w	:=	qt_tot_210_w + 1;
		nr_seq_linha_w	:=	nr_seq_linha_w + 1;
		ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
					'210' ||
					r_C04_w.cd_unimed_prestador ||
					r_C04_w.cd_prestador ||
					r_C04_w.nm_prestador ||
					r_C04_w.dt_negociacao ||
					r_C04_w.dt_publicacao;
		ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;

		insert	into w_ptu_envio_arq(ds_conteudo,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_sequencia)
		values (ds_conteudo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_linha_w,
			nextval('w_ptu_envio_arq_seq'));

		-- R211 ¿ SERVIÇO - TABELA CONTRATUALIZADA (OBRIGATÓRIO)
		for r_C05_w in C05(r_C04_w.nr_sequencia) loop
			qt_tot_211_w	:=	qt_tot_211_w + 1;
			nr_seq_linha_w	:=	nr_seq_linha_w + 1;
			ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
						'211' ||
						r_C05_w.ie_tipo_item ||
						r_C05_w.ie_tipo_tabela ||
						r_C05_w.cd_servico ||
						r_C05_w.vl_servico;
			ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;

			insert	into w_ptu_envio_arq(ds_conteudo,
				dt_atualizacao,
				nm_usuario,
				nr_seq_apres,
				nr_sequencia)
			values (ds_conteudo_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_linha_w,
				nextval('w_ptu_envio_arq_seq'));
		end loop;
	end loop;
end loop;

-- R215 ¿ TRAILER (OBRIGATÓRIO)
nr_seq_linha_w	:=	nr_seq_linha_w + 1;
ds_conteudo_w 	:=	lpad(nr_seq_linha_w,8,'0') ||
			'215' ||
			lpad(to_char(qt_tot_202_w),5,'0') ||
			lpad(to_char(qt_tot_203_w),5,'0') ||
			lpad(to_char(qt_tot_204_w),5,'0') ||
			lpad(to_char(qt_tot_210_w),5,'0') ||
			lpad(to_char(qt_tot_211_w),5,'0');
ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;

insert	into w_ptu_envio_arq(ds_conteudo,
	dt_atualizacao,
	nm_usuario,
	nr_seq_apres,
	nr_sequencia)
values (ds_conteudo_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_linha_w,
	nextval('w_ptu_envio_arq_seq'));

-- HASH (OBRIGATÓRIO)
nr_seq_linha_w	:=	nr_seq_linha_w + 1;
ds_arquivo_w := pls_hash_ptu_pck.obter_hash_txt(ds_arquivo_w); -- Gerar HASH
ds_conteudo_w 	:= 	lpad(nr_seq_linha_w,8,'0') ||
			'998' ||
			ds_hash_w;

insert	into w_ptu_envio_arq(ds_conteudo,
	dt_atualizacao,
	nm_usuario,
	nr_seq_apres,
	nr_sequencia)
values (ds_conteudo_w,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_linha_w,
	nextval('w_ptu_envio_arq_seq'));

update	ptu_pacote
set	ds_hash		= ds_hash_w
where	nr_sequencia	= nr_seq_pacote_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_a1200_80 ( nr_seq_pacote_p ptu_pacote.nr_sequencia%type, cd_interface_p interface.cd_interface%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

