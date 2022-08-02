-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_importar_arq_a700_v110a ( ds_conteudo_p text, nm_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_versao_p INOUT text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 

ds_registro_w			varchar(3);

--'701'
cd_unimed_destino_w		varchar(4);
cd_unimed_origem_w		varchar(10);
dt_inicial_pagto_w		timestamp;
dt_final_pagto_w		timestamp;
dt_geracao_w			timestamp;
nr_versao_transacao_w		smallint;
nr_seq_geracao_w		integer;

--'702'
nr_seq_servico_w		bigint;
nr_lote_w			integer;
nr_nota_w			ptu_nota_cobranca.nr_nota%type;
nr_seq_prestador_w   		pls_prestador.nr_sequencia%type;
cd_unimed_w			varchar(4);
cd_usuario_plano_w		varchar(13);
nm_beneficiario_w		varchar(25);
dt_atendimento_w		varchar(14);
dt_atendimento_ww		timestamp;
cd_excecao_w			varchar(1);
ie_carater_atendimento_w	varchar(1);
cd_cid_w			varchar(6);
ie_paciente_w			varchar(1);
ie_tipo_saida_spdat_w		varchar(1);
ie_tipo_atendimento_w		varchar(2);
nr_guia_principal_w		ptu_nota_cobranca.nr_guia_principal%type;
nr_seq_prest_inter_w		ptu_nota_cobranca.nr_seq_prest_inter%type;
cd_cgc_prestador_w		varchar(255);
nr_cpf_prestador_w		varchar(255);
tp_pessoa_w			varchar(1);
nr_cnpj_cpf_w			varchar(14);
cd_cnes_cont_exec_w		varchar(7);
cd_munic_cont_exec_w		varchar(7);

dt_internacao_w			timestamp;
dt_alta_w			timestamp;
tp_nota_w			smallint;
id_nota_principal_w		varchar(1);
nr_ver_tiss_w			varchar(7);
nr_guia_tiss_prestador_w	varchar(20);
nr_guia_tiss_principal_w	varchar(20);
nr_guia_tiss_operadora_w	varchar(20);
tp_ind_acidente_w		varchar(1);
motivo_encerram_w		varchar(2);
nr_cnpj_cpf_req_w		varchar(14);
nm_prest_req_w			varchar(60);
sg_cons_prof_req_w		varchar(12);
nr_cons_prof_req_w		varchar(15);
sg_uf_cons_req_w		varchar(2);
nr_cbo_req_w			integer;
dt_protocolo_w			timestamp;
id_rn_w				varchar(1);
tp_consulta_w			ptu_nota_cobranca.tp_consulta%type;
nm_prest_exec_w			ptu_nota_cobranca.nm_prest_exec%type;
tp_prest_exec_w			ptu_nota_cobranca.tp_prest_exec%type;
id_rec_proprio_w		ptu_nota_cobranca.id_rec_proprio%type;
cd_cid_obito_cobr_w		ptu_nota_cobranca.cd_cid_obito%type;

--'703'
nm_hospital_w			varchar(60);
nr_declara_obito_w		varchar(17);
nr_declara_obito_1_w		varchar(17);
nr_declara_obito_2_w		varchar(17);
nr_declara_obito_3_w		varchar(17);
nr_declara_obito_4_w		varchar(17);
nr_declara_obito_5_w		varchar(17);
nr_declara_vivo_1_w		varchar(15);
nr_declara_vivo_2_w		varchar(15);
nr_declara_vivo_3_w		varchar(15);
nr_declara_vivo_4_w		varchar(15);
nr_declara_vivo_5_w		varchar(15);
cd_cid_obito_w			varchar(6);
cd_cid_obito_1_w		varchar(6);
cd_cid_obito_2_w		varchar(6);
cd_cid_obito_3_w		varchar(6);
cd_cid_obito_4_w		varchar(6);
cd_cid_obito_5_w		varchar(6);
ie_tipo_acomodacao_w		varchar(2);
ie_faturamento_w		varchar(1);
cd_cgc_hospital_w		bigint;
nr_nota_703_w			ptu_nota_hospitalar.nr_nota%type;
nr_seq_hospitalar_w		bigint;
nr_seq_cobranca_w		bigint;
nr_lote_703_w			integer;
cd_hospital_w			integer;
tx_mult_amb_w			real;
cd_unimed_hospital_w 		smallint;
ie_tipo_internacao_w		smallint;
reg_internacao_w		smallint;

--'704'
qt_regra_w			bigint := 0;
qt_material_w			bigint := 0;
ie_material_intercambio_w	varchar(2);
ie_origem_proc_valido_w		pls_parametros.ie_origem_proc_valido%type;
ie_origem_proced_padrao_w	procedimento.ie_origem_proced%type;
cd_mat_number_inter_w		numeric(30) := null;
nr_seq_regra_conv_w		bigint;
qt_proc_valido_w		bigint;
qt_proced_origem_w		bigint;
nr_seq_material_w		bigint;
cd_servico_w			integer;

ie_origem_proced_w		bigint;
nr_lote_704_w			integer;
nr_nota_704_w			ptu_nota_servico.nr_nota%type;
cd_unimed_prestador_w		varchar(3);
cd_prestador_w			integer;
nm_prestador_w			varchar(70);
ie_tipo_participacao_w		varchar(1);
dt_procedimento_w		timestamp;
ie_tipo_tabela_w		smallint;
cd_procedimento_w		integer;
qt_procedimento_w		ptu_nota_servico.qt_procedimento%type;
vl_procedimento_w		double precision;
vl_custo_operacional_w		double precision;
vl_filme_w			double precision;
cd_porte_anestesico_w		varchar(1);
cd_unimed_pre_req_w		varchar(4);
cd_prestador_req_w		integer;
ie_via_acesso_w			smallint;
vl_adic_procedimento_w		double precision;
vl_adic_co_w			double precision;
vl_adic_filme_w			double precision;
cd_especialidade_w		smallint;
ie_tipo_prestador_w		varchar(2);
ie_rede_propria_w		varchar(1);
ie_tipo_pessoa_prestador_w	varchar(1);
nr_cgc_cpf_w			bigint;
ie_pacote_w			varchar(1);
cd_ato_w			varchar(1);
tx_procedimento_w		smallint;
nr_seq_nota_w			bigint;
ds_hora_procedimento_w		varchar(8);
cd_cnes_prest_w			varchar(7);
nm_profissional_prestador_w 	varchar(60);
sg_cons_prof_prest_w		varchar(12);
nr_cons_prof_prest_w		varchar(15);
sg_uf_cons_prest_w		varchar(2);
ie_reembolso_w			varchar(1);
nr_autorizacao_w		bigint;

hr_final_w			varchar(8);
id_acres_urg_emer_w		varchar(1);
nr_cbo_exec_w			integer;
tec_utilizada_w			smallint;
dt_autoriz_w			timestamp;
dt_solicitacao_w		timestamp;
unidade_medida_w		varchar(3);
nr_reg_anvisa_w			varchar(15);
cd_munic_w			varchar(7);
cd_ref_material_fab_w		varchar(60);
dt_pgto_prestador_w		timestamp;
nr_cnpj_fornecedor_w		varchar(14);
cd_rec_prestador_w		ptu_nota_servico.cd_rec_prestador%type;

--'705'
nr_lote_705_w			integer;
nr_nota_705_w			ptu_nota_complemento.nr_nota%type;
ie_tipo_complemento_w		smallint;
ds_complemento_w		varchar(100);
especif_material_w		varchar(500);
cd_servico_mat_w		varchar(50);
ie_somente_codigo_w		pls_regra_conv_mat_interc.ie_somente_codigo%type;

nm_id_sid_w			ptu_servico_pre_pagto.ds_sid_processo%type;
nm_id_serial_w			ptu_servico_pre_pagto.ds_serial_processo%type;
ds_hash_w			ptu_servico_pre_pagto.ds_hash%type;
ie_pacote_intercambio_w 	pls_conversao_proc.ie_pacote_intercambio%type := 'N';
ie_priorizar_conv_pct_int_w	pls_parametros.ie_priorizar_conv_pct_int%type;


BEGIN
	
begin
select 	coalesce(max(ie_material_intercambio),'S'),
	coalesce(max(ie_origem_proc_valido),'N'),
	coalesce(max(ie_priorizar_conv_pct_int), 'N')
into STRICT	ie_material_intercambio_w,
	ie_origem_proc_valido_w,
	ie_priorizar_conv_pct_int_w
from 	pls_parametros
where 	cd_estabelecimento = cd_estabelecimento_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182468);
end;

ds_registro_w	:=	substr(ds_conteudo_p,9,3);

select	max(sid),
	max(serial#)
into STRICT	nm_id_sid_w,
	nm_id_serial_w
from	gv$session
where 	audsid = userenv('SESSIONID');

if (ds_registro_w	= '701') then	
	cd_unimed_destino_w	:= substr(ds_conteudo_p,12,4);
	cd_unimed_origem_w	:= substr(ds_conteudo_p,16,4);
	nr_seq_geracao_w	:= (substr(ds_conteudo_p,28,4))::numeric;
	
	nr_versao_transacao_w := null;
	if ((substr(ds_conteudo_p,48,2))::numeric  > 0) then
		nr_versao_transacao_w := (substr(ds_conteudo_p,48,2))::numeric;
	end if;
	
	begin
	dt_geracao_w		:= to_date(substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4),'dd/mm/yyyy');
	exception
	when others then
		dt_geracao_w := null;
	end;
	
	begin
	dt_inicial_pagto_w	:= to_date(substr(ds_conteudo_p,38,2)||substr(ds_conteudo_p,36,2)||substr(ds_conteudo_p,32,4),'dd/mm/yyyy');
	exception
	when others then
		dt_inicial_pagto_w := null;
	end;
	
	begin
	dt_final_pagto_w	:= to_date(substr(ds_conteudo_p,46,2)||substr(ds_conteudo_p,44,2)||substr(ds_conteudo_p,40,4),'dd/mm/yyyy');
	exception
	when others then
		dt_final_pagto_w := null;
	end;

	insert into ptu_servico_pre_pagto(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_estabelecimento,
		cd_unimed_destino,
		cd_unimed_origem,
		dt_geracao,
		nr_versao_transacao,
		dt_inicio_pagto,
		dt_fim_pagto,
		ie_envio_recebimento,
		nr_seq_geracao,
		nm_usuario_importacao,
		dt_importacao_arquivo,
		nm_arquivo,
		ie_status,
		ds_sid_processo,
		ds_serial_processo)
	values (nextval('ptu_servico_pre_pagto_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'1',
		cd_unimed_destino_w, 
		cd_unimed_origem_w, 
		dt_geracao_w,
		nr_versao_transacao_w, 
		dt_inicial_pagto_w, 
		dt_final_pagto_w,
		'R',
		nr_seq_geracao_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_arquivo_p,
		'R',
		nm_id_sid_w,
		nm_id_serial_w);
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_servico_w
from	ptu_servico_pre_pagto
where	ie_status		= 'R'
and	nm_usuario		= nm_usuario_p
and	ds_sid_processo		= nm_id_sid_w
and	ds_serial_processo	= nm_id_serial_w;

if (coalesce(nr_seq_servico_w::text, '') = '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_servico_w
	from	ptu_servico_pre_pagto
	where	nm_usuario	= nm_usuario_p;
end if;

if (ds_registro_w	= '702') then
	
	nr_lote_w := null;
	if ((substr(ds_conteudo_p,12,8))::numeric  > 0) then
		nr_lote_w := (substr(ds_conteudo_p,12,8))::numeric;
	end if;

	cd_unimed_w := null;
	if ((substr(ds_conteudo_p,32,4))::numeric  > 0) then
		cd_unimed_w := substr(ds_conteudo_p,32,4);
	end if;
	
	nr_guia_principal_w	:= trim(both substr(ds_conteudo_p,157,20));
	nr_nota_w		:= trim(both substr(ds_conteudo_p,137,20));
	cd_excecao_w		:= trim(both substr(ds_conteudo_p,98,1));
	cd_usuario_plano_w	:= trim(both substr(ds_conteudo_p,39,13));
	nm_beneficiario_w	:= trim(both substr(ds_conteudo_p,52,25));
	
	if (somente_numero(nr_guia_principal_w) = 0) then
		nr_guia_principal_w	:= null;
	end if;
	
	begin
	dt_atendimento_ww	:= to_date(substr(ds_conteudo_p,85,2)||substr(ds_conteudo_p,81,4)||substr(ds_conteudo_p,77,4) ||' '||
						substr(ds_conteudo_p,87,8), 'dd/mm/yyyy hh24:mi:ss');
	exception
	when others then
		dt_atendimento_ww := null;
	end;
	
	cd_cid_w		:= trim(both substr(ds_conteudo_p,102,6));
	ie_paciente_w		:= trim(both substr(ds_conteudo_p,122,1));
	ie_tipo_saida_spdat_w	:= null;
	ie_tipo_atendimento_w	:= trim(both substr(ds_conteudo_p,124,2));
	
	if (substr(ie_tipo_atendimento_w,1,1) = '0') then
		ie_tipo_atendimento_w	:= substr(ie_tipo_atendimento_w,2,1);
	end if;
	
	begin
	dt_internacao_w	:= to_date(substr(ds_conteudo_p,185,2)||substr(ds_conteudo_p,181,4)||substr(ds_conteudo_p,177,4)|| ' ' ||
					substr(ds_conteudo_p,187,8), 'dd/mm/yyyy hh24:mi:ss');
	exception
	when others then
		dt_internacao_w := null;
	end;
	
	begin
	dt_alta_w	:= to_date(substr(ds_conteudo_p,206,2)||substr(ds_conteudo_p,202,4)||substr(ds_conteudo_p,198,4)|| ' ' ||
					substr(ds_conteudo_p,208,8), 'dd/mm/yyyy hh24:mi:ss');
	exception
	when others then
		dt_alta_w := null;
	end;
	
	tp_nota_w			:= (trim(both substr(ds_conteudo_p,219,1)))::numeric;
	id_nota_principal_w		:= trim(both substr(ds_conteudo_p,220,1));
	nr_ver_tiss_w			:= trim(both substr(ds_conteudo_p,221,7));
	nr_guia_tiss_prestador_w	:= trim(both substr(ds_conteudo_p,228,20));
	nr_guia_tiss_principal_w	:= trim(both substr(ds_conteudo_p,248,20));
	nr_guia_tiss_operadora_w	:= trim(both substr(ds_conteudo_p,268,20));
	tp_ind_acidente_w		:= trim(both substr(ds_conteudo_p,288,1));
	motivo_encerram_w		:= trim(both substr(ds_conteudo_p,289,2));
	nr_cnpj_cpf_req_w		:= trim(both substr(ds_conteudo_p,291,14));
	sg_cons_prof_req_w		:= trim(both substr(ds_conteudo_p,345,12));

	if 	trim(both upper(sg_cons_prof_req_w)) = 'CRESS' then
		sg_cons_prof_req_w := 'CRAS';
	end if;

	if 	trim(both upper(sg_cons_prof_req_w)) = 'CREFONO' then
		sg_cons_prof_req_w := 'CRFA';
	end if;
	
	nr_cons_prof_req_w		:= trim(both substr(ds_conteudo_p,357,15));
	sg_uf_cons_req_w		:= trim(both substr(ds_conteudo_p,372,2));
	nr_cbo_req_w			:= (trim(both substr(ds_conteudo_p,374,6)))::numeric;
	ie_carater_atendimento_w 	:= trim(both substr(ds_conteudo_p,389,1));
	tp_consulta_w			:= trim(both substr(ds_conteudo_p,390,1));
	tp_pessoa_w			:= trim(both substr(ds_conteudo_p,391,1));
	nr_cnpj_cpf_w			:= trim(both substr(ds_conteudo_p,392,14));
	cd_cnes_cont_exec_w		:= trim(both substr(ds_conteudo_p,406,7));
	cd_munic_cont_exec_w		:= trim(both substr(ds_conteudo_p,413,6));
	
	if (nr_cbo_req_w = 0) then
		nr_cbo_req_w := null;
	end if;
	
	begin
	dt_protocolo_w	:= to_date(substr(ds_conteudo_p,386,2) || substr(ds_conteudo_p,384,2) || substr(ds_conteudo_p,380,4), 'dd/mm/yyyy');
	exception
	when others then
		dt_protocolo_w := null;
	end;
	
	id_rn_w				:= trim(both substr(ds_conteudo_p,388,1));
	nm_prest_req_w			:= trim(both substr(ds_conteudo_p,420,60));
	
	nm_prest_exec_w			:= trim(both substr(ds_conteudo_p,490,60));
	tp_prest_exec_w			:= trim(both substr(ds_conteudo_p,560,2));
	id_rec_proprio_w		:= trim(both substr(ds_conteudo_p,562,1));
	cd_cid_obito_cobr_w		:= trim(both substr(ds_conteudo_p,563,6));
	
	insert into ptu_nota_cobranca(nr_sequencia,
		nr_seq_fatura,
		nr_lote,
		nr_nota,
		cd_unimed,
		cd_usuario_plano,
		dt_atendimento,
		cd_excecao,
		ie_carater_atendimento,
		ie_paciente,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_tipo_saida_spdat,
		ie_tipo_atendimento,
		nm_beneficiario,
		cd_cid,
		nr_guia_principal,
		nr_seq_serv_pre_pagto,
		dt_internacao,
		dt_alta,
		dt_ultima_autoriz,
		tp_nota,
		id_nota_principal,
		nr_ver_tiss,
		nr_guia_tiss_prestador,
		nr_guia_tiss_principal,
		nr_guia_tiss_operadora,
		tp_ind_acidente,
		motivo_encerram,
		nr_cnpj_cpf_req,
		nm_prest_req,
		sg_cons_prof_req,
		nr_cons_prof_req,
		sg_uf_cons_req,
		nr_cbo_req,
		nr_fatura_glosada,
		nr_ndr_glosada,
		nr_lote_glosado,
		nr_nota_glosada,
		dt_protocolo,
		id_rn,
		tp_consulta,
		tp_pessoa,
		nr_cnpj_cpf,
		cd_cnes_cont_exec,
		cd_munic_cont_exec,
		nm_prest_exec,
		tp_prest_exec,
		id_rec_proprio,
		cd_cid_obito)
	values (nextval('ptu_nota_cobranca_seq'),
		null,
		nr_lote_w,
		nr_nota_w,
		cd_unimed_w,
		cd_usuario_plano_w,
		dt_atendimento_ww,
		cd_excecao_w,
		ie_carater_atendimento_w,
		ie_paciente_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_saida_spdat_w,
		ie_tipo_atendimento_w,
		nm_beneficiario_w,
		cd_cid_w,
		nr_guia_principal_w,
		nr_seq_servico_w,
		dt_internacao_w,
		dt_alta_w,
		null,
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
		sg_cons_prof_req_w,
		nr_cons_prof_req_w,
		sg_uf_cons_req_w,
		nr_cbo_req_w,
		null,
		null,
		null,
		null,
		dt_protocolo_w,
		id_rn_w,
		tp_consulta_w,
		tp_pessoa_w,
		nr_cnpj_cpf_w,
		cd_cnes_cont_exec_w,
		cd_munic_cont_exec_w,
		nm_prest_exec_w,
		tp_prest_exec_w,
		id_rec_proprio_w,
		cd_cid_obito_cobr_w);
end if;

if (ds_registro_w	in ('703','704','705')) then
	select	max(z.nr_sequencia)
	into STRICT	nr_seq_cobranca_w
	from	ptu_servico_pre_pagto	x,
		ptu_nota_cobranca	z
	where	x.nr_sequencia		= z.nr_seq_serv_pre_pagto
	and	x.ie_status		= 'R'
	and	z.nm_usuario		= nm_usuario_p
	and	x.ds_sid_processo	= nm_id_sid_w
	and	x.ds_serial_processo	= nm_id_serial_w;
	
	if (coalesce(nr_seq_cobranca_w::text, '') = '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_cobranca_w
		from	ptu_nota_cobranca
		where	nm_usuario	= nm_usuario_p;
	end if;
end if;

if (ds_registro_w = '703') then
	
	nr_lote_703_w := '0';
	if ((substr(ds_conteudo_p,12,8))::numeric  > 0) then
		nr_lote_703_w := (substr(ds_conteudo_p,12,8))::numeric;
	end if;
	
	cd_unimed_hospital_w := '0';
	if ((substr(ds_conteudo_p,31,4))::numeric  > 0) then
		cd_unimed_hospital_w := (substr(ds_conteudo_p,31,4))::numeric;
	end if;
	
	cd_hospital_w := '0';
	if ((substr(ds_conteudo_p,35,8))::numeric  > 0) then
		cd_hospital_w := (substr(ds_conteudo_p,35,8))::numeric;
	end if;
	
	ie_tipo_internacao_w := '0';
	if ((substr(ds_conteudo_p,133,1))::numeric  > 0) then
		ie_tipo_internacao_w := (substr(ds_conteudo_p,133,1))::numeric;
	
		if (ie_tipo_internacao_w = 6) then
			ie_tipo_internacao_w	:= 4;
		end if;
		
		if (ie_tipo_internacao_w = 7) then
			ie_tipo_internacao_w	:= 5;
		end if;
		
	end if;
	
	ie_faturamento_w := null;
	if ((substr(ds_conteudo_p,153,1))::numeric  > 0) then
		ie_faturamento_w := (substr(ds_conteudo_p,153,1))::numeric;
	end if;

	nr_nota_703_w		:= trim(both substr(ds_conteudo_p,375,20));
	tx_mult_amb_w		:= trunc(substr(ds_conteudo_p,112,2)||','||substr(ds_conteudo_p,114,2));	
	ie_tipo_acomodacao_w	:= trim(both substr(ds_conteudo_p,68,2));
	
	cd_cgc_hospital_w	:= trim(both substr(ds_conteudo_p,119,14));
	--cd_cid_obito_w		:= trim(substr(ds_conteudo_p,154,6));
	nr_declara_vivo_1_w	:= trim(both substr(ds_conteudo_p,167,15));
	nr_declara_vivo_2_w	:= trim(both substr(ds_conteudo_p,182,15));
	nr_declara_vivo_3_w	:= trim(both substr(ds_conteudo_p,197,15));
	nr_declara_vivo_4_w	:= trim(both substr(ds_conteudo_p,212,15));
	nr_declara_vivo_5_w	:= trim(both substr(ds_conteudo_p,227,15));
	nr_declara_obito_w	:= trim(both substr(ds_conteudo_p,243,17));
	cd_cid_obito_1_w	:= trim(both substr(ds_conteudo_p,260,6));
	cd_cid_obito_2_w	:= trim(both substr(ds_conteudo_p,266,6));
	cd_cid_obito_3_w	:= trim(both substr(ds_conteudo_p,272,6));
	cd_cid_obito_4_w	:= trim(both substr(ds_conteudo_p,278,6));
	cd_cid_obito_5_w	:= trim(both substr(ds_conteudo_p,284,6));
	nr_declara_obito_1_w	:= trim(both substr(ds_conteudo_p,290,17));
	nr_declara_obito_2_w	:= trim(both substr(ds_conteudo_p,307,17));
	nr_declara_obito_3_w	:= trim(both substr(ds_conteudo_p,324,17));
	nr_declara_obito_4_w	:= trim(both substr(ds_conteudo_p,341,17));
	nr_declara_obito_5_w	:= trim(both substr(ds_conteudo_p,358,17));
	
	reg_internacao_w	:= (trim(both substr(ds_conteudo_p,395,1)))::numeric;
	nm_hospital_w		:= trim(both substr(ds_conteudo_p,396,60));

	insert into ptu_nota_hospitalar(nr_sequencia,
		nr_seq_nota_cobr,
		nr_lote,
		nr_nota,
		cd_unimed_hospital,
		cd_hospital, 
		nm_hospital,
		ie_tipo_acomodacao,
		dt_internacao, 
		dt_alta,
		dt_atualizacao,
		nm_usuario, 
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		tx_mult_amb, 
		cd_cgc_hospital,
		ie_tipo_internacao,
		ie_faturamento, 
		ie_ind_acidente,
		cd_motivo_saida,
		qt_nasc_vivos, 
		qt_nasc_mortos,
		qt_nasc_vivos_pre,
		qt_obito_precoce, 
		qt_obito_tardio,
		ie_int_gestacao,
		ie_int_aborto, 
		ie_int_transtorno,
		ie_int_puerperio,
		ie_int_recem_nascido,
		ie_int_neonatal,
		ie_int_baixo_peso,
		ie_int_parto_cesarea,
		ie_int_parto_normal,
		cd_cid_obito,
		ie_obito_mulher,
		nr_declara_obito, 
		reg_internacao)
	values (nextval('ptu_nota_hospitalar_seq'),
		nr_seq_cobranca_w,
		nr_lote_703_w,
		nr_nota_703_w,
		cd_unimed_hospital_w,
		cd_hospital_w, 
		nm_hospital_w,
		ie_tipo_acomodacao_w,
		null, --dt_internacao
		null, --dt_alta
		clock_timestamp(),
		nm_usuario_p, 
		clock_timestamp(),
		nm_usuario_p,
		tx_mult_amb_w, 
		cd_cgc_hospital_w,
		ie_tipo_internacao_w,
		ie_faturamento_w, 
		null, --ie_ind_acidente
		null, --cd_motivo_saida
		null, --qt_nasc_vivos
		null, --qt_nasc_mortos
		null, --qt_nasc_vivos_pre
		null, --qt_obito_precoce
		null, --qt_obito_tardio
		null, --ie_int_gestacao
		null, --ie_int_aborto
		null, --ie_int_transtorno
		null, --ie_int_puerperio
		null, --ie_int_recem_nascido
		null, --ie_int_neonatal
		null, --ie_int_baixo_peso
		null, --ie_int_parto_cesarea
		null, --ie_int_parto_normal
		cd_cid_obito_w,
		null, --ie_obito_mulher
		nr_declara_obito_w,
		reg_internacao_w) returning nr_sequencia into nr_seq_hospitalar_w;
	
	--	COMPLEMENTO HOSPITALAR	1
	insert into ptu_nota_hosp_compl(nr_sequencia,
		nr_seq_nota_hosp,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec, 
		nr_declara_vivo, 
		cd_cid_obito, 
		nr_declara_obito)
	values (nextval('ptu_nota_hosp_compl_seq'), 
		nr_seq_hospitalar_w,
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p,
		nr_declara_vivo_1_w, 
		cd_cid_obito_1_w, 
		nr_declara_obito_1_w);
	
	--	COMPLEMENTO HOSPITALAR	2
	insert into ptu_nota_hosp_compl(nr_sequencia,
		nr_seq_nota_hosp, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec,
		nm_usuario_nrec, 
		nr_declara_vivo,
		cd_cid_obito,
		nr_declara_obito)
	values (nextval('ptu_nota_hosp_compl_seq'),
		nr_seq_hospitalar_w,
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p,
		nr_declara_vivo_2_w, 
		cd_cid_obito_2_w, 
		nr_declara_obito_2_w);
	
	--	COMPLEMENTO HOSPITALAR	3
	insert into ptu_nota_hosp_compl(nr_sequencia,
		nr_seq_nota_hosp,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec, 
		nr_declara_vivo,
		cd_cid_obito,
		nr_declara_obito)
	values (nextval('ptu_nota_hosp_compl_seq'),
		nr_seq_hospitalar_w,
		clock_timestamp(), 
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_declara_vivo_3_w,
		cd_cid_obito_3_w,
		nr_declara_obito_3_w);
	
	--	COMPLEMENTO HOSPITALAR	4
	insert into ptu_nota_hosp_compl(nr_sequencia,
		nr_seq_nota_hosp,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec, 
		nr_declara_vivo,
		cd_cid_obito,
		nr_declara_obito)
	values (nextval('ptu_nota_hosp_compl_seq'),
		nr_seq_hospitalar_w,
		clock_timestamp(), 
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_declara_vivo_4_w,
		cd_cid_obito_4_w, 
		nr_declara_obito_4_w);
	
	--	COMPLEMENTO HOSPITALAR	5
	insert into ptu_nota_hosp_compl(nr_sequencia,
		nr_seq_nota_hosp, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec,
		nm_usuario_nrec, 
		nr_declara_vivo, 
		cd_cid_obito, 
		nr_declara_obito)
	values (nextval('ptu_nota_hosp_compl_seq'), 
		nr_seq_hospitalar_w,
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p,
		nr_declara_vivo_5_w, 
		cd_cid_obito_5_w, 
		nr_declara_obito_5_w);
end if;	

if (ds_registro_w = '704') then
	select	max(nr_ver_tiss)
	into STRICT	nr_ver_tiss_w
	from	ptu_nota_cobranca
	where	nr_sequencia	= nr_seq_cobranca_w;
	
	nr_lote_704_w := null;
	if ((substr(ds_conteudo_p,12,8))::numeric  > 0) then
		nr_lote_704_w := (substr(ds_conteudo_p,12,8))::numeric;
	end if;
	
	cd_unimed_prestador_w := null;
	if ((substr(ds_conteudo_p,32,3))::numeric  > 0) then
		cd_unimed_prestador_w := (substr(ds_conteudo_p,32,3))::numeric;
	end if;
	
	cd_prestador_w := null;
	if ((substr(ds_conteudo_p,35,8))::numeric  > 0) then
		cd_prestador_w := (substr(ds_conteudo_p,35,8))::numeric;
	end if;
	
	cd_servico_w := null;
	if ((substr(ds_conteudo_p,93,8))::numeric  > 0) then
		cd_servico_w := (substr(ds_conteudo_p,93,8))::numeric;
	end if;
	
	qt_procedimento_w := 0;
	if ((substr(ds_conteudo_p,101,8))::numeric  > 0) then
		qt_procedimento_w := (substr(ds_conteudo_p,101,8))::numeric;
	end if;
	
	vl_procedimento_w := 0;
	if ((substr(ds_conteudo_p,109,14))::numeric  > 0) then
		vl_procedimento_w := (substr(ds_conteudo_p,109,12)||','|| substr(ds_conteudo_p,121,2))::numeric;
	end if;
	
	vl_custo_operacional_w := 0;
	if ((substr(ds_conteudo_p,123,14))::numeric  > 0) then
		vl_custo_operacional_w := (substr(ds_conteudo_p,123,12)||','|| substr(ds_conteudo_p,135,2))::numeric;
	end if;

	vl_filme_w := 0;
	if ((substr(ds_conteudo_p,137,14))::numeric  > 0) then
		vl_filme_w := (substr(ds_conteudo_p,137,12)||','|| substr(ds_conteudo_p,149,2))::numeric;
	end if;
	
	cd_unimed_pre_req_w := null;
	--if	(to_number(substr(ds_conteudo_p,165,4)) > 0) then

	--	cd_unimed_pre_req_w := to_number(substr(ds_conteudo_p,165,4));

	--end if;
	
	cd_prestador_req_w := null;
	--if	(to_number(substr(ds_conteudo_p,169,8)) > 0) then

	--	cd_prestador_req_w := to_number(substr(ds_conteudo_p,169,8));

	--end if;
	
	ie_via_acesso_w := null;
	if ((substr(ds_conteudo_p,177,2))::(numeric IS NOT NULL AND numeric::text <> '')) then
		ie_via_acesso_w := (substr(ds_conteudo_p,177,2))::numeric;
	end if;
	cd_especialidade_w 	:= null; -- cd_especialidade_w := to_number(substr(ds_conteudo_p,221,2));
	--ie_tipo_prestador_w		:= trim(substr(ds_conteudo_p,231,2));
	
	nr_cgc_cpf_w := null;
	if ((substr(ds_conteudo_p,235,14) IS NOT NULL AND (substr(ds_conteudo_p,235,14))::text <> '')) then
		nr_cgc_cpf_w := substr(ds_conteudo_p,235,14);
	end if;
	
	tx_procedimento_w := null;
	if ((substr(ds_conteudo_p,252,2))::numeric  > 0) then
		tx_procedimento_w := (substr(ds_conteudo_p,252,2))::numeric;
	end if;
	
	nr_seq_nota_w := null;
	if ((substr(ds_conteudo_p,255,11))::numeric  > 0) then
		nr_seq_nota_w := (substr(ds_conteudo_p,255,11))::numeric;
	end if;
	
	nr_nota_704_w			:= trim(both substr(ds_conteudo_p,436,20));
	ie_tipo_tabela_w		:= trim(both substr(ds_conteudo_p,92,1));
	ie_tipo_participacao_w		:= trim(both substr(ds_conteudo_p,83,1));
	qt_procedimento_w		:= dividir_sem_round((qt_procedimento_w)::numeric,10000);
	
	begin
	dt_procedimento_w := to_date(substr(ds_conteudo_p,90,2)||substr(ds_conteudo_p,88,2)||substr(ds_conteudo_p,84,4),'dd/mm/yyyy');
	exception
	when others then
		dt_procedimento_w := null;
	end;
	
	cd_porte_anestesico_w		:= trim(both substr(ds_conteudo_p,151,1));
	--ie_rede_propria_w		:= trim(substr(ds_conteudo_p,233,1));
	ie_tipo_pessoa_prestador_w	:= trim(both substr(ds_conteudo_p,234,1));			
	ie_pacote_w			:= trim(both substr(ds_conteudo_p,249,1));
	cd_ato_w			:= trim(both substr(ds_conteudo_p,251,1));
	ds_hora_procedimento_w		:= trim(both substr(ds_conteudo_p,266,8));
	cd_cnes_prest_w			:= trim(both substr(ds_conteudo_p,274,7));
	sg_cons_prof_prest_w		:= trim(both substr(ds_conteudo_p,281,12));
	nr_cons_prof_prest_w		:= trim(both substr(ds_conteudo_p,293,15));
	sg_uf_cons_prest_w		:= trim(both substr(ds_conteudo_p,308,2));
	ie_reembolso_w			:= trim(both substr(ds_conteudo_p,435,1));
	hr_final_w			:= trim(both substr(ds_conteudo_p,456,8));
	id_acres_urg_emer_w		:= trim(both substr(ds_conteudo_p,464,1));
	nr_cbo_exec_w			:= (trim(both substr(ds_conteudo_p,465,6)))::numeric;
	tec_utilizada_w			:= (trim(both substr(ds_conteudo_p,471,1)))::numeric;
	
	nm_prestador_w			:= null; --trim(substr(ds_conteudo_p,635,70));
	nm_profissional_prestador_w 	:= trim(both substr(ds_conteudo_p,705,60));
	
	if (nr_cbo_exec_w = 0) then
		nr_cbo_exec_w := null;
	end if;
	
	begin
	dt_autoriz_w		:= to_date(substr(ds_conteudo_p,478,2) || substr(ds_conteudo_p,476,2) || substr(ds_conteudo_p,472,4), 'dd/mm/yyyy');
	exception
	when others then
		dt_autoriz_w := null;
	end;
	
	begin
	dt_solicitacao_w		:= to_date(substr(ds_conteudo_p,486,2) || substr(ds_conteudo_p,484,2) || substr(ds_conteudo_p,480,4), 'dd/mm/yyyy');
	exception
	when others then
		dt_solicitacao_w := null;
	end;
	
	unidade_medida_w		:= trim(both substr(ds_conteudo_p,488,3));
	nr_reg_anvisa_w			:= trim(both substr(ds_conteudo_p,491,15));
	cd_munic_w			:= (trim(both substr(ds_conteudo_p,506,7)))::numeric;
	
	begin
	dt_pgto_prestador_w		:= to_date(substr(ds_conteudo_p,549,2) || substr(ds_conteudo_p,547,2) || substr(ds_conteudo_p,543,4), 'dd/mm/yyyy');
	exception
	when others then
		dt_pgto_prestador_w := null;
	end;
	
	nr_cnpj_fornecedor_w		:= trim(both substr(ds_conteudo_p,551,14));
	cd_rec_prestador_w		:= trim(both substr(ds_conteudo_p,565,10));
	cd_ref_material_fab_w		:= trim(both substr(ds_conteudo_p,575,60));
	
	nr_seq_material_w		:= null;
	cd_procedimento_w		:= null;
	ie_origem_proced_w		:= null;
	if (ie_tipo_tabela_w = 4) then
		ie_pacote_intercambio_w := 'S';
	else
		ie_pacote_intercambio_w := 'N';
	end if;
	
	if (ie_tipo_tabela_w in (2,3,5,6)) then				
		if (coalesce(ie_material_intercambio_w,'S') = 'S') then		
			nr_seq_material_w := cd_servico_w;
			
		elsif (coalesce(ie_material_intercambio_w,'S') = 'C') then
			nr_seq_material_w := null;
			
			 nr_seq_material_w := pls_obter_mat_tiss_vigente( nr_seq_material_w, clock_timestamp(), cd_servico_w, 'O', 'N', nr_ver_tiss_w);
			
			if (coalesce(nr_seq_material_w::text, '') = '') then
				nr_seq_material_w := 0;
			end if;
			
		elsif (coalesce(ie_material_intercambio_w,'S') = 'CI') then			
			nr_seq_material_w := null;
			
			SELECT * FROM pls_obter_mat_a900_vigente( nr_seq_material_w, clock_timestamp(), cd_servico_w, nr_ver_tiss_w) INTO STRICT  nr_seq_material_w, cd_servico_w;
			
			if (coalesce(nr_seq_material_w::text, '') = '') then
				nr_seq_material_w := 0;
			end if;
		end if;
		
		select	count(1)
		into STRICT	qt_regra_w
		from	pls_conversao_proc
		where	(cd_material_imp IS NOT NULL AND cd_material_imp::text <> '')
		and	ie_situacao = 'A'
		and	ie_ptu = 'S';
		
		if (qt_regra_w > 0) then
			cd_mat_number_inter_w := somente_numero(cd_servico_w);
		
			SELECT * FROM pls_obter_proced_conversao(	null, null, null, cd_estabelecimento_p, 4, null, 3, 'R', null, null, null, cd_mat_number_inter_w, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_regra_conv_w, ie_somente_codigo_w, clock_timestamp(), null, null, null, 'N', ie_priorizar_conv_pct_int_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w, nr_seq_regra_conv_w, ie_somente_codigo_w;
		end if;
		
		if ((coalesce(nr_seq_material_w,0))<> 0) then
			select	count(nr_sequencia)
			into STRICT	qt_material_w
			from	pls_material
			where	nr_sequencia	= nr_seq_material_w;
		end if;
		
		if (coalesce(qt_material_w,0) = 0) then
			SELECT * FROM ptu_obter_material_conversao(	cd_servico_w, ie_tipo_tabela_w, dt_procedimento_w, 'R', '7', null, null, nr_seq_material_w, cd_servico_mat_w, ie_somente_codigo_w) INTO STRICT nr_seq_material_w, cd_servico_mat_w, ie_somente_codigo_w;
		end if;		

		if (coalesce(nr_seq_material_w,0) = 0) then
			nr_seq_material_w	:= null;
		end if;
		
		-- A900
		if (coalesce(nr_seq_material_w::text, '') = '') then
			cd_mat_number_inter_w := somente_numero(cd_servico_w);
			
			 nr_seq_material_w := pls_obter_mat_tiss_vigente( nr_seq_material_w, clock_timestamp(), cd_mat_number_inter_w, 'A', 'N', nr_ver_tiss_w);
		end if;
		
		-- FEDERACAO
		if (coalesce(nr_seq_material_w::text, '') = '') then
			 nr_seq_material_w := pls_obter_mat_tiss_vigente( nr_seq_material_w, clock_timestamp(), cd_mat_number_inter_w, 'F', 'N', nr_ver_tiss_w);
		end if;	
							
		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
			nr_seq_material_w := null;
		end if;
	else
		/*A origem do procedimento e buscado por regra existente no cadastro de regras / Procedimentos/ regra origem.*/

		SELECT * FROM pls_obter_proced_conversao(	cd_servico_w, null, null, cd_estabelecimento_p, 4, null, 3, 'R', null, null, null, null, null, cd_procedimento_w, ie_origem_proced_w, nr_seq_regra_conv_w, ie_somente_codigo_w, clock_timestamp(), null, null, null, ie_pacote_intercambio_w, ie_priorizar_conv_pct_int_w) INTO STRICT cd_procedimento_w, ie_origem_proced_w, nr_seq_regra_conv_w, ie_somente_codigo_w;
		
		-- Obter a origem padrao para os itens conforme a regra.
		ie_origem_proced_padrao_w := pls_obter_origem_proced(cd_estabelecimento_p, null, 'R', dt_procedimento_w, null);
		
		if (coalesce(ie_origem_proced_w::text, '') = '') then
			--jjung OS 483853 - 02/10/2012 - adicionado restricao para data de vigencia das regras cadastradas.
			ie_origem_proced_w := ie_origem_proced_padrao_w;
		end if;
		--Criado tratamento para atender as OS 575917 que solicita que seja buscado a ultima origem valida e a OS 644869 onde indica que deve ser respeitada a origem padrao do sistema	
		if (ie_origem_proc_valido_w	= 'S') then
			select	count(1)
			into STRICT	qt_proced_origem_w
			from	procedimento
			where	cd_procedimento = cd_procedimento_w
			and	ie_origem_proced = ie_origem_proced_w
			and	ie_situacao = 'A';
			
			/*Se este procedimento nao existir na origem padrao e selecionado o max origem proced*/

			if (qt_proced_origem_w = 0) then	
				-- Buscar a origem do procedimento ativo
				select	max(ie_origem_proced)
				into STRICT	ie_origem_proced_w
				from	procedimento
				where	cd_procedimento = cd_procedimento_w
				and	ie_situacao = 'A';	
				
				-- Se nao encontrar a origem em procedimentos ativos, busca em procedimentos que nao estiverem ativos.
				if (coalesce(ie_origem_proced_w::text, '') = '') then
					select	max(ie_origem_proced)
					into STRICT	ie_origem_proced_w
					from	procedimento
					where	cd_procedimento = cd_procedimento_w;	
				end if;
			end if;
		else
			select	count(1)
			into STRICT	qt_proced_origem_w
			from	procedimento
			where	cd_procedimento = cd_procedimento_w
			and	ie_origem_proced = ie_origem_proced_w;
			--OS667827

			/*Se este procedimento nao existir na origem padrao e selecionado o max origem proced
			OS 644869 Conforme solicitado foi realizado tratamento para caso nao */
			if (qt_proced_origem_w = 0) then	
				-- Buscar a origem do procedimento ativo
				select	coalesce(max(ie_origem_proced),ie_origem_proced_w)
				into STRICT	ie_origem_proced_w
				from	procedimento
				where	cd_procedimento = cd_procedimento_w
				and	ie_origem_proced in (	SELECT	ie_origem_proced
								from	PLS_REGRA_ORIGEM_PROCED
								where	ie_origem_proced !=ie_origem_proced_w );	
			end if;
		end if;
		
		select	count(1)
		into STRICT	qt_proc_valido_w
		from	procedimento
		where	cd_procedimento	= cd_procedimento_w
		and	ie_origem_proced = ie_origem_proced_w;
		
		-- Tem que deixar o item como NAO ENCONTRADO
		if (qt_proc_valido_w = 0) then
			cd_procedimento_w := null;
			ie_origem_proced_w := null;
		end if;
	end if;
	
	-- OS 763014

	--select	max(ie_origem_proced)

	--into	ie_origem_proced_w

	--from	procedimento

	--where	cd_procedimento	= cd_procedimento_w;
	
	insert into ptu_nota_servico(nr_sequencia,
		nr_seq_nota_cobr,
		nr_lote,
		nr_nota,
		cd_unimed_prestador,
		cd_prestador,
		nm_prestador,
		ie_tipo_participacao,
		dt_procedimento,
		ie_tipo_tabela,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_servico,
		nr_seq_material,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento,
		ie_tipo_prestador,
		ie_rede_propria,
		ie_tipo_pessoa_prestador,
		vl_procedimento,
		vl_custo_operacional,
		vl_filme,
		cd_porte_anestesico,
		cd_unimed_pre_req,
		cd_prestador_req,
		ie_via_acesso,
		cd_especialidade,
		nr_seq_nota,
		ds_hora_procedimento,
		cd_cnes_prest,
		nm_profissional_prestador,
		sg_cons_prof_prest,
		nr_cons_prof_prest,
		sg_uf_cons_prest,
		nr_cgc_cpf_req,
		nm_prestador_requisitante,
		sg_cons_prof_req,
		nr_cons_prof_req,
		sg_uf_cons_req,
		ie_reembolso,
		nr_autorizacao,
		nr_cgc_cpf,
		ie_pacote,
		cd_ato,
		tx_procedimento,
		hr_final,
		id_acres_urg_emer,
		nr_cbo_exec,
		tec_utilizada,
		dt_autoriz,
		dt_solicitacao,
		unidade_medida,
		nr_reg_anvisa,
		cd_munic,
		cd_ref_material_fab,
		dt_pgto_prestador,
		vl_adic_procedimento,
		vl_adic_filme,
		vl_adic_co,
		nr_cnpj_fornecedor,
		cd_rec_prestador)
	values (nextval('ptu_nota_servico_seq'),
		nr_seq_cobranca_w,
		nr_lote_704_w,
		nr_nota_704_w,
		cd_unimed_prestador_w,
		cd_prestador_w,
		nm_prestador_w,
		ie_tipo_participacao_w,
		dt_procedimento_w,
		ie_tipo_tabela_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_servico_w,
		nr_seq_material_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_procedimento_w,
		ie_tipo_prestador_w,
		ie_rede_propria_w,
		ie_tipo_pessoa_prestador_w,
		vl_procedimento_w,
		vl_custo_operacional_w,
		vl_filme_w,
		cd_porte_anestesico_w,
		cd_unimed_pre_req_w,
		cd_prestador_req_w,
		ie_via_acesso_w,
		cd_especialidade_w,
		nr_seq_nota_w,
		ds_hora_procedimento_w,
		cd_cnes_prest_w,
		nm_profissional_prestador_w,
		sg_cons_prof_prest_w,
		nr_cons_prof_prest_w,
		sg_uf_cons_prest_w,
		null,
		null,
		null,
		null,
		null,
		ie_reembolso_w,
		nr_autorizacao_w,
		nr_cgc_cpf_w,
		ie_pacote_w,
		cd_ato_w,
		tx_procedimento_w,
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
		0,
		0,
		0,
		nr_cnpj_fornecedor_w,
		cd_rec_prestador_w);
		
	select	max(nr_seq_prest_inter),
		max(tp_pessoa),
		max(nr_cnpj_cpf),
		max(cd_cnes_cont_exec),
		max(cd_munic_cont_exec),
		max(nm_prest_exec)
	into STRICT	nr_seq_prest_inter_w,
		tp_pessoa_w,
		nr_cnpj_cpf_w,
		cd_cnes_cont_exec_w,
		cd_munic_cont_exec_w,
		nm_prestador_w
	from	ptu_nota_cobranca
	where	nr_sequencia		= nr_seq_cobranca_w;
	
	if (coalesce(nr_seq_prest_inter_w::text, '') = '') then
		if (tp_pessoa_w = 'J') then
			cd_cgc_prestador_w		:= nr_cnpj_cpf_w;
			nr_cpf_prestador_w		:= null;
		elsif (tp_pessoa_w = 'F') then
			cd_cgc_prestador_w		:= null;
			nr_cpf_prestador_w		:= substr(nr_cnpj_cpf_w,4,11);
		end if;
		
		SELECT * FROM pls_gerar_prest_intercambio(	nr_cpf_prestador_w, cd_cgc_prestador_w, nm_prestador_w, cd_cnes_cont_exec_w, cd_munic_cont_exec_w, nm_usuario_p, null, nr_cbo_exec_w, nr_seq_prest_inter_w, nr_seq_prestador_w) INTO STRICT nr_seq_prest_inter_w, nr_seq_prestador_w;
		
		if (nr_seq_prest_inter_w IS NOT NULL AND nr_seq_prest_inter_w::text <> '') then
			update	ptu_nota_cobranca
			set	nr_seq_prest_inter	= nr_seq_prest_inter_w
			where	nr_sequencia		= nr_seq_cobranca_w;
		end if;
	end if;
end if;

if (ds_registro_w = '705') then
	
	nr_lote_705_w := null;
	if ((substr(ds_conteudo_p,12,8))::numeric  > 0) then
		nr_lote_705_w := (substr(ds_conteudo_p,12,8))::numeric;
	end if;
	
	nr_nota_705_w		:= trim(both substr(ds_conteudo_p,132,20));
	ie_tipo_complemento_w	:= (substr(ds_conteudo_p,31,1))::numeric;
	ds_complemento_w	:= trim(both substr(ds_conteudo_p,32,100));
	especif_material_w	:= trim(both substr(ds_conteudo_p,152,500));
	
	insert into ptu_nota_complemento(nr_sequencia,
		nr_seq_nota_cobr,
		nr_lote,
		nr_nota,
		ie_tipo_complemento,
		ds_complemento,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		especif_material)
	values (nextval('ptu_nota_complemento_seq'),
		nr_seq_cobranca_w,
		nr_lote_705_w,
		nr_nota_705_w,
		ie_tipo_complemento_w,
		ds_complemento_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		especif_material_w);
end if;

if (ds_registro_w = '709') then
	vl_procedimento_w := 0;
	if ((substr(ds_conteudo_p,53,14))::numeric  > 0) then
		vl_procedimento_w := (substr(ds_conteudo_p,53,12)||','|| substr(ds_conteudo_p,65,2))::numeric;
	end if;
	
	vl_custo_operacional_w := 0;
	if ((substr(ds_conteudo_p,67,14))::numeric  > 0) then
		vl_custo_operacional_w := (substr(ds_conteudo_p,67,12)||','|| substr(ds_conteudo_p,79,2))::numeric;
	end if;

	vl_filme_w := 0;
	if ((substr(ds_conteudo_p,81,14))::numeric  > 0) then
		vl_filme_w := (substr(ds_conteudo_p,81,12)||','|| substr(ds_conteudo_p,93,2))::numeric;
	end if;
	
	update	ptu_servico_pre_pagto
	set	vl_tot_serv	= vl_procedimento_w,
		vl_tot_co	= vl_custo_operacional_w,
		vl_tot_filme	= vl_filme_w
	where	nr_sequencia	= nr_seq_servico_w;
end if;

if (ds_registro_w = '998') then
	update	ptu_servico_pre_pagto
	set	ds_hash		= trim(both substr(ds_conteudo_p,12,32))
	where	nr_sequencia	= nr_seq_servico_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_importar_arq_a700_v110a ( ds_conteudo_p text, nm_arquivo_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_versao_p INOUT text) FROM PUBLIC;

