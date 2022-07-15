-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_encaminhamento ( nr_seq_encaminhamento_p bigint) AS $body$
DECLARE

 
	ie_tipo_evolucao_w			usuario.ie_tipo_evolucao%type;
	nm_usuario_w				usuario.nm_usuario%type;
	cd_ciap_w					atend_encaminhamento.cd_ciap%type;
	cd_doenca_w					atend_encaminhamento.cd_doenca%type;
	ds_ciap_w					ciap_problema.ds_ciap%type;
	ds_doenca_w					cid_doenca.ds_doenca_cid%type;
	cd_pessoa_fisica_w 		pessoa_fisica.cd_pessoa_fisica%type;
	nr_atendimento_w			evolucao_paciente.nr_atendimento%type;
	cd_profissional_w			evolucao_paciente.cd_medico%type;
	
	ds_medico_especialidade_w	varchar(255);
	ds_especialidade_w			varchar(255);
	ds_cabecalho_w				varchar(32000);
	ds_rodape_w		 			varchar(255);
	ie_nivel_atencao_w		 	varchar(1);
	
	ds_enc_especialidade_w		varchar(8000) := '';
	ds_evolucao_w				varchar(32000) := '';
	
	ds_fonte_w					varchar(100);
	ds_tam_fonte_w				varchar(10);
	nr_tam_fonte_w				integer;
	

BEGIN 
	 
	if (nr_seq_encaminhamento_p IS NOT NULL AND nr_seq_encaminhamento_p::text <> '') then 
	 
		select	wheb_usuario_pck.get_nm_usuario 
		into STRICT	nm_usuario_w 
		;
 
		select	ie_tipo_evolucao 
		into STRICT	ie_tipo_evolucao_w 
		from	usuario 
		where	nm_usuario = nm_usuario_w;
		 
		if (coalesce(ie_tipo_evolucao_w::text, '') = '') then 
			--Tipo de evolução não informado para este usuário. 
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(264634);
		end if;
		 
		select	OBTER_PESSOA_FISICA_USUARIO(nm_usuario_w,'C') 
		into STRICT	cd_profissional_w 
		;
		 
		 
		select	substr(obter_nome_pf(cd_medico_dest),1,255) ds_medico_especialidade, 
				substr(obter_desc_espec_medica(cd_especialidade),1,255) ds_especialidade, 
				cd_ciap, 
				cd_doenca, 
				obter_desc_ciap(cd_ciap), 
				obter_desc_cid(cd_doenca), 
				cd_pessoa_fisica, 
				nr_atendimento 
		into STRICT	ds_medico_especialidade_w, 
				ds_especialidade_w, 
				cd_ciap_w, 
				cd_doenca_w, 
				ds_ciap_w, 
				ds_doenca_w, 
				cd_pessoa_fisica_w, 
				nr_atendimento_w 
		from	atend_encaminhamento 
		where	nr_sequencia = nr_seq_encaminhamento_p;
		 
		ds_evolucao_w := ds_evolucao_w 	|| wheb_rtf_pck.get_negrito(true)|| obter_desc_expressao(317061) || ' - ' || obter_desc_expressao(10651941) ||wheb_rtf_pck.get_negrito(false)|| chr(13)||chr(10);
		 
		ds_evolucao_w := ds_evolucao_w || chr(13)||chr(10);
						 
		if (ds_especialidade_w IS NOT NULL AND ds_especialidade_w::text <> '') then 
			ds_evolucao_w := ds_evolucao_w || obter_desc_expressao(10651941) ||': ' || ds_especialidade_w ||chr(13)||chr(10);
			ds_evolucao_w := ds_evolucao_w || chr(13)||chr(10);
		end if;
		 
		if (ds_medico_especialidade_w IS NOT NULL AND ds_medico_especialidade_w::text <> '') then 
			ds_evolucao_w := ds_evolucao_w || obter_desc_expressao(325901) ||': ' || ds_medico_especialidade_w ||chr(13)||chr(10);
			ds_evolucao_w := ds_evolucao_w || chr(13)||chr(10);
		end if;
		 
		if (cd_ciap_w IS NOT NULL AND cd_ciap_w::text <> '') then 
			ds_evolucao_w := ds_evolucao_w || obter_desc_expressao(699114) || ' ' || obter_desc_expressao(291947) ||': ' || cd_ciap_w || ' - ' || ds_ciap_w ||chr(13)||chr(10);
			ds_evolucao_w := ds_evolucao_w || chr(13)||chr(10);
		end if;
		 
		if (cd_doenca_w IS NOT NULL AND cd_doenca_w::text <> '') then 
			ds_evolucao_w := ds_evolucao_w || obter_desc_expressao(284902) || ' ' || obter_desc_expressao(291947) ||': ' || cd_doenca_w || ' - ' || ds_doenca_w ||chr(13)||chr(10);
			ds_evolucao_w := ds_evolucao_w || chr(13)||chr(10);
		end if;	
					 
		ds_evolucao_w := ds_evolucao_w || chr(13)||chr(10);
			 
		ds_fonte_w := Obter_Param_Usuario(281, 5, obter_perfil_ativo, nm_usuario_w, wheb_usuario_pck.get_cd_estabelecimento, ds_fonte_w);
		ds_tam_fonte_w := Obter_Param_Usuario(281, 6, obter_perfil_ativo, nm_usuario_w, wheb_usuario_pck.get_cd_estabelecimento, ds_tam_fonte_w);
		nr_tam_fonte_w := somente_numero(ds_tam_fonte_w) * 2;
 
		ds_cabecalho_w	:= '{\rtf1\ansi\ansicpg1252\deff0\deflang1046{\fonttbl{\f0\fswiss\fcharset0 '||ds_fonte_w||';}}'|| 
			  '{\*\generator Msftedit 5.41.15.1507;}\viewkind4\uc1\pard\f0\fs'||nr_tam_fonte_w||' ';
				 
		ds_rodape_w	:= '}';
		 
		ds_evolucao_w	:= replace(ds_evolucao_w, chr(13)||chr(10), ' \par ');
		ds_evolucao_w := ds_cabecalho_w||ds_evolucao_w||ds_rodape_w;
		 
		ie_nivel_atencao_w := wheb_assist_pck.get_nivel_atencao_perfil;
		 
		insert into evolucao_paciente( 
				cd_evolucao, 
				dt_evolucao, 
				ie_tipo_evolucao, 
				cd_pessoa_fisica, 
				dt_atualizacao, 
				nm_usuario, 
				nr_atendimento, 
				ds_evolucao, 
				cd_medico, 
				dt_liberacao, 
				ie_evolucao_clinica, 
				ie_situacao, 
				ie_nivel_atencao) 
			values (nextval('evolucao_paciente_seq'), 
				clock_timestamp(), 
				ie_tipo_evolucao_w, 
				cd_pessoa_fisica_w, 
				clock_timestamp(), 
				nm_usuario_w, 
				nr_atendimento_w, 
				ds_evolucao_w, 
				cd_profissional_w, 
				clock_timestamp(), 
				'P', 
				'A', 
				ie_nivel_atencao_w);
 
				commit;
	end if;
				 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_encaminhamento ( nr_seq_encaminhamento_p bigint) FROM PUBLIC;

