-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.processar_pf_arq ( nr_seq_lote_p bigint, nr_seq_mov_empresa_p bigint, arq_texto_p utl_file.file_type) AS $body$
DECLARE

	
	ds_conteudo_w		varchar(4000);
	cd_pais_w		varchar(10);
	nr_seq_mov_pessoa_w	ptu_mov_benef_pf_lote.nr_sequencia%type;
	nr_seq_mov_segurado_w	ptu_mov_benef_segurado.nr_sequencia%type;
	nr_seq_mov_seg_plano_w	ptu_mov_benef_seg_plano.nr_sequencia%type;
	reservado_w		varchar(100);
	reservado9_w		varchar(100);
	nm_pessoa_fisica_w	varchar(70);
	id_estrangeiro_w	varchar(1);
	cd_nacionalidade_w	pessoa_fisica.cd_nacionalidade%type;
	ie_brasileiro_w		varchar(1);
	cd_unimed_interc_w	varchar(4);
	cd_carteira_interc_w	varchar(13);
	nr_cartao_intercambio_w	pls_segurado_carteira.nr_cartao_intercambio%type;
	cd_municipio_ibge_w	varchar(7);
	dt_validade_carteira_w	varchar(10);
	nr_via_solicitacao_w	pls_segurado_carteira.nr_via_solicitacao%type;
	ie_tipo_rede_min_w	ptu_rede_referenciada.ie_tipo_rede_min%type;
	nr_ddd_w		bigint;
	nr_telefone_w		bigint;
	nr_seq_pais_w		pessoa_fisica.nr_seq_pais%type;
	tp_genero_social_w	varchar(1);
	nm_social_w		pessoa_fisica.nm_social%type;
	nm_social_cartao_w	varchar(25);
	
	C01 CURSOR FOR
		SELECT	nr_sequencia,
			rpad(coalesce(nm_beneficiario, ' '),25,' ') nm_beneficiario,
			to_char(dt_nascimento,'yyyymmdd') dt_nascimento,
			ie_sexo,
			lpad(coalesce(cd_cgc_cpf,0),15,0) nr_cpf,
			rpad(coalesce(nr_rg, ' '),30,' ') nr_rg,
			rpad(coalesce(ds_orgao_emissor_ci, ' '),30, ' ') ds_orgao_emissor_ci,
			nm_mae_benef,
			coalesce(ie_estado_civil,'U') ie_estado_civil,
			lpad(coalesce(nr_pis_pasep, 0),11,0) nr_pis_pasep,
			rpad(coalesce(nr_cartao_nac_sus, ' '),15, ' ') nr_cartao_nac_sus,
			cd_municipio_ibge_nasc,
			cd_pessoa_fisica			
		from (	SELECT	*
				from	ptu_mov_benef_pf_lote
				where	nr_seq_lote	= nr_seq_lote_p
				and	coalesce(nr_seq_mov_empresa_p::text, '') = ''
				and 	coalesce(nr_seq_mov_empresa::text, '') = ''
				
union all

				select	*
				from	ptu_mov_benef_pf_lote
				where	nr_seq_lote		= nr_seq_lote_p
				and	nr_seq_mov_empresa	= nr_seq_mov_empresa_p
				and	(nr_seq_mov_empresa_p IS NOT NULL AND nr_seq_mov_empresa_p::text <> '')) alias17;
	
	C02 CURSOR FOR
		SELECT	coalesce(ie_tipo_endereco, ' ')		ie_tipo_endereco,
			rpad(coalesce(ds_endereco, ' '),40,' ')	ds_endereco,
			rpad(coalesce(nr_endereco, 'S/N'),6,' ')	nr_endereco,
			rpad(coalesce(ds_complemento, ' '),20, ' ')	ds_complemento,
			rpad(coalesce(ds_bairro, ' '),30, ' ') 	ds_bairro,
			rpad(coalesce(nm_municipio, ' '),30, ' ')	nm_municipio,
			cd_municipio_ibge			cd_municipio_ibge,
			lpad(coalesce(cd_cep,0),8,'0')		cd_cep,
			coalesce(sg_uf, '  ')			sg_uf,
			lpad(coalesce(nr_ddd,0),4,0)			nr_ddd,
			lpad(coalesce(nr_ramal,0),4,0)		nr_ramal,
			rpad(coalesce(ds_email, ' '),40, ' ')	ds_email,
			lpad(coalesce(nr_fone,0),9,0)		nr_fone,
			lpad(coalesce(nr_ddd_2,0),4,0)		nr_ddd_2,
			lpad(coalesce(nr_ramal_2,0),4,0)		nr_ramal_2,
			rpad(coalesce(ds_email_2, ' '),40, ' ')	ds_email_2,
			lpad(coalesce(nr_fone_2,0),9,0)		nr_fone_2,
			lpad(coalesce(nr_ddd_3,0),4,0)		nr_ddd_3,
			lpad(coalesce(nr_ramal_3,0),4,0)		nr_ramal_3,
			rpad(coalesce(ds_email_3, ' '),40, ' ')	ds_email_3,
			lpad(coalesce(nr_fone_3,0),9,0)		nr_fone_3,
			coalesce(cd_tipo_logradouro,'  ')		cd_tipo_logradouro,
			coalesce(ie_tipo_email, ' ')			ie_tipo_email,
			coalesce(ie_tipo_telefone, ' ')		ie_tipo_telefone,
			rpad(coalesce(ds_email, ' '),70, ' ')	ds_email_ptu_100
		from	ptu_mov_benef_pf_compl
		where	nr_seq_mov_pessoa	= nr_seq_mov_pessoa_w;
	
	C03 CURSOR FOR
		SELECT	nr_sequencia,
			lpad(cd_unimed,4,'0') cd_unimed,
			rpad(cd_usuario_plano,13,' ') cd_usuario_plano,
			rpad(cd_titular_plano,13, ' ') cd_titular_plano,
			lpad(cd_dependencia,2,'0') cd_dependencia,
			to_char(dt_inclusao,'yyyymmdd') dt_inclusao,
			CASE WHEN coalesce(dt_exclusao::text, '') = '' THEN '        '  ELSE to_char(dt_exclusao,'yyyymmdd') END  dt_exclusao,
			ie_consta_sib,
			rpad(coalesce(nr_prot_ans_origem, ' '),20, ' ') nr_prot_ans_origem,
			ie_beneficio_obito,
			nr_seq_segurado,
			lpad(coalesce(cd_motivo_exclusao, ' '),2,'0') cd_motivo_exclusao
		from	ptu_mov_benef_segurado
		where	nr_seq_mov_pessoa	= nr_seq_mov_pessoa_w;
	
	C04 CURSOR FOR
		SELECT	lpad(coalesce(cd_unimed_destino,0),4,'0') cd_unimed_destino,
			lpad(coalesce(cd_unimed_origem,0),4,'0') cd_unimed_origem,
			ie_tipo_repasse,
			to_char(dt_repasse,'yyyymmdd') dt_repasse,
			CASE WHEN coalesce(dt_fim_repasse::text, '') = '' THEN '        '  ELSE to_char(dt_fim_repasse,'yyyymmdd') END  dt_fim_repasse,
			CASE WHEN coalesce(dt_comp_risco::text, '') = '' THEN '        '  ELSE to_char(dt_comp_risco,'yyyymmdd') END  dt_comp_risco,
			ie_tipo_compartilhamento
		from	ptu_mov_benef_seg_repasse
		where	nr_seq_mov_segurado	= nr_seq_mov_segurado_w;
	
	C05 CURSOR FOR
		SELECT	a.nr_sequencia,
			rpad(coalesce(ptu_somente_caracter_permitido(a.ds_razao_social, 'ANS'), ' '),40, ' ') ds_razao_social,
			to_char(a.dt_inclusao,'yyyymmdd') dt_inclusao,
			CASE WHEN coalesce(a.dt_exclusao::text, '') = '' THEN '        '  ELSE to_char(a.dt_exclusao,'yyyymmdd') END  dt_exclusao,
			a.ie_abrangencia,
			a.ie_natureza,
			a.ie_acomodacao,
			a.ie_plano,
			rpad(coalesce(a.cd_prod_ans,' '),20, ' ') cd_prod_ans,
			CASE WHEN coalesce(a.ie_segmentacao,'1')='1' THEN '07' WHEN coalesce(a.ie_segmentacao,'1')='2' THEN '10' WHEN coalesce(a.ie_segmentacao,'1')='3' THEN '11' WHEN coalesce(a.ie_segmentacao,'1')='5' THEN '01' WHEN coalesce(a.ie_segmentacao,'1')='6' THEN '02' WHEN coalesce(a.ie_segmentacao,'1')='7' THEN '03' WHEN coalesce(a.ie_segmentacao,'1')='8' THEN '06' WHEN coalesce(a.ie_segmentacao,'1')='9' THEN '08' WHEN coalesce(a.ie_segmentacao,'1')='10' THEN '09' WHEN coalesce(a.ie_segmentacao,'1')='11' THEN '04' WHEN coalesce(a.ie_segmentacao,'1')='12' THEN '05' END  ie_segmentacao,
			rpad(coalesce(a.cd_rede,' '),4,' ') cd_rede,
			rpad(coalesce(a.ds_rede, ' '),40, ' ') ds_rede,
			lpad(coalesce(a.nr_via_solicitacao,0),2,0) nr_via_solicitacao,
			CASE WHEN coalesce(a.dt_validade_carteira::text, '') = '' THEN '        '  ELSE to_char(a.dt_validade_carteira,'yyyymmdd') END  dt_validade_carteira,
			lpad(a.cd_local_atendimento,4,'0') cd_local_atendimento,
			a.ie_carencia_temp,
			CASE WHEN coalesce(a.dt_fim_carencia::text, '') = '' THEN '        '  ELSE to_char(a.dt_fim_carencia,'yyyymmdd') END  dt_fim_carencia,
			CASE WHEN a.ie_repasse='P' THEN '1' WHEN a.ie_repasse='C' THEN '2' END  ie_repasse,
			coalesce(a.cd_motivo_exclusao,'00') cd_motivo_exclusao,
			rpad(coalesce(a.ds_plano_origem, ' '),60, ' ') ds_plano_origem_atual,
			rpad(coalesce(a.nr_contrato, ' '),15, ' ') nr_contrato,
			CASE WHEN coalesce(a.dt_contr_plano::text, '') = '' THEN '        '  ELSE to_char(a.dt_contr_plano,'yyyymmdd') END  dt_contr_plano,
			lpad(coalesce(a.cd_cgc_administradora, '0'),15,'0') cd_cgc_administradora,
			(SELECT	rpad(coalesce(max(x.ds_razao_social),' '),40,' ')
			from	pessoa_juridica x
			where	x.cd_cgc = a.cd_cgc_administradora) ds_razao_social_adm,
			(select	rpad(coalesce(max(x.nm_fantasia),' '),40,' ')
			from	pessoa_juridica x
			where	x.cd_cgc = a.cd_cgc_administradora) nm_fantasia_adm
		from	ptu_mov_benef_seg_plano a
		where	a.nr_seq_mov_segurado	= nr_seq_mov_segurado_w;
	
	C06 CURSOR FOR
		SELECT	cd_municipio_ibge,
			coalesce(sg_estado, '  ') sg_estado
		from	ptu_mov_benef_seg_abrang
		where	nr_seq_mov_seg_plano	= nr_seq_mov_seg_plano_w;
	
	C07 CURSOR FOR
		SELECT	cd_tipo_cobertura,
			dt_fim_carencia
		from	ptu_mov_benef_seg_carencia
		where	nr_seq_mov_seg_plano	= nr_seq_mov_seg_plano_w;
	
	
BEGIN
	
	--R303 - DADOS DA PESSOA

	for r_c01_w in C01 loop
		begin
		
		nr_seq_mov_pessoa_w	:= r_c01_w.nr_sequencia;
		
		select	rpad(coalesce(ptu_somente_caracter_permitido(nm_pessoa_fisica,'ANS'),' '),70, ' ') nm_pessoa_fisica,
			rpad(coalesce(ptu_somente_caracter_permitido(nm_social,'ANS'),' '),70, ' ') nm_social,
			cd_nacionalidade,
			obter_compl_pf(cd_pessoa_fisica,1,'CDMDV') cd_municipio_ibge,
			nr_seq_pais
		into STRICT	nm_pessoa_fisica_w,
			nm_social_w,
			cd_nacionalidade_w,
			cd_municipio_ibge_w,
			nr_seq_pais_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = r_c01_w.cd_pessoa_fisica;
		
		if (nr_seq_pais_w IS NOT NULL AND nr_seq_pais_w::text <> '') then
			select	max(cd_pais_sib)
			into STRICT	cd_pais_w
			from	pais
			where	nr_sequencia	= nr_seq_pais_w;
			
			if (cd_pais_w IS NOT NULL AND cd_pais_w::text <> '') then
				cd_pais_w	:= lpad(cd_pais_w, 3, '0');
			else
				cd_pais_w	:= '032';
			end if;
		else
			cd_pais_w	:= '032';
		end if;
		
		reservado_w := rpad(' ',25,' ');
		
		id_estrangeiro_w := 'N';
		
		tp_genero_social_w := ' '; -- Estamos aguardando campo que devera ser criado na OS 1852049.
		nm_social_cartao_w := rpad(coalesce(pls_gerar_nome_abreviado(nm_social_w),' '),25,' '); -- Estamos aguardando campo que devera ser criado na OS 1852049.
		
		if (cd_nacionalidade_w IS NOT NULL AND cd_nacionalidade_w::text <> '') then
			select	ie_brasileiro
			into STRICT	ie_brasileiro_w
			from	nacionalidade
			where	cd_nacionalidade = cd_nacionalidade_w;
			
			if (ie_brasileiro_w = 'N') then
				id_estrangeiro_w := 'S';
			end if;
		end if;
		
		if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('11')) then
			ds_conteudo_w	:=	r_c01_w.nm_beneficiario||r_c01_w.dt_nascimento||r_c01_w.ie_sexo||r_c01_w.nr_cpf||r_c01_w.nr_rg||r_c01_w.ds_orgao_emissor_ci||
						cd_pais_w||r_c01_w.nr_cartao_nac_sus||reservado_w||r_c01_w.ie_estado_civil||r_c01_w.nr_pis_pasep||
						lpad((r_c01_w.cd_municipio_ibge_nasc||calcula_digito('MODULO10',somente_numero(r_c01_w.cd_municipio_ibge_nasc))),7,0)||
						nm_social_w||nm_pessoa_fisica_w||rpad(coalesce(r_c01_w.nm_mae_benef,' '),70,' ')||id_estrangeiro_w|| lpad(coalesce(cd_municipio_ibge_w, ' '),7,' ') ||
						nm_social_cartao_w || tp_genero_social_w;
		elsif (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('09','10')) then
			ds_conteudo_w	:=	r_c01_w.nm_beneficiario||r_c01_w.dt_nascimento||r_c01_w.ie_sexo||r_c01_w.nr_cpf||r_c01_w.nr_rg||r_c01_w.ds_orgao_emissor_ci||
						cd_pais_w||r_c01_w.nr_cartao_nac_sus||reservado_w||r_c01_w.ie_estado_civil||r_c01_w.nr_pis_pasep||
						lpad((r_c01_w.cd_municipio_ibge_nasc||calcula_digito('MODULO10',somente_numero(r_c01_w.cd_municipio_ibge_nasc))),7,0)||
						nm_social_w||nm_pessoa_fisica_w||rpad(coalesce(r_c01_w.nm_mae_benef,' '),70,' ')||id_estrangeiro_w|| lpad(coalesce(cd_municipio_ibge_w, ' '),7,' ');
		else
			ds_conteudo_w	:=	r_c01_w.nm_beneficiario||r_c01_w.dt_nascimento||r_c01_w.ie_sexo||r_c01_w.nr_cpf||r_c01_w.nr_rg||r_c01_w.ds_orgao_emissor_ci||
						cd_pais_w||r_c01_w.nr_cartao_nac_sus||reservado_w||r_c01_w.ie_estado_civil||r_c01_w.nr_pis_pasep||
						lpad((r_c01_w.cd_municipio_ibge_nasc||calcula_digito('MODULO10',somente_numero(r_c01_w.cd_municipio_ibge_nasc))),7,0)||
						nm_social_w||nm_pessoa_fisica_w||rpad(coalesce(r_c01_w.nm_mae_benef,' '),70,' ')||id_estrangeiro_w;
		end if;
		
		CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('303',ds_conteudo_w,arq_texto_p);
		
		--R305 - COMPLEMENTO CADASTRAL DE BENEFICIARIO

		for r_c02_w in C02 loop
			begin
			reservado_w	:= '        ';
			reservado9_w	:= ' ';
			
			if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('09','10','11')) then
				ds_conteudo_w	:= '1'||r_c02_w.ie_tipo_endereco||r_c02_w.ds_endereco||r_c02_w.nr_endereco||r_c02_w.ds_complemento||r_c02_w.ds_bairro||
							lpad(reservado9_w,30,' ')|| lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c02_w.cd_municipio_ibge),7,0)||r_c02_w.cd_cep||lpad(reservado9_w,2,' ')||
							lpad(reservado9_w,4,' ')||reservado_w||lpad(reservado9_w,4,' ')||lpad(reservado9_w,40,' ')||lpad(reservado9_w,9,' ')||r_c02_w.cd_tipo_logradouro;
			else
				ds_conteudo_w	:= '1'||r_c02_w.ie_tipo_endereco||r_c02_w.ds_endereco||r_c02_w.nr_endereco||r_c02_w.ds_complemento||r_c02_w.ds_bairro||
							r_c02_w.nm_municipio|| lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c02_w.cd_municipio_ibge),7,0)||r_c02_w.cd_cep||r_c02_w.sg_uf||
							r_c02_w.nr_ddd||reservado_w||r_c02_w.nr_ramal||r_c02_w.ds_email||r_c02_w.nr_fone||r_c02_w.cd_tipo_logradouro;
			end if;
			
			CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('305',ds_conteudo_w,arq_texto_p);
			
			if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('10','11')) then
				if	((r_c02_w.ie_tipo_telefone <> '0') or (r_c02_w.ie_tipo_email <> '0')) then
					ds_conteudo_w	:= 	r_c02_w.ie_tipo_telefone||r_c02_w.nr_ddd||r_c02_w.nr_fone||r_c02_w.ie_tipo_email||r_c02_w.ds_email_ptu_100;
					CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('311',ds_conteudo_w,arq_texto_p);
				else
					PERFORM set_config('ptu_moviment_benef_a1300_pck.qt_reduzir_r311_w', current_setting('ptu_moviment_benef_a1300_pck.qt_reduzir_r311_w')::bigint + 1, false);
				end if;
			elsif (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) = '09') then
				ds_conteudo_w	:= 	r_c02_w.nr_ddd||r_c02_w.nr_fone||r_c02_w.nr_ramal||r_c02_w.nr_ddd_2||r_c02_w.nr_fone_2||r_c02_w.nr_ramal_2||
							r_c02_w.nr_ddd_3||r_c02_w.nr_fone_3||r_c02_w.nr_ramal_3||r_c02_w.ds_email||r_c02_w.ds_email_2||r_c02_w.ds_email_3;
				CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('311',ds_conteudo_w,arq_texto_p);
			end if;
			end;
		end loop;
		
		--R306 - DADOS DO BENEFICIARIO

		for r_c03_w in C03 loop
			begin
			
			nr_seq_mov_segurado_w	:= r_c03_w.nr_sequencia;
			
			if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('09','10','11')) then
				ds_conteudo_w	:=	r_c03_w.cd_unimed||r_c03_w.cd_usuario_plano||r_c03_w.cd_titular_plano||r_c03_w.cd_dependencia||r_c03_w.dt_inclusao||
							r_c03_w.dt_exclusao||r_c03_w.ie_consta_sib||r_c03_w.nr_prot_ans_origem||r_c03_w.ie_beneficio_obito||'N';
			else
				ds_conteudo_w	:=	r_c03_w.cd_unimed||r_c03_w.cd_usuario_plano||r_c03_w.cd_titular_plano||r_c03_w.cd_dependencia||r_c03_w.dt_inclusao||
							r_c03_w.dt_exclusao||r_c03_w.ie_consta_sib||r_c03_w.nr_prot_ans_origem||r_c03_w.ie_beneficio_obito;
			end if;
			
			CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('306',ds_conteudo_w,arq_texto_p);
			
			--R307 - DADOS DO REPASSE

			for r_c04_w in C04 loop
				begin
				
				cd_unimed_interc_w := lpad('0',4,'0');
				cd_carteira_interc_w := rpad('0',13,'0');
				
				if (r_c04_w.ie_tipo_compartilhamento = 1) then --Cartao do beneficiario na Unimed destino. Se for habitual, nao e gerado
					select	max(nr_cartao_intercambio)
					into STRICT	nr_cartao_intercambio_w
					from	pls_segurado_carteira
					where	nr_seq_segurado = r_c03_w.nr_seq_segurado;
					
					if (nr_cartao_intercambio_w IS NOT NULL AND nr_cartao_intercambio_w::text <> '') then
						cd_unimed_interc_w := lpad(nr_cartao_intercambio_w,4,'0');
						cd_carteira_interc_w := rpad(substr(nr_cartao_intercambio_w,5,17),13,'0');
					end if;
				end if;
				
				select	to_char(max(dt_validade_carteira),'yyyymmdd'),
					max(nr_via_solicitacao)
				into STRICT	dt_validade_carteira_w,
					nr_via_solicitacao_w
				from	pls_segurado_carteira
				where	nr_seq_segurado = r_c03_w.nr_seq_segurado;
				
				if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('11')) then
					ds_conteudo_w	:= 	r_c04_w.cd_unimed_origem||r_c04_w.cd_unimed_destino||r_c04_w.ie_tipo_repasse||'        '||
								r_c04_w.dt_fim_repasse||cd_unimed_interc_w||cd_carteira_interc_w||lpad(nr_via_solicitacao_w,2,'0')||
								dt_validade_carteira_w||r_c04_w.dt_comp_risco;
				elsif (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('09','10')) then
					if (current_setting('ptu_moviment_benef_a1300_pck.cd_versao_ptu_w')::ptu_regra_interface.cd_versao_ptu%type in ('10.0','10.0a')) then
						ds_conteudo_w	:= 	r_c04_w.cd_unimed_origem||r_c04_w.cd_unimed_destino||r_c04_w.ie_tipo_repasse||r_c04_w.dt_repasse||
									r_c04_w.dt_fim_repasse||cd_unimed_interc_w||cd_carteira_interc_w||lpad(nr_via_solicitacao_w,2,'0')||
									dt_validade_carteira_w||r_c04_w.dt_comp_risco;
					else
						ds_conteudo_w	:=	r_c04_w.cd_unimed_origem||r_c04_w.cd_unimed_destino||r_c04_w.ie_tipo_repasse||r_c04_w.dt_repasse||
									r_c04_w.dt_fim_repasse||cd_unimed_interc_w||cd_carteira_interc_w||lpad(nr_via_solicitacao_w,2,'0')||dt_validade_carteira_w;
					end if;
				else
					ds_conteudo_w	:= 	r_c04_w.cd_unimed_origem||r_c04_w.cd_unimed_destino||r_c04_w.ie_tipo_repasse||r_c04_w.dt_repasse||
								r_c04_w.dt_fim_repasse||cd_unimed_interc_w||cd_carteira_interc_w;
				end if;
				CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('307',ds_conteudo_w,arq_texto_p);
				end;
			end loop;
			
			--R308 - DADOS DO PLANO

			for r_c05_w in C05 loop
				begin
				nr_seq_mov_seg_plano_w	:= r_c05_w.nr_sequencia;
				
				reservado_w := rpad(' ',40,' ');
				
				select	coalesce(max(ie_tipo_rede_min), '0')
				into STRICT	ie_tipo_rede_min_w
				from	ptu_rede_referenciada
				where	cd_rede = r_c05_w.cd_rede;
				
				if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('11')) then
					ds_conteudo_w	:= 	r_c05_w.ds_razao_social||r_c05_w.dt_inclusao||r_c05_w.dt_exclusao||reservado_w||
								r_c05_w.ie_abrangencia||r_c05_w.ie_natureza||r_c05_w.ie_acomodacao||' '||r_c05_w.ie_plano||
								r_c05_w.cd_prod_ans||r_c05_w.ie_segmentacao||r_c05_w.cd_rede||r_c05_w.ds_rede||
								r_c05_w.nr_via_solicitacao||r_c05_w.dt_validade_carteira||r_c05_w.cd_local_atendimento||
								r_c05_w.ie_carencia_temp||r_c05_w.dt_fim_carencia||r_c05_w.ie_repasse||r_c05_w.cd_motivo_exclusao||
								r_c05_w.nm_fantasia_adm||r_c05_w.ds_plano_origem_atual||r_c05_w.ds_razao_social_adm||r_c05_w.nr_contrato||
								r_c05_w.dt_contr_plano||ie_tipo_rede_min_w||r_c05_w.cd_cgc_administradora;
				elsif (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('09','10')) then
					ds_conteudo_w	:= 	r_c05_w.ds_razao_social||r_c05_w.dt_inclusao||r_c05_w.dt_exclusao||reservado_w||
								r_c05_w.ie_abrangencia||r_c05_w.ie_natureza||r_c05_w.ie_acomodacao||' '||r_c05_w.ie_plano||
								r_c05_w.cd_prod_ans||r_c05_w.ie_segmentacao||r_c05_w.cd_rede||r_c05_w.ds_rede||
								r_c05_w.nr_via_solicitacao||r_c05_w.dt_validade_carteira||r_c05_w.cd_local_atendimento||
								r_c05_w.ie_carencia_temp||r_c05_w.dt_fim_carencia||r_c05_w.ie_repasse||r_c05_w.cd_motivo_exclusao||
								r_c05_w.nm_fantasia_adm||r_c05_w.ds_plano_origem_atual||r_c05_w.ds_razao_social_adm||r_c05_w.nr_contrato||
								r_c05_w.dt_contr_plano||ie_tipo_rede_min_w;
				else
					ds_conteudo_w	:= 	r_c05_w.ds_razao_social||r_c05_w.dt_inclusao||r_c05_w.dt_exclusao||reservado_w||
								r_c05_w.ie_abrangencia||r_c05_w.ie_natureza||r_c05_w.ie_acomodacao||' '||r_c05_w.ie_plano||
								r_c05_w.cd_prod_ans||r_c05_w.ie_segmentacao||r_c05_w.cd_rede||r_c05_w.ds_rede||
								r_c05_w.nr_via_solicitacao||r_c05_w.dt_validade_carteira||r_c05_w.cd_local_atendimento||
								r_c05_w.ie_carencia_temp||r_c05_w.dt_fim_carencia||r_c05_w.ie_repasse||r_c05_w.cd_motivo_exclusao||
								r_c05_w.nm_fantasia_adm||r_c05_w.ds_plano_origem_atual||r_c05_w.ds_razao_social_adm||r_c05_w.nr_contrato||
								r_c05_w.dt_contr_plano;
				end if;
				
				CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('308',ds_conteudo_w,arq_texto_p);
				
				--R309 - ABRANGENCIA

				for r_c06_w in C06 loop
					begin
					ds_conteudo_w	:= lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c06_w.cd_municipio_ibge),7,0)||r_c06_w.SG_ESTADO;
					CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('309',ds_conteudo_w,arq_texto_p);
					end;
				end loop;
				
				--R310 - CARENCIAS

				for r_c07_w in C07 loop
					begin					
					ds_conteudo_w	:= lpad(r_c07_w.cd_tipo_cobertura,3,0)|| to_char(r_c07_w.dt_fim_carencia,'YYYYMMDD');
					CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('310',ds_conteudo_w,arq_texto_p);
					end;
				end loop;
				
				end;
			end loop;
			
			end;
		end loop;
		
		end;
	end loop;
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.processar_pf_arq ( nr_seq_lote_p bigint, nr_seq_mov_empresa_p bigint, arq_texto_p utl_file.file_type) FROM PUBLIC;