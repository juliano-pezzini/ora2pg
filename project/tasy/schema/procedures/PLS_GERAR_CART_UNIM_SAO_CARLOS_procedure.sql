-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_cart_unim_sao_carlos ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_header_w			varchar(4000);
ds_sub_header_w			varchar(4000);
cd_usuario_plano_w		varchar(255);
nm_beneficiario_w		varchar(255);
tp_contratacao_w		varchar(255);
dt_nascimento_w			varchar(255);
dt_validade_carteira_w		varchar(255);
cd_local_cobranca_w		varchar(255);
ds_produto_w			varchar(255);
cd_abrangencia_w		varchar(255);
ds_abrangencia_w		varchar(255);
ds_registro_ans_w		varchar(255);
ds_mensagem_cpt_w		varchar(255);
nm_empresa_w			varchar(255);
nm_empresa_ww			varchar(255);
ds_rede_atendimento_w		varchar(255);
ds_carencia1_w			w_pls_interface_carteira.ds_carencia_1%type;
ds_carencia2_w			w_pls_interface_carteira.ds_carencia_2%type;
ds_carencia3_w			w_pls_interface_carteira.ds_carencia_3%type;
ds_carencia4_w			w_pls_interface_carteira.ds_carencia_4%type;
ds_carencia5_w			w_pls_interface_carteira.ds_carencia_5%type;
ds_carencia6_w			w_pls_interface_carteira.ds_carencia_6%type;
ds_carencia7_w			w_pls_interface_carteira.ds_carencia_7%type;
ds_carencia8_w			w_pls_interface_carteira.ds_carencia_8%type;
ds_carencia9_w			w_pls_interface_carteira.ds_carencia_9%type;
ds_carencia10_w			w_pls_interface_carteira.ds_carencia_10%type;
ds_carencia11_w			w_pls_interface_carteira.ds_carencia_11%type;
ds_carencia12_w			w_pls_interface_carteira.ds_carencia_12%type;
nr_via_solicitacao_w		varchar(255);
ds_regiao_w			varchar(4000);
ds_trilha_1_w			w_pls_interface_carteira.ds_trilha_1%type;
ds_trilha_2_w			w_pls_interface_carteira.ds_trilha_2%type;
nr_protocolo_ans_w		varchar(12);
dt_contratacao_w		varchar(255);
ds_mensagem_w			varchar(255);
dt_inclusao_operadora_w		timestamp;
nr_seq_contrato_w		bigint;
ds_mensagem_cart_w		varchar(255);
ds_mens_carencia_w		varchar(255);
ds_mensagem_carencia_w		varchar(255);
cd_cgc_estipulante_w		varchar(255);
cd_pf_estipulante_w		varchar(255);
nr_seq_plano_w			bigint;
nr_seq_regiao_w			bigint;
ie_tipo_segurado_w		varchar(255);
ds_congenere_w			varchar(255);
ds_tipo_acomodacao_w		varchar(255);
cd_rede_refer_ptu_w		pls_plano.cd_rede_refer_ptu%type;
ie_tipo_contratacao_w		pls_plano.ie_tipo_contratacao%type;
nm_fantasia_w			pls_plano.nm_fantasia%type;
nr_seq_localizacao_benef_w	pls_segurado.nr_seq_localizacao_benef%type;
ds_localizacao_w		pls_localizacao_benef.ds_localizacao%type;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
ds_regiao_1_w			varchar(1000);
ds_regiao_2_w			varchar(1000);
ds_regiao_3_w			varchar(1000);
ds_regiao_4_w			varchar(1000);
ds_regiao_5_w			varchar(1000);
ie_situacao_trabalhista_w	pls_segurado.ie_situacao_trabalhista%type;
ie_tipo_operacao_w		pls_plano.ie_tipo_operacao%type;
dt_vigencia_plano_w		char(10);
ds_segmentacao_w		varchar(56);
nr_cartao_nac_sus_w		varchar(20);
ie_tipo_contrato_w		pls_intercambio.ie_tipo_contrato%type;
nr_seq_oper_congenere_w		pls_intercambio.nr_seq_oper_congenere%type;
nr_seq_congenere_w		pls_intercambio.nr_seq_congenere%type;
ds_operadora_congenere_w	varchar(50);
cd_ans_w			pls_outorgante.cd_ans%type;
ds_tipo_rede_min_w		varchar(50);

C01 CURSOR(nr_seq_lote_p	pls_lote_carteira.nr_sequencia%type) FOR 
	SELECT	b.nr_sequencia		nr_seq_segurado 
	from	pls_segurado_carteira	a, 
		pls_segurado		b, 
		pls_carteira_emissao	c, 
		pls_lote_carteira	d 
	where	a.nr_seq_segurado	= b.nr_sequencia 
	and	c.nr_seq_seg_carteira	= a.nr_sequencia 
	and	c.nr_seq_lote		= d.nr_sequencia 
	and	d.nr_sequencia		= nr_seq_lote_p;

C02 CURSOR(	nr_seq_plano_p		pls_plano_area.nr_seq_plano%type) FOR 
	SELECT	c.ds_municipio 
	from	pls_plano_area		a, 
		pls_regiao_local	b, 
		sus_municipio		c 
	where	c.cd_municipio_ibge	= b.cd_municipio_ibge 
	and	b.nr_seq_regiao		= a.nr_seq_regiao 
	and	a.nr_seq_plano		= nr_seq_plano_p;

C03 CURSOR(	nr_seq_plano_p		pls_plano_area.nr_seq_plano%type) FOR 
	SELECT	b.sg_uf_municipio 
	from	pls_plano_area		a, 
		pls_regiao_local	b 
	where	b.nr_seq_regiao		= a.nr_seq_regiao 
	and	a.nr_seq_plano		= nr_seq_plano_p;

BEGIN 
 
delete	FROM w_pls_interface_carteira 
where	nr_seq_lote	= nr_seq_lote_p;
 
for c01_w in C01(nr_seq_lote_p) loop 
	select	c.cd_usuario_plano, 
		substr((CASE WHEN (trim(both nm_abreviado) IS NOT NULL AND (trim(both nm_abreviado))::text <> '') THEN upper(nm_abreviado) ELSE pls_gerar_nome_abreviado(a.nm_pessoa_fisica) END), 1, 25) nm_beneficiario, 
		to_char(a.dt_nascimento, 'dd/mm/yyyy'), 
		--substr(nvl(pls_obter_dados_cart_unimed(b.nr_sequencia, d.nr_sequencia, 'DA', 1), 'NÃO SE APLICA'), 1, 50) ds_produto, 
		upper(substr(d.nm_fantasia,1,30)) ds_produto, 
		to_char(c.dt_validade_carteira, 'dd/mm/yyyy'), 
		CASE WHEN d.ie_tipo_contratacao='I' THEN  'Individual ou Familiar' WHEN d.ie_tipo_contratacao='CA' THEN  'Coletivo por Adesão' WHEN d.ie_tipo_contratacao='CE' THEN  'Coletivo Empresarial' END , 
		CASE WHEN d.ie_regulamentacao='R' THEN  'NÃO REGULAMENTADO' WHEN d.ie_regulamentacao='P' THEN  'REGULAMENTADO' WHEN d.ie_regulamentacao='A' THEN  'ADAPTADO' END , 
		d.ie_abrangencia, 
		upper(obter_valor_dominio(1667,d.ie_abrangencia)), 
		lpad(to_char(c.nr_via_solicitacao), 2, '0'), 
		d.nr_sequencia, 
		substr(CASE WHEN d.ie_regulamentacao='R' THEN d.cd_scpa  ELSE d.nr_protocolo_ans END ,1,12) nr_protocolo_ans, 
		replace(replace(ds_trilha1, ';', ''),'%',''), 
		replace(ds_trilha2, ';', ''), 
		to_char(to_date(b.dt_contratacao),'dd/mm/yyyy'), 
		b.dt_inclusao_operadora, 
		b.ie_tipo_segurado, 
		b.nr_seq_contrato, 
		CASE WHEN ie_acomodacao='I' THEN  'Individual'  WHEN ie_acomodacao='C' THEN 'Coletivo'  ELSE 'Não se aplica' END  ds_tipo_acomodacao, 
		d.ie_tipo_contratacao, 
		d.nm_fantasia, 
		nr_seq_localizacao_benef, 
		b.nr_seq_intercambio, 
		b.ie_situacao_trabalhista, 
		to_char(to_date(d.dt_ativacao),'dd/mm/yyyy') dt_vigencia_plano, 
		upper(substr(obter_valor_dominio(1665,d.ie_segmentacao),1,56)) ds_segmentacao, 
		substr(a.nr_cartao_nac_sus,1,20) nr_cartao_nac_sus 
	into STRICT	cd_usuario_plano_w, 
		nm_beneficiario_w, 
		dt_nascimento_w, 
		ds_produto_w, 
		dt_validade_carteira_w, 
		tp_contratacao_w, 
		ds_registro_ans_w, 
		cd_abrangencia_w, 
		ds_abrangencia_w, 
		nr_via_solicitacao_w, 
		nr_seq_plano_w, 
		nr_protocolo_ans_w, 
		ds_trilha_1_w, 
		ds_trilha_2_w, 
		dt_contratacao_w, 
		dt_inclusao_operadora_w, 
		ie_tipo_segurado_w, 
		nr_seq_contrato_w, 
		ds_tipo_acomodacao_w, 
		ie_tipo_contratacao_w, 
		nm_fantasia_w, 
		nr_seq_localizacao_benef_w, 
		nr_seq_intercambio_w, 
		ie_situacao_trabalhista_w, 
		dt_vigencia_plano_w, 
		ds_segmentacao_w, 
		nr_cartao_nac_sus_w 
	from	pls_plano		d, 
		pls_segurado_carteira	c, 
		pls_segurado		b, 
		pessoa_fisica		a 
	where	c.nr_seq_segurado	= b.nr_sequencia 
	and	b.nr_seq_plano		= d.nr_sequencia 
	and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica 
	and	b.nr_sequencia		= c01_w.nr_seq_segurado;
 
	ds_operadora_congenere_w := null;
	cd_ans_w		 := null;
 
	if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then 
		select	a.cd_pf_estipulante, 
			a.cd_cgc_estipulante 
		into STRICT	cd_pf_estipulante_w, 
			cd_cgc_estipulante_w 
		from	pls_contrato a 
		where	a.nr_sequencia = nr_seq_contrato_w;
 
		select	max(ds_mensagem) 
		into STRICT	ds_mensagem_carencia_w 
		from	pls_contrato_mensagem_cart 
		where	nr_seq_contrato			= nr_seq_contrato_w 
		and	coalesce(ie_mensagem_carencia,'N')	= 'S' 
		and	ie_mensagem_abrangencia		= 'N' 
		and	ie_situacao			= 'A' 
		and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());
	elsif (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then 
		select	a.cd_pessoa_fisica, 
			a.cd_cgc, 
			a.ie_tipo_contrato, 
			a.nr_seq_oper_congenere, 
			a.nr_seq_congenere 
		into STRICT	cd_pf_estipulante_w, 
			cd_cgc_estipulante_w, 
			ie_tipo_contrato_w, 
			nr_seq_oper_congenere_w, 
			nr_seq_congenere_w 
		from	pls_intercambio a 
		where	a.nr_sequencia = nr_seq_intercambio_w;
 
		if (ie_tipo_contrato_w = 'C') then 
			select	substr(pls_obter_nome_congenere(nr_seq_oper_congenere_w),1,50) 
			into STRICT	ds_operadora_congenere_w 
			;
		elsif (ie_tipo_contrato_w = 'I') then 
			select	max(cd_ans) 
			into STRICT	cd_ans_w 
			from	pls_congenere 
			where	nr_sequencia = nr_seq_congenere_w;
		end if;
 
		select	max(ds_mensagem) 
		into STRICT	ds_mensagem_carencia_w 
		from	pls_contrato_mensagem_cart 
		where	nr_seq_intercambio		= nr_seq_intercambio_w 
		and	coalesce(ie_mensagem_carencia,'N')	= 'S' 
		and	ie_mensagem_abrangencia		= 'N' 
		and	ie_situacao			= 'A' 
		and	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp());
	end if;
 
	if (nr_seq_plano_w IS NOT NULL AND nr_seq_plano_w::text <> '') then 
		select	cd_rede_refer_ptu, 
			ie_tipo_operacao, 
			pls_obter_rede_ref_produto(nr_seq_plano_w,cd_estabelecimento_p,'DT') 
		into STRICT	cd_rede_refer_ptu_w, 
			ie_tipo_operacao_w, 
			ds_tipo_rede_min_w 
		from	pls_plano 
		where	nr_sequencia = nr_seq_plano_w;
 
		select	upper(CASE WHEN ds_tipo_rede_min_w='Básica' THEN 'Básico'  ELSE ds_tipo_rede_min_w END ) 
		into STRICT	ds_tipo_rede_min_w 
		;
 
		ds_rede_atendimento_w := substr(cd_rede_refer_ptu_w || ' ' || ds_tipo_rede_min_w,1,13);
 
		if (length(cd_rede_refer_ptu_w) = 2) then 
			cd_rede_refer_ptu_w := ds_abrangencia_w || cd_rede_refer_ptu_w;
		end if;
	end if;
 
	cd_usuario_plano_w	:= substr(cd_usuario_plano_w,1,1)||' '||substr(cd_usuario_plano_w,2,3)||' '||substr(cd_usuario_plano_w,5,12)||' '||substr(cd_usuario_plano_w,17,1);
 
	if (cd_pf_estipulante_w IS NOT NULL AND cd_pf_estipulante_w::text <> '') then 
		nm_empresa_w	:= substr(' ',1,18);
	elsif (ie_tipo_contratacao_w = 'I') then 
		nm_empresa_w	:= substr(nm_fantasia_w,1,18);
	else 
		if (ie_situacao_trabalhista_w IS NOT NULL AND ie_situacao_trabalhista_w::text <> '') then 
			if (ie_situacao_trabalhista_w = 'A') then 
				nm_empresa_w := 'INATIVOS/APOSENTADO';
			elsif (ie_situacao_trabalhista_w = 'D') then 
				nm_empresa_w := 'INATIVOS/DEM';
			else 
				nm_empresa_w := obter_valor_dominio(3840,ie_situacao_trabalhista_w);
			end if;
		elsif (coalesce(nr_seq_localizacao_benef_w,0) <> 0) then 
			select 	ds_localizacao 
			into STRICT	ds_localizacao_w 
			from 	pls_localizacao_benef 
			where 	nr_sequencia 	= nr_seq_localizacao_benef_w;
 
			nm_empresa_w	:= substr(ds_localizacao_w,1,18);
		elsif (coalesce(nr_seq_localizacao_benef_w,0) = 0) then 
			if (cd_pf_estipulante_w IS NOT NULL AND cd_pf_estipulante_w::text <> '') then 
				select	max(b.nm_empresa) 
				into STRICT	nm_empresa_ww 
				from	empresa_referencia b, 
					compl_pessoa_fisica a 
				where	a.cd_pessoa_fisica	= cd_pf_estipulante_w 
				and	a.cd_empresa_refer   = b.cd_empresa;
			elsif (cd_cgc_estipulante_w IS NOT NULL AND cd_cgc_estipulante_w::text <> '') then 
				select nm_fantasia 
				into STRICT	nm_empresa_ww 
				from 	pessoa_juridica 
				where 	cd_cgc = cd_cgc_estipulante_w;
			end if;
			nm_empresa_w	:= substr(coalesce(nm_empresa_ww,' '),1,18);
		end if;
	end if;
 
	ds_regiao_w	:= '';
	ds_regiao_1_w	:= '';
	ds_regiao_2_w	:= '';
	ds_regiao_3_w	:= '';
	ds_regiao_4_w	:= '';
	ds_regiao_5_w	:= '';
 
	if (ie_tipo_segurado_w = 'R') then 
		select	max(b.nm_fantasia) 
		into STRICT	ds_congenere_w 
		from	pls_segurado_repasse	c, 
			pessoa_juridica		b, 
			pls_congenere		a 
		where	b.cd_cgc		= a.cd_cgc 
		and	a.nr_sequencia		= c.nr_seq_congenere_atend 
		and	c.nr_seq_segurado	= c01_w.nr_seq_segurado 
		and	(c.dt_liberacao IS NOT NULL AND c.dt_liberacao::text <> '') 
		and	coalesce(c.dt_fim_repasse::text, '') = '';
 
		ds_regiao_1_w	:= 'REPASSE ATT. ' || ds_congenere_w;
	else 
		if (cd_abrangencia_w = 'GM') then 
			for c02_w in C02(nr_seq_plano_w) loop 
				if (length(ds_regiao_1_w || c02_w.ds_municipio) + 2 <= 42) then 
					ds_regiao_1_w := ' ' || c02_w.ds_municipio || ',' || ds_regiao_1_w;
				elsif (length(ds_regiao_2_w || c02_w.ds_municipio) + 2 <= 75) then 
					ds_regiao_2_w := ' ' || c02_w.ds_municipio || ',' || ds_regiao_2_w;
				elsif (length(ds_regiao_3_w || c02_w.ds_municipio) + 2 <= 75) then 
					ds_regiao_3_w := ' ' || c02_w.ds_municipio || ',' || ds_regiao_3_w;
				elsif (length(ds_regiao_4_w || c02_w.ds_municipio) + 2 <= 75) then 
					ds_regiao_4_w := ' ' || c02_w.ds_municipio || ',' || ds_regiao_4_w;
				elsif (length(ds_regiao_5_w || c02_w.ds_municipio) + 2 <= 75) then 
					ds_regiao_5_w := ' ' || c02_w.ds_municipio || ' ' || ds_regiao_5_w;
				end if;
			end loop;
 
			ds_regiao_1_w := 'Área de Atuação do Produto: ' || ds_regiao_1_w;
		elsif (cd_abrangencia_w = 'GE') then 
			for c03_w in C03(nr_seq_plano_w) loop 
				if (length(ds_regiao_1_w || c03_w.sg_uf_municipio) + 2 <= 45) then 
					ds_regiao_1_w := ' ' || c03_w.sg_uf_municipio || ',' || ds_regiao_1_w;
				elsif (length(ds_regiao_2_w || c03_w.sg_uf_municipio) + 2 <= 75) then 
					ds_regiao_2_w := ' ' || c03_w.sg_uf_municipio || ',' || ds_regiao_2_w;
				elsif (length(ds_regiao_3_w || c03_w.sg_uf_municipio) + 2 <= 75) then 
					ds_regiao_3_w := ' ' || c03_w.sg_uf_municipio || ',' || ds_regiao_3_w;
				elsif (length(ds_regiao_4_w || c03_w.sg_uf_municipio) + 2 <= 75) then 
					ds_regiao_4_w := ' ' || c03_w.sg_uf_municipio || ',' || ds_regiao_4_w;
				elsif (length(ds_regiao_5_w || c03_w.sg_uf_municipio) + 2 <= 75) then 
					ds_regiao_5_w := ' ' || c03_w.sg_uf_municipio || ',' || ds_regiao_5_w;
				end if;
			end loop;
 
			ds_regiao_1_w := 'Área de Atuação do Produto: ' || ds_regiao_1_w;
		elsif (cd_abrangencia_w = 'M') then 
			select	substr(obter_desc_municipio_ibge(max(b.cd_municipio_ibge)),1,255) ds_municipio 
			into STRICT	ds_regiao_1_w 
			from	pls_plano_area		a, 
				pls_regiao_local	b 
			where	b.nr_seq_regiao		= a.nr_seq_regiao 
			and	a.nr_seq_plano		= nr_seq_plano_w;
 
			ds_regiao_1_w := 'Área de Atuação do Produto: ' || ds_regiao_1_w;
		end if;
	end if;
 
if (ds_regiao_5_w IS NOT NULL AND ds_regiao_5_w::text <> '') then 
		if (substr(ds_regiao_5_w, length(ds_regiao_5_w), 1) = ',') then 
			ds_regiao_5_w:= substr(ds_regiao_5_w, 1, length(ds_regiao_5_w) - 1);
		end if;
	elsif (ds_regiao_4_w IS NOT NULL AND ds_regiao_4_w::text <> '') then 
		if (substr(ds_regiao_4_w, length(ds_regiao_4_w), 1) = ',') then 
			ds_regiao_4_w:= substr(ds_regiao_4_w, 1, length(ds_regiao_4_w) - 1);
		end if;
	elsif (ds_regiao_3_w IS NOT NULL AND ds_regiao_3_w::text <> '') then 
		if (substr(ds_regiao_3_w, length(ds_regiao_3_w), 1) = ',') then 
			ds_regiao_3_w:= substr(ds_regiao_3_w, 1, length(ds_regiao_3_w) - 1);
		end if;
	elsif (ds_regiao_2_w IS NOT NULL AND ds_regiao_2_w::text <> '') then 
		if (substr(ds_regiao_2_w, length(ds_regiao_2_w), 1) = ',') then 
			ds_regiao_2_w:= substr(ds_regiao_2_w, 1, length(ds_regiao_2_w) - 1);
		end if;
	else 
		if (substr(ds_regiao_1_w, length(ds_regiao_1_w), 1) = ',') then 
			ds_regiao_1_w:= substr(ds_regiao_1_w, 1, length(ds_regiao_1_w) - 1);
		end if;
	end if;
 
	ds_regiao_2_w	:= coalesce(substr(ds_regiao_2_w, 2, length(ds_regiao_2_w) - 1), ' ');
	ds_regiao_3_w	:= coalesce(substr(ds_regiao_3_w, 2, length(ds_regiao_3_w) - 1), ' ');
	ds_regiao_4_w	:= coalesce(substr(ds_regiao_4_w, 2, length(ds_regiao_4_w) - 1), ' ');
	ds_regiao_5_w	:= coalesce(substr(ds_regiao_5_w, 2, length(ds_regiao_5_w) - 1), ' ');
 
	ds_regiao_w	:= rpad(ds_regiao_1_w, 75) || ' ' || rpad(ds_regiao_2_w, 75) || ' ' || rpad(ds_regiao_3_w, 75) || ' ' || rpad(ds_regiao_4_w, 75) || ' ' || rpad(ds_regiao_5_w, 75);
 
	ds_mensagem_cpt_w	:= pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w,'DCPT',6);
 
	nm_beneficiario_w	:= Elimina_Acentuacao(nm_beneficiario_w);
	ds_regiao_w		:= Elimina_Acentuacao(ds_regiao_w);
	ds_produto_w		:= Elimina_Acentuacao(ds_produto_w);
 
	--cd_local_cobranca_w	:= lpad(pls_obter_area_cobranca(c01_w.nr_seq_segurado,cd_estabelecimento_p),4,'0'); 
 
	if ((trim(both ds_mensagem_carencia_w) IS NOT NULL AND (trim(both ds_mensagem_carencia_w))::text <> '')) then 
		ds_carencia1_w := ds_mensagem_carencia_w;
	else 
		ds_carencia1_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 1));
		ds_carencia2_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 2));
		ds_carencia3_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 3));
		ds_carencia4_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 4));
		ds_carencia5_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 5));
		ds_carencia6_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 6));
		ds_carencia7_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 7));
		ds_carencia8_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 8));
		ds_carencia9_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 9));
		ds_carencia10_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 10));
		ds_carencia11_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 11));
		ds_carencia12_w	:= Elimina_Acentuacao(pls_obter_dados_cart_unimed(c01_w.nr_seq_segurado, nr_seq_plano_w, 'CAM7', 12));
	end if;
 
	insert into w_pls_interface_carteira(	nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_lote, ie_tipo_reg, 
			cd_usuario_plano, dt_nascimento, ds_tipo_contratacao, dt_validade_carteira, nm_beneficiario, cd_local_cobranca, nm_plano, 
			ds_abrangencia, ds_registro_ans, dt_cpt, ds_rede_atendimento, nr_protocolo_ans, 
			ds_trilha_1, ds_trilha_2, nr_via_cartao, ds_regiao, ds_estipulante, ds_acomodacao, 
			ds_carencia_1, ds_carencia_2, ds_carencia_3, ds_carencia_4, ds_carencia_5, ds_carencia_6, 
			ds_carencia_7, ds_carencia_8, ds_carencia_9, ds_carencia_10, ds_carencia_11, ds_carencia_12, 
			dt_adesao, ds_segmentacao, ds_cns, ds_observacao_2, cd_operadora_empresa) 
	values (	nextval('w_pls_interface_carteira_seq'), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, nr_seq_lote_p, 2, 
			cd_usuario_plano_w, dt_nascimento_w, tp_contratacao_w, dt_validade_carteira_w, nm_beneficiario_w, cd_local_cobranca_w, ds_produto_w, 
			ds_abrangencia_w, ds_registro_ans_w, ds_mensagem_cpt_w, ds_rede_atendimento_w, nr_protocolo_ans_w, 
			rpad(ds_trilha_1_w, 50), rpad(ds_trilha_2_w, 50), nr_via_solicitacao_w, ds_regiao_w, nm_empresa_w,ds_tipo_acomodacao_w, 
			ds_carencia1_w, ds_carencia2_w, ds_carencia3_w, ds_carencia4_w, ds_carencia5_w, ds_carencia6_w, 
			ds_carencia7_w, ds_carencia8_w, ds_carencia9_w, ds_carencia10_w, ds_carencia11_w,ds_carencia12_w, 
			dt_contratacao_w, ds_segmentacao_w, nr_cartao_nac_sus_w, ds_operadora_congenere_w, cd_ans_w);
end loop;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_cart_unim_sao_carlos ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

