-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_atend_colmeia (cd_pessoa_fisica_p text, dt_entrada_p text, dt_alta_p text, cd_cns_medico_resp_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_apac_p bigint, cd_carater_internacao_p text, nr_atendimento_p INOUT bigint) AS $body$
DECLARE

 
cd_medico_resp_w		atendimento_paciente.cd_medico_resp%type;
qt_gerou_atend_w		bigint := 0;
nr_seq_interno_conv_w		atend_categoria_convenio.nr_seq_interno%type;
cd_categoria_w			atend_categoria_convenio.cd_categoria%type;
qt_gerou_convenio_w		bigint := 0;
cd_setor_atendimento_w		atend_paciente_unidade.cd_setor_atendimento%type;
dt_saida_interno_w		atend_paciente_unidade.dt_saida_interno%type;
nr_seq_interno_unid_w		atend_paciente_unidade.nr_seq_interno%type;
cd_convenio_sus_w		atend_categoria_convenio.cd_convenio%type;
cd_procedencia_w		atendimento_paciente.cd_procedencia%type;
cd_unidade_basica_w		atend_paciente_unidade.cd_unidade_basica%type;
cd_unidade_compl_w		atend_paciente_unidade.cd_unidade_compl%type;
qt_atendimento_w		bigint;
dt_entrada_w			atendimento_paciente.dt_entrada%type;
cd_tipo_acomodacao_w		atend_paciente_unidade.cd_tipo_acomodacao%type;
ds_erro_w			sus_erro_imp_colmeia.ds_erro%type;
dt_alta_w			timestamp;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
ie_commit_w			varchar(1) := 'N';


BEGIN 
 
cd_procedencia_w := obter_param_usuario(1124, 138, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_procedencia_w);
cd_setor_atendimento_w := obter_param_usuario(1124, 139, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_setor_atendimento_w);
cd_categoria_w := obter_param_usuario(1124, 140, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_categoria_w);
 
begin 
dt_entrada_w 	:= to_date(dt_entrada_p, 'dd/mm/yyyy hh24:mi:ss');
dt_alta_w	:= to_date(dt_alta_p,'dd/mm/yyyy hh24:mi:ss');
exception 
when others then 
	ds_erro_w := substr('dt_entrada_p:'|| dt_entrada_p || ';dt_alta_p:'|| dt_alta_p,1,2000);
end;
 
if (dt_entrada_w IS NOT NULL AND dt_entrada_w::text <> '') then 
	if ((substr(cd_cns_medico_resp_p,1,15) IS NOT NULL AND (substr(cd_cns_medico_resp_p,1,15))::text <> '')) then 
		begin 
		 
		begin 
		select	a.nr_atendimento 
		into STRICT	nr_atendimento_w 
		from	atendimento_paciente a 
		where	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
		and	a.dt_entrada = dt_entrada_w  LIMIT 1;
		exception 
		when others then 
			nr_atendimento_w := null;
		end;
		 
		cd_medico_resp_w := obter_dados_pf_cns(substr(cd_cns_medico_resp_p,1,15),'CD');
		if (coalesce(cd_medico_resp_w,'X') = 'X') then 
			ds_erro_w := substr(ds_erro_w || wheb_mensagem_pck.get_texto(736101) || substr(cd_cns_medico_resp_p,1,15) || ';', 2000);
		end if;
 
		if (coalesce(nr_atendimento_w,0) = 0) and (coalesce(cd_medico_resp_w,'X') <> 'X')then	/*só vai criar o novo atendimento se não tver nenhuma APAC vigente para a pessoa física */
 
			begin 
			 
			select	nextval('atendimento_paciente_seq') 
			into STRICT	nr_atendimento_w 
			;	
						 
			begin 
			insert into atendimento_paciente(nr_atendimento, 
						ie_tipo_atendimento, 
						cd_medico_resp, 
						ie_carater_inter_sus, 
						ie_tipo_convenio, 
						dt_entrada, 
						cd_pessoa_fisica, 
						cd_estabelecimento, 
						cd_procedencia, 
						dt_atualizacao, 
						nm_usuario, 
						ie_permite_visita) 
					values ( nr_atendimento_w, 
					  	8, 
					  	cd_medico_resp_w, 
						cd_carater_internacao_p, 
					  	3, 
					  	dt_entrada_w, 
					  	cd_pessoa_fisica_p, 
					  	cd_estabelecimento_p, 
					  	cd_procedencia_w, 
					  	clock_timestamp(), 
					  	nm_usuario_p, 
					  	'S');			
			exception			 
			when others then 
				ds_erro_w		:=	substr(ds_erro_w || wheb_mensagem_pck.get_texto(282485) || sqlerrm || ';', 2000);
				nr_atendimento_w 	:= null;
			end;
			ie_commit_w := 'S';
			/* VERIFICA SE GEROU ATENDIMENTO */
 
			select	count(1) 
			into STRICT	qt_gerou_atend_w 
			from	atendimento_paciente 
			where	nr_atendimento = coalesce(nr_atendimento_w,0)  LIMIT 1;
 
			if (qt_gerou_atend_w > 0) then 
				begin 
 
				select	nextval('atend_categoria_convenio_seq') 
				into STRICT	nr_seq_interno_conv_w 
				;
 
				begin 
				select 	coalesce(cd_convenio_sus,0) 
				into STRICT	cd_convenio_sus_w 
				from	parametro_faturamento 
				where	cd_estabelecimento = cd_estabelecimento_p  LIMIT 1;
				exception 
				when others then 
					cd_convenio_sus_w := 1;
				end;
 
				if (cd_convenio_sus_w > 0) then 
					begin					 
					insert into atend_categoria_convenio( 
								cd_convenio, 
								cd_categoria, 
								nm_usuario, 
								nr_atendimento, 
								nr_seq_interno, 
								dt_atualizacao, 
								dt_inicio_vigencia) 
							values (	cd_convenio_sus_w, 
								cd_categoria_w, 
								nm_usuario_p, 
								nr_atendimento_w, 
								nr_seq_interno_conv_w, 
								clock_timestamp(), 
								clock_timestamp());									
					exception 
					when others then 
						nr_seq_interno_conv_w	:= null;
						ds_erro_w		:= substr(ds_erro_w || wheb_mensagem_pck.get_texto(282511) || sqlerrm || ';', 2000);
					end;
				end if;
				end;
			end if;
 
			/* VERIFICA SE GEROU O CONVÊNIO */
 
			select count(1) 
			into STRICT	qt_gerou_convenio_w 
			from 	atend_categoria_convenio 
			where 	nr_atendimento = nr_atendimento_w  LIMIT 1;
 
			if (qt_gerou_convenio_w > 0) then 
				begin 
 
				select	nextval('atend_paciente_unidade_seq') 
				into STRICT	nr_seq_interno_unid_w 
				;
 
				if (coalesce(dt_alta_p,'X') = 'X') then 
					dt_saida_interno_w := to_date('30/12/2999 00:00:00','dd/mm/yyyy hh24:mi:ss');
				else 
					dt_saida_interno_w := to_date(dt_alta_p,'dd/mm/yyyy hh24:mi:ss');
				end if;
 
				begin 
				select	max(cd_unidade_basica)				 
				into STRICT	cd_unidade_basica_w					 
				from	unidade_atendimento 
				where	cd_setor_atendimento = cd_setor_atendimento_w 
				and	ie_situacao = 'A' 
				and	ie_higienizacao = 'N';
				exception 
				when others then 
					cd_unidade_basica_w := 'X';
				end;
				 
				begin 
				select	max(cd_unidade_compl) 
				into STRICT	cd_unidade_compl_w 
				from	unidade_atendimento 
				where	cd_setor_atendimento = cd_setor_atendimento_w 
				and	cd_unidade_basica = cd_unidade_basica_w 
				and	ie_situacao = 'A' 
				and	ie_higienizacao = 'N';
				exception 
				when others then 
					cd_unidade_compl_w := 'X';
				end;
 
				if (coalesce(cd_unidade_basica_w,'X') <> 'X') and (coalesce(cd_unidade_compl_w,'X') <> 'X') then 
					begin 
					 
					select	max(a.cd_tipo_acomodacao) 
					into STRICT	cd_tipo_acomodacao_w 
					from	unidade_atendimento_v a 
					where	a.cd_setor_atendimento = cd_setor_atendimento_w 
					and	a.cd_unidade_basica = cd_unidade_basica_w 
					and	a.cd_unidade_compl = coalesce(cd_unidade_compl_w, a.cd_unidade_compl);
					 
					begin 
					insert into atend_paciente_unidade( 
							cd_setor_atendimento, 
							cd_unidade_basica, 
							cd_unidade_compl, 
							dt_entrada_unidade, 
							dt_saida_interno, 
							dt_atualizacao, 
							nm_usuario, 
							nr_sequencia, 
							nr_atendimento, 
							nr_seq_interno, 
							cd_tipo_acomodacao) 
						values (	cd_setor_atendimento_w, 
							cd_unidade_basica_w, 
							coalesce(cd_unidade_compl_w,' '), 
							dt_entrada_w, 
							dt_saida_interno_w, 
							clock_timestamp(), 
							nm_usuario_p, 
							1, 
							nr_atendimento_w, 
							nr_seq_interno_unid_w, 
							cd_tipo_acomodacao_w);					
					exception 
					when others then 
						nr_seq_interno_unid_w	:= null;
						ds_erro_w		:= substr(ds_erro_w || wheb_mensagem_pck.get_texto(282511) || sqlerrm || ';', 2000);
					end;
					end;
				end if;
				end;
			end if;
			end;
		end if;
		end;
	end if;
end if;
 
if (coalesce(ds_erro_w, 'X') <> 'X') then 
	begin 
	insert into sus_erro_imp_colmeia( 
		ds_erro, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_atendimento, 
		nr_seq_interno, 
		nr_sequencia) 
	values (	ds_erro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_atendimento_w, 
		null, 
		nextval('sus_erro_imp_colmeia_seq'));
		 
	ie_commit_w := 'S';
	end;
end if;
 
if (ie_commit_w = 'S') then 
	begin 
	commit;	
	end;
end if;
 
nr_atendimento_p := nr_atendimento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_atend_colmeia (cd_pessoa_fisica_p text, dt_entrada_p text, dt_alta_p text, cd_cns_medico_resp_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_apac_p bigint, cd_carater_internacao_p text, nr_atendimento_p INOUT bigint) FROM PUBLIC;

