-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasylab_registrar_atendimento ( cd_pessoa_fisica_p text, --cd_medico_resp_p				varchar2,
 nr_sequencia_tasylab_p bigint, dt_entrada_p timestamp, cd_pessoa_resp_p text, --nr_prescricao_origem_p		number,
 cd_erro_p INOUT bigint, ds_erro_p INOUT text, nr_atendimento_p INOUT bigint) AS $body$
DECLARE


nr_atendimento_w			atendimento_paciente.nr_atendimento%type;

cd_categoria_w				categoria_convenio.cd_categoria%type;
cd_plano_convenio_w			convenio_plano.cd_plano%type;
cd_tipo_acomodacao_w		categoria_convenio.cd_tipo_acomodacao%type;

nr_sequencia_w				atend_paciente_unidade.nr_sequencia%type;

cd_tipo_acomodacao_unid_w	unidade_atendimento.cd_tipo_acomodacao%type;

cd_convenio_w				lab_tasylab_cliente.cd_convenio%type;
cd_medico_resp_w            lab_tasylab_cliente.cd_medico%type;
cd_estabelecimento_w        lab_tasylab_cliente.cd_estabelecimento%type;
cd_usuario_convenio_w       lab_tasylab_cliente.cd_usuario_convenio%type;
dt_validade_carteira_w      lab_tasylab_cliente.dt_validade_carteira%type;
nr_seq_externo_w            lab_tasylab_cliente.nr_sequencia%type;
cd_procedencia_w            lab_tasylab_cliente.cd_procedencia%type;
ie_carater_inter_sus_w      lab_tasylab_cliente.ie_carater_inter_sus%type;
ie_tipo_atend_tiss_w        lab_tasylab_cliente.ie_tipo_atend_tiss%type;
ie_tipo_convenio_w          lab_tasylab_cliente.ie_tipo_convenio%type;
cd_setor_atendimento_w      lab_tasylab_cliente.cd_setor_atendimento%type;
cd_unidade_basica_w         lab_tasylab_cliente.cd_unidade_basica%type;
cd_unidade_compl_w          lab_tasylab_cliente.cd_unidade_compl%type;


BEGIN

cd_erro_p	:= 0;

if (coalesce(dt_entrada_p::text, '') = '') then
	cd_erro_p	:= 8;
end if;

if (cd_erro_p = 0) then
	select	max(a.cd_convenio),
			max(a.cd_medico),
			max(a.cd_estabelecimento),
			max(a.cd_usuario_convenio),
			max(a.dt_validade_carteira),
			max(a.nr_sequencia),
			max(a.cd_procedencia),
			max(a.ie_carater_inter_sus),
			max(a.ie_tipo_atend_tiss),
			max(a.ie_tipo_convenio),
			max(a.cd_setor_atendimento),
			--max(cd_tipo_acomodacao),
			max(a.cd_unidade_basica),
			max(a.cd_unidade_compl)
	into STRICT	cd_convenio_w,
			cd_medico_resp_w,
			cd_estabelecimento_w,
			cd_usuario_convenio_w,
			dt_validade_carteira_w,
			nr_seq_externo_w,
			cd_procedencia_w,
			ie_carater_inter_sus_w,
			ie_tipo_atend_tiss_w,
			ie_tipo_convenio_w,
			cd_setor_atendimento_w,
			--cd_tipo_acomodacao_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
	from	lab_tasylab_cliente a
	where	nr_sequencia = nr_sequencia_tasylab_p;

	if (coalesce(cd_medico_resp_w::text, '') = '') then
		cd_erro_p	:= 9;
	elsif (coalesce(cd_estabelecimento_w::text, '') = '') then
		cd_erro_p	:= 10;
	elsif (coalesce(cd_convenio_w::text, '') = '') then
		cd_erro_p	:= 11;
	else

		select	nextval('atendimento_paciente_seq')
		into STRICT	nr_atendimento_w
		;

		nr_atendimento_p	:= nr_atendimento_w;

		begin
		insert into atendimento_paciente(nr_atendimento,
										dt_entrada,
										ie_tipo_atendimento,
										cd_pessoa_fisica,
										cd_medico_resp,
										cd_procedencia,
										ie_carater_inter_sus,
										ie_tipo_atend_tiss,
										ie_tipo_convenio,
										ie_permite_visita,
										cd_pessoa_responsavel,
										cd_estabelecimento,
										dt_atualizacao,
										nm_usuario)
								values (nr_atendimento_w,
										dt_entrada_p,
										7,
										cd_pessoa_fisica_p,
										cd_medico_resp_w,
										coalesce(cd_procedencia_w, 18),
										coalesce(ie_carater_inter_sus_w, '1'),
										coalesce(ie_tipo_atend_tiss_w, '5'),
										coalesce(ie_tipo_convenio_w, '2'),
										'N',
										cd_pessoa_resp_p,
										cd_estabelecimento_w,
										clock_timestamp(),
										'TasyLab-atend');
		exception
		when others then
			cd_erro_p	:= 1;
			ds_erro_p	:= substr('Erro ao inserir o atendimento residencial '||sqlerrm,1,2000);
		end;

		if (cd_erro_p = 0) then

			select	max(a.cd_categoria),
					max(b.cd_plano),
					max(a.cd_tipo_acomodacao)
			into STRICT	cd_categoria_w,
					cd_plano_convenio_w,
					cd_tipo_acomodacao_w
			from	categoria_convenio a,
					convenio_plano b
			where	a.cd_convenio = b.cd_convenio
			and		a.cd_convenio = cd_convenio_w;

			if (coalesce(cd_categoria_w::text, '') = '') then
				cd_erro_p	:= 12;
			else
				begin
				insert into atend_categoria_convenio(
											nr_seq_interno,
											nr_atendimento,
											cd_convenio,
											cd_categoria,
											cd_plano_convenio,
											cd_tipo_acomodacao,
											cd_usuario_convenio,
											dt_validade_carteira,
											dt_inicio_vigencia,
											ie_tipo_guia,
											nm_usuario,
											dt_atualizacao,
											nr_doc_convenio
											)
									values (
											nextval('atend_categoria_convenio_seq'),
											nr_atendimento_w,
											cd_convenio_w,
											cd_categoria_w,
											cd_plano_convenio_w,
											cd_tipo_acomodacao_w,
											coalesce(cd_usuario_convenio_w,123),
											dt_validade_carteira_w,
											dt_entrada_p,
											'L',
											'TasyLab-Conv',
											clock_timestamp(),
											nr_atendimento_w);
				exception
				when others then
					cd_erro_p	:= 1;
					ds_erro_p	:= substr('Erro ao inserir o convênio do atendimento '||sqlerrm,1,2000);
				end;
			end if;
		end if;

		if (cd_erro_p = 0) then

			select	coalesce(max(nr_sequencia),0)+1
			into STRICT	nr_sequencia_w
			from	atend_paciente_unidade
			where	nr_atendimento = nr_atendimento_w;

			select	max(a.cd_tipo_acomodacao)
			into STRICT	cd_tipo_acomodacao_unid_w
			from	unidade_atendimento a
			where	a.cd_setor_atendimento 	= cd_setor_atendimento_w
			and		a.cd_unidade_basica	= cd_unidade_basica_w
			and		a.cd_unidade_compl 	= cd_unidade_compl_w;

			begin
			insert into atend_paciente_unidade(
										nr_seq_interno,
										nr_atendimento,
										nr_sequencia,
										cd_setor_atendimento,
										cd_tipo_acomodacao,
										cd_unidade_basica,
										cd_unidade_compl,
										dt_entrada_unidade,
										dt_saida_interno,
										dt_atualizacao,
										dt_atualizacao_nrec,
										nm_usuario,
										nm_usuario_nrec)
							values (
										nextval('atend_paciente_unidade_seq'),
										nr_atendimento_w,
										nr_sequencia_w,
										coalesce(cd_setor_atendimento_w, 134),
										coalesce(cd_tipo_acomodacao_unid_w, 0), -- andrey -- 20,
										coalesce(cd_unidade_basica_w, 1),
										coalesce(cd_unidade_compl_w, ' '), --verificar
										dt_entrada_p,
										to_date('31/12/2999','dd/mm/yyyy'),
										clock_timestamp(),
										clock_timestamp(),
										'TasyLab-Unidade',
										'TasyLab-Unidade');
			exception
			when others then
				cd_erro_p	:= 1;
				ds_erro_p	:= substr('Erro ao inserir o setor do atendimento '||sqlerrm,1,2000);
			end;

		end if;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasylab_registrar_atendimento ( cd_pessoa_fisica_p text,  nr_sequencia_tasylab_p bigint, dt_entrada_p timestamp, cd_pessoa_resp_p text,  cd_erro_p INOUT bigint, ds_erro_p INOUT text, nr_atendimento_p INOUT bigint) FROM PUBLIC;

