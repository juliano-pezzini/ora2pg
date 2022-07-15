-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_parecer_solic_mat_cpoe ( nr_seq_encaminhamento_p bigint, ds_conteudo_p text, nr_seq_regulacao_p bigint, nr_seq_parecer_p INOUT bigint) AS $body$
DECLARE



cd_pessoa_fisica_w	cpoe_procedimento.cd_pessoa_fisica%type;
nr_atendimento_w	cpoe_procedimento.nr_atendimento%type;
dt_avaliacao_w		cpoe_procedimento.dt_liberacao%type;
ds_titulo_w			varchar(255);

nr_seq_parecer_w	parecer_medico_req.nr_parecer%type;

nm_usuario_w		usuario.nm_usuario%type;
cd_pf_usuario_w		usuario.cd_pessoa_fisica%type;

ds_fonte_w			varchar(100);
ds_tam_fonte_w		varchar(10);
nr_tam_fonte_w		integer;

ds_cabecalho_w		varchar(32000);
ds_conteudo_w		varchar(32000);
ds_rodape_w		 	varchar(32000);
ds_titulo_rft_w 	varchar(255) := '';
ds_enter_w			varchar(10)	:=  '\par';

ds_parecer_w		varchar(32000);

enviar_CI_w			varchar(1);
enviar_email_w		varchar(1);

					

BEGIN

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
	cd_pf_usuario_w := obter_pessoa_fisica_usuario(nm_usuario_w, 'C');

	select	max(a.cd_pessoa_fisica),
			max(a.nr_atendimento),
			max(a.dt_liberacao)
	into STRICT	cd_pessoa_fisica_w,
			nr_atendimento_w,
			dt_avaliacao_w
	from	cpoe_material a
	where	a.nr_sequencia = nr_seq_encaminhamento_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		
		ds_conteudo_w := ds_conteudo_p;	

		Select 	obter_desc_expressao(875028) -- Solicitações de exames, procedimentos e cirurgias
		into STRICT	ds_titulo_w
		;
		
		
		if (ds_titulo_w IS NOT NULL AND ds_titulo_w::text <> '') then			
			ds_titulo_w := '<b>' ||  '<center>' || ds_titulo_w || '</b>'||'</center>' || '<br>'|| '<br>';				
		end if;
		

		ds_parecer_w	:= ds_titulo_w ||ds_conteudo_w;	
		
		select	nextval('parecer_medico_req_seq')
		into STRICT	nr_seq_parecer_w
		;
		
		insert into parecer_medico_req(
							nr_parecer,
							nr_atendimento,
							cd_medico,
							cd_especialidade,
							dt_atualizacao,
							nm_usuario,
							ds_motivo_consulta,
							dt_liberacao,
							cd_perfil_ativo,
							ie_situacao,
							cd_pessoa_fisica,
							ie_tipo_parecer,
							nm_usuario_nrec,
							dt_atualizacao_nrec
						) values (
							nr_seq_parecer_w,
							nr_atendimento_w,
							cd_pf_usuario_w,
							obter_especialidade_medico(cd_pf_usuario_w, 'C'),
							clock_timestamp(),
							nm_usuario_w,
							ds_parecer_w,
							clock_timestamp(),
							wheb_usuario_pck.get_cd_perfil,
							'A',
							cd_pessoa_fisica_w,
							'M',
							nm_usuario_w,
							clock_timestamp()
						);
						
		nr_seq_parecer_p := nr_seq_parecer_w;
		
		commit;
	

		enviar_CI_w := Obter_Param_Usuario(281, 361, obter_perfil_ativo, nm_usuario_w, wheb_usuario_pck.get_cd_estabelecimento, enviar_CI_w);
		if (enviar_CI_w <> 'N') then
			begin
				CALL enviar_comunic_parecer_html(nr_seq_parecer_w,1, wheb_usuario_pck.get_cd_estabelecimento, 0, nm_usuario_w);
			Exception when others then
				null;
				
			end;
		end if;
		
		enviar_email_w := Obter_Param_Usuario(281, 1167, obter_perfil_ativo, nm_usuario_w, wheb_usuario_pck.get_cd_estabelecimento, enviar_email_w);
		if (enviar_email_w <> 'N') then
			begin
				CALL enviar_email_parecer_med(nr_seq_parecer_w,1, wheb_usuario_pck.get_cd_estabelecimento, 0, nm_usuario_w);
		Exception when others then
				null;
			end;
		end if;
		
		
	end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_parecer_solic_mat_cpoe ( nr_seq_encaminhamento_p bigint, ds_conteudo_p text, nr_seq_regulacao_p bigint, nr_seq_parecer_p INOUT bigint) FROM PUBLIC;

