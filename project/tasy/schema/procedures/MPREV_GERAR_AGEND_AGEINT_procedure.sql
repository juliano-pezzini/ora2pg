-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_gerar_agend_ageint ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, dt_prevista_p timestamp, nr_seq_partic_ciclo_item_p mprev_partic_ciclo_item.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_pf_usuario_logado_p pessoa_fisica.cd_pessoa_fisica%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_captacao_p mprev_captacao.nr_sequencia%type, nr_seq_agenda_integrada_p INOUT agenda_integrada.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Gerar agendamento na Agenda integrada para participantes da medicina preventiva
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_pessoa_responsavel_w		mprev_equipe.cd_pessoa_responsavel%type;
ds_lista_responsaveis_w		varchar(255);
lista_responsaveis_w		dbms_sql.varchar2_table;
dt_nascimento_w			pessoa_fisica.dt_nascimento%type;
nm_paciente_w			pessoa_fisica.nm_pessoa_fisica%type;
nr_seq_status_w			agenda_integrada_status.nr_sequencia%type;
nr_sequencia_w			agenda_integrada.nr_sequencia%type;
nr_seq_item_w			agenda_integrada_item.nr_sequencia%type;
ie_sexo_w			pessoa_fisica.ie_sexo%type;
nr_seq_motivo_agendamento_w	motivo_agendamento.nr_sequencia%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
ie_classif_agenda_w		agenda_classif.cd_classificacao%type;
cd_procedencia_w		procedencia.cd_procedencia%type;

cd_convenio_w			integer;
cd_categoria_w			varchar(10);
cd_usuario_convenio_w		varchar(30);
cd_pessoa_fisica_bene_w 	varchar(10);
nm_pessoa_fisica_bene_w 	varchar(60);
ie_situacao_atend_bene_w 	varchar(1);
ds_abort_bene_w 		varchar(500);
dt_validade_carteira_w 		timestamp;
cd_plano_w 			varchar(10);
nr_doc_convenio_w		varchar(20) := null;
cd_tipo_acomodacao_w		smallint := null;
ds_observacao_w			varchar(4000);
param_agenda_integrada_w	varchar(2);
cd_especialidade_w		especialidade_medica.cd_especialidade%type;
ie_tipo_atendimento_w	agenda_integrada.ie_tipo_atendimento%type;

BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	nm_paciente_w := substr(obter_nome_pf(cd_pessoa_fisica_p),1,60);

	select	nextval('agenda_integrada_seq')
	into STRICT	nr_sequencia_w
	;

	SELECT 	MAX(nr_sequencia)
	into STRICT	nr_seq_status_w
	FROM 	agenda_integrada_status
	WHERE 	ie_status_tasy = 'EA'
	and	coalesce(IE_SITUACAO,'A') = 'A';

	select	max(dt_nascimento),
			max(ie_sexo)
	into STRICT	dt_nascimento_w,
			ie_sexo_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> '') then
		nr_seq_segurado_w := mprev_obter_dados_captacao(nr_seq_captacao_p, clock_timestamp(), 'BN');
	else
		nr_seq_segurado_w := mprev_obter_benef_partic(null, cd_pessoa_fisica_p);
	end if;

	select	max(a.ie_classif_agenda),
			max(a.cd_procedencia),
			max(a.ie_tipo_atendimento)
	into STRICT	ie_classif_agenda_w,
			cd_procedencia_w,
			ie_tipo_atendimento_w
	from	hdm_regra_gerar_agenda a,
			hdm_regra_ger_agenda_perf b
	where	a.nr_sequencia 	= b.nr_seq_gerar_agenda
	and		a.ie_situacao = 'A'
	and		b.cd_perfil 	= Obter_Perfil_Ativo
	and		((a.ie_captacao = 'S' and (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> ''))
			or (a.ie_acomp_plano = 'S' and (nr_seq_partic_ciclo_item_p IS NOT NULL AND nr_seq_partic_ciclo_item_p::text <> '')));

	if (coalesce(ie_classif_agenda_w::text, '') = '') then
		select	max(a.ie_classif_agenda),
				max(a.cd_procedencia),
				max(a.ie_tipo_atendimento)
		into STRICT	ie_classif_agenda_w,
				cd_procedencia_w,
				ie_tipo_atendimento_w
		from	hdm_regra_gerar_agenda a
		where	a.ie_situacao = 'A'
		and (SELECT	count(*) count
				from	hdm_regra_ger_agenda_perf b
				where	a.nr_sequencia 	= b.nr_seq_gerar_agenda
				and	(b.cd_perfil IS NOT NULL AND b.cd_perfil::text <> '')) = 0
		and		((a.ie_captacao = 'S' and (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> ''))
				or (a.ie_acomp_plano = 'S' and (nr_seq_partic_ciclo_item_p IS NOT NULL AND nr_seq_partic_ciclo_item_p::text <> '')));
	end if;

	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '')then
		SELECT * FROM obter_dados_segurado_agenda(nr_seq_segurado_w, nm_usuario_p, cd_estabelecimento_p, cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, cd_pessoa_fisica_bene_w, nm_pessoa_fisica_bene_w, ie_situacao_atend_bene_w, ds_abort_bene_w, dt_validade_carteira_w, cd_plano_w, ie_tipo_atendimento_w) INTO STRICT cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, cd_pessoa_fisica_bene_w, nm_pessoa_fisica_bene_w, ie_situacao_atend_bene_w, ds_abort_bene_w, dt_validade_carteira_w, cd_plano_w;
	else
		param_agenda_integrada_w	:= coalesce(obter_valor_param_usuario(869, 13, Obter_Perfil_Ativo, nm_usuario_p, 0), 'N');

		if (param_agenda_integrada_w in ('AG', 'AT')) then
			SELECT * FROM gerar_convenio_ageint(	cd_pessoa_fisica_p, null, nr_sequencia_w, param_agenda_integrada_w, cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_carteira_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, nm_usuario_p, ds_observacao_w) INTO STRICT cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_carteira_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, ds_observacao_w;
		end if;
	end if;

	insert 	into agenda_integrada(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, dt_inicio_agendamento,
			dt_fim_agendamento, nr_seq_status, cd_pessoa_fisica,
			nm_paciente, dt_nascimento, ie_turno,
			dt_prevista, cd_estabelecimento, ie_sexo,
			cd_categoria, cd_convenio, cd_plano,
			cd_usuario_convenio, dt_validade_carteira, nr_doc_convenio,
			cd_procedencia, nr_seq_captacao, nr_seq_partic_ciclo_item)
		values (nr_sequencia_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, clock_timestamp(),
			null, nr_seq_status_w, cd_pessoa_fisica_p,
			nm_paciente_w, dt_nascimento_w, 2,
			dt_prevista_p, cd_estabelecimento_p, ie_sexo_w,
			cd_categoria_w, cd_convenio_w, cd_plano_w,
			cd_usuario_convenio_w, dt_validade_carteira_w, nr_doc_convenio_w,
			cd_procedencia_w, nr_seq_captacao_p, nr_seq_partic_ciclo_item_p);

	/*Entra no if caso a procedure for chamada pela função HDM - Acompanhamento do plano de atendimento*/

	if (nr_seq_partic_ciclo_item_p IS NOT NULL AND nr_seq_partic_ciclo_item_p::text <> '') then

		ds_lista_responsaveis_w	:= mprev_obter_profissionais(nr_seq_partic_ciclo_item_p);

		/*Busca a sequencia do motivo do agendamento do atendimento previsto gerado manualmente*/

		select	a.nr_seq_motivo_agendamento
		into STRICT	nr_seq_motivo_agendamento_w
		from	mprev_partic_ciclo_item a
		where	nr_sequencia = nr_seq_partic_ciclo_item_p;

	end if;

	/*Entra no if caso a procedure for chamada pela função HDM - Captação*/

	if (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> '') then
		/*Busca o responsável pela equipe da pessoa fisica logada. Caso a pessoa fisica não for responsável de equipe vai retornar
		o responsável sa equipe que ele pertence.*/
		ds_lista_responsaveis_w	:= mprev_obter_prof_captacao(nr_seq_captacao_p);

		if (coalesce(ds_lista_responsaveis_w::text, '') = '') then
			ds_lista_responsaveis_w	:= mprev_obter_resp_equipe_pf(cd_pf_usuario_logado_p);
		end if;
		/*Motivo padrão ao gerar agendamento na Agenda Integrada. Parâmetro [7] da função HDM - Captação.*/

		nr_seq_motivo_agendamento_w	:= obter_valor_param_usuario(10155, 7, Obter_Perfil_Ativo, nm_usuario_p, 0);
	end if;
	-- 4º ¿ usuário logado
	if (coalesce(ds_lista_responsaveis_w::text, '') = '') then
		--Atribui cd_pessoa_fisica do usuário logado como responsável pela equipe
		ds_lista_responsaveis_w := cd_pf_usuario_logado_p;
	end if;

	lista_responsaveis_w := obter_lista_string(ds_lista_responsaveis_w, ',');

	for	i in lista_responsaveis_w.first..lista_responsaveis_w.last loop
		cd_pessoa_responsavel_w	:= lista_responsaveis_w(i);

		select 	hdm_obter_espec_ageint(cd_pessoa_responsavel_w, cd_estabelecimento_p)
		into STRICT	cd_especialidade_w
		;

		select	nextval('agenda_integrada_item_seq')
		into STRICT	nr_seq_item_w
		;

		insert 	into agenda_integrada_item(nr_sequencia, nr_seq_agenda_int, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				ie_tipo_agendamento, cd_medico, dt_prevista_item,
				nr_seq_partic_ciclo_item, nr_seq_motivo_agendamento, nr_seq_captacao,
				ie_classif_agenda, cd_especialidade)
			values (nr_seq_item_w, nr_sequencia_w, clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				'C', cd_pessoa_responsavel_w, null,
				nr_seq_partic_ciclo_item_p, nr_seq_motivo_agendamento_w, nr_seq_captacao_p,
				ie_classif_agenda_w, cd_especialidade_w);
	end loop;

end if;

nr_seq_agenda_integrada_p	:= nr_sequencia_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_gerar_agend_ageint ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, dt_prevista_p timestamp, nr_seq_partic_ciclo_item_p mprev_partic_ciclo_item.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_pf_usuario_logado_p pessoa_fisica.cd_pessoa_fisica%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_captacao_p mprev_captacao.nr_sequencia%type, nr_seq_agenda_integrada_p INOUT agenda_integrada.nr_sequencia%type) FROM PUBLIC;
