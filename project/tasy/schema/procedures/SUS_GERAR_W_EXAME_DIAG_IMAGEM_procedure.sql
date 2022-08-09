-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_w_exame_diag_imagem (dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
cd_unidade_w			bigint;
qt_registros_w			bigint;
tp_linha_w			bigint;
ds_linha_w			varchar(2000);
nr_sequencia_w			bigint;
cd_exame_w 			varchar(20);
cd_paciente_unidade_w 		varchar(10);
ds_bairro_w 			varchar(45);
ds_cep_w 			varchar(9);
ds_email_w 			varchar(40);
ds_endereco_w 			varchar(60);
ds_municipio_w 			varchar(45);
ds_uf_w 			varchar(2);
dt_procedimento_w 		timestamp;
dt_agenda_w 			varchar(10);
dt_hor_ini_w 			varchar(5);
dt_nascimento_w 		timestamp;
ie_sexo_w 			varchar(1);
ie_tipo_atendimento_w 		smallint;
nm_contato_w 			varchar(45);
nm_mae_w 			varchar(60);
nm_paciente_w 			varchar(60);
nm_pai_w 			varchar(60);
nr_atendimento_w 		bigint;
nr_cns_w 			varchar(20);
nr_contato_tel_w 		varchar(8);
nr_contato_tel_ddd_w 		varchar(2);
nr_cpf_w 			varchar(25);
nr_endereco_w 			varchar(5);
nr_interno_conta_w 		bigint;
nr_prontuario_w 		bigint;
nr_rg_w 			varchar(20);
nr_seq_proc_w 			bigint;
nr_tel_celular_w 		varchar(8);
nr_tel_celular_ddd_w 		varchar(2);
nr_tel_com_w 			varchar(8);
nr_tel_com_ddd_w 		varchar(2);
nr_tel_com_ramal_w 		varchar(5);
nr_tel_res_w 			varchar(8);
nr_tel_res_ddd_w 		varchar(2);
cd_municipio_ibge_w		varchar(7);
					
C01 CURSOR FOR 
	SELECT	1 tp_linha, 
		'COD_UNIDADE;DT_ENVIO' 
	 
	where	qt_registros_w > 0 
	
union all
 
	SELECT	2 tp_linha, 
		cd_unidade_w||';'||to_char(clock_timestamp(),'yyyy-mm-dd') 
	 
	where	qt_registros_w > 0 
	
union all
 
	select	3 tp_linha, 
		'ID_EXAME;DATA_AGENDA;HOR_INI;ID_PACIENTE_UNIDADE;NOME_PACIENTE;'|| 
		'NUM_CNS;NUM_PRONTUARIO;SEXO;DT_NASCIMENTO;RG;CPF;NOME_MAE;'|| 
		'NOME_PAI;ENDERECO;ENDERECO_NUMERO;BAIRRO;MUNICIPIO;CODMUNGEST;UF;CEP;'|| 
		'TEL_RES_DDD;TEL_RES;TEL_CELULAR_DDD;TEL_CELULAR;TEL_COM_DDD;'|| 
		'TEL_COM;TEL_COM_RAMAL;EMAIL;CONTATO_NOME;CONTATO_TEL_DDD;CONTATO_TEL' 
	 
	where	qt_registros_w > 0 
	order by 1;	
 
C02 CURSOR FOR 
	SELECT	4 tp_linha, 
		Obter_Proc_Interno(a.nr_seq_proc_interno,'CI') cd_exame, 
		a.dt_procedimento, 
		d.cd_pessoa_fisica, 
		d.nm_pessoa_fisica, 
		d.nr_cartao_nac_sus, 
		d.nr_prontuario, 
		d.ie_sexo, 
		d.dt_nascimento, 
		d.nr_identidade, 
		d.nr_cpf, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,5,'N'),1,60) nm_mae, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,4,'N'),1,60) nm_pai, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'EN'),1,60) ds_endereco, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'NR'),1,5) nr_endereco, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'B'),1,45) ds_bairro, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'DM'),1,45) ds_municipio, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'CDM')||calcula_digito('MODULO10',obter_compl_pf(d.cd_pessoa_fisica,1,'CDM')),1,7) cd_municipio_ibge,		 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'UF'),1,2) ds_uf, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'CEP'),1,5)||'-'||substr(obter_compl_pf(d.cd_pessoa_fisica,1,'CEP'),6,8) cd_cep, 
		substr((somente_numero(obter_compl_pf(d.cd_pessoa_fisica,1,'DDT')))::numeric ,1,2) nr_ddd_res, 
		substr(somente_numero(obter_compl_pf(d.cd_pessoa_fisica,1,'T')),1,8) nr_tel_res, 
		substr((somente_numero(d.nr_ddd_celular))::numeric ,1,2) nr_ddd_cel, 
		substr(somente_numero(d.nr_telefone_celular),1,8) nr_tel_cel, 
		substr((somente_numero(obter_compl_pf(d.cd_pessoa_fisica,2,'DDT')))::numeric ,1,2) nr_ddd_com, 
		substr(somente_numero(obter_compl_pf(d.cd_pessoa_fisica,2,'T')),1,8) nr_tel_com, 
		substr(somente_numero(obter_compl_pf(d.cd_pessoa_fisica,2,'RAM')),1,5) nr_ram_com, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'M'),1,40) ds_email, 
		substr(obter_compl_pf(d.cd_pessoa_fisica,1,'N'),1,45) nm_contato, 
		substr((somente_numero(obter_compl_pf(d.cd_pessoa_fisica,1,'DDT')))::numeric ,1,2) nr_ddd_con, 
		substr(somente_numero(obter_compl_pf(d.cd_pessoa_fisica,1,'T')),1,8) nr_tel_con, 
		a.nr_interno_conta, 
		a.nr_sequencia, 
		a.nr_atendimento 
	from	pessoa_fisica d, 
		procedimento_paciente a, 
		conta_paciente b, 
		atendimento_paciente c 
	where	a.nr_interno_conta = b.nr_interno_conta 
	and	b.nr_atendimento = c.nr_atendimento 
	and	c.cd_pessoa_fisica = d.cd_pessoa_fisica 
	and	a.dt_procedimento between dt_inicial_p and dt_final_p 
	and	c.ie_tipo_atendimento = ie_tipo_atendimento_p 
	and	Sus_Obter_Estrut_Proc(a.cd_procedimento,a.ie_origem_proced,'C','S') in (204,205,206,207,210) 
	and	b.cd_convenio_parametro = obter_dados_param_faturamento(cd_estabelecimento_p,'CSUS') 
	order by	dt_procedimento;	
 

BEGIN 
 
cd_unidade_w	:= somente_numero(obter_valor_param_usuario(999, 74, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p));
 
delete from w_exame_diag_imagem_sus 
where 	nm_usuario 	= nm_usuario_p 
and	dt_inicial 	= dt_inicial_p 
and	dt_final	= dt_final_p 
and	ie_tipo_atendimento = ie_tipo_atendimento_p;
 
begin 
select	count(*) 
into STRICT	qt_registros_w 
from	procedimento_paciente a, 
	conta_paciente b, 
	atendimento_paciente c 
where	a.nr_interno_conta = b.nr_interno_conta 
and	b.nr_atendimento = c.nr_atendimento 
and	a.dt_procedimento between dt_inicial_p and dt_final_p 
and	c.ie_tipo_atendimento = ie_tipo_atendimento_p 
and	Sus_Obter_Estrut_Proc(a.cd_procedimento,a.ie_origem_proced,'C','S') in (204,205,206,207,210) 
and	b.cd_convenio_parametro = obter_dados_param_faturamento(cd_estabelecimento_p,'CSUS');
exception 
when others then 
	qt_registros_w := 0;
end;
 
open C01;
loop 
fetch C01 into	 
	tp_linha_w, 
	ds_linha_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	nextval('w_exame_diag_imagem_sus_seq') 
	into STRICT	nr_sequencia_w 
	;
	 
	insert into w_exame_diag_imagem_sus( 
		nr_sequencia,		dt_atualizacao,		nm_usuario, 
		dt_atualizacao_nrec,	nm_usuario_nrec,	cd_unidade, 
		dt_envio,		cd_exame,		dt_agenda, 
		dt_hor_ini,		cd_paciente_unidade,	nm_paciente, 
		nr_cns,			nr_prontuario,		ie_sexo, 
		dt_nascimento,		nr_rg,			nr_cpf, 
		nm_mae,			nm_pai,			ds_endereco, 
		nr_endereco,		ds_bairro,		ds_municipio, 
		ds_uf,			ds_cep,			nr_tel_res_ddd, 
		nr_tel_res,		nr_tel_celular_ddd,	nr_tel_celular, 
		nr_tel_com_ddd,		nr_tel_com,		nr_tel_com_ramal, 
		ds_email,		nm_contato,		nr_contato_tel_ddd, 
		nr_contato_tel,		nr_interno_conta,	nr_seq_proc, 
		nr_atendimento,		ds_linha,		tp_linha, 
		dt_inicial,		dt_final,		ie_tipo_atendimento) 
	values (nr_sequencia_w,		clock_timestamp(),		nm_usuario_p, 
		clock_timestamp(),		nm_usuario_p,		cd_unidade_w, 
		clock_timestamp(),		null,			null, 
		null,			null,			null, 
		null,			null,			null, 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			null,			null,			 
		null,			ds_linha_w,		tp_linha_w, 
		dt_inicial_p,		dt_final_p,		ie_tipo_atendimento_p);	
	end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into	 
	tp_linha_w, 
	cd_exame_w, 
	dt_procedimento_w, 
	cd_paciente_unidade_w, 
	nm_paciente_w, 
	nr_cns_w, 
	nr_prontuario_w, 
	ie_sexo_w, 
	dt_nascimento_w, 
	nr_rg_w, 
	nr_cpf_w, 
	nm_mae_w, 
	nm_pai_w, 
	ds_endereco_w, 
	nr_endereco_w, 
	ds_bairro_w, 
	ds_municipio_w, 
	cd_municipio_ibge_w, 
	ds_uf_w, 
	ds_cep_w, 
	nr_tel_res_ddd_w, 
	nr_tel_res_w, 
	nr_tel_celular_ddd_w, 
	nr_tel_celular_w, 
	nr_tel_com_ddd_w, 
	nr_tel_com_w, 
	nr_tel_com_ramal_w, 
	ds_email_w, 
	nm_contato_w, 
	nr_contato_tel_ddd_w, 
	nr_contato_tel_w, 
	nr_interno_conta_w, 
	nr_seq_proc_w, 
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	 
	select	nextval('w_exame_diag_imagem_sus_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	dt_agenda_w	:= to_char(dt_procedimento_w,'yyyy-mm-dd');
	dt_hor_ini_w 	:= to_char(dt_procedimento_w,'hh24:mi');
	 
	insert into w_exame_diag_imagem_sus( 
		nr_sequencia,		dt_atualizacao,		nm_usuario, 
		dt_atualizacao_nrec,	nm_usuario_nrec,	cd_unidade, 
		dt_envio,		cd_exame,		dt_agenda, 
		dt_hor_ini,		cd_paciente_unidade,	nm_paciente, 
		nr_cns,			nr_prontuario,		ie_sexo, 
		dt_nascimento,		nr_rg,			nr_cpf, 
		nm_mae,			nm_pai,			ds_endereco, 
		nr_endereco,		ds_bairro,		ds_municipio, 
		ds_uf,			ds_cep,			nr_tel_res_ddd, 
		nr_tel_res,		nr_tel_celular_ddd,	nr_tel_celular, 
		nr_tel_com_ddd,		nr_tel_com,		nr_tel_com_ramal, 
		ds_email,		nm_contato,		nr_contato_tel_ddd, 
		nr_contato_tel,		nr_interno_conta,	nr_seq_proc, 
		nr_atendimento,		tp_linha,		dt_inicial,		 
		dt_final,		ie_tipo_atendimento,	cd_municipio_ibge, 
		ds_linha) 
	values (nr_sequencia_w,		clock_timestamp(),		nm_usuario_p, 
		clock_timestamp(),		nm_usuario_p,		cd_unidade_w, 
		clock_timestamp(),		cd_exame_w,		dt_procedimento_w, 
		dt_procedimento_w,	cd_paciente_unidade_w,	nm_paciente_w, 
		nr_cns_w,		nr_prontuario_w,	ie_sexo_w, 
		dt_nascimento_w,	nr_rg_w,		nr_cpf_w, 
		nm_mae_w,		nm_pai_w,		ds_endereco_w, 
		nr_endereco_w,		ds_bairro_w, 		ds_municipio_w, 
		ds_uf_w,		ds_cep_w, 		nr_tel_res_ddd_w, 
		nr_tel_res_w,		nr_tel_celular_ddd_w,	nr_tel_celular_w, 
		nr_tel_com_ddd_w,	nr_tel_com_w,		nr_tel_com_ramal_w, 
		ds_email_w, 		nm_contato_w,		nr_contato_tel_ddd_w, 
		nr_contato_tel_w,	nr_interno_conta_w,	nr_seq_proc_w, 
		nr_atendimento_w,	tp_linha_w,		dt_inicial_p,		 
		dt_final_p,		ie_tipo_atendimento_p,	cd_municipio_ibge_w, 
		cd_exame_w ||';'|| dt_agenda_w ||';'|| dt_hor_ini_w ||';'|| cd_paciente_unidade_w ||';'|| 
		nm_paciente_w ||';'||nr_cns_w ||';'|| nr_prontuario_w ||';'|| ie_sexo_w ||';'|| 
		to_char(dt_nascimento_w,'yyyy-mm-dd') ||';'|| nr_rg_w ||';'|| nr_cpf_w ||';'|| nm_mae_w ||';'|| 
		nm_pai_w ||';'|| ds_endereco_w ||';'|| nr_endereco_w ||';'|| ds_bairro_w ||';'|| 
		ds_municipio_w ||';'|| cd_municipio_ibge_w ||';'|| ds_uf_w ||';'|| ds_cep_w ||';'|| 
		nr_tel_res_ddd_w ||';'|| nr_tel_res_w ||';'|| nr_tel_celular_ddd_w ||';'|| 
		nr_tel_celular_w ||';'|| nr_tel_com_ddd_w ||';'|| nr_tel_com_w ||';'|| nr_tel_com_ramal_w||';'|| 
		ds_email_w ||';'||nm_contato_w ||';'|| nr_contato_tel_ddd_w ||';'|| nr_contato_tel_w);		
	 
	end;
end loop;
close C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_w_exame_diag_imagem (dt_inicial_p timestamp, dt_final_p timestamp, ie_tipo_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
