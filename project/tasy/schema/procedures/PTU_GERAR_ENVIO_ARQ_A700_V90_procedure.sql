-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_envio_arq_a700_v90 ( nr_seq_servico_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE

 
-- Arquivo 
ds_conteudo_w			varchar(4000);
ds_arquivo_w			text;
ds_hash_w			ptu_servico_pre_pagto.ds_hash%type;

ds_meridiano_w			varchar(3);
cd_cooperativa_w		varchar(4);
cd_cgc_w			varchar(14);
sg_estado_w			pessoa_juridica.sg_estado%type;
nr_seq_registro_w		bigint := 0;
qt_registro_w			bigint := 0;
nr_seq_nota_cobranca_w		bigint;
nr_seq_nota_cobranca_ww		bigint;
nr_seq_nota_servico_w		bigint;
qt_tot_r702_w			integer := 0;
qt_tot_r703_w			integer := 0;
qt_tot_r704_w			integer := 0;
qt_tot_r704_ww			bigint := 0;
qt_tot_r705_w			integer := 0;
					
-- 701 
cd_unimed_destino_w		varchar(4);
cd_unimed_origem_w		varchar(4);
dt_geracao_w			varchar(8);
nr_seq_geracao_w		varchar(4);
dt_inicio_pagto_w		varchar(8);
dt_fim_pagto_w			varchar(8);
nr_versao_transacao_w		varchar(2);
cd_operadora_origem_w		pls_congenere.cd_cooperativa%type;

-- 702 
nm_beneficiario_w		varchar(25);
dt_atendimento_w		varchar(21);
cd_usuario_plano_w		varchar(13);
nr_nota_w			ptu_nota_cobranca.nr_nota%type;
nr_guia_principal_w		ptu_nota_cobranca.nr_guia_principal%type;
nr_lote_w			varchar(8);
cd_cid_w			varchar(6);
cd_unimed_w			varchar(4);
ie_tipo_atendimento_w		varchar(2);
cd_excecao_w			varchar(1);
ie_carater_atendimento_w	varchar(1);
ie_paciente_w			varchar(1);
ie_tipo_saida_spdat_w		varchar(1);
dt_internacao_702_w		varchar(21);
dt_alta_702_w			varchar(21);
dt_ultima_autoriz_w		varchar(8);
tp_nota_w			varchar(1);
id_nota_principal_w		varchar(1);
nr_ver_tiss_w			varchar(7);
nr_guia_tiss_prestador_w	varchar(20);
nr_guia_tiss_principal_w	varchar(20);
nr_guia_tiss_operadora_w	varchar(20);
tp_ind_acidente_w		varchar(1);
motivo_encerram_w		varchar(2);
nr_cnpj_cpf_req_w		varchar(14);
nm_prest_req_w			varchar(70);
sg_cons_prof_req_702_w		varchar(12);
nr_cons_prof_req_702_w		varchar(15);
sg_uf_cons_req_702_w		varchar(2);
nr_cbo_req_w			varchar(6);
nr_fatura_glosada_w		varchar(11);
nr_ndr_glosada_w		varchar(11);
nr_lote_glosado_w		varchar(8);
nr_nota_glosada_w		varchar(11);
dt_protocolo_w			varchar(8);
id_rn_w				varchar(1);
dt_atendimento_ww		timestamp;
tp_consulta_w			varchar(1);
tp_pessoa_w			varchar(1);
nr_cnpj_cpf_w			varchar(14);
cd_cnes_cont_exec_w		varchar(7);
cd_munic_cont_exec_w		varchar(7);

-- 703 
nm_hospital_w			varchar(70);
dt_internacao_w			varchar(21);
dt_alta_w			varchar(21);
nr_declara_obito_w		varchar(17);
nr_declara_obito_0_w		varchar(17);
nr_declara_obito_1_w		varchar(17);
nr_declara_obito_2_w		varchar(17);
nr_declara_obito_3_w		varchar(17);
nr_declara_obito_4_w		varchar(17);
nr_declara_obito_5_w		varchar(17);
nr_declara_vivo_0_w		varchar(15);
nr_declara_vivo_1_w		varchar(15);
nr_declara_vivo_2_w		varchar(15);
nr_declara_vivo_3_w		varchar(15);
nr_declara_vivo_4_w		varchar(15);
nr_declara_vivo_5_w		varchar(15);
cd_cgc_hospital_w		varchar(14);
nr_nota_703_w			ptu_nota_hospitalar.nr_nota%type;
nr_lote_703_w			varchar(8);
cd_hospital_w			varchar(8);
cd_cid_obito_w			varchar(6);
cd_cid_obito_0_w		varchar(6);
cd_cid_obito_1_w		varchar(6);
cd_cid_obito_2_w		varchar(6);
cd_cid_obito_3_w		varchar(6);
cd_cid_obito_4_w		varchar(6);
cd_cid_obito_5_w		varchar(6);
cd_unimed_hospital_w		varchar(4);
tx_mult_amb_w			varchar(4);
ie_tipo_acomodacao_w		varchar(2);
cd_motivo_saida_w		varchar(2);
qt_nasc_vivos_w			varchar(2);
qt_nasc_mortos_w		varchar(2);
qt_nasc_vivos_pre_w		varchar(2);
qt_obito_precoce_w		varchar(2);
qt_obito_tardio_w		varchar(2);
ie_ind_acidente_w		varchar(1);
ie_tipo_internacao_w		varchar(1);
ie_int_gestacao_w		varchar(1);
ie_int_aborto_w			varchar(1);
ie_int_transtorno_w		varchar(1);
ie_int_puerperio_w		varchar(1);
ie_int_recem_nascido_w		varchar(1);
ie_int_neonatal_w		varchar(1);
ie_int_baixo_peso_w		varchar(1);
ie_int_parto_cesarea_w		varchar(1);
ie_int_parto_normal_w		varchar(1);
ie_faturamento_w		varchar(1);
ie_obito_mulher_w		varchar(1);
reg_internacao_w		varchar(1);

-- 704 
ds_servico_w			varchar(80);
nm_prestador_w			varchar(70);
nm_profissional_prestador_w	varchar(70);
nm_prestador_requisitante_w	varchar(40);
nr_gui_tiss_w			varchar(20);
nr_cons_prof_prest_w		varchar(15);
nr_cons_prof_req_w		varchar(15);
vl_procedimento_w		varchar(14);
vl_custo_operacional_w		varchar(14);
vl_filme_w			varchar(14);
vl_adic_procedimento_w		varchar(14);
vl_adic_co_w			varchar(14);
vl_adic_filme_w			varchar(14);
nr_cgc_cpf_w			varchar(14);
nr_cgc_cpf_req_w		varchar(14);
vl_pago_prest_w			varchar(14);
sg_cons_prof_prest_w		varchar(12);
sg_cons_prof_req_w		varchar(12);
nr_nota_704_w			ptu_nota_servico.nr_nota%type;
nr_seq_nota_w			varchar(11);
nr_autorizacao_w		varchar(10);
nr_lote_704_w			varchar(8);
cd_prestador_w			varchar(8);
dt_procedimento_w		varchar(8);
cd_procedimento_w		varchar(8);
qt_procedimento_w		varchar(8);
cd_prestador_req_w		varchar(8);
ds_hora_procedimento_w		varchar(8);
cd_pacote_w			varchar(8);
cd_cnes_prest_w			varchar(7);
cd_unimed_prestador_w		varchar(4);
cd_unimed_autorizadora_w	varchar(4);
cd_unimed_pre_req_w		varchar(4);
tx_procedimento_w		varchar(3);
ie_via_acesso_w			varchar(2);
cd_especialidade_w		varchar(2);
ie_tipo_prestador_w		varchar(2);
sg_uf_cons_prest_w		varchar(2);
sg_uf_cons_req_w		varchar(2);
ie_tipo_participacao_w		varchar(1);
ie_tipo_tabela_w		varchar(1);
cd_porte_anestesico_w		varchar(1);
ie_rede_propria_w		varchar(1);
ie_tipo_pessoa_prestador_w	varchar(1);
ie_pacote_w			varchar(1);
cd_ato_w			varchar(1);
ie_reembolso_w			varchar(1);
tp_autoriz_w			varchar(1);
ie_prestador_alto_custo_w	varchar(1) := ' ';
cd_especialidade_ptu_w		smallint;
hr_final_w			varchar(8);
id_acres_urg_emer_w		varchar(1);
nr_cbo_exec_w			varchar(6);
tec_utilizada_w			varchar(1);
dt_autoriz_w			varchar(8);
dt_solicitacao_w		varchar(8);
unidade_medida_w		varchar(3);
nr_reg_anvisa_w			varchar(15);
cd_munic_w			varchar(7);
cd_ref_material_fab_w		varchar(60);
dt_pgto_prestador_w		varchar(8);
nr_cnpj_fornecedor_w		varchar(14);
qt_nota_servico_w		integer;
cd_rec_prestador_w		varchar(10);

-- 705 
ds_complemento_w		varchar(100);
nr_nota_705_w			ptu_nota_complemento.nr_nota%type;
nr_lote_705_w			varchar(8);
ie_tipo_complemento_w		varchar(1);
especif_material_w		varchar(500);

-- 709 
vl_tot_serv_w			varchar(14);
vl_tot_co_w			varchar(14);
vl_tot_filme_w			varchar(14);

C00 CURSOR FOR 
	SELECT	lpad(coalesce(cd_unimed_destino,'0'),4,'0'), 
		lpad(coalesce(coalesce(cd_unimed_origem,cd_operadora_origem_w),'0'),4,'0'), 
		to_char(dt_geracao,'yyyymmdd'), 
		lpad(coalesce(nr_seq_geracao,'0'),4,'0'), 
		to_char(dt_inicio_pagto,'yyyymmdd'), 
		to_char(dt_fim_pagto,'yyyymmdd'), 
		'20' 
	from	ptu_servico_pre_pagto 
	where	nr_sequencia	= nr_seq_servico_p;
	
C01 CURSOR FOR 
	SELECT	lpad(coalesce(elimina_caractere_especial(to_char(nr_lote)),'0'),8,'0'), 
		lpad(coalesce(substr(elimina_caractere_especial(to_char(coalesce(pls_obter_dados_conta(nr_nota,'G'),pls_obter_dados_conta(nr_nota,'GR')))),1,20),'0'),20,'0'), 
		lpad(coalesce(cd_unimed,'0'),4,'0'), 
		lpad(coalesce(cd_usuario_plano,'0'),13,'0'), 
		rpad(coalesce(elimina_acentuacao(nm_beneficiario),' '),25,' '), 
		rpad(coalesce(to_char(dt_atendimento,'yyyy/mm/ddhh:mi:ss') || ds_meridiano_w,' '),21,' '), 
		rpad(coalesce(to_char(cd_excecao),' '),1,' '), 
		rpad(coalesce(to_char(ie_carater_atendimento),' '),1,' '), 
		rpad(coalesce(to_char(cd_cid),' '),6,' '), 
		rpad(coalesce(ie_paciente,' '),1,' '), 
		rpad(coalesce(ie_tipo_saida_spdat,' '),1,' '), 
		lpad(coalesce(ie_tipo_atendimento,' '),2,'0'), 
		rpad(CASE WHEN id_nota_principal='S' THEN ' '  ELSE coalesce(nr_guia_principal,' ') END ,20,' '), 
		nr_sequencia, 
		CASE WHEN coalesce(dt_internacao::text, '') = '' THEN lpad(' ',21,' ')  ELSE rpad(coalesce(to_char(dt_internacao,'yyyy/mm/ddhh:mi:ss') || CASE WHEN coalesce(dt_internacao::text, '') = '' THEN ' '  ELSE ds_meridiano_w END ,' '),21,' ') END , 
		CASE WHEN coalesce(dt_alta::text, '') = '' THEN lpad(' ',21,' ')  ELSE rpad(coalesce(to_char(dt_alta,'yyyy/mm/ddhh:mi:ss') || CASE WHEN coalesce(dt_alta::text, '') = '' THEN ' '  ELSE ds_meridiano_w END ,' '),21,' ') END , 
		rpad(coalesce(to_char(dt_ultima_autoriz,'yyyymmdd'),' '),8,' '), 
		coalesce(tp_nota,'0'), 
		rpad(coalesce(id_nota_principal,'N'),1,' '), 
		rpad(coalesce(nr_ver_tiss,' '),7,' '), 
		rpad(coalesce(nr_guia_tiss_prestador,' '),20,' '), 
		rpad(coalesce(nr_guia_tiss_principal,' '),20,' '), 
		rpad(coalesce(nr_guia_tiss_operadora,' '),20,' '), 
		rpad(coalesce(tp_ind_acidente,'9'),1,'9'), 
		rpad(coalesce(motivo_encerram,' '),2,' '), 
		lpad(coalesce(nr_cnpj_cpf_req,'0'),14,'0'), 
		rpad(coalesce(ptu_somente_caracter_permitido(nm_prest_req,'ANS'),' '),70,' '), 
		rpad(coalesce(sg_cons_prof_req,' '),12,' '), 
		rpad(coalesce(nr_cons_prof_req,' '),15,' '), 
		rpad(coalesce(sg_uf_cons_req,' '),2,' '), 
		lpad(coalesce(nr_cbo_req,'0'),6,'0'), 
		lpad(coalesce(nr_fatura_glosada,'0'),11,'0'), 
		lpad(coalesce(nr_ndr_glosada,'0'),11,'0'), 
		lpad(coalesce(nr_lote_glosado,'0'),8,'0'), 
		rpad(coalesce(nr_nota_glosada,' '),11,' '), 
		rpad(coalesce(to_char(dt_protocolo,'yyyymmdd'),' '),8,' '), 
		rpad(coalesce(id_rn,'N'),1,' '), 
		rpad(coalesce(to_char(tp_consulta),' '),1,' '), 
		coalesce(tp_pessoa,' '), 
		lpad(coalesce(nr_cnpj_cpf,'0'),14,'0'), 
		rpad(coalesce(cd_cnes_cont_exec,'9999999'),7,'9'), 
		rpad(coalesce(cd_munic_cont_exec || substr(calcula_digito('MODULO10', cd_munic_cont_exec),1,1),'0'),7,'0') 
	from	ptu_nota_cobranca 
	where	nr_seq_serv_pre_pagto	= nr_seq_servico_p;
	
C02 CURSOR FOR 
	SELECT	lpad(elimina_caractere_especial(a.nr_lote),8,'0') nr_lote_703, 
		lpad(coalesce(substr(elimina_caractere_especial(to_char(pls_obter_dados_conta(a.nr_nota,'G'))),1,20),'0'),20,'0') nr_nota_703, 
		lpad(coalesce(a.cd_unimed_hospital,'0'),4,'0'), 
		lpad(coalesce(a.cd_hospital,'0'),8,'0'), 
		rpad(coalesce(ptu_somente_caracter_permitido(a.nm_hospital,'ANS'),' '),70,' '),		 
		rpad(coalesce(a.ie_tipo_acomodacao,' '),2,' '), 
		rpad(coalesce(to_char(a.dt_internacao,'yyyy/mm/ddhh:mi:ss') || CASE WHEN coalesce(a.dt_internacao::text, '') = '' THEN ' '  ELSE ds_meridiano_w END ,' '),21,' '), 
		rpad(coalesce(to_char(a.dt_alta,'yyyy/mm/ddhh:mi:ss') || CASE WHEN coalesce(a.dt_alta::text, '') = '' THEN ' '  ELSE ds_meridiano_w END ,' '),21,' '), 
		lpad(replace(replace(campo_mascara(a.tx_mult_amb,2),',',''),'.',''),4,'0'), 
		lpad(a.ie_ind_acidente,1,' '), 
		rpad(a.cd_motivo_saida,2,' '), 
		lpad(coalesce(a.cd_cgc_hospital,' '),14,' '), 
		coalesce(a.ie_tipo_internacao,'0'), 
		lpad(coalesce(a.qt_nasc_vivos,'0'),2,'0'), 
		lpad(coalesce(a.qt_nasc_mortos,'0'),2,'0'), 
		lpad(coalesce(a.qt_nasc_vivos_pre,'0'),2,'0'), 
		lpad(coalesce(a.qt_obito_precoce,'0'),1,'0'), 
		lpad(coalesce(a.qt_obito_tardio,'0'),1,'0'), 
		lpad(coalesce(a.ie_int_gestacao,'N'),1,' '), 
		lpad(coalesce(a.ie_int_aborto,'N'),1,' '), 
		lpad(coalesce(a.ie_int_transtorno,'N'),1,' '), 
		lpad(coalesce(a.ie_int_puerperio,'N'),1,' '), 
		lpad(coalesce(a.ie_int_recem_nascido,'N'),1,' '), 
		lpad(coalesce(a.ie_int_neonatal,'N'),1,' '), 
		lpad(coalesce(a.ie_int_baixo_peso,'N'),1,' '), 
		lpad(coalesce(a.ie_int_parto_cesarea,'N'),1,' '), 
		lpad(coalesce(a.ie_int_parto_normal,'N'),1,' '), 
		to_char(coalesce(a.ie_faturamento,'1')), 
		coalesce(to_char(a.ie_obito_mulher),'0'), 
		rpad(coalesce(a.nr_declara_obito,' '),17,' '), 
		coalesce(a.reg_internacao,'0') 
	from	ptu_nota_hospitalar	a, 
		ptu_nota_cobranca	c 
	where	a.nr_seq_nota_cobr	= c.nr_sequencia 
	and	c.nr_sequencia		= nr_seq_nota_cobranca_w 
	and	c.tp_nota 		= 3;
	
C03 CURSOR FOR 
	SELECT	lpad(coalesce(elimina_caractere_especial(a.nr_lote),'0'),8,'0'), 
		CASE WHEN 	lpad(coalesce(substr(elimina_caractere_especial(to_char(pls_obter_dados_conta(a.nr_nota,'G'))),length(to_char(pls_obter_dados_conta(a.nr_nota,'G'))) - 10,length(to_char(pls_obter_dados_conta(a.nr_nota,'G')))),'0'),11,'0')='00000000000' THEN  			lpad(coalesce(substr(elimina_caractere_especial(to_char(pls_obter_dados_conta(a.nr_nota,'G'))),1,11),'0'),11,'0')  ELSE lpad(coalesce(substr(elimina_caractere_especial(to_char(pls_obter_dados_conta(a.nr_nota,'G'))),length(to_char(pls_obter_dados_conta(a.nr_nota,'G'))) - 10,length(to_char(pls_obter_dados_conta(a.nr_nota,'G')))),'0'),11,'0') END , 
		lpad(coalesce(a.cd_unimed_prestador,'0'),4,'0'), 
		lpad(coalesce(a.cd_prestador,'0'),8,'0'), 
		rpad(coalesce(elimina_caractere_especial(elimina_acentuacao(a.nm_prestador)),' '),70,' '), 
		rpad(coalesce(a.ie_tipo_participacao,'0'),1,'0'), 
		rpad(coalesce(to_char(a.dt_procedimento,'yyyymmdd'),' '),8,' '), 
		rpad(coalesce(to_char(a.ie_tipo_tabela),' '),1,' '), 
		lpad(coalesce(a.cd_servico,'0'),8,'0'), 
		coalesce(a.qt_procedimento,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(a.vl_procedimento,2),',',''),'.',''),'0'),14,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(a.vl_custo_operacional,2),',',''),'.',''),'0'),14,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(a.vl_filme,2),',',''),'.',''),'0'),14,'0'), 
		rpad(coalesce(to_char(a.cd_porte_anestesico),' '),1,' '), 
		lpad(coalesce(a.cd_unimed_autorizadora,'0'),4,'0'), 
		lpad(coalesce(a.cd_unimed_pre_req,'0'),4,'0'), 
		lpad(coalesce(a.cd_prestador_req,'0'),8,'0'), 
		lpad(coalesce(a.ie_via_acesso,'0'),2,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(a.vl_adic_procedimento,2),',',''),'.',''),'0'),14,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(a.vl_adic_co,2),',',''),'.',''),'0'),14,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(a.vl_adic_filme,2),',',''),'.',''),'0'),14,'0'), 
		lpad(coalesce(a.cd_especialidade,'0'),2,'0'), 
		lpad(coalesce(a.ie_tipo_prestador,'0'),2,'0'), 
		rpad(coalesce(to_char(a.ie_rede_propria),' '),1,' '), 
		rpad(coalesce(to_char(a.ie_tipo_pessoa_prestador),' '),1,' '), 
		lpad(coalesce(a.nr_cgc_cpf,'0'),14,'0'), 
		rpad(coalesce(to_char(a.ie_pacote),' '),1,' '), 
		rpad(coalesce(to_char(a.cd_ato),' '),1,' '), 
		lpad(coalesce(a.tx_procedimento,'0'),3,'0'), 
		lpad(coalesce(a.nr_seq_nota,'0'),11,'0'), 
		rpad(coalesce(a.ds_hora_procedimento,' '),8,' '), 
		rpad(coalesce(a.cd_cnes_prest,'9999999'),7,'9'), 
		rpad(coalesce(elimina_caractere_especial(elimina_acentuacao(a.nm_profissional_prestador)),' '),70,' '), 
		rpad(coalesce(a.sg_cons_prof_prest,' '),12,' '), 
		rpad(coalesce(a.nr_cons_prof_prest,' '),15,' '), 
		rpad(coalesce(a.sg_uf_cons_prest,' '),2,' '), 
		lpad(coalesce(a.nr_cgc_cpf_req,'0'),14,'0'), 
		rpad(coalesce(elimina_caractere_especial(elimina_acentuacao(a.nm_prestador_requisitante)),' '),40,' '), 
		rpad(coalesce(a.sg_cons_prof_req,' '),12,' '), 
		rpad(coalesce(a.nr_cons_prof_req,' '),15,' '), 
		rpad(coalesce(a.sg_uf_cons_req,' '),2,' '), 
		rpad(coalesce(to_char(a.ie_reembolso),' '),1,' '), 
		lpad(coalesce(a.nr_autorizacao,'0'),10,'0'), 
		lpad(coalesce(replace(replace(campo_mascara(vl_pago_prest,2),',',''),'.',''),'0'),14,'0'), 
		a.nr_sequencia, 
		lpad(coalesce(to_char(cd_pacote),'0'),8,'0'), 
		rpad(coalesce(nr_guia_tiss,' '),20,' '), 
		rpad(coalesce(to_char(coalesce(tp_autoriz,1)),' '),1,' '), 
		rpad(coalesce(elimina_caractere_especial(elimina_acentuacao(ds_servico)),' '),80,' '), 
		rpad(coalesce(a.hr_final,' '),8,' '), 
		coalesce(a.id_acres_urg_emer,'N'), 
		lpad(coalesce(a.nr_cbo_exec,'0'),6,'0'), 
		coalesce(a.tec_utilizada,'0'), 
		rpad(coalesce(to_char(a.dt_autoriz,'yyyymmdd'),' '),8,' '), 
		rpad(coalesce(to_char(a.dt_solicitacao,'yyyymmdd'),' '),8,' '), 
		lpad(coalesce(a.unidade_medida,'0'),3,'0'), 
		rpad(coalesce(a.nr_reg_anvisa,' '),15,' '), 
		rpad(coalesce(a.cd_munic || substr(calcula_digito('MODULO10', a.cd_munic),1,1),'0'),7,'0'), 
		rpad(coalesce(substr(a.cd_ref_material_fab,1,60),' '),60,' '), 
		rpad(coalesce(to_char(a.dt_pgto_prestador,'yyyymmdd'),' '),8,' '), 
		rpad(coalesce(nr_cnpj_fornecedor,'0'),14,'0'), 
		b.nr_sequencia, 
		rpad(coalesce(a.cd_rec_prestador,'0'),10,'0') 
	from	ptu_nota_servico	a, 
		ptu_nota_cobranca	b 
	where	a.nr_seq_nota_cobr	= b.nr_sequencia 
	and	coalesce(a.qt_procedimento,0) > 0 
	and	b.nr_sequencia		= nr_seq_nota_cobranca_w;
	
C04 CURSOR FOR 
	SELECT	lpad(coalesce(elimina_caractere_especial(a.nr_lote),'0'),8,'0'), 
		lpad(coalesce(substr(elimina_caractere_especial(to_char(pls_obter_dados_conta(a.nr_nota,'G'))),length(to_char(pls_obter_dados_conta(a.nr_nota,'G'))) - 10,length(to_char(pls_obter_dados_conta(a.nr_nota,'G')))),'0'),11,'0'), 
		coalesce(to_char(a.ie_tipo_complemento),' '), 
		rpad(coalesce(elimina_caractere_especial(elimina_acentuacao(replace(replace(a.ds_complemento,chr(13),''),chr(10),''))),' '),100,' '), 
		rpad(coalesce(elimina_caractere_especial(elimina_acentuacao(replace(replace(a.especif_material,chr(13),''),chr(10),''))),' '),500,' ') 
	from	ptu_nota_complemento	a, 
		ptu_nota_cobranca	b 
	where	a.nr_seq_nota_cobr	= b.nr_sequencia 
	and	b.nr_sequencia		= nr_seq_nota_cobranca_w;
	
C10 CURSOR FOR 
	SELECT	rpad(coalesce(b.nr_declara_vivo,' '),15,' '), 
		rpad(coalesce(b.cd_cid_obito,' '),6,' '), 
		rpad(coalesce(b.nr_declara_obito,' '),17,' ') 
	FROM ptu_nota_cobranca c, ptu_nota_hospitalar a
LEFT OUTER JOIN ptu_nota_hosp_compl b ON (a.nr_sequencia = b.nr_seq_nota_hosp)
WHERE a.nr_seq_nota_cobr	= c.nr_sequencia and c.nr_sequencia		= nr_seq_nota_cobranca_w;


BEGIN 
delete from w_ptu_envio_arq where nm_usuario = nm_usuario_p;
 
-- Padrão brasileiro é -3, Regiões Sul, Sudeste e Nordeste, Goiás, Distrito Federal, Tocantins, Amapá e Pará 
ds_meridiano_w := '-03';
 
select	lpad(cd_unimed_destino,4,'0') 
into STRICT	cd_cooperativa_w 
from	ptu_servico_pre_pagto 
where	nr_sequencia	= nr_seq_servico_p;
 
select	max(cd_cgc) 
into STRICT	cd_cgc_w 
from	pls_congenere 
where	lpad(cd_cooperativa,4,'0') = cd_cooperativa_w;
 
select	max(sg_estado) 
into STRICT	sg_estado_w 
from	pessoa_juridica 
where	cd_cgc = cd_cgc_w;
 
if (sg_estado_w in ('RN','PB','PE','AL')) then 
	ds_meridiano_w := '-02';
end if;
 
if (sg_estado_w in ('MS','MT','RO','AC','AM','RR')) then 
	ds_meridiano_w := '-04';
end if;
 
cd_operadora_origem_w	:= pls_obter_unimed_estab(cd_estabelecimento_p);
 
open C00;
loop 
fetch C00 into	 
	cd_unimed_destino_w, 
	cd_unimed_origem_w, 
	dt_geracao_w, 
	nr_seq_geracao_w, 
	dt_inicio_pagto_w, 
	dt_fim_pagto_w, 
	nr_versao_transacao_w;	
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin 
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
 
	ds_conteudo_w	:=	lpad(to_char(nr_seq_registro_w),8,'0') || '701' || cd_unimed_destino_w || cd_unimed_origem_w || dt_geracao_w || nr_seq_geracao_w || 
				dt_inicio_pagto_w || dt_fim_pagto_w || nr_versao_transacao_w;
	ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;
 
	insert into w_ptu_envio_arq(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		ds_conteudo, 
		nr_seq_apres) 
	values (nextval('w_ptu_envio_arq_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		ds_conteudo_w, 
		nr_seq_registro_w);
		 
	open C01;
	loop 
	fetch C01 into 
		nr_lote_w, 
		nr_nota_w, 
		cd_unimed_w, 
		cd_usuario_plano_w, 
		nm_beneficiario_w, 
		dt_atendimento_w, 
		cd_excecao_w, 
		ie_carater_atendimento_w, 
		cd_cid_w, 
		ie_paciente_w, 
		ie_tipo_saida_spdat_w, 
		ie_tipo_atendimento_w, 
		nr_guia_principal_w, 
		nr_seq_nota_cobranca_w, 
		dt_internacao_702_w, 
		dt_alta_702_w, 
		dt_ultima_autoriz_w, 
		tp_nota_w, 
		id_nota_principal_w, 
		nr_ver_tiss_w, 
		nr_guia_tiss_prestador_w, 
		nr_guia_tiss_principal_w, 
		nr_guia_tiss_operadora_w, 
		tp_ind_acidente_w, 
		motivo_encerram_w, 
		nr_cnpj_cpf_req_w, 
		nm_prest_req_w, 
		sg_cons_prof_req_702_w, 
		nr_cons_prof_req_702_w, 
		sg_uf_cons_req_702_w, 
		nr_cbo_req_w, 
		nr_fatura_glosada_w, 
		nr_ndr_glosada_w, 
		nr_lote_glosado_w, 
		nr_nota_glosada_w, 
		dt_protocolo_w, 
		id_rn_w, 
		tp_consulta_w, 
		tp_pessoa_w, 
		nr_cnpj_cpf_w, 
		cd_cnes_cont_exec_w, 
		cd_munic_cont_exec_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		qt_registro_w		:= 0;
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		qt_tot_r702_w		:= qt_tot_r702_w + 1;
		 
		select	count(1) 
		into STRICT	qt_registro_w 
		from	ptu_nota_hospitalar	a, 
			ptu_nota_hosp_compl	b, 
			ptu_nota_cobranca	c 
		where	a.nr_sequencia		= b.nr_seq_nota_hosp 
		and	a.nr_seq_nota_cobr	= c.nr_sequencia 
		and	c.nr_sequencia		= nr_seq_nota_cobranca_w  LIMIT 1;
		 
		begin 
		select	dt_atendimento 
		into STRICT	dt_atendimento_ww 
		from	ptu_nota_cobranca 
		where	nr_sequencia		= nr_seq_nota_cobranca_w;
		exception 
		when others then 
			dt_atendimento_ww	:= clock_timestamp();
		end;
		 
		/* OS 649133 - Em atendimentos ao TISS o campo tipo de saída ( IE_TIPO_SAIDA_SPDAT_W ) deve ser informado em atendimento com data superior a 31/08/2007 quando não houver internação. */
	 
		if (qt_registro_w > 0) and (trunc(dt_atendimento_ww) <= trunc(to_date('31/08/2007', 'dd/mm/yyyy'))) or (somente_numero(nr_ver_tiss_w) >= '30000') then 
			ie_tipo_saida_spdat_w := ' ';
		end if;
		 
		if (coalesce(trim(both nr_guia_principal_w)::text, '') = '') then 
			nr_guia_principal_w := lpad('0',20,'0');
		end if;
		 
		ds_conteudo_w	:=	lpad(to_char(nr_seq_registro_w),8,'0') || '702' || nr_lote_w || lpad(' ',12,' ') || cd_unimed_destino_w || '  ' || 
					cd_usuario_plano_w || nm_beneficiario_w || dt_atendimento_w || lpad(' ',4,' ') || cd_cid_w || 
					lpad(' ',14,' ') || ie_paciente_w || ie_tipo_saida_spdat_w || ie_tipo_atendimento_w || lpad(' ',11,' ') || nr_nota_w || 
					nr_guia_principal_w || dt_internacao_702_w || dt_alta_702_w || tp_nota_w || id_nota_principal_w || 
					nr_ver_tiss_w || nr_guia_tiss_prestador_w || nr_guia_tiss_principal_w || nr_guia_tiss_operadora_w || tp_ind_acidente_w || 
					motivo_encerram_w || nr_cnpj_cpf_req_w || lpad(' ',40,' ') || sg_cons_prof_req_702_w || nr_cons_prof_req_702_w || sg_uf_cons_req_702_w || 
					lpad(coalesce(nr_cbo_req_w,'0'),6,'0') || dt_protocolo_w || id_rn_w || ie_carater_atendimento_w || tp_consulta_w || tp_pessoa_w || nr_cnpj_cpf_w || 
					cd_cnes_cont_exec_w || cd_munic_cont_exec_w || nm_prest_req_w;
		ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;
 
		insert into w_ptu_envio_arq(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			ds_conteudo, 
			nr_seq_apres) 
		values (nextval('w_ptu_envio_arq_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			ds_conteudo_w, 
			nr_seq_registro_w);
			 
		open C02;
		loop 
		fetch C02 into 
			nr_lote_703_w, 
			nr_nota_703_w, 
			cd_unimed_hospital_w, 
			cd_hospital_w, 
			nm_hospital_w, 
			ie_tipo_acomodacao_w, 
			dt_internacao_w, 
			dt_alta_w, 
			tx_mult_amb_w, 
			ie_ind_acidente_w, 
			cd_motivo_saida_w, 
			cd_cgc_hospital_w, 
			ie_tipo_internacao_w, 
			qt_nasc_vivos_w, 
			qt_nasc_mortos_w,			 
			qt_nasc_vivos_pre_w, 
			qt_obito_precoce_w, 
			qt_obito_tardio_w, 
			ie_int_gestacao_w, 
			ie_int_aborto_w, 
			ie_int_transtorno_w, 
			ie_int_puerperio_w, 
			ie_int_recem_nascido_w, 
			ie_int_neonatal_w, 
			ie_int_baixo_peso_w, 
			ie_int_parto_cesarea_w, 
			ie_int_parto_normal_w, 
			ie_faturamento_w, 
			ie_obito_mulher_w, 
			nr_declara_obito_w, 
			reg_internacao_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			nr_declara_vivo_1_w 	:= null;
			nr_declara_vivo_2_w 	:= null;
			nr_declara_vivo_3_w 	:= null;
			nr_declara_vivo_4_w 	:= null;
			nr_declara_vivo_5_w 	:= null;
			cd_cid_obito_w		:= null;			
			cd_cid_obito_1_w 	:= null;
			cd_cid_obito_2_w 	:= null;
			cd_cid_obito_3_w 	:= null;
			cd_cid_obito_4_w 	:= null;
			cd_cid_obito_5_w 	:= null;
			nr_declara_obito_1_w 	:= null;
			nr_declara_obito_2_w 	:= null;
			nr_declara_obito_3_w 	:= null;
			nr_declara_obito_4_w 	:= null;
			nr_declara_obito_5_w 	:= null;
			 
			open C10;
			loop 
			fetch C10 into	 
				nr_declara_vivo_0_w, 
				cd_cid_obito_0_w, 
				nr_declara_obito_0_w;
			EXIT WHEN NOT FOUND; /* apply on C10 */
				begin 
				 
				if (coalesce(nr_declara_vivo_1_w::text, '') = '') then 
					nr_declara_vivo_1_w := nr_declara_vivo_0_w;
				 
				elsif (coalesce(nr_declara_vivo_2_w::text, '') = '') then 
					nr_declara_vivo_2_w := nr_declara_vivo_0_w;
					 
				elsif (coalesce(nr_declara_vivo_3_w::text, '') = '') then 
					nr_declara_vivo_3_w := nr_declara_vivo_0_w;
					 
				elsif (coalesce(nr_declara_vivo_4_w::text, '') = '') then 
					nr_declara_vivo_4_w := nr_declara_vivo_0_w;
				 
				elsif (coalesce(nr_declara_vivo_5_w::text, '') = '') then 
					nr_declara_vivo_5_w := nr_declara_vivo_0_w;
				end if;
				 
				if (coalesce(cd_cid_obito_1_w::text, '') = '') then 
					cd_cid_obito_1_w 	:= cd_cid_obito_0_w;
					cd_cid_obito_w		:= cd_cid_obito_0_w;
				 
				elsif (coalesce(cd_cid_obito_2_w::text, '') = '') then 
					cd_cid_obito_2_w 	:= cd_cid_obito_0_w;
					cd_cid_obito_w		:= cd_cid_obito_0_w;
					 
				elsif (coalesce(cd_cid_obito_3_w::text, '') = '') then 
					cd_cid_obito_3_w 	:= cd_cid_obito_0_w;
					cd_cid_obito_w		:= cd_cid_obito_0_w;
					 
				elsif (coalesce(cd_cid_obito_4_w::text, '') = '') then 
					cd_cid_obito_4_w 	:= cd_cid_obito_0_w;
					cd_cid_obito_w		:= cd_cid_obito_0_w;
				 
				elsif (coalesce(cd_cid_obito_5_w::text, '') = '') then 
					cd_cid_obito_5_w 	:= cd_cid_obito_0_w;
					cd_cid_obito_w		:= cd_cid_obito_0_w;
				end if;
				 
				cd_cid_obito_w	:= rpad(substr(coalesce(cd_cid_obito_w,' '),1,6),6,' ');
				 
				if (coalesce(nr_declara_obito_1_w::text, '') = '') then 
					nr_declara_obito_1_w := nr_declara_obito_0_w;
				 
				elsif (coalesce(nr_declara_obito_2_w::text, '') = '') then 
					nr_declara_obito_2_w := nr_declara_obito_0_w;
					 
				elsif (coalesce(nr_declara_obito_3_w::text, '') = '') then 
					nr_declara_obito_3_w := nr_declara_obito_0_w;
					 
				elsif (coalesce(nr_declara_obito_4_w::text, '') = '') then 
					nr_declara_obito_4_w := nr_declara_obito_0_w;
				 
				elsif (coalesce(nr_declara_obito_5_w::text, '') = '') then 
					nr_declara_obito_5_w := nr_declara_obito_0_w;
				end if;				
				end;
			end loop;
			close C10;
			 
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			qt_tot_r703_w		:= qt_tot_r703_w + 1;
			 
			ds_conteudo_w	:= 	lpad(to_char(nr_seq_registro_w),8,'0') || 
						'703' || 
						nr_lote_703_w || 
						lpad(' ',11,' ') || 
						cd_unimed_hospital_w || 
						cd_hospital_w || 
						lpad(' ',25,' ') || 
						ie_tipo_acomodacao_w || 
						lpad(' ',42,' ') || 					 
						tx_mult_amb_w || '  ' || 
						cd_cgc_hospital_w || 
						ie_tipo_internacao_w || 
						' ' || 
						qt_nasc_vivos_w || 
						qt_nasc_mortos_w || 
						qt_nasc_vivos_pre_w || 
						qt_obito_precoce_w || 
						qt_obito_tardio_w || 
						ie_int_gestacao_w || 
						ie_int_aborto_w || 
						ie_int_transtorno_w || 
						ie_int_puerperio_w || 
						ie_int_recem_nascido_w || 
						ie_int_neonatal_w || 
						ie_int_baixo_peso_w || 
						ie_int_parto_cesarea_w || 
						ie_int_parto_normal_w || 
						ie_faturamento_w || 
						cd_cid_obito_w || 
						lpad(' ',7,' ') || 
						rpad(coalesce(nr_declara_vivo_1_w,' '),15,' ') || 
						rpad(coalesce(nr_declara_vivo_2_w,' '),15,' ') || 
						rpad(coalesce(nr_declara_vivo_3_w,' '),15,' ') || 
						rpad(coalesce(nr_declara_vivo_4_w,' '),15,' ') || 
						rpad(coalesce(nr_declara_vivo_5_w,' '),15,' ') || 
						' ' || 
						nr_declara_obito_w || 
						rpad(coalesce(cd_cid_obito_1_w,' '),6,' ') || 
						rpad(coalesce(cd_cid_obito_2_w,' '),6,' ') || 
						rpad(coalesce(cd_cid_obito_3_w,' '),6,' ') || 
						rpad(coalesce(cd_cid_obito_4_w,' '),6,' ') || 
						rpad(coalesce(cd_cid_obito_5_w,' '),6,' ') || 
						rpad(coalesce(nr_declara_obito_1_w,' '),17,' ') || 
						rpad(coalesce(nr_declara_obito_2_w,' '),17,' ') || 
						rpad(coalesce(nr_declara_obito_3_w,' '),17,' ') || 
						rpad(coalesce(nr_declara_obito_4_w,' '),17,' ') || 
						rpad(coalesce(nr_declara_obito_5_w,' '),17,' ') || 
						nr_nota_703_w || 
						reg_internacao_w || 
						nm_hospital_w;
			ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;
 
			insert into w_ptu_envio_arq(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				ds_conteudo, 
				nr_seq_apres) 
			values (nextval('w_ptu_envio_arq_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				ds_conteudo_w, 
				nr_seq_registro_w);
			end;
		end loop;
		close C02;
		 
		open C03;
		loop 
		fetch C03 into 
			nr_lote_704_w, 
			nr_nota_704_w, 
			cd_unimed_prestador_w, 
			cd_prestador_w, 
			nm_prestador_w, 
			ie_tipo_participacao_w, 
			dt_procedimento_w, 
			ie_tipo_tabela_w, 
			cd_procedimento_w, 
			qt_procedimento_w, 
			vl_procedimento_w, 
			vl_custo_operacional_w, 
			vl_filme_w, 
			cd_porte_anestesico_w, 
			cd_unimed_autorizadora_w, 
			cd_unimed_pre_req_w, 
			cd_prestador_req_w, 
			ie_via_acesso_w, 
			vl_adic_procedimento_w, 
			vl_adic_co_w, 
			vl_adic_filme_w, 
			cd_especialidade_w, 
			ie_tipo_prestador_w, 
			ie_rede_propria_w, 
			ie_tipo_pessoa_prestador_w, 
			nr_cgc_cpf_w, 
			ie_pacote_w, 
			cd_ato_w, 
			tx_procedimento_w, 
			nr_seq_nota_w, 
			ds_hora_procedimento_w, 
			cd_cnes_prest_w, 
			nm_profissional_prestador_w, 
			sg_cons_prof_prest_w, 
			nr_cons_prof_prest_w, 
			sg_uf_cons_prest_w, 
			nr_cgc_cpf_req_w, 
			nm_prestador_requisitante_w, 
			sg_cons_prof_req_w, 
			nr_cons_prof_req_w, 
			sg_uf_cons_req_w, 
			ie_reembolso_w, 
			nr_autorizacao_w, 
			vl_pago_prest_w, 
			nr_seq_nota_servico_w, 
			cd_pacote_w, 
			nr_gui_tiss_w, 
			tp_autoriz_w, 
			ds_servico_w, 
			hr_final_w, 
			id_acres_urg_emer_w, 
			nr_cbo_exec_w, 
			tec_utilizada_w, 
			dt_autoriz_w, 
			dt_solicitacao_w, 
			unidade_medida_w, 
			nr_reg_anvisa_w, 
			cd_munic_w, 
			cd_ref_material_fab_w, 
			dt_pgto_prestador_w, 
			nr_cnpj_fornecedor_w, 
			nr_seq_nota_cobranca_ww, 
			cd_rec_prestador_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			qt_tot_r704_w		:= qt_tot_r704_w + 1;
 
			if (cd_prestador_w IS NOT NULL AND cd_prestador_w::text <> '') then 
				select	max(a.ie_prestador_alto_custo) 
				into STRICT	ie_prestador_alto_custo_w 
				from	pls_prestador a 
				where	upper(a.cd_prestador) = upper(cd_prestador_w);
			end if;
 
			cd_prestador_w := lpad(cd_prestador_w,8,'0');
 
			-- Utiliza o código de especialidade do PTU 
			if (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then 
				select	max(cd_ptu) 
				into STRICT	cd_especialidade_ptu_w 
				from	especialidade_medica 
				where	cd_especialidade = cd_especialidade_w;
				 
				if (cd_especialidade_ptu_w IS NOT NULL AND cd_especialidade_ptu_w::text <> '') then 
					cd_especialidade_w := lpad(coalesce(cd_especialidade_ptu_w,'0'),2,'0');
				end if;
			end if;
 
			-- Mesma informação do registro 702 
			nr_nota_704_w := nr_nota_w;
 
			-- O sistema deve seguir o padrão de 4 casas para de inteiros e 4 para casas decimais, a representação da quantidade 1 é a seguinte --> '00010000' 
			qt_procedimento_w	:= lpad(somente_numero(trunc(qt_procedimento_w)),4,'0') || rpad(somente_numero(qt_procedimento_w - trunc(qt_procedimento_w)),4,'0');
 
			if (ie_carater_atendimento_w = '1') and (coalesce(trim(both hr_final_w)::text, '') = '') then 
				hr_final_w	:= ds_hora_procedimento_w;
			end if;
 
			-- Verifique a nota 00000000000235678160, lote 15421731. Sempre que houver um registro R703, no registro R704 as notas com participação H (hospital) devem ter os campos R704.CD_UNI_PRE+R704.CD_PREST = R703.CD_UNI_HOSP+R703.CD_HOSP 
			-- 
			begin 
			select	a.cd_unimed_hospital, 
				a.cd_hospital 
			into STRICT	cd_unimed_hospital_w, 
				cd_hospital_w 
			from	ptu_nota_hospitalar	a, 
				ptu_nota_cobranca	c 
			where	a.nr_seq_nota_cobr	= c.nr_sequencia 
			and	c.nr_sequencia		= nr_seq_nota_cobranca_ww 
			and	c.tp_nota 		= 3;
			exception 
			when others then 
				cd_unimed_hospital_w	:= null;
				cd_hospital_w		:= null;
			end;
 
			if (coalesce(ie_tipo_participacao_w,'X') = 'H') then 
				cd_unimed_prestador_w	:= lpad(coalesce(cd_unimed_hospital_w,cd_unimed_prestador_w),4,'0');
				cd_prestador_w		:= lpad(coalesce(cd_hospital_w,cd_prestador_w),8,'0');
			end if;
 
			if (ie_tipo_tabela_w = '2') or (ie_tipo_participacao_w = ' ') then 
				ie_tipo_participacao_w	:= '0';
			end if;
	 
			ds_conteudo_w	:=	lpad(to_char(nr_seq_registro_w),8,'0') || '704' || nr_lote_704_w || lpad(' ',11,' ') || 
						cd_unimed_prestador_w || cd_prestador_w || lpad(' ',40,' ') || ie_tipo_participacao_w || dt_procedimento_w || 
						ie_tipo_tabela_w || cd_procedimento_w || qt_procedimento_w || vl_procedimento_w || vl_custo_operacional_w || 
						vl_filme_w || cd_porte_anestesico_w || lpad(' ',13,' ') || cd_unimed_pre_req_w || cd_prestador_req_w || ie_via_acesso_w || 
						lpad(' ',42,' ') || cd_especialidade_w || dt_pgto_prestador_w || ie_tipo_prestador_w || ie_rede_propria_w || 
						ie_tipo_pessoa_prestador_w || nr_cgc_cpf_w || ie_pacote_w || 'S' || cd_ato_w || tx_procedimento_w || nr_seq_nota_w || 
						ds_hora_procedimento_w || lpad(' ',7,' ') || sg_cons_prof_prest_w || nr_cons_prof_prest_w || sg_uf_cons_prest_w || 
						lpad(' ',85,' ') || lpad(' ',40,' ') || ie_reembolso_w || nr_nota_704_w || hr_final_w || id_acres_urg_emer_w || 
						nr_cbo_exec_w || tec_utilizada_w || dt_autoriz_w || dt_solicitacao_w || unidade_medida_w || nr_reg_anvisa_w || 
						lpad(' ',37,' ') || lpad(' ',8,' ') || nr_cnpj_fornecedor_w || cd_rec_prestador_w || cd_ref_material_fab_w || nm_prestador_w || 
						nm_profissional_prestador_w;
			ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;
 
			qt_tot_r704_ww	:= qt_tot_r704_ww + somente_numero(qt_procedimento_w);
 
			insert into w_ptu_envio_arq(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				ds_conteudo, 
				nr_seq_apres) 
			values (nextval('w_ptu_envio_arq_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				ds_conteudo_w, 
				nr_seq_registro_w);
				 
			update	ptu_nota_servico 
			set	nr_seq_a500	= nr_seq_registro_w 
			where	nr_sequencia	= nr_seq_nota_servico_w;
			end;
		end loop;
		close C03;
		 
		open C04;
		loop 
		fetch C04 into	 
			nr_lote_705_w, 
			nr_nota_705_w, 
			ie_tipo_complemento_w, 
			ds_complemento_w, 
			especif_material_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin 
			nr_seq_registro_w	:= nr_seq_registro_w + 1;
			qt_tot_r705_w		:= qt_tot_r705_w + 1;
			 
			-- Mesma informação do registro 702 
			nr_nota_705_w := nr_nota_w;
 
			ds_conteudo_w	:=	lpad(to_char(nr_seq_registro_w),8,'0') || '705' || nr_lote_705_w || lpad(' ',11,' ') || 
						ie_tipo_complemento_w || ds_complemento_w || nr_nota_705_w;
			ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;
 
			insert into w_ptu_envio_arq(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				ds_conteudo, 
				nr_seq_apres) 
			values (nextval('w_ptu_envio_arq_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				ds_conteudo_w, 
				nr_seq_registro_w);
			end;
		end loop;
		close C04;
		 
		end;
	end loop;
	close C01;
			 
	end;
end loop;
close C00;
 
-- R709 ¿ TRAILER (OBRIGATÓRIO) 
nr_seq_registro_w	:= nr_seq_registro_w + 1;
 
select	replace(coalesce(ptu_obter_qt_registro_serv(nr_seq_servico_p,'VL_SERV'),'0'),',',''), 
	replace(coalesce(ptu_obter_qt_registro_serv(nr_seq_servico_p,'VL_CO'),'0'),',',''), 
	replace(coalesce(ptu_obter_qt_registro_serv(nr_seq_servico_p,'VL_FI'),'0'),',','') 
into STRICT	vl_tot_serv_w, 
	vl_tot_co_w, 
	vl_tot_filme_w
;
 
ds_conteudo_w	:=	lpad(to_char(nr_seq_registro_w),8,'0') || '709' || lpad(to_char(qt_tot_r702_w),5,'0') || lpad(to_char(qt_tot_r703_w),5,'0') || 
			lpad(to_char(qt_tot_r704_w),5,'0') || lpad(to_char(qt_tot_r705_w),5,'0') || lpad(' ',10,' ') || lpad(to_char(qt_tot_r704_ww),11,'0') || 
			lpad(vl_tot_serv_w,14,'0') || lpad(vl_tot_co_w,14,'0') || lpad(vl_tot_filme_w,14,'0');
ds_arquivo_w	:=	ds_arquivo_w || ds_conteudo_w;
 
insert into w_ptu_envio_arq(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	ds_conteudo, 
	nr_seq_apres) 
values (nextval('w_ptu_envio_arq_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	ds_conteudo_w, 
	nr_seq_registro_w);
	 
-- R998 ¿ Hash (OBRIGATÓRIO) 
nr_seq_registro_w	:=	nr_seq_registro_w + 1;
ds_arquivo_w := pls_hash_ptu_pck.obter_hash_txt(ds_arquivo_w); -- Gerar HASH 
ds_conteudo_w		:=	lpad(nr_seq_registro_w,8,'0') || '998' || ds_hash_w;
 
insert into w_ptu_envio_arq(nr_sequencia, 
	dt_atualizacao, 
	nm_usuario, 
	ds_conteudo, 
	nr_seq_apres) 
values (nextval('w_ptu_envio_arq_seq'), 
	clock_timestamp(), 
	nm_usuario_p, 
	ds_conteudo_w, 
	nr_seq_registro_w);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_envio_arq_a700_v90 ( nr_seq_servico_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

