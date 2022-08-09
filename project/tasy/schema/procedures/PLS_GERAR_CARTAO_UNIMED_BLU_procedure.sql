-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_cartao_unimed_blu ( nr_seq_lote_p bigint, cd_interface_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
ds_header_w			varchar(4000);
ds_sub_header_w			varchar(4000);
cd_usuario_plano_w		varchar(30);
nm_beneficiario_w		varchar(250);
tp_contratacao_w		varchar(250);
dt_nascimento_w			varchar(20);
dt_validade_carteira_w		varchar(20);
cd_local_cobranca_w		varchar(20);
ds_produto_w			varchar(50);
cd_abrangencia_w		varchar(10);
ds_abrangencia_w		varchar(50);
ds_registro_ans_w		varchar(50);
ds_acomodacao_w			varchar(50);
cod_empresa_w			bigint;
ds_mensagem_cpt_w		varchar(15);
nm_empresa_w			varchar(50);
ds_carencia_ww			varchar(4000);
ds_carencia_w			varchar(4000);
ds_observacao_1_w		varchar(100);
ds_observacao_2_w		varchar(100);
tp_contrato_w			varchar(10);
nr_via_solicitacao_w		bigint;
ds_regiao_w			varchar(4000);
ds_trilha_1_w			pls_segurado_carteira.ds_trilha1%type;
ds_trilha_2_w			pls_segurado_carteira.ds_trilha2%type;
ds_trilha_3_w			pls_segurado_carteira.ds_trilha3%type;
nr_protocolo_ans_w		varchar(100);
dt_contratacao_w		timestamp;
qt_carencias_w			integer;
ie_tela_carencia_w		integer;
ie_carencia_abrangencia_ant_w	pls_parametros.ie_carencia_abrangencia_ant%type;
qt_cpt_nao_w			integer;
qt_carencias_nao_cumpridas_w	integer;
----------------------------------------------------------------------
cd_cgc_estipulante_w		varchar(20);
cd_pf_estipulante_w		varchar(20);
i				bigint;
qt_registros_w			bigint;
nr_seq_plano_w			bigint;
nr_seq_regiao_w			bigint;
ds_municipio_w			varchar(255);
ds_regiao_1_w			varchar(76);
ds_regiao_2_w			varchar(76);
ds_regiao_3_w			varchar(76);
nr_seq_vinculo_sca_w		bigint;
nr_seq_contrato_w		bigint;
nm_plano_sca_w			varchar(255);
dt_carencia_sca_w		varchar(50);
qt_carencia_sca_w		bigint;
ds_carencia_sca_w		varchar(500);
ds_mensagem_w			varchar(255);
qt_mensagens_w			bigint;
dt_fim_cpt_w			varchar(15);
dt_fim_cpt_verso_w		varchar(15);

ds_cns_w			pessoa_fisica.nr_cartao_nac_sus%type;
ie_cpt_w			varchar(255);
ds_cpt_w			varchar(255);
dt_fim_carencia_w		timestamp;
nm_fantasia_w			varchar(255);
dt_inicio_vigencia_w		varchar(20);
ds_mensagem_carencia_w		varchar(255);
nr_seq_segurado_ant_w		pls_segurado.nr_seq_segurado_ant%type;
ie_abrangencia_ant_w		pls_plano.ie_abrangencia%type;
ie_abrangencia_atual_w		pls_plano.ie_abrangencia%type;
ds_abrangencia_ant_w		varchar(255);
cd_rede_refer_ptu_w		pls_plano.cd_rede_refer_ptu%type;
nr_seq_plano_ant_w		pls_segurado_alt_plano.nr_seq_plano_ant%type;
dt_alteracao_plano_w		pls_segurado_alt_plano.dt_alteracao%type;

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_segurado_carteira	a,
		pls_segurado		b,
		pls_carteira_emissao	c,
		pls_lote_carteira	d
	where	a.nr_seq_segurado	= b.nr_sequencia
	and	c.nr_seq_seg_carteira	= a.nr_sequencia
	and	c.nr_seq_lote		= d.nr_sequencia
	and	d.nr_sequencia		= nr_seq_lote_p;

c02 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_plano_area	a,
		pls_regiao	b
	where	a.nr_seq_regiao		= b.nr_sequencia
	and	a.nr_seq_plano		= nr_seq_plano_w
	order by a.nr_sequencia;

c03 CURSOR FOR
	SELECT	obter_initcap(b.ds_municipio)
	from	pls_regiao_local	a,
		sus_municipio		b
	where	a.cd_municipio_ibge	= b.cd_municipio_ibge
	and	a.nr_seq_regiao		= nr_seq_regiao_w
	order by b.ds_municipio;

C04 CURSOR FOR
	SELECT	b.ds_carencia,
		b.qt_dias
	from	pls_carencia_sca_v	b,
		pls_tipo_carencia	a
	where	a.nr_sequencia		= b.nr_seq_carencia
	and	a.ie_padrao_carteira	= 'S'
	and	b.nr_seq_segurado	= nr_seq_segurado_w
	and exists (	SELECT	1
			from	pls_sca_vinculo x
			where	x.nr_seq_segurado = nr_seq_segurado_w
			and	x.nr_seq_plano = b.nr_seq_plano
			and	((coalesce(x.dt_fim_vigencia::text, '') = '') or (x.dt_fim_vigencia > clock_timestamp())))
	order by a.nr_apresentacao;

C05 CURSOR FOR
	SELECT	ds_mensagem
	from (	SELECT	ds_mensagem,
				nr_seq_ordem
			from	pls_plano_mensagem_cart
			where	nr_seq_plano	= nr_seq_plano_w
			and	clock_timestamp()	between dt_inicio_vigencia and fim_dia(dt_fim_vigencia)
			and	ie_situacao	= 'A'
			
union all

			select	ds_mensagem,
				1 nr_seq_ordem
			from	pls_contrato_mensagem_cart
			where	nr_seq_contrato	= nr_seq_contrato_w
			and	clock_timestamp()	between dt_inicio_vigencia and fim_dia(dt_fim_vigencia)
			and	ie_situacao	= 'A') alias4
	order by nr_seq_ordem;


BEGIN

select	max(ie_carencia_abrangencia_ant)
into STRICT	ie_carencia_abrangencia_ant_w
from	pls_parametros;

ds_header_w	:= 	'COD_CLIENTE;DT_NASCIMENTO;TP_CONTRATACAO;DT_VAL_CARTEIRA;NM_USUARIO;LOCAL_COBRANCA;DS_PRODUTO;DS_ABRANGENCIA;DS_DESC_ABRANG;DS_REGISTRO_ANS;DS_ACOMODACAO;COD_EMPRESA;' ||
			'DT_FIM_CPT;NM_EMPRESA;REDE_ATEND;COBERTURA_1;DT_FIM_1;COBERTURA_2;DT_FIM_2;COBERTURA_3;DT_FIM_3;COBERTURA_4;DT_FIM_4;COBERTURA_5;DT_FIM_5;COBERTURA_6;DT_FIM_6;' ||
			'COBERTURA_7;DT_FIM_7;COBERTURA_8;DT_FIM_8;COBERTURA_9;DT_FIM_9;COBERTURA_10;DT_FIM_10;COBERTURA_11;DT_FIM_11;COBERTURA_12;DT_FIM_12;COBERTURA_13;DT_FIM_13;COBERTURA_14;' ||
			'DT_FIM_14;MSG_SELO_CARNE;OBS_1;OBS_2;TP_CONTRATO;TI_GERACAO;DR_REGISTRO;DS_REGIAO_1;DS_REGIAO_2;DS_REGIAO_3;TRILHA1;TRILHA2;TRILHA3;NR_CNS;SEM_CARENCIAS;DESC_CPT;' ||
			'DT_FIM_CPT_VERSO;DT_INI_VIGENCIA;DS_SEGMENTACAO_PRODUTO;MUDANCA_ABRANGENCIA';

ds_sub_header_w	:= 	'AAA;BBB;CCC;DDD;EEE;FFF;GGG;HHH;III;JJJ;KKK;LLL;MMM;NNN;RRR;COBERTURA_1;DATA_1;COBERTURA_2;DATA_2;COBERTURA_3;DATA_3;COBERTURA_4;DATA_4;COBERTURA_5;DATA_5;COBERTURA_6;' ||
			'DATA_6;COBERTURA_7;DATA_7;COBERTURA_8;DATA_8;COBERTURA_9;DATA_9;COBERTURA_10;DATA_10;COBERTURA_11;DATA_11;COBERTURA_12;DATA_12;COBERTURA_13;DATA_13;COBERTURA_14;' ||
			'DATA_14;TEXTO_SELO-CARNE;OBSERVACAO_1;OBSERVACAO_2;VD_CO_IP;TIPO_GERACAO;REGISTRO_ANS;REGIAO_1;REGIAO_2;REGIAO_3;TRILHA1_NOME;' ||
			'TRILHA2_COD_BENEF_fs_VIA_DATA_fs_LOCAL_PROD_ABRAG_RES;TRILHA3_TICARTAO_10z_TICLIENTE_SEXO_5z_NASC_BASE_49z_INCL_11z;NR_CNS;SEM_CARENCIAS;DESC_CPT;DT_FIM_CPT_VERSO;' ||
			'DT_INI_VIGENCIA;DS_SEGMENTACAO_PRODUTO;MUDANCA_ABRANGENCIA';

delete	FROM w_pls_interface_carteira
where	nr_seq_lote	= nr_seq_lote_p;

insert into w_pls_interface_carteira(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_lote,ds_header,ie_tipo_reg)
values (	nextval('w_pls_interface_carteira_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_lote_p,ds_header_w,1);

insert into w_pls_interface_carteira(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_lote,ds_header,ie_tipo_reg)
values (	nextval('w_pls_interface_carteira_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_lote_p,ds_sub_header_w,2);

open C01;
loop
fetch C01 into
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ie_abrangencia_ant_w	:= null;
	
	select	c.cd_usuario_plano,
		a.nm_pessoa_fisica,
		to_char(a.dt_nascimento,'dd/mm/yyyy'),
		substr(d.ds_carteira_acomodacao,1,50),
		substr(pls_obter_dados_cart_unimed(b.nr_sequencia,d.nr_sequencia,'DASJ',1),1,50),
		to_char(c.dt_validade_carteira,'dd/mm/yyyy'),
		to_char(c.dt_inicio_vigencia,'dd/mm/yyyy'),
		f.cd_cgc_estipulante,
		CASE WHEN d.ie_tipo_contratacao='I' THEN 'INDIVIDUAL OU FAMILIAR' WHEN d.ie_tipo_contratacao='CA' THEN ' ' || upper(wheb_mensagem_pck.get_texto(1108944)) WHEN d.ie_tipo_contratacao='CE' THEN ' COLETIVO EMPRESARIAL' END ,
		CASE WHEN d.ie_regulamentacao='R' THEN upper(wheb_mensagem_pck.get_texto(1108945)) WHEN d.ie_regulamentacao='A' THEN 'ADAPTADO'  ELSE 'REGULAMENTADO' END ,
		b.cd_operadora_empresa,
		CASE WHEN d.ie_abrangencia='E' THEN 'ES' WHEN d.ie_abrangencia='GE' THEN 'A' WHEN d.ie_abrangencia='GM' THEN 'RB' WHEN d.ie_abrangencia='M' THEN 'MU' WHEN d.ie_abrangencia='N' THEN 'NA' END ,
		upper(Obter_Valor_Dominio(1667,d.ie_abrangencia)),
		c.nr_via_solicitacao,
		d.nr_sequencia,
		CASE WHEN d.ie_preco='3' THEN 'CO'  ELSE 'VD' END ,
		CASE WHEN d.ie_regulamentacao='P' THEN  d.nr_protocolo_ans  ELSE d.cd_scpa END ,
		replace(replace(c.ds_trilha2,';',''),'?',''),
		c.ds_trilha3,
		f.cd_pf_estipulante,
		b.dt_contratacao,
		f.nr_sequencia,
		lpad(coalesce(a.nr_cartao_nac_sus,'0'),15,'0') ds_cns,
		d.nm_fantasia,
		nr_seq_segurado_ant,
		d.ie_abrangencia,
		coalesce(d.cd_rede_refer_ptu,';')
	into STRICT	cd_usuario_plano_w,
		nm_beneficiario_w,
		dt_nascimento_w,
		ds_produto_w,
		ds_acomodacao_w,
		dt_validade_carteira_w,
		dt_inicio_vigencia_w,
		cd_cgc_estipulante_w,
		tp_contratacao_w,
		ds_registro_ans_w,
		cod_empresa_w,
		cd_abrangencia_w,
		ds_abrangencia_w,
		nr_via_solicitacao_w,
		nr_seq_plano_w,
		tp_contrato_w,
		nr_protocolo_ans_w,
		ds_trilha_2_w,
		ds_trilha_3_w,
		cd_pf_estipulante_w,
		dt_contratacao_w,
		nr_seq_contrato_w,
		ds_cns_w,
		nm_fantasia_w,
		nr_seq_segurado_ant_w,
		ie_abrangencia_atual_w,
		cd_rede_refer_ptu_w
	from	pls_contrato		f,
		pls_plano		d,
		pls_segurado_carteira	c,
		pls_segurado		b,
		pessoa_fisica		a
	where	c.nr_seq_segurado	= b.nr_sequencia
	and	b.nr_seq_plano		= d.nr_sequencia
	and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
	and	b.nr_seq_contrato	= f.nr_sequencia
	and	b.nr_sequencia		= nr_seq_segurado_w;

	ds_trilha_2_w := substr(ds_trilha_2_w,1,length(ds_trilha_2_w) - 2) || substr(cd_rede_refer_ptu_w,3,4);

	cd_usuario_plano_w	:= substr(cd_usuario_plano_w,1,1)||' '||substr(cd_usuario_plano_w,2,3)||' '||substr(cd_usuario_plano_w,5,12)||' '||substr(cd_usuario_plano_w,17,1);

	nm_beneficiario_w	:= substr(pls_abrevia_nome_unimed_blu(nm_beneficiario_w),1,25);

	nm_beneficiario_w	:= upper(nm_beneficiario_w);
	if (length(nm_beneficiario_w) < 25) then
		nm_beneficiario_w	:= rpad(nm_beneficiario_w,25,' ');
	end if;

	ds_trilha_1_w	:= nm_beneficiario_w;

	if (coalesce(cd_pf_estipulante_w::text, '') = '') then
		nm_empresa_w	:= substr(coalesce(obter_dados_pf_pj('',cd_cgc_estipulante_w,'ABV'),obter_dados_pf_pj('',cd_cgc_estipulante_w,'F')),1,18);
	else
		nm_empresa_w	:= 'Individual/Familiar';
	end if;

	ds_carencia_w	:= '';

	qt_mensagens_w	:= 0;

	open C05;
	loop
	fetch C05 into
		ds_mensagem_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		qt_mensagens_w	:= qt_mensagens_w + 1;

		ds_carencia_w	:= ds_carencia_w ||ds_mensagem_w||';------------;';
		end;
	end loop;
	close C05;

	for i in 1..12-qt_mensagens_w loop
		begin
		ds_carencia_ww	:= nvl(substr(pls_obter_dados_cart_unimed(nr_seq_segurado_w, nr_seq_plano_w,'CAUB',i),1,255),';');

		if	(i < 12) then
			ds_carencia_w	:= ds_carencia_w ||ds_carencia_ww||';';
		else
			ds_carencia_w	:= ds_carencia_w ||ds_carencia_ww;
		end if;
		end;
	end loop;
	ds_carencia_sca_w	:= '';

	if	(qt_mensagens_w > 0) then
		ds_carencia_w		:= substr(ds_carencia_w,1,length(ds_carencia_w)-1);
	end if;

	ie_cpt_w := ' ';

	open C04;
	loop
	fetch C04 into
		nm_plano_sca_w,
		qt_carencia_sca_w;
	exit when C04%notfound;
		begin
		dt_carencia_sca_w	:= to_char(to_date(dt_contratacao_w+qt_carencia_sca_w),'dd/mm/yyyy');

		if	(dt_carencia_sca_w	<= sysdate) then
			dt_carencia_sca_w	:= 'IMEDIATO';
			ie_cpt_w := upper(wheb_mensagem_pck.get_texto(1108951));
		end if;

		ds_carencia_sca_w	:= ds_carencia_sca_w||';'||nm_plano_sca_w ||';'||dt_carencia_sca_w;
		end;
	end loop;
	close C04;

	if	(pls_obter_qt_caracter_linha(ds_carencia_sca_w,';') < 4) then
		if	(pls_obter_qt_caracter_linha(ds_carencia_sca_w,';') = 0) then
			ds_carencia_sca_w	:= ds_carencia_sca_w||';;;;';
		elsif	(pls_obter_qt_caracter_linha(ds_carencia_sca_w,';') = 2) then
			ds_carencia_sca_w	:= ds_carencia_sca_w||';;';
		end if;
	end if;

	ds_regiao_1_w	:= '';
	ds_regiao_2_w	:= '';
	ds_regiao_3_w	:= '';
	ds_regiao_w	:= '';

	if	(cd_abrangencia_w in ('RB','MU')) then
		ds_regiao_1_w	:= wheb_mensagem_pck.get_texto(1108952)||' ';
		ds_regiao_2_w	:= '';
		ds_regiao_3_w	:= '';

		open C02;
		loop
		fetch C02 into
			nr_seq_regiao_w;
		exit when C02%notfound;
			begin
			open C03;
			loop
			fetch C03 into
				ds_municipio_w;
			exit when C03%notfound;
				begin
				if	(length(ds_regiao_1_w||ds_municipio_w) <= 66) then
					ds_regiao_1_w := ds_regiao_1_w||ds_municipio_w||', ';
				elsif	(length(ds_regiao_2_w||ds_municipio_w) <= 66) then
					ds_regiao_2_w := ds_regiao_2_w||ds_municipio_w||', ';
				elsif	(length(ds_regiao_3_w||ds_municipio_w) <= 66) then
					ds_regiao_3_w := ds_regiao_3_w||ds_municipio_w||', ';
				end if;
				end;
			end loop;
			close C03;
			end;
		end loop;
		close C02;
	end if;

	ds_regiao_w	:= substr(ds_regiao_1_w,1,length(ds_regiao_1_w)-1)||';'||substr(ds_regiao_2_w,1,length(ds_regiao_2_w)-1)||';'||substr(ds_regiao_3_w,1,length(ds_regiao_3_w)-1);

	begin
	select	to_char(max(nvl(a.dt_inicio_vigencia, c.dt_inclusao_operadora)) + max(a.qt_dias),'dd/mm/yyyy')
	into	dt_fim_cpt_w
	from	pls_carencia		a,
		pls_tipo_carencia	b,
		pls_segurado		c
	where	a.nr_seq_tipo_carencia	= b.nr_sequencia
	and	a.nr_seq_segurado	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_segurado_w
	and	b.ie_cpt = 'S'
	and	a.qt_dias > 0;
	exception
	when others then
		dt_fim_cpt_w := null;
	end;

	if	((dt_fim_cpt_w is null) or dt_fim_cpt_w < sysdate )then
		ds_mensagem_cpt_w := upper(wheb_mensagem_pck.get_texto(1108953));
		ds_cpt_w := ' ';
		dt_fim_cpt_verso_w := ' ';
	else
		ds_mensagem_cpt_w := dt_fim_cpt_w;
		ds_cpt_w := upper(wheb_mensagem_pck.get_texto(1108954));
		dt_fim_cpt_verso_w := dt_fim_cpt_w;
	end if;

	select	count(1)
	into	qt_carencias_w
	from	pls_carencia
	where	nr_seq_segurado	= nr_seq_segurado_w;

	ie_tela_carencia_w := 0;

	begin
	select  b.nr_seq_plano_ant,
		b.dt_alteracao
	into	nr_seq_plano_ant_w,
		dt_alteracao_plano_w
	from    pls_segurado a,
		pls_segurado_alt_plano  b
	where   a.nr_sequencia = b.nr_seq_segurado
	and 	a.nr_seq_plano = b.nr_seq_plano_atual  
	and  	a.nr_sequencia  = nr_seq_segurado_w
	and	b.ie_situacao = 'A'
	and 	rownum = 1
	order by b.dt_alteracao desc;
	exception
	when others then
		nr_seq_plano_ant_w := null;
	end;

	if	(qt_carencias_w > 0) then
		ie_tela_carencia_w := 1; -- 1 = aba Carencia / 2 = aba Carencias abrangencia nova
		if 	(ie_carencia_abrangencia_ant_w = 'S') then
			if	(nr_seq_plano_ant_w is not null) then 
				select	a.ie_abrangencia
				into	ie_abrangencia_ant_w
				from	pls_plano	a
				where	a.nr_sequencia = nr_seq_plano_ant_w;
			elsif	(nr_seq_segurado_ant_w is not null) then
				select	a.ie_abrangencia
				into	ie_abrangencia_ant_w
				from	pls_segurado	b,
					pls_plano	a
				where	b.nr_seq_plano	= a.nr_sequencia
				and	b.nr_sequencia	= nr_seq_segurado_ant_w;
			end if;
			
			if	(ie_abrangencia_ant_w is not null) then
				if	((ie_abrangencia_ant_w = 'E') and
						(ie_abrangencia_atual_w = 'N') or
					((ie_abrangencia_ant_w = 'GM') and
						(ie_abrangencia_atual_w = 'E') or
					((ie_abrangencia_ant_w = 'GM') and
						(ie_abrangencia_atual_w = 'N') or
					((ie_abrangencia_ant_w = 'M') and
						(ie_abrangencia_atual_w = 'E') or
					((ie_abrangencia_ant_w = 'M') and
						(ie_abrangencia_atual_w = 'N')))))) then

					select	count(1)
					into	qt_cpt_nao_w
					from	pls_carencia
					where	nr_seq_segurado	= nr_seq_segurado_w
					and	ie_cpt = 'N';

					if	(qt_cpt_nao_w > 0) then
						ie_tela_carencia_w := 2; -- 1 = aba Carencia / 2 = aba Carencias abrangencia nova
					end if;
				end if;
			end if;	
		end if;
	end if;

	if	(ie_tela_carencia_w <> 0) then -- 1 = aba Carencia / 2 = aba Carencias abrangencia nova
		if	(ie_tela_carencia_w = '1') then -- 1 = aba Carencia
			select	count(1)
			into	qt_carencias_nao_cumpridas_w
			from	pls_carencia		a,
				pls_tipo_carencia	b
			where	a.nr_seq_tipo_carencia 	= b.nr_sequencia
			and	a.nr_seq_segurado 	= nr_seq_segurado_w
			and	b.ie_padrao_carteira 	= 'S'
			--and	dt_inicio_vigencia 	<= sysdate 
			and	a.dt_fim_vigencia 	>= sysdate
			and	a.qt_dias > 0
			and	b.ie_utilizacao <> 'S';
		elsif	(ie_tela_carencia_w = '2') then -- 2 = aba Carencias abrangencia nova
			if	(nr_seq_plano_ant_w is not null ) then 
				dt_contratacao_w := dt_alteracao_plano_w;
			end if;
			
			select	count(1)
			into	qt_carencias_nao_cumpridas_w
			from	pls_carencia		a,
				pls_tipo_carencia	b
			where	a.nr_seq_tipo_carencia 	= b.nr_sequencia
			and	a.nr_seq_segurado 	= nr_seq_segurado_w
			and	a.ie_cpt 		= 'N'
			and	b.ie_padrao_carteira	= 'S'
			and	(dt_contratacao_w + nvl(a.qt_dias_fora_abrang_ant,a.qt_dias)) >= sysdate
			and	nvl(a.qt_dias_fora_abrang_ant,a.qt_dias) > 0
			and	nvl(b.ie_utilizacao,'X') <> 'S';
		end if;
	else
		qt_carencias_nao_cumpridas_w := 0;
	end if;

	if	(qt_carencias_nao_cumpridas_w = 0) then
		ie_cpt_w 	:= upper(wheb_mensagem_pck.get_texto(1108951));
		ds_carencia_w	:=  ';;;;;;;;;;;;;;;;;;;;;;;'||upper(ds_carencia_sca_w);
	else
		ie_cpt_w 	:= ' ';
		ds_carencia_w	:= upper(ds_carencia_w) ||upper(ds_carencia_sca_w);
	end if;

	ds_mensagem_carencia_w := null;

	if 	(nr_seq_plano_ant_w is not null) then 
		select	a.ie_abrangencia
		into	ie_abrangencia_ant_w
		from	pls_plano	a
		where	a.nr_sequencia = nr_seq_plano_ant_w;
	elsif	(nr_seq_segurado_ant_w is not null) then
		select	a.ie_abrangencia
		into	ie_abrangencia_ant_w
		from	pls_segurado	b,
			pls_plano	a
		where	b.nr_seq_plano	= a.nr_sequencia
		and	b.nr_sequencia	= nr_seq_segurado_ant_w;
	end if;

	if	(ie_abrangencia_ant_w is not null) then
		if	((ie_abrangencia_ant_w = 'E') and
				(ie_abrangencia_atual_w = 'N') or
			((ie_abrangencia_ant_w = 'GM') and
				(ie_abrangencia_atual_w = 'E') or
			((ie_abrangencia_ant_w = 'GM') and
				(ie_abrangencia_atual_w = 'N') or
			((ie_abrangencia_ant_w = 'M') and
				(ie_abrangencia_atual_w = 'E') or
			((ie_abrangencia_ant_w = 'M') and
				(ie_abrangencia_atual_w = 'N')))))) then

			if	(ie_abrangencia_ant_w = 'GM') then
				ds_abrangencia_ant_w	:= wheb_mensagem_pck.get_texto(1108792);
			elsif	(ie_abrangencia_ant_w = 'M') then
				ds_abrangencia_ant_w	:= wheb_mensagem_pck.get_texto(1108793);
			elsif	(ie_abrangencia_ant_w = 'E') then
				ds_abrangencia_ant_w	:= wheb_mensagem_pck.get_texto(1108794);
			elsif	(ie_abrangencia_ant_w = 'N') then
				ds_abrangencia_ant_w	:= wheb_mensagem_pck.get_texto(1108795);
			end if;

			begin
			select	to_char(max(nvl(a.dt_inicio_vigencia, c.dt_inclusao_operadora)) + max(a.qt_dias),'dd/mm/yyyy')
			into	dt_fim_carencia_w
			from	pls_carencia		a,
				pls_tipo_carencia	b,
				pls_segurado		c
			where	a.nr_seq_tipo_carencia	= b.nr_sequencia
			and	a.nr_seq_segurado	= c.nr_sequencia
			and	c.nr_sequencia		= nr_seq_segurado_w
			and	b.ie_cpt = 'N'
			and	a.qt_dias > 0
			and	b.ie_utilizacao <> 'S';
			exception
			when others then
				dt_fim_carencia_w := null;
			end;
			
			if	((dt_fim_carencia_w is null) or dt_fim_carencia_w < sysdate) then
				ds_mensagem_carencia_w := wheb_mensagem_pck.get_texto(1108956, 'DS_ABRANGENCIA_ANT='||ds_abrangencia_ant_w);
			else
				ds_mensagem_carencia_w := wheb_mensagem_pck.get_texto(1108958, 'DS_ABRANGENCIA_ANT='||ds_abrangencia_ant_w||';DT_FIM_CARENCIA='||dt_fim_carencia_w);
			end if;
		end if;
	end if;

	if	(cd_abrangencia_w in ('ES','A')) then
		ds_observacao_1_w	:= 'Atendimento restrito ao Estado de Santa Catarina.';
	elsif	(cd_abrangencia_w = 'NA') then
		ds_observacao_1_w	:= 'Atend. Nacional, exceto hospitais nao credenciados e ou alto custo.';
	else
		ds_observacao_1_w	:= chr(39);
	end if;

	ds_observacao_2_w	:= '';
	if	(cd_abrangencia_w <> 'NA') then
		if	(nr_seq_plano_w in (2308, 2306, 2309, 2310)) then
			ds_observacao_2_w := wheb_mensagem_pck.get_texto(1108971);
		elsif	not((nr_seq_plano_w >= 2230) and (nr_seq_plano_w <= 2245)) then
			ds_observacao_2_w := wheb_mensagem_pck.get_texto(1108972);
		end if;
	end if;

	cd_local_cobranca_w	:= '0026';

	insert into w_pls_interface_carteira(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			nr_seq_lote,ie_tipo_reg,cd_usuario_plano,dt_nascimento,ds_tipo_contratacao,
			dt_validade_carteira,nm_beneficiario,cd_local_cobranca,nm_plano,cd_abrangencia,
			ds_abrangencia,ds_registro_ans,ds_acomodacao,cd_operadora_empresa,dt_cpt,
			ds_estipulante,ds_rede_atendimento,ds_carencia,ds_observacao,ds_observacao_2,
			tp_contrato,nr_protocolo_ans,ds_trilha_1,ds_trilha_2,ds_trilha_3,nr_seq_segurado,
			nr_via_cartao,ds_regiao, ds_cns, ds_carencia_9, ds_carencia_8, ds_carencia_5,
			dt_adesao, ds_segmentacao, ds_mensagem_carencia)
	values (	nextval('w_pls_interface_carteira_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			nr_seq_lote_p,3,cd_usuario_plano_w,dt_nascimento_w,tp_contratacao_w,
			dt_validade_carteira_w,nm_beneficiario_w,cd_local_cobranca_w,ds_produto_w,cd_abrangencia_w,
			ds_abrangencia_w,ds_registro_ans_w,ds_acomodacao_w,cod_empresa_w,ds_mensagem_cpt_w,
			nm_empresa_w,cd_rede_refer_ptu_w,ds_carencia_w,ds_observacao_1_w,ds_observacao_2_w,
			tp_contrato_w,nr_protocolo_ans_w,ds_trilha_1_w,ds_trilha_2_w,ds_trilha_3_w,nr_seq_segurado_w,
			nr_via_solicitacao_w,ds_regiao_w, ds_cns_w, ie_cpt_w, ds_cpt_w,dt_fim_cpt_verso_w,
			dt_contratacao_w, nm_fantasia_w, ds_mensagem_carencia_w);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_cartao_unimed_blu ( nr_seq_lote_p bigint, cd_interface_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
