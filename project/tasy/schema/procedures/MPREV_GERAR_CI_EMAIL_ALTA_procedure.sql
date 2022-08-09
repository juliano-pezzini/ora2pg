-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_gerar_ci_email_alta ( nr_seq_participante_p mprev_participante.nr_sequencia%type, nr_seq_programa_partic_p mprev_programa_partic.nr_sequencia%type, ie_gerar_ci_p mprev_atend_previsto_alta.ie_gerar_ci%type, ie_gerar_email_p mprev_atend_previsto_alta.ie_gerar_email%type, dt_prevista_p timestamp, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_alta_p timestamp, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar comunicação interna e ou e-mail para os responsáveis pelo programa quando o participante recebe alta
informando que foi gerado um atendimento previsto na HDM - Acompanhamento do plano de atendimento para.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_lista_usuario_w	varchar(4000)	:= null;
ds_titulo_w		varchar(255);
ds_comunicado_w		varchar(4000);
nm_usuario_w		usuario.nm_usuario%type;
nm_participante_w	varchar(280);
ds_email_destino_w	usuario.ds_email%type;
ds_email_origem_w	usuario.ds_email%type;
lista_para_email_w	dbms_sql.varchar2_table;
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;

c01 CURSOR FOR
	/* Obter os profissionais responsáveis do participante */

	SELECT	c.nm_usuario
	from	usuario c,
		mprev_programa_partic b,
		mprev_prog_partic_prof a
	where	a.nr_seq_programa_partic = b.nr_sequencia
	and	a.cd_profissional = c.cd_pessoa_fisica
	and	b.nr_sequencia = nr_seq_programa_partic_p
	and	coalesce(dt_alta_p,clock_timestamp()) between a.dt_inicio_acomp and coalesce(a.dt_fim_acomp,coalesce(dt_alta_p,clock_timestamp()))
	
union

	/* Responsáveis pela equipe */

	SELECT	e.nm_usuario
	from	mprev_prog_partic_prof a,
		mprev_programa_partic b,
		mprev_equipe c,
		mprev_equipe_profissional d,
		usuario e
	where	a.nr_seq_programa_partic = b.nr_sequencia
	and	a.nr_seq_equipe = c.nr_sequencia
	and	d.nr_seq_equipe = c.nr_sequencia
	and	d.cd_pessoa_fisica = e.cd_pessoa_fisica
	and	b.nr_sequencia = nr_seq_programa_partic_p
	and	c.ie_situacao = 'A'
	and	coalesce(dt_alta_p,clock_timestamp()) between a.dt_inicio_acomp and coalesce(a.dt_fim_acomp,coalesce(dt_alta_p,clock_timestamp()));

BEGIN
if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		nm_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (coalesce(ds_lista_usuario_w::text, '') = '') then
			ds_lista_usuario_w	:= nm_usuario_w || ',';
		else
			ds_lista_usuario_w	:= ds_lista_usuario_w || ' ' || nm_usuario_w || ',';
		end if;
		end;
	end loop;
	close C01;

	if (ds_lista_usuario_w IS NOT NULL AND ds_lista_usuario_w::text <> '') then
		/*Participante HDM - Alerta de situação de atendimento*/

		ds_titulo_w	:= substr(obter_texto_dic_objeto(358668,wheb_usuario_pck.get_nr_seq_idioma,null),1,255);

		/*Mensagem automática: */

		ds_comunicado_w	:= obter_texto_dic_objeto(341576,wheb_usuario_pck.get_nr_seq_idioma,null);

		select 	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from 	mprev_participante
		where 	nr_sequencia = nr_seq_participante_p;

		/*Concatena a sequencia do participante com o nome do mesmo para adicionar na mensagem*/

		nm_participante_w	:= substr(nr_seq_participante_p || ' - ' || '(' || cd_pessoa_fisica_w || ') ' || mprev_obter_nm_participante(nr_seq_participante_p),1,280);

		/*Foi gerado um atendimento previsto para o participante #@PARTICIPANTE#@,
		com data prevista para #@DT_PREVISTA#@, originado pela alta do atendimento #@NR_ATENDIMENTO#@.*/
		ds_comunicado_w	:= ds_comunicado_w ||chr(13)||chr(10)||
				obter_texto_dic_objeto(383288, wheb_usuario_pck.get_nr_seq_idioma,
						'participante='||nm_participante_w||
						';dt_prevista='||dt_prevista_p||
						';nr_atendimento='||nr_atendimento_p);

		/*Se a regra solicitar o envio de CI aos profissionais responsáveis*/

		if (ie_gerar_ci_p = 'S') then
			CALL gerar_comunic_padrao(	clock_timestamp(),
						ds_titulo_w,
						ds_comunicado_w,
						nm_usuario_p,
						'N',
						ds_lista_usuario_w,
						'N',
						null,null,null,null,clock_timestamp(),null,null);
		end if;

		/*Se a regra solicitar o envio de e-mail aos profissionais responsáveis*/

		if (ie_gerar_email_p = 'S') then
			/*Busca o e-mail do usuário Remetente*/

			select	max(ds_email)
			into STRICT	ds_email_origem_w
			from	usuario
			where	nm_usuario	= nm_usuario_p;

			if (ds_email_origem_w IS NOT NULL AND ds_email_origem_w::text <> '') then
				/*Carrega a lista de e-mail´s dos profissionais*/

				lista_para_email_w := obter_lista_string(ds_lista_usuario_w, ',');

				for	i in lista_para_email_w.first..lista_para_email_w.last loop
					/*Busca o e-mail do usuário dos profissionais */

					select	coalesce(max(a.ds_email), max(obter_email_pf(a.cd_pessoa_fisica)))
					into STRICT	ds_email_destino_w
					from	usuario a
					where	a.nm_usuario	= trim(both lista_para_email_w(i));

					if (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') then
						begin
						/*Envia o e-mail utilizando a procedure enviar_email*/

						CALL enviar_email(ds_titulo_w, ds_comunicado_w, ds_email_origem_w, ds_email_destino_w, nm_usuario_p, 'M');
						exception
							when others then
							CALL gravar_log_tasy(100,substr('user=' || nm_usuario_p|| ' error=' || sqlerrm,1,2000),nm_usuario_p);
						end;
					end if;
				end loop;
			end if;
		end if;
	end if;
end if;

/* Não precisa ter commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_gerar_ci_email_alta ( nr_seq_participante_p mprev_participante.nr_sequencia%type, nr_seq_programa_partic_p mprev_programa_partic.nr_sequencia%type, ie_gerar_ci_p mprev_atend_previsto_alta.ie_gerar_ci%type, ie_gerar_email_p mprev_atend_previsto_alta.ie_gerar_email%type, dt_prevista_p timestamp, nr_atendimento_p atendimento_paciente.nr_atendimento%type, dt_alta_p timestamp, nm_usuario_p text) FROM PUBLIC;
