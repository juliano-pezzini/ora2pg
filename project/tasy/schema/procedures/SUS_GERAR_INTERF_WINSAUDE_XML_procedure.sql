-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_interf_winsaude_xml ( dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
dt_inicial_w		timestamp;
dt_final_w 		timestamp;
nm_razao_social_w		varchar(70);
nm_fantasia_w		varchar(70);
nr_cnpj_w		varchar(14);
nr_cnes_w		varchar(7);
cd_mun_ibge_estab_w 	varchar(6);
cd_medico_executor_w	varchar(15);
cd_med_exec_anterior_w	varchar(15)	:= '';
cd_medico_w		smallint	:= 0;
nm_medico_w 		varchar(70);
dt_nasc_medico_w		timestamp;
nr_cpf_medico_w		varchar(11);
nr_cns_medico_w		varchar(15);
cd_mun_ibge_medico_w	varchar(6);
cd_cbo_w		varchar(6);
ds_cbo_w		varchar(60);
nr_atendimento_w	bigint;
dt_entrada_w		timestamp;
hr_entrada_w		timestamp;
ie_carater_atend_w		varchar(2);
nm_paciente_w		varchar(70);
dt_nascimento_w		timestamp;
ie_sexo_w		varchar(1);
nr_cns_w			varchar(15);
nr_cpf_w 			varchar(11);
nm_mae_w		varchar(70);
nm_pai_w		varchar(70);
cd_municipio_ibge_w	varchar(6);
cd_procedimento_w	varchar(9);
cd_cid_w			varchar(4);
qt_procedimento_w		varchar(9);
ds_detalhamento_w		varchar(2000);

C01 CURSOR FOR 
	SELECT	a.nr_atendimento, 
		a.dt_entrada, 
		a.ie_carater_inter_sus, 
		substr(elimina_caractere_especial(obter_nome_pf(a.cd_pessoa_fisica)),1,70) nm_paciente, 
		substr(obter_dados_pf(a.cd_pessoa_fisica,'DN'),1,10) dt_nascimento, 
		substr(obter_dados_pf(a.cd_pessoa_fisica,'SE'),1,1) ie_sexo, 
		substr(obter_dados_pf(a.cd_pessoa_fisica,'CNS'),1,15) nr_cns, 
		substr(replace(replace(obter_dados_pf(a.cd_pessoa_fisica,'CPF'),'.',''),'-',''),1,11) nr_cpf, 
		substr(elimina_caractere_especial(obter_compl_pf(a.cd_pessoa_fisica,5,'N')),1,70) nm_mae, 
		substr(elimina_caractere_especial(obter_compl_pf(a.cd_pessoa_fisica,4,'N')),1,70) nm_pai, 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CDM'),1,6) cd_municipio_ibge, 
		lpad(substr(to_char(c.cd_procedimento),1,8),9,'0') cd_procedimento, 
		substr(c.cd_doenca_cid,1,4) cd_cid, 
		sum(qt_procedimento) qt_procedimento 
	from	procedimento_paciente c, 
		conta_paciente b, 
		atendimento_paciente a 
	where	c.nr_interno_conta 	= b.nr_interno_conta 
	and	b.nr_atendimento	= a.nr_atendimento 
	and	a.ie_tipo_atendimento in (3,8) 
	and	obter_tipo_convenio(obter_convenio_atendimento(a.nr_atendimento)) = 3 
	and	trunc(a.dt_entrada) between trunc(dt_inicial_p) and trunc(dt_final_p) 
	and	c.cd_medico_executor = cd_medico_executor_w 
	and (coalesce(c.cd_cbo,'0') = coalesce(cd_cbo_w,'0')) 
	and	coalesce(c.cd_motivo_exc_conta::text, '') = '' 
	and	c.ie_origem_proced = 7 
	group by	a.nr_atendimento, 
		a.dt_entrada, 
		a.ie_carater_inter_sus, 
		substr(elimina_caractere_especial(obter_nome_pf(a.cd_pessoa_fisica)),1,70), 
		substr(obter_dados_pf(a.cd_pessoa_fisica,'DN'),1,10), 
		substr(obter_dados_pf(a.cd_pessoa_fisica,'SE'),1,1), 
		substr(obter_dados_pf(a.cd_pessoa_fisica,'CNS'),1,15), 
		substr(replace(replace(obter_dados_pf(a.cd_pessoa_fisica,'CPF'),'.',''),'-',''),1,11), 
		substr(elimina_caractere_especial(obter_compl_pf(a.cd_pessoa_fisica,5,'N')),1,70), 
		substr(elimina_caractere_especial(obter_compl_pf(a.cd_pessoa_fisica,4,'N')),1,70), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CDM'),1,6), 
		lpad(substr(to_char(c.cd_procedimento),1,8),9,'0'), 
		substr(c.cd_doenca_cid,1,4) 
	order by dt_entrada, nm_paciente;

C02 CURSOR FOR 
	SELECT	c.cd_medico_executor, 
		substr(elimina_caractere_especial(obter_nome_pf(c.cd_medico_executor)),1,70) nm_medico, 
		substr(obter_dados_pf(c.cd_medico_executor,'DN'),1,10) dt_nasc_medico, 
		substr(replace(replace(obter_dados_pf(c.cd_medico_executor,'CPF'),'.',''),'-',''),1,11) nr_cpf_medico, 
		substr(obter_dados_pf(c.cd_medico_executor,'CNS'),1,15) nr_cns_medico, 
		substr(obter_compl_pf(c.cd_medico_executor,1,'CDM'),1,6) cd_mun_ibge_medico, 
		c.cd_cbo, 
		substr(sus_obter_desc_cbo(c.cd_cbo),1,60) ds_cbo 
	from	procedimento_paciente c, 
		conta_paciente b, 
		atendimento_paciente a 
	where	c.nr_interno_conta 	= b.nr_interno_conta 
	and	b.nr_atendimento	= a.nr_atendimento 
	and	a.ie_tipo_atendimento in (3,8) 
	and	obter_tipo_convenio(obter_convenio_atendimento(a.nr_atendimento)) = 3 
	and	trunc(a.dt_entrada) between trunc(dt_inicial_p) and trunc(dt_final_p) 
	and	(c.cd_medico_executor IS NOT NULL AND c.cd_medico_executor::text <> '') 
	and	coalesce(c.cd_motivo_exc_conta::text, '') = '' 
	and	c.ie_origem_proced = 7 
	group by	c.cd_medico_executor, 
		substr(elimina_caractere_especial(obter_nome_pf(c.cd_medico_executor)),1,70), 
		substr(obter_dados_pf(c.cd_medico_executor,'DN'),1,10), 
		substr(replace(replace(obter_dados_pf(c.cd_medico_executor,'CPF'),'.',''),'-',''),1,11), 
		substr(obter_dados_pf(c.cd_medico_executor,'CNS'),1,15), 
		substr(obter_compl_pf(c.cd_medico_executor,1,'CDM'),1,6), 
		c.cd_cbo, 
		substr(sus_obter_desc_cbo(c.cd_cbo),1,60) 
	order by nm_medico;


BEGIN 
 
delete 	from w_interf_winsaude_cab 
where	trunc(dt_inicial)	= trunc(dt_inicial_p) 
and	trunc(dt_final)		= trunc(dt_final_p);
 
delete 	from w_interf_winsaude_med 
where	trunc(dt_inicial)	= trunc(dt_inicial_p) 
and	trunc(dt_final)		= trunc(dt_final_p);
 
delete 	from w_interf_winsaude_xml 
where	trunc(dt_inicial)	= trunc(dt_inicial_p) 
and	trunc(dt_final)		= trunc(dt_final_p);
 
begin 
select	max(c.nm_razao_social), 
	max(c.ds_nome_curto), 
	max(b.cd_cgc), 
	max(a.cd_cnes_hospital), 
	max(d.cd_municipio_ibge) 
into STRICT	nm_razao_social_w, 
	nm_fantasia_w, 
	nr_cnpj_w, 
	nr_cnes_w, 
	cd_mun_ibge_estab_w 
from	pessoa_juridica d, 
	empresa c, 
	estabelecimento b,	 
	sus_parametros_bpa a 
where	c.cd_empresa 		= b.cd_empresa 
and	b.cd_cgc		= d.cd_cgc 
and	b.cd_estabelecimento 	= a.cd_estabelecimento 
and	a.cd_estabelecimento 	= cd_estabelecimento_p;
exception 
when others then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(182909);
end;
 
insert into w_interf_winsaude_cab(	 
	nr_sequencia, 
	dt_inicial, 
	dt_final, 
	nm_fantasia, 
	nm_razao_social, 
	nr_cnes, 
	cd_cnpj, 
	cd_mun_ibge_estab, 
	dt_atualizacao, 
	dt_atualizacao_nrec, 
	nm_usuario, 
	nm_usuario_nrec) 
values (	nextval('w_interf_winsaude_cab_seq'), 
	trunc(dt_inicial_p), 
	trunc(dt_final_p), 
	nm_razao_social_w, 
	nm_fantasia_w, 
	nr_cnes_w, 
	nr_cnpj_w, 
	cd_mun_ibge_estab_w, 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p);
	 
open C02;
loop 
fetch C02 into	 
	cd_medico_executor_w, 
	nm_medico_w, 
	dt_nasc_medico_w, 
	nr_cpf_medico_w, 
	nr_cns_medico_w, 
	cd_mun_ibge_medico_w, 
	cd_cbo_w, 
	ds_cbo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	 
	if (coalesce(cd_med_exec_anterior_w,'X') <> cd_medico_executor_w) then 
		begin		 
		cd_medico_w := cd_medico_w + 1;
		end;
	end if;
	 
	insert into w_interf_winsaude_med( 
		nr_sequencia, 
		dt_inicial, 
		dt_final, 
		cd_medico_executor, 
		cd_medico, 
		nm_medico, 
		nr_cpf_medico, 
		nr_cns_medico, 
		dt_nasc_medico, 
		cd_mun_ibge_medico, 
		cd_cbo, 
		ds_cbo, 
		dt_atualizacao, 
		dt_atualizacao_nrec, 
		nm_usuario, 
		nm_usuario_nrec) 
	values ( nextval('w_interf_winsaude_med_seq'), 
		trunc(dt_inicial_p), 
		trunc(dt_final_p), 
		cd_medico_executor_w, 
		cd_medico_w, 
		nm_medico_w, 
		nr_cpf_medico_w, 
		nr_cns_medico_w, 
		dt_nasc_medico_w, 
		cd_mun_ibge_medico_w, 
		cd_cbo_w, 
		ds_cbo_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		nm_usuario_p, 
		nm_usuario_p);
		 
	cd_med_exec_anterior_w := cd_medico_executor_w;
	 
	open C01;
	loop 
	fetch C01 into 
		nr_atendimento_w,	 
		dt_entrada_w, 
		ie_carater_atend_w, 
		nm_paciente_w, 
		dt_nascimento_w, 
		ie_sexo_w, 
		nr_cns_w, 
		nr_cpf_w, 
		nm_mae_w, 
		nm_pai_w, 
		cd_municipio_ibge_w, 
		cd_procedimento_w, 
		cd_cid_w, 
		qt_procedimento_w;	
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		insert into w_interf_winsaude_xml( 
			nr_sequencia, 
			dt_inicial, 
			dt_final, 
			cd_cbo, 
			cd_medico, 
			nr_atendimento, 
			dt_entrada, 
			ie_carater_atend, 
			nm_paciente, 
			dt_nascimento, 
			ie_sexo, 
			nr_cns, 
			nr_cpf, 
			nm_mae, 
			nm_pai, 
			cd_municipio_ibge, 
			cd_procedimento, 
			cd_cid, 
			qt_procedimento, 
			ds_detalhamento, 
			dt_atualizacao, 
			dt_atualizacao_nrec, 
			nm_usuario,   
			nm_usuario_nrec) 
		values ( nextval('w_interf_winsaude_xml_seq'), 
			trunc(dt_inicial_p), 
			trunc(dt_final_p), 
			cd_cbo_w, 
			cd_medico_w, 
			nr_atendimento_w, 
			dt_entrada_w, 
			ie_carater_atend_w, 
			nm_paciente_w, 
			dt_nascimento_w, 
			ie_sexo_w, 
			nr_cns_w, 
			nr_cpf_w, 
			nm_mae_w, 
			nm_pai_w, 
			cd_municipio_ibge_w, 
			cd_procedimento_w, 
			cd_cid_w, 
			qt_procedimento_w, 
			'', 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_p);
		end;
	end loop;
	close C01;
		 
	end;
end loop;
close C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_interf_winsaude_xml ( dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

