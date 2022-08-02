-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_w_guia_solic_radio (nr_sequencia_autor_p bigint, nr_seq_lote_anexo_p bigint, nm_usuario_p text, ds_dir_padrao_p text) AS $body$
DECLARE



cd_convenio_w			bigint;
cd_estabelecimento_w		bigint;
cd_ans_w			varchar(100);
ds_arquivo_logo_w		varchar(255);
ds_arquivo_logo_comp_w		varchar(255);
ie_gerar_tiss_w			varchar(10);
nr_seq_anexo_w			bigint;
nr_seq_guia_w			bigint;
ds_versao_w			varchar(20);
cd_pessoa_fisica_w		varchar(10);
cd_item_w			varchar(10);
ds_item_w			varchar(150);
cd_edicao_amb_w			varchar(2);
ie_opcao_fabricante_w		smallint;
qt_solicitada_w			tiss_anexo_guia_item.qt_solicitada%type;
vl_solicitado_w			double precision;
nr_registro_anvisa_w		varchar(15);
cd_ref_fabricante_w		varchar(30);
nr_autorizacao_func_w		varchar(30);
qt_item_w			bigint;
dt_provavel_w			timestamp;
qt_dose_dia_w			double precision;
ie_via_aplicacao_w		varchar(5);
nr_sequencia_autor_w		bigint;
im_logo_convenio_w		tiss_logo_convenio.im_logo_convenio%type;

c01 CURSOR FOR
SELECT	b.cd_item,
	b.ds_item,
	b.cd_edicao_amb,
	b.ie_opcao_fabricante,
	b.qt_solicitada,
	b.qt_dose_dia,
	b.dt_provavel,
	b.ie_via_aplicacao
from	tiss_anexo_guia a,
	tiss_anexo_guia_item b
where	a.nr_sequencia		= b.nr_seq_guia
and	a.nr_sequencia		= nr_seq_anexo_w
and	a.ie_tiss_tipo_anexo	= 3; --Quimio
c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_sequencia_autor
from	tiss_anexo_guia a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p
and	a.ie_tiss_tipo_anexo	= 3

union

SELECT	a.nr_sequencia,
	a.nr_sequencia_autor
from	tiss_anexo_guia a
where	a.nr_seq_lote_anexo	= nr_seq_lote_anexo_p
and	a.ie_tiss_tipo_anexo	= 3;


BEGIN

delete	from w_tiss_relatorio
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_guia
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_beneficiario
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_solicitacao
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_contratado_solic
where	nm_usuario		= nm_usuario_p;

delete	from w_tiss_opm
where	nm_usuario		= nm_usuario_p;

commit;

if (coalesce(nr_sequencia_autor_p,-1) > 0) or (coalesce(nr_seq_lote_anexo_p,-1) > 0) then

	if (coalesce(nr_sequencia_autor_p,-1) > 0) then

		CALL tiss_atualizar_autorizacao(nr_sequencia_autor_p,nm_usuario_p);

		select	max(a.cd_convenio),
			max(a.cd_estabelecimento),
			max(c.cd_ans),
			max(b.ds_arquivo_logo_tiss)
		into STRICT	cd_convenio_w,
			cd_estabelecimento_w,
			cd_ans_w,
			ds_arquivo_logo_w
		from	autorizacao_convenio a,
			convenio b,
			pessoa_juridica c
		where	b.cd_convenio	= a.cd_convenio
		and	b.cd_cgc	= c.cd_cgc
		and	a.nr_sequencia	= nr_sequencia_autor_p;

	elsif (coalesce(nr_seq_lote_anexo_p,-1) > 0) then

		select	max(a.cd_convenio),
			max(a.cd_estabelecimento),
			max(c.cd_ans),
			max(b.ds_arquivo_logo_tiss)
		into STRICT	cd_convenio_w,
			cd_estabelecimento_w,
			cd_ans_w,
			ds_arquivo_logo_w
		from	tiss_anexo_lote a,
			convenio b,
			pessoa_juridica c
		where	b.cd_convenio	= a.cd_convenio
		and	b.cd_cgc	= c.cd_cgc
		and	a.nr_sequencia	= nr_seq_lote_anexo_p;

	end if;

	select	max(ds_arquivo_logo_comp),
		coalesce(max(ie_gerar_tiss), 'S')
	into STRICT	ds_arquivo_logo_comp_w,
		ie_gerar_tiss_w
	from	tiss_parametros_convenio
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	cd_convenio		= cd_convenio_w;

	select	tiss_obter_versao(cd_convenio_w,cd_estabelecimento_w)
	into STRICT	ds_versao_w
	;
	
	begin
		select	im_logo_convenio
		into STRICT	im_logo_convenio_w
		from	tiss_logo_convenio
		where	cd_convenio	   = cd_convenio_w
		and 	coalesce(ie_situacao,'N') = 'A';
	exception
	when others then
		im_logo_convenio_w := null;
	end;
	
	if (coalesce(im_logo_convenio_w::text, '') = '') and (ds_arquivo_logo_w IS NOT NULL AND ds_arquivo_logo_w::text <> '') then
		ds_arquivo_logo_w := tiss_diretorio_logo(ds_arquivo_logo_comp_w, ds_dir_padrao_p) || ds_arquivo_logo_w;
	end if;

	if (coalesce(ie_gerar_tiss_w,'S') = 'S') then

		if (ds_arquivo_logo_w IS NOT NULL AND ds_arquivo_logo_w::text <> '') and (coalesce(im_logo_convenio_w::text, '') = '') then
			insert	into w_tiss_relatorio(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_arquivo_logo,
				im_logo_convenio)
			values (nextval('w_tiss_relatorio_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_arquivo_logo_w,
				null);
		else
			insert	into w_tiss_relatorio(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_arquivo_logo,
				im_logo_convenio)
			values (nextval('w_tiss_relatorio_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				null,
				im_logo_convenio_w);
		end if;

		open C02;
		loop
		fetch C02 into
			nr_seq_anexo_w,
			nr_sequencia_autor_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			qt_item_w	:= 0;

			open C01;
			loop
			fetch C01 into
				cd_item_w,
				ds_item_w,
				cd_edicao_amb_w,
				ie_opcao_fabricante_w,
				qt_solicitada_w,
				qt_dose_dia_w,
				dt_provavel_w,
				ie_via_aplicacao_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin

				if (qt_item_w = 0) then
					nr_seq_guia_w := TISS_GERAR_CABEC_SOLIC_RADIO( nr_sequencia_autor_w, nr_seq_anexo_w, nm_usuario_p, nr_seq_guia_w);
				end if;

				qt_item_w	:= qt_item_w + 1;

				insert into w_tiss_opm(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_guia,
					cd_opm,
					cd_edicao,
					ds_opm,
					qt_solicitada,
					nr_seq_apresentacao,
					dt_prevista,
					qt_frequencia,
					ie_via_aplicacao)
				values (nextval('w_tiss_opm_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_guia_w,
					cd_item_w,
					cd_edicao_amb_w,
					ds_item_w,
					qt_solicitada_w,
					qt_item_w,
					dt_provavel_w,
					qt_dose_dia_w,
					ie_via_aplicacao_w);

				if (qt_item_w =12) then
					qt_item_w 	:= 0;
					CALL TISS_COMPLETAR_GUIA(nr_seq_guia_w, nm_usuario_p);
				end if;

				end;
			end loop;
			close C01;

			CALL TISS_COMPLETAR_GUIA(nr_seq_guia_w, nm_usuario_p);

			end;
		end loop;
		close C02;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_w_guia_solic_radio (nr_sequencia_autor_p bigint, nr_seq_lote_anexo_p bigint, nm_usuario_p text, ds_dir_padrao_p text) FROM PUBLIC;

