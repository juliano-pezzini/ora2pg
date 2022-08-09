-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_senha_autorizacao (cd_senha_p text, hr_inicio_p timestamp, cd_agenda_p text, nm_usuario_p text) AS $body$
DECLARE

							  
nr_atendimento_w  	 bigint;
cd_pessoa_fisica_w	 varchar(10);
cd_convenio_w		 integer;
ie_carater_int_w	 varchar(2);
cd_medico_solic_w	 varchar(10);
cd_procedimento_princ_w	 bigint;
cd_senha_w		 varchar(20);	
cd_categoria_w		 varchar(10);
cd_plano_convenio_w	 varchar(10);
cd_usuario_convenio_w	 varchar(30);
dt_nascimento_w		 timestamp;
qt_idade_w		 smallint;
qt_idade_mes_w		 smallint;
ie_origem_proced_w	bigint;	
dt_agenda_w		timestamp;
hr_inicio_w		timestamp;
cd_agenda_w		bigint;
cd_estabelecimento_ww	bigint;
dt_agenda_consiste_w	timestamp;
nr_telefone_w		varchar(255);
cd_doenca_cid_w		varchar(10);


BEGIN

if (cd_senha_p IS NOT NULL AND cd_senha_p::text <> '') then
	
	SELECT 	MAX(a.nr_atendimento),
		MAX(a.cd_pessoa_fisica),
		MAX(a.cd_convenio),
		MAX(a.ie_carater_int_tiss),
		MAX(a.cd_medico_solicitante),
		MAX(a.cd_procedimento_principal),
		MAX(a.cd_senha),
		MAX(b.cd_categoria),
		MAX(b.cd_plano_convenio),
		MAX(b.cd_usuario_convenio),
		max(to_date(obter_dados_pf(a.cd_pessoa_fisica,'DN'),'dd/mm/yyyy')),
		max((obter_dados_pf(a.cd_pessoa_fisica,'I'))::numeric ),
		max(campo_numerico(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),clock_timestamp(),'MM'))),
		max(ie_origem_proced),
		max(obter_fone_pac_agenda(a.cd_pessoa_fisica))
	into STRICT	nr_atendimento_w,
		cd_pessoa_fisica_w,
		cd_convenio_w,
		ie_carater_int_w,
		cd_medico_solic_w,
		cd_procedimento_princ_w,
		cd_senha_w,
		cd_categoria_w,
		cd_plano_convenio_w,
		cd_usuario_convenio_w,
		dt_nascimento_w,
		qt_idade_w,
		qt_idade_mes_w,
		ie_origem_proced_w,
		nr_telefone_w
	FROM    autorizacao_convenio_tiss b,
		autorizacao_convenio a
	WHERE   a.cd_senha = cd_senha_p
	AND     b.nr_sequencia_autor = a.nr_sequencia;
	
	select  max(cd_doenca)
	into STRICT	cd_doenca_cid_w
	from    autor_diag_medico a,
		autor_diag_doenca b,
	        autorizacao_convenio c
        where   a.nr_sequencia = b.nr_seq_autor_diag
	and     a.nr_sequencia_autor = c.nr_sequencia
	and	c.cd_senha = cd_senha_p;
		
end if;




if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (hr_inicio_p IS NOT NULL AND hr_inicio_p::text <> '') then
					
	update  agenda_paciente
	set	nr_atendimento		=   nr_atendimento_w,
		cd_pessoa_fisica	=   cd_pessoa_fisica_w,
		cd_convenio		=   cd_convenio_w,
		ie_carater_cirurgia	=   ie_carater_int_w,
		cd_usuario_convenio	=   cd_usuario_convenio_w,
		cd_categoria		=   cd_categoria_w,
		cd_plano		=   cd_plano_convenio_w,
		cd_procedimento		=   cd_procedimento_princ_w,
		cd_medico		=   cd_medico_solic_w,
		DS_SENHA		=   cd_senha_w,
		dt_agendamento		=   clock_timestamp(),
		nm_usuario_orig		=   nm_usuario_p,
		dt_atualizacao		=   clock_timestamp(),
		nm_usuario		=   nm_usuario_p,
		nm_paciente		=   obter_nome_pf(cd_pessoa_fisica_w),	
		dt_nascimento_pac	=   dt_nascimento_w,
		qt_idade_paciente	=   qt_idade_w,
		qt_idade_mes		=   qt_idade_mes_w,
		ie_status_agenda	=   'N',
		ie_origem_proced	=   ie_origem_proced_w,
		ie_autorizacao 		=   'PA',
		nr_telefone		=   nr_telefone_w,
		cd_doenca_cid		=   cd_doenca_cid_w
	where	cd_agenda		=   cd_agenda_p
	and 	hr_inicio		=   hr_inicio_p
	and 	ie_status_agenda 	=   'L';
	if	NOT FOUND then
		-- Ocorreu um erro com o horário de destino! '||chr(13) || chr(10)|| 'Favor atualizar a tela de agendamentos e efetuar o processo  novamente.#@#@
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(264441);
	end if;					
commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_senha_autorizacao (cd_senha_p text, hr_inicio_p timestamp, cd_agenda_p text, nm_usuario_p text) FROM PUBLIC;
