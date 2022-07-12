-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_moviment_benef_a1300_pck.processar_arquivo ( nr_seq_lote_p bigint, cd_unimed_destino_p ptu_mov_benef_destino.cd_unimed_destino%type, arq_texto_p utl_file.file_type) AS $body$
DECLARE

	
	ds_conteudo_w			varchar(4000);
	current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype		ptu_mov_benef_lote%rowtype;
	ptu_mov_benef_contagem_w	ptu_mov_benef_contagem%rowtype;
	ptu_mov_benef_trailer_w		ptu_mov_benef_trailer%rowtype;
	ds_reservado_w			varchar(255);
	ds_reservado9_w			varchar(255);
	ds_hash_w			varchar(32);
	nr_cnpj_w			varchar(15);
	nr_cei_w			varchar(12);
	ie_tipo_movimentacao_w		ptu_mov_benef_lote.ie_tipo_movimentacao%type;
	
	
	C01 CURSOR FOR
		SELECT	nr_sequencia,
			lpad(coalesce(cd_filial,'0'),3,'0') cd_filial,
			rpad(coalesce(ds_razao_social, ' '),40,' ') ds_razao_social,
			rpad(coalesce(nm_empr_abrev, ' '),18, ' ') nm_empr_abrev,
			coalesce(cd_cgc_cpf,'0') nr_cnpj,
			lpad(coalesce(nr_insc_estadual,0),20,0) nr_insc_estadual,
			rpad(coalesce(ds_endereco, ' '),40, ' ') ds_endereco,
			rpad(coalesce(ds_complemento, ' '),20, ' ') ds_complemento,
			rpad(coalesce(ds_bairro, ' '),30, ' ') ds_bairro,
			lpad(coalesce(cd_cep,'0'),8,'0') cd_cep,
			rpad(coalesce(nm_cidade, ' '),30,  ' ') nm_cidade,
			sg_uf,
			lpad(coalesce(nr_ddd,0),4,0) nr_ddd,
			to_char(dt_inclusao,'yyyymmdd') dt_inclusao,
			CASE WHEN coalesce(dt_exclusao::text, '') = '' THEN '        '  ELSE to_char(dt_exclusao,'yyyymmdd') END  dt_exclusao,
			lpad(coalesce(cd_empresa_origem,0),10,0) cd_empresa_origem,
			cd_municipio_ibge,
			lpad(coalesce(nr_telefone,0),9,0) nr_telefone,
			lpad(coalesce(nr_fax,0),9,0) nr_fax,
			nr_seq_contrato,
			rpad(coalesce(nm_fantasia_empr, ' '),40, ' ') nm_fantasia_empr,
			rpad(coalesce(nm_empr_abrev, ' '),30, ' ') nm_empresa_abrev,
			nr_cei,
			coalesce(cd_caepf,'0') cd_caepf,
			(	SELECT	max(ie_empreendedor_individual)
				from	pessoa_juridica x
				where	x.cd_cgc	= a.cd_cgc_cpf) ie_empreendedor_individual,
			(	select	max(nr_contrato)
				from	pls_contrato
				where	nr_sequencia	= a.nr_seq_contrato) nr_contrato
		from	ptu_mov_benef_empresa a
		where	nr_seq_lote	= nr_seq_lote_p;
	
	C02 CURSOR FOR
		SELECT	*
		from	ptu_mov_benef_exclusao
		where	nr_seq_lote	= nr_seq_lote_p;
	
	C03 CURSOR FOR
		SELECT	*
		from	ptu_mov_benef_autogestao
		where	nr_seq_lote	= nr_seq_lote_p;
	
	
BEGIN
	dbms_lob.createtemporary(current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text, TRUE);
	dbms_lob.open(current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text, dbms_lob.lob_readwrite);
	PERFORM set_config('ptu_moviment_benef_a1300_pck.nr_sequencial_arq_w', 0, false);
	
	select	*
	into STRICT	current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype
	from	ptu_mov_benef_lote
	where	nr_sequencia	= nr_seq_lote_p;
	
	PERFORM set_config('ptu_moviment_benef_a1300_pck.cd_versao_ptu_w', pls_obter_versao_ptu(get_cd_estabelecimento, null, clock_timestamp(),'A1300'), false);
	PERFORM set_config('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w', ptu_obter_versao_transacao('A1300',current_setting('ptu_moviment_benef_a1300_pck.cd_versao_ptu_w')::ptu_regra_interface.cd_versao_ptu%type), false);
	
	PERFORM set_config('ptu_moviment_benef_a1300_pck.qt_total_r316_w', 0, false);
	ds_reservado_w	:= '        ';
	ds_reservado9_w	:= ' ';
	
	select	CASE WHEN current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype.ie_tipo_movimentacao='E' THEN  'P'  ELSE current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype.ie_tipo_movimentacao END
	into STRICT	ie_tipo_movimentacao_w
	;
	
	--R301 - Header

	ds_conteudo_w	:= lpad(cd_unimed_destino_p,4,0) || lpad(pls_obter_cd_cooperativa(get_cd_estabelecimento),4,0)|| to_char(clock_timestamp(),'YYYYMMDD')||
			ie_tipo_movimentacao_w||to_char(current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype.dt_inicial,'YYYYMMDD')||
			to_char(current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype.dt_final,'YYYYMMDD')||current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2);
	
	CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('301',ds_conteudo_w,arq_texto_p);
	
	CALL ptu_moviment_benef_a1300_pck.processar_pf_arq(nr_seq_lote_p,null,arq_texto_p);
	
	--R302 - EMPRESA CONTRATANTE

	for r_c01_w in C01 loop
		begin
		
		if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) = '11') then
			select	CASE WHEN r_c01_w.cd_caepf='0' THEN r_c01_w.nr_cnpj  ELSE '0' END  --Se CAEPF estiver informado, precisa enviar zeros no CNPJ
			into STRICT	nr_cnpj_w
			;
			
			ds_conteudo_w	:=	r_c01_w.cd_filial||r_c01_w.ds_razao_social||lpad(ds_reservado9_w,18,' ')||lpad(nr_cnpj_w,15,'0')||r_c01_w.nr_insc_estadual||
							r_c01_w.ds_endereco||r_c01_w.ds_complemento||r_c01_w.ds_bairro||r_c01_w.cd_cep||lpad(ds_reservado9_w,30,' ')||lpad(ds_reservado9_w,2,' ')||
							r_c01_w.nr_ddd|| lpad(ds_reservado_w,8,' ')||lpad(ds_reservado_w,8,' ') || r_c01_w.dt_inclusao||r_c01_w.dt_exclusao||r_c01_w.cd_empresa_origem||
							lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c01_w.cd_municipio_ibge),7,0)||r_c01_w.nr_telefone||r_c01_w.nr_fax||rpad(r_c01_w.nr_contrato,15, ' ')||
							r_c01_w.nm_fantasia_empr||r_c01_w.nm_empresa_abrev||lpad(r_c01_w.cd_caepf,14,'0');
		else
			if (r_c01_w.cd_caepf <> '0') then --Conforme comunicado www2.unimed.coop.br/nacional/maisinfo/ge/CADBENEF/20181226/20181226.html, deve enviar o CAEPF no CNPJ para versoes anteriores a 11 do PTU
				nr_cnpj_w	:= lpad(r_c01_w.cd_caepf,15,'0');
				nr_cei_w	:= lpad('0',12,'0');
			elsif (r_c01_w.ie_empreendedor_individual = 'S') and --Necessario validar se empresario individual, pois ele nao tem CNPJ
				(r_c01_w.nr_cei IS NOT NULL AND r_c01_w.nr_cei::text <> '') then -- porem o cliente cadastra o CEI no campo CNPJ por ser obrigatorio, nesse caso nao pode gerar o mesmo valor nos dois campos
				nr_cnpj_w	:= lpad('0',15,'0');
				nr_cei_w	:= lpad(coalesce(r_c01_w.nr_cei,'0'),12,'0');
			else
				nr_cnpj_w	:= lpad(coalesce(r_c01_w.nr_cnpj,'0'),15,'0');
				nr_cei_w	:= lpad(coalesce(r_c01_w.nr_cei,'0'),12,'0');
			end if;
			
			if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) = '10') then
				ds_conteudo_w	:=	r_c01_w.cd_filial||r_c01_w.ds_razao_social||lpad(ds_reservado9_w,18,' ')||nr_cnpj_w||r_c01_w.nr_insc_estadual||
							r_c01_w.ds_endereco||r_c01_w.ds_complemento||r_c01_w.ds_bairro||r_c01_w.cd_cep||lpad(ds_reservado9_w,30,' ')||lpad(ds_reservado9_w,2,' ')||
							r_c01_w.nr_ddd|| lpad(ds_reservado_w,8,' ')||lpad(ds_reservado_w,8,' ') || r_c01_w.dt_inclusao||r_c01_w.dt_exclusao||r_c01_w.cd_empresa_origem||
							lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c01_w.cd_municipio_ibge),7,0)||r_c01_w.nr_telefone||r_c01_w.nr_fax||rpad(r_c01_w.nr_contrato,15, ' ')||
							r_c01_w.nm_fantasia_empr||r_c01_w.nm_empresa_abrev||nr_cei_w;
			elsif (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) = '09') then
				ds_conteudo_w	:=	r_c01_w.cd_filial||r_c01_w.ds_razao_social||lpad(ds_reservado9_w,18,' ')||lpad(r_c01_w.nr_cnpj,15,'0')||r_c01_w.nr_insc_estadual||
							r_c01_w.ds_endereco||r_c01_w.ds_complemento||r_c01_w.ds_bairro||r_c01_w.cd_cep||lpad(ds_reservado9_w,30,' ')||lpad(ds_reservado9_w,2,' ')||
							r_c01_w.nr_ddd|| lpad(ds_reservado_w,8,' ')||lpad(ds_reservado_w,8,' ') || r_c01_w.dt_inclusao||r_c01_w.dt_exclusao||r_c01_w.cd_empresa_origem||
							lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c01_w.cd_municipio_ibge),7,0)||r_c01_w.nr_telefone||r_c01_w.nr_fax||rpad(r_c01_w.nr_contrato,15, ' ')||
							r_c01_w.nm_fantasia_empr||r_c01_w.nm_empresa_abrev;
			else
				ds_conteudo_w	:=	r_c01_w.cd_filial||r_c01_w.ds_razao_social||r_c01_w.nm_empr_abrev||lpad(r_c01_w.nr_cnpj,15,'0')||r_c01_w.nr_insc_estadual||
							r_c01_w.ds_endereco||r_c01_w.ds_complemento||r_c01_w.ds_bairro||r_c01_w.cd_cep||r_c01_w.nm_cidade||r_c01_w.sg_uf||
							r_c01_w.nr_ddd|| ds_reservado_w||ds_reservado_w || r_c01_w.dt_inclusao||r_c01_w.dt_exclusao||r_c01_w.cd_empresa_origem||
							lpad(ptu_moviment_benef_a1300_pck.calcular_digito_municipio_ibge(r_c01_w.cd_municipio_ibge),7,0)||r_c01_w.nr_telefone||r_c01_w.nr_fax||rpad(r_c01_w.nr_contrato,15, ' ')||
							r_c01_w.nm_fantasia_empr;
			end if;
		end if;
		
		CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('302',ds_conteudo_w,arq_texto_p);
		
		CALL ptu_moviment_benef_a1300_pck.processar_pf_arq(nr_seq_lote_p,r_c01_w.nr_sequencia,arq_texto_p);
		end;
	end loop;
	
	--R316 INATIVACAO DO BENEFICIARIO

	for r_c02_w in c02 loop
		begin
		
		ds_conteudo_w	:= 	lpad(r_c02_w.cd_operadora,4,0) || lpad(r_c02_w.cd_beneficiario,13,0) ||
					to_char(r_c02_w.dt_exclusao,'YYYYMMDD') || to_char(r_c02_w.dt_fim_vigencia,'YYYYMMDD') ||
					lpad(coalesce(r_c02_w.cd_motivo_exclusao,'0'),2,0);
		
		CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('316',ds_conteudo_w,arq_texto_p);
		
		PERFORM set_config('ptu_moviment_benef_a1300_pck.qt_total_r316_w', current_setting('ptu_moviment_benef_a1300_pck.qt_total_r316_w')::ptu_mov_benef_trailer.qt_total_r316%type + 1, false);
		
		end;
	end loop;
	
	--R317 - AUTOGESTAO CESSAO DE REDE

	for r_c03_w in C03 loop
		begin
		ds_conteudo_w	:=	lpad(r_c03_w.cd_unimed,4,0) || lpad(r_c03_w.cd_usuario_plano,13,0) ||
					rpad(r_c03_w.nm_beneficiario,70,' ') || coalesce(to_char(r_c03_w.dt_nascimento,'yyyymmdd'),'        ') || coalesce(r_c03_w.ie_sexo,'I') ||
					rpad(coalesce(r_c03_w.cd_cns,' '),15,' ') || lpad(r_c03_w.cd_cnpj,15,'0') || lpad(coalesce(r_c03_w.cd_auto_gestao_ans,'0'),10,'0') ||
					lpad(coalesce(r_c03_w.nr_cpf,'0'),15,'0') || coalesce(to_char(r_c03_w.dt_inclusao,'yyyymmdd'),'        ') || coalesce(to_char(r_c03_w.dt_exclusao,'yyyymmdd'),'        ');
		
		CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('317',ds_conteudo_w,arq_texto_p);
		end;
	end loop;
	
	select	*
	into STRICT	ptu_mov_benef_contagem_w
	from	ptu_mov_benef_contagem
	where	nr_seq_lote = nr_seq_lote_p;
	
	--R318 - DADOS - CONTAGEM DE BENEFICIARIOS

	if (current_setting('ptu_moviment_benef_a1300_pck.ptu_mov_benef_lote_w')::ptu_mov_benef_lote%rowtype.ie_tipo_movimentacao <> 'E') then --No lote de exclusao nao pode enviar o registro R318
		ds_conteudo_w	:= 	to_char(ptu_mov_benef_contagem_w.dt_mes_referencia,'YYYYMM')||lpad(ptu_mov_benef_contagem_w.qt_benef_pf_co_loc,10,0)||
					lpad(ptu_mov_benef_contagem_w.qt_benef_pf_pp_loc,10,0)||lpad(ptu_mov_benef_contagem_w.qt_benef_pj_co_loc,10,0)||
					lpad(ptu_mov_benef_contagem_w.qt_benef_pj_pp_loc,10,0)||lpad(ptu_mov_benef_contagem_w.qt_benef_pf_rep_co,10,0)||
					lpad(ptu_mov_benef_contagem_w.qt_benef_pf_rep_pp,10,0)||lpad(ptu_mov_benef_contagem_w.qt_benef_pj_rep_co,10,0)||
					lpad(ptu_mov_benef_contagem_w.qt_benef_pj_rep_pp,10,0)||lpad(ptu_mov_benef_contagem_w.qt_benef_pf_rec_co,10,0)||
					lpad(ptu_mov_benef_contagem_w.qt_benef_pf_rec_pp,10,0)||lpad(ptu_mov_benef_contagem_w.qt_benef_pj_rec_co,10,0)||
					lpad(ptu_mov_benef_contagem_w.qt_benef_pj_rec_pp,10,0);
		
		CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('318',ds_conteudo_w,arq_texto_p);
	end if;
	
	select	*
	into STRICT	ptu_mov_benef_trailer_w
	from	ptu_mov_benef_trailer
	where	nr_seq_lote = nr_seq_lote_p;
	
	--R319 - TRAILLER

	if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('10','11')) then
		ds_conteudo_w	:=	lpad(ptu_mov_benef_trailer_w.qt_total_r302,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r303,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r304,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r305,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r306,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r307,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r308,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r309,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r310,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r317,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r311-current_setting('ptu_moviment_benef_a1300_pck.qt_reduzir_r311_w')::bigint,7,0)|| lpad(current_setting('ptu_moviment_benef_a1300_pck.qt_total_r316_w')::ptu_mov_benef_trailer.qt_total_r316%type,7,0);
	elsif (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) = '09') then
		ds_conteudo_w	:=	lpad(ptu_mov_benef_trailer_w.qt_total_r302,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r303,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r304,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r305,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r306,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r307,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r308,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r309,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r310,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r317,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r311,7,0);
	else
		ds_conteudo_w	:=	lpad(ptu_mov_benef_trailer_w.qt_total_r302,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r303,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r304,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r305,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r306,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r307,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r308,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r309,7,0)||
					lpad(ptu_mov_benef_trailer_w.qt_total_r310,7,0)||lpad(ptu_mov_benef_trailer_w.qt_total_r317,7,0);
	end if;
	
	CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('319',ds_conteudo_w,arq_texto_p);
	
	if (current_setting('ptu_moviment_benef_a1300_pck.nr_versao_transacao_w')::varchar(2) in ('08','09','10','11')) then
		current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text := pls_hash_ptu_pck.obter_hash_txt(current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text);
		ds_conteudo_w		:=	lpad(ds_hash_w,32,' ');
		CALL CALL CALL CALL CALL CALL ptu_moviment_benef_a1300_pck.incluir_linha_arq('998',ds_conteudo_w, arq_texto_p);
		
		update	ptu_mov_benef_destino
		set	ds_hash_a1300	= ds_hash_w
		where	cd_unimed_destino = cd_unimed_destino_p
		and	nr_seq_lote = nr_seq_lote_p;
		commit;
	end if;
	
	if (dbms_lob.isopen(current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text) = 1) Then
		dbms_lob.close(current_setting('ptu_moviment_benef_a1300_pck.ds_arquivo_w')::text);
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benef_a1300_pck.processar_arquivo ( nr_seq_lote_p bigint, cd_unimed_destino_p ptu_mov_benef_destino.cd_unimed_destino%type, arq_texto_p utl_file.file_type) FROM PUBLIC;
