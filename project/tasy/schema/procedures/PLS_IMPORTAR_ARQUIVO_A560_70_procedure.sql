-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_importar_arquivo_a560_70 ( ds_conteudo_p text, nr_seq_camara_contest_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Importar arquivo A560 na função da contestação
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/nr_seq_ptu_fatura_w		bigint;
nr_seq_nota_debito_w		bigint;
nr_seq_nota_deb_bol_w		bigint;
nr_seq_nota_conclusao_w		bigint;
nr_seq_pls_fatura_w		bigint;

cd_unimed_destino_w		varchar(4);
cd_unimed_origem_w		varchar(4);
nr_fatura_w			ptu_nota_debito.nr_fatura%type;
vl_tot_fatura_w			double precision;
nr_nota_credito_debito_a500_w	ptu_nota_debito.nr_nota_credito_debito_a500%type;
vl_total_ndc_a500_w		double precision;
nr_nota_debito_w		bigint;
dt_ven_nota_w			timestamp;
ie_conclusao_ndc_w		varchar(1);
tp_arquivo_w			varchar(1);
nr_seq_lote_contest_w		bigint;
dt_postagem_w			timestamp;
qt_registro_w			bigint := 0;
tp_arq_parcial_w		ptu_nota_debito.tp_arq_parcial%type;

cd_banco_w			varchar(5);
cd_agencia_cd_cedente_w		varchar(25);
nr_nosso_numero_w		varchar(20);
ds_uso_banco_w			varchar(15);
ds_carteira_w			varchar(10);
ds_especie_w			varchar(4);
vlr_documento_w			double precision;
dt_documento_w			timestamp;
ds_especie_doc_w		varchar(5);
ds_aceite_w			varchar(2);
dt_proces_w			timestamp;
ds_local_pagto_w		varchar(60);
ds_obs_local_pagto_w		varchar(60);
ie_boleto_w			smallint;

ds_linha_digitavel_w		varchar(60);
cd_barras_w			varchar(44);
ds_observacao_w			varchar(60);
ds_instrucao_w			varchar(60);

-- PTU_NOTA_DEB_CREDOR_DEVED
tp_cred_dev_w			varchar(1) := '1';
nm_cred_dev_w			varchar(60);
ds_endereco_w			varchar(40);
ds_end_cpl_w			varchar(20);
nr_end_w			varchar(6);
ds_bairro_w			varchar(30);
nr_cep_w			varchar(8);
ds_cidade_w			varchar(30);
cd_uf_w				varchar(2);
cd_cnpj_cpf_w			varchar(14);
nr_ddd_w			smallint;
nr_fone_w			integer;
nr_fax_w			integer;

-- PTU_NOTA_DEB_DADOS
dt_emissao_ndc_w		timestamp;
dt_ven_ndc_w			timestamp;
nr_linha_w			smallint := 1;
ds_linha_w			varchar(74);
vl_ndc_w			double precision;
tp_doc_568_w			smallint;

-- PTU_NOTA_DEB_FAT_NDR
nr_fatura_orig_w		ptu_nota_deb_fat_ndr.nr_fatura%type;
dt_emissao_fatura_w		timestamp;
vl_tot_fat_w			double precision;
nr_ndr_w			ptu_nota_deb_fat_ndr.nr_ndr%type;
ds_ndr_w			varchar(30);
dt_emissao_ndr_w		timestamp;
vl_tot_ndr_w			double precision;
ie_parametro_12_w		funcao_param_usuario.vl_parametro%type;
qt_inconsistente_w		integer := 0;

nr_fatura_contest_w		ptu_fatura.nr_fatura%type;
nr_nota_cred_deb_contest_w	ptu_fatura.nr_nota_credito_debito%type;


BEGIN
if (substr(ds_conteudo_p,9,3) = '561') then
	begin
	select	nr_seq_ptu_fatura,
		nr_seq_lote_contest,
		nr_seq_pls_fatura
	into STRICT	nr_seq_ptu_fatura_w,
		nr_seq_lote_contest_w,
		nr_seq_pls_fatura_w
	from	pls_lote_contestacao	c,
		ptu_camara_contestacao	b
	where	c.nr_sequencia	= b.nr_seq_lote_contest
	and	b.nr_sequencia	= nr_seq_camara_contest_p;
	exception
	when others then
		nr_seq_ptu_fatura_w	:= null;
		nr_seq_lote_contest_w	:= null;
		nr_seq_pls_fatura_w	:= null;
	end;

	ie_parametro_12_w := Obter_Param_Usuario(1334, 12, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_parametro_12_w);

	if (coalesce(ie_parametro_12_w, 'S') = 'N') then
		select	count(1)
		into STRICT	qt_inconsistente_w
		
		where	exists (SELECT	1
				from	pls_conta_proc		x,
					pls_contestacao_proc 	c,
					pls_contestacao		b,
					pls_lote_contestacao	a
				where	a.nr_sequencia	= b.nr_seq_lote
				and	b.nr_sequencia	= c.nr_seq_contestacao
				and	x.nr_sequencia	= c.nr_seq_conta_proc
				and	coalesce(x.cd_procedimento::text, '') = ''
				and	a.nr_sequencia	= nr_seq_lote_contest_w
				
union

				SELECT	1
				from	pls_conta_mat		x,
					pls_contestacao_mat 	c,
					pls_contestacao		b,
					pls_lote_contestacao	a
				where	a.nr_sequencia	= b.nr_seq_lote
				and	b.nr_sequencia	= c.nr_seq_contestacao
				and	x.nr_sequencia	= c.nr_seq_conta_mat
				and	coalesce(x.nr_seq_material::text, '') = ''
				and	a.nr_sequencia	= nr_seq_lote_contest_w);

		if (qt_inconsistente_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(291156);
		end if;
	end if;

	select	count(1)
	into STRICT	qt_inconsistente_w
	from	pls_lote_discussao
	where	nr_seq_lote_contest	= nr_seq_lote_contest_w
	and	ie_status not in ('C')
	and	coalesce(dt_fechamento::text, '') = '';

	if (qt_inconsistente_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(291158);
	end if;

	cd_unimed_destino_w		:= lpad(trim(both substr(ds_conteudo_p,12,4)),4,'0');
	cd_unimed_origem_w		:= lpad(trim(both substr(ds_conteudo_p,16,4)),4,'0');
	nr_fatura_w			:= trim(both substr(ds_conteudo_p,73,20));

	begin
	vl_tot_fatura_w			:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,31,14));
	exception
	when others then
		vl_tot_fatura_w	:= 0;
	end;

	nr_nota_credito_debito_a500_w	:= trim(both substr(ds_conteudo_p,93,20));

	begin
	vl_total_ndc_a500_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,58,14));
	exception
	when others then
		vl_total_ndc_a500_w := 0;
	end;

	begin
	tp_arquivo_w := trim(both substr(ds_conteudo_p,72,1));
	exception
	when others then
		tp_arquivo_w := null;
	end;

	tp_arq_parcial_w := trim(both substr(ds_conteudo_p,113,1));

	insert into ptu_nota_debito(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_unimed_origem,
		cd_unimed_destino,
		nr_fatura,
		vl_total_fatura,
		nr_nota_debito, -- 562
		dt_ven_nota, -- 562
		nr_seq_fatura,
		nr_seq_camara_contest,
		nr_nota_credito_debito_a500,
		vl_total_ndc_a500,
		ie_conclusao_ndc,
		ie_origem,
		tp_arquivo,
		tp_arq_parcial)
	values (nextval('ptu_nota_debito_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_unimed_origem_w,
		cd_unimed_destino_w,
		nr_fatura_w,
		vl_tot_fatura_w,
		0,
		null,
		nr_seq_ptu_fatura_w,
		nr_seq_camara_contest_p,
		nr_nota_credito_debito_a500_w,
		vl_total_ndc_a500_w,
		null,
		'I',
		coalesce(tp_arquivo_w,'1'),
		tp_arq_parcial_w);

	if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') or (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then

		if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then
			select	max(nr_fatura),
				max(nr_nota_credito_debito)
			into STRICT	nr_fatura_contest_w,
				nr_nota_cred_deb_contest_w
			from	ptu_fatura
			where	nr_sequencia = nr_seq_ptu_fatura_w;

		elsif (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then
			select	max(nr_fatura),
				max(nr_nota_credito_debito)
			into STRICT	nr_fatura_contest_w,
				nr_nota_cred_deb_contest_w
			from	ptu_fatura
			where	nr_seq_pls_fatura = nr_seq_pls_fatura_w;

		end if;

		nr_fatura_contest_w 		:= somente_numero(nr_fatura_contest_w);
		nr_nota_cred_deb_contest_w 	:= somente_numero(nr_nota_cred_deb_contest_w);
		nr_fatura_w 			:= somente_numero(nr_fatura_w);
		nr_nota_credito_debito_a500_w 	:= somente_numero(nr_nota_credito_debito_a500_w);

		-- Consistir se a importação esta ocorrendo no local certo
		if (nr_fatura_w <> nr_fatura_contest_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310034);

		elsif (nr_nota_credito_debito_a500_w <> nr_nota_cred_deb_contest_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310034);
		end if;
	end if;

	-- Se for Integral ou Complementar a contestação esta concluida
	if (tp_arquivo_w in ('1','3')) and (nr_seq_lote_contest_w IS NOT NULL AND nr_seq_lote_contest_w::text <> '') then
		update	pls_lote_contestacao
		set	ie_status	= 'C'
		where	nr_sequencia	= nr_seq_lote_contest_w;
	end if;
elsif (substr(ds_conteudo_p,9,3) = '562') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_nota_debito_w
	from	ptu_nota_debito
	where	nm_usuario	= nm_usuario_p
	and	ie_origem	= 'I';

	select	max(cd_unimed_origem),
		max(tp_arquivo)
	into STRICT	cd_unimed_origem_w,
		tp_arquivo_w
	from	ptu_nota_debito
	where	nr_sequencia = nr_seq_nota_debito_w;

	cd_unimed_origem_w	:= lpad(cd_unimed_origem_w,4,'0');
	nr_nota_debito_w	:= (substr(ds_conteudo_p,12,11))::numeric;

	begin
	dt_ven_nota_w		:= to_date(substr(ds_conteudo_p,29,2)||substr(ds_conteudo_p,27,2)||substr(ds_conteudo_p,23,4),'dd/mm/yyyy');
	exception
	when others then
		dt_ven_nota_w := null;
	end;

	ie_conclusao_ndc_w	:= trim(both substr(ds_conteudo_p,31,1));

	select	max(a.nr_seq_camara_contest)
	into STRICT	qt_registro_w
	from	ptu_nota_deb_conclusao b,
		ptu_nota_debito a
	where	a.nr_sequencia			= b.nr_seq_nota_debito
	and	coalesce(a.ie_cancelamento,'N')	<> 'S'
	and	lpad(a.cd_unimed_origem,4,'0')	= cd_unimed_origem_w
	and	b.nr_nota_debito		= nr_nota_debito_w
	and	a.tp_arquivo			= tp_arquivo_w
	and	a.nr_fatura			= nr_fatura_w;

	/*aaschlote 23/04/2014 - OS 705713*/

	if (qt_registro_w > 0) then
		delete	FROM ptu_nota_debito
		where	nr_sequencia	= nr_seq_nota_debito_w;

		commit;
		CALL wheb_mensagem_pck.exibir_mensagem_abort(271597);
	end if;

	insert into ptu_nota_deb_conclusao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_nota_debito,
		dt_ven_nota,
		id_ndc_conclusao,
		nr_seq,
		tp_reg,
		nr_seq_nota_debito)
	values (	nextval('ptu_nota_deb_conclusao_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_nota_debito_w,
		dt_ven_nota_w,
		ie_conclusao_ndc_w,
		null,
		'562',
		nr_seq_nota_debito_w);
elsif (substr(ds_conteudo_p,9,3) = '563') then
	select	max(x.nr_sequencia),
		max(a.nr_sequencia)
	into STRICT	nr_seq_nota_debito_w,
		nr_seq_nota_conclusao_w
	from	ptu_nota_deb_conclusao a,
		ptu_nota_debito x
	where	x.nr_sequencia	= a.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	cd_banco_w		:= trim(both substr(ds_conteudo_p,12,5));
	cd_agencia_cd_cedente_w	:= trim(both substr(ds_conteudo_p,17,25));
	nr_nosso_numero_w	:= trim(both substr(ds_conteudo_p,42,20));
	ds_uso_banco_w		:= trim(both substr(ds_conteudo_p,62,15));
	ds_carteira_w		:= trim(both substr(ds_conteudo_p,77,10));
	ds_especie_w		:= trim(both substr(ds_conteudo_p,87,4));

	begin
	vlr_documento_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,91,14));
	exception
	when others then
		vlr_documento_w	:= 0;
	end;

	begin
	dt_documento_w		:= to_date(substr(ds_conteudo_p,111,2)||substr(ds_conteudo_p,109,2)||substr(ds_conteudo_p,105,4),'dd/mm/yyyy');
	exception
	when others then
		dt_documento_w	:= null;
	end;

	ds_especie_doc_w	:= trim(both substr(ds_conteudo_p,113,5));
	ds_aceite_w		:= trim(both substr(ds_conteudo_p,118,2));

	begin
	dt_proces_w		:= to_date(substr(ds_conteudo_p,126,2)||substr(ds_conteudo_p,124,2)||substr(ds_conteudo_p,120,4),'dd/mm/yyyy');
	exception
	when others then
		dt_proces_w	:= null;
	end;

	ds_local_pagto_w	:= coalesce(substr(ds_conteudo_p,128,60),' ');
	ds_obs_local_pagto_w	:= coalesce(substr(ds_conteudo_p,188,60),' ');

	begin
	ie_boleto_w		:= coalesce((substr(ds_conteudo_p,248,1))::numeric ,1);
	exception
	when others then
		ie_boleto_w := 1;
	end;

	insert into ptu_nota_deb_bol(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq,
		tp_reg,
		nr_banco,
		agencia_cd_cedente,
		nosso_numero,
		uso_banco,
		ds_carteira,
		especie,
		vlr_documento,
		dt_documento,
		especie_doc,
		aceite,
		dt_proces,
		local_pagto,
		obs_local_pagto,
		tp_boleto,
		nr_seq_nota_debito,
		nr_seq_nota_deb_conclusao)
	values (nextval('ptu_nota_deb_bol_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		0,
		'563',
		cd_banco_w,
		cd_agencia_cd_cedente_w,
		nr_nosso_numero_w,
		ds_uso_banco_w,
		ds_carteira_w,
		ds_especie_w,
		vlr_documento_w,
		dt_documento_w,
		ds_especie_doc_w,
		ds_aceite_w,
		dt_proces_w,
		ds_local_pagto_w,
		ds_obs_local_pagto_w,
		ie_boleto_w,
		nr_seq_nota_debito_w,
		nr_seq_nota_conclusao_w);

elsif (substr(ds_conteudo_p,9,3) = '564') then
	select	max(z.nr_sequencia)
	into STRICT	nr_seq_nota_deb_bol_w
	from	ptu_nota_debito x,
		ptu_nota_deb_bol z
	where	x.nr_sequencia	= z.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	ds_instrucao_w	:= coalesce(trim(both substr(ds_conteudo_p,12,60)),' ');

	insert into ptu_nota_deb_bol_inst(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq,
		tp_reg,
		ds_instrucao,
		nr_seq_nota_deb_bol)
	values (nextval('ptu_nota_deb_bol_inst_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		0,
		'564',
		ds_instrucao_w,
		nr_seq_nota_deb_bol_w);

elsif (substr(ds_conteudo_p,9,3) = '565') then
	select	max(z.nr_sequencia)
	into STRICT	nr_seq_nota_deb_bol_w
	from	ptu_nota_debito x,
		ptu_nota_deb_bol z
	where	x.nr_sequencia	= z.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	ds_observacao_w	:= coalesce(trim(both substr(ds_conteudo_p,12,60)),' ');

	insert into ptu_nota_deb_bol_obs(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq,
		tp_reg,
		ds_observacao,
		nr_seq_nota_deb_bol)
	values (nextval('ptu_nota_deb_bol_obs_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		0,
		'565',
		ds_observacao_w,
		nr_seq_nota_deb_bol_w);

elsif (substr(ds_conteudo_p,9,3) = '566') then
	select	max(z.nr_sequencia)
	into STRICT	nr_seq_nota_deb_bol_w
	from	ptu_nota_debito x,
		ptu_nota_deb_bol z
	where	x.nr_sequencia	= z.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	ds_linha_digitavel_w	:= coalesce(trim(both substr(ds_conteudo_p,12,60)),' ');
	cd_barras_w		:= coalesce(trim(both substr(ds_conteudo_p,72,44)),' ');

	insert into ptu_nota_deb_bol_ld(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq,
		tp_reg,
		linha_digitavel,
		cd_barras,
		nr_seq_nota_deb_bol)
	values (nextval('ptu_nota_deb_bol_ld_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		0,
		'566',
		ds_linha_digitavel_w,
		cd_barras_w,
		nr_seq_nota_deb_bol_w);

elsif (substr(ds_conteudo_p,9,3) = '567') then
	select	max(x.nr_sequencia),
		max(a.nr_sequencia)
	into STRICT	nr_seq_nota_debito_w,
		nr_seq_nota_conclusao_w
	from	ptu_nota_deb_conclusao a,
		ptu_nota_debito x
	where	x.nr_sequencia	= a.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	tp_cred_dev_w	:= trim(both substr(ds_conteudo_p,12,1));
	nm_cred_dev_w	:= trim(both substr(ds_conteudo_p,13,60));
	ds_endereco_w	:= trim(both substr(ds_conteudo_p,73,40));
	ds_end_cpl_w	:= trim(both substr(ds_conteudo_p,113,20));
	ds_bairro_w	:= trim(both substr(ds_conteudo_p,139,30));
	ds_cidade_w	:= trim(both substr(ds_conteudo_p,177,30));
	cd_uf_w		:= trim(both substr(ds_conteudo_p,207,2));
	cd_cnpj_cpf_w	:= trim(both substr(ds_conteudo_p,209,14));
	nr_cep_w	:= trim(both substr(ds_conteudo_p,169,8));

	select	CASE WHEN somente_numero(substr(ds_conteudo_p,133,6))=0 THEN null  ELSE somente_numero(substr(ds_conteudo_p,133,6)) END
	into STRICT	nr_end_w
	;

	select	CASE WHEN (substr(ds_conteudo_p,223,4))::numeric =0 THEN null  ELSE (substr(ds_conteudo_p,223,4))::numeric  END
	into STRICT	nr_ddd_w
	;

	select	CASE WHEN (substr(ds_conteudo_p,227,9))::numeric =0 THEN null  ELSE (substr(ds_conteudo_p,227,9))::numeric  END
	into STRICT	nr_fone_w
	;

	select	CASE WHEN (substr(ds_conteudo_p,236,9))::numeric =0 THEN null  ELSE (substr(ds_conteudo_p,236,9))::numeric  END
	into STRICT	nr_fax_w
	;

	insert into ptu_nota_deb_credor_deved(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_nota_debito,
		tp_cred_dev,
		nm_cred_dev,
		ds_endereco,
		ds_end_cpl,
		nr_end,
		ds_bairro,
		nr_cep,
		ds_cidade,
		cd_uf,
		cd_cnpj_cpf,
		nr_ddd,
		nr_fone,
		nr_fax,
		nr_seq,
		tp_reg,
		nr_seq_nota_deb_conclusao)
	values (	nextval('ptu_nota_deb_credor_deved_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_nota_debito_w,
		tp_cred_dev_w,
		nm_cred_dev_w,
		ds_endereco_w,
		ds_end_cpl_w,
		nr_end_w,
		ds_bairro_w,
		nr_cep_w,
		ds_cidade_w,
		cd_uf_w,
		cd_cnpj_cpf_w,
		nr_ddd_w,
		nr_fone_w,
		nr_fax_w,
		0,
		'567',
		nr_seq_nota_conclusao_w);

elsif (substr(ds_conteudo_p,9,3) = '568') then
	select	max(x.nr_sequencia),
		max(a.nr_sequencia)
	into STRICT	nr_seq_nota_debito_w,
		nr_seq_nota_conclusao_w
	from	ptu_nota_deb_conclusao a,
		ptu_nota_debito x
	where	x.nr_sequencia	= a.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	begin
	dt_emissao_ndc_w:= to_date(substr(ds_conteudo_p,18,2)||substr(ds_conteudo_p,16,2)||substr(ds_conteudo_p,12,4),'dd/mm/yyyy');
	exception
	when others then
		dt_emissao_ndc_w := null;
	end;

	begin
	dt_ven_ndc_w	:= to_date(substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4),'dd/mm/yyyy');
	exception
	when others then
		dt_ven_ndc_w := null;
	end;

	nr_linha_w	:= (substr(ds_conteudo_p,28,2))::numeric;
	ds_linha_w	:= trim(both substr(ds_conteudo_p,30,74));

	begin
	vl_ndc_w	:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,104,14));
	exception
	when others then
		vl_ndc_w := 0;
	end;

	begin
	tp_doc_568_w := (substr(ds_conteudo_p,118,1))::numeric;
	exception
	when others then
		tp_doc_568_w := null;
	end;

	insert into ptu_nota_deb_dados(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_nota_debito,
		dt_emissao_ndc,
		dt_ven_ndc,
		nr_linha,
		ds_linha,
		vl_ndc,
		nr_seq,
		tp_reg,
		nr_seq_nota_deb_conclusao,
		tp_doc_568)
	values (	nextval('ptu_nota_deb_dados_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_nota_debito_w,
		dt_emissao_ndc_w,
		dt_ven_ndc_w,
		nr_linha_w,
		ds_linha_w,
		vl_ndc_w,
		0,
		'568',
		nr_seq_nota_conclusao_w,
		tp_doc_568_w);

elsif (substr(ds_conteudo_p,9,3) = '569') then
	select	max(x.nr_sequencia),
		max(a.nr_sequencia)
	into STRICT	nr_seq_nota_debito_w,
		nr_seq_nota_conclusao_w
	from	ptu_nota_deb_conclusao a,
		ptu_nota_debito x
	where	x.nr_sequencia	= a.nr_seq_nota_debito
	and	x.nm_usuario	= nm_usuario_p
	and	x.ie_origem	= 'I';

	nr_fatura_orig_w := trim(both substr(ds_conteudo_p,78,20));
	nr_ndr_w := trim(both substr(ds_conteudo_p,98,20));

	begin
	dt_emissao_fatura_w	:= to_date(substr(ds_conteudo_p,29,2)||substr(ds_conteudo_p,27,2)||substr(ds_conteudo_p,23,4),'dd/mm/yyyy');
	exception
	when others then
		dt_emissao_fatura_w := null;
	end;

	begin
	vl_tot_fat_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,31,14));
	exception
	when others then
		vl_tot_fat_w := 0;
	end;

	begin
	dt_emissao_ndr_w	:= to_date(substr(ds_conteudo_p,62,2)||substr(ds_conteudo_p,60,2)||substr(ds_conteudo_p,56,4),'dd/mm/yyyy');
	exception
	when others then
		dt_emissao_ndr_w := null;
	end;

	begin
	vl_tot_ndr_w		:= pls_format_valor_imp_ptu(substr(ds_conteudo_p,64,14));
	exception
	when others then
		vl_tot_ndr_w	:= 0;
	end;

	insert into ptu_nota_deb_fat_ndr(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_nota_debito,
		nr_fatura,
		dt_emissao_fatura,
		vl_tot_fat,
		nr_ndr,
		dt_emissao_ndr,
		vl_tot_ndr,
		nr_seq,
		tp_reg,
		nr_seq_nota_deb_conclusao)
	values (	nextval('ptu_nota_deb_fat_ndr_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_nota_debito_w,
		nr_fatura_orig_w,
		dt_emissao_fatura_w,
		vl_tot_fat_w,
		nr_ndr_w,
		dt_emissao_ndr_w,
		vl_tot_ndr_w,
		0,
		'569',
		nr_seq_nota_conclusao_w);

elsif (substr(ds_conteudo_p,9,3) = '999') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_nota_debito_w
	from	ptu_nota_debito
	where	nm_usuario	= nm_usuario_p
	and	ie_origem	= 'I';

	begin
	dt_postagem_w	:= to_date(substr(ds_conteudo_p,20,2)||substr(ds_conteudo_p,17,2)||substr(ds_conteudo_p,12,4)||substr(ds_conteudo_p,22,8),'dd/mm/yyyy hh24:mi:ss');
	exception
	when others then
		dt_postagem_w := null;
	end;

	if (nr_seq_nota_debito_w IS NOT NULL AND nr_seq_nota_debito_w::text <> '') then
		update	ptu_nota_debito
		set	dt_postagem	= dt_postagem_w
		where	nr_sequencia	= nr_seq_nota_debito_w;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_importar_arquivo_a560_70 ( ds_conteudo_p text, nr_seq_camara_contest_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

