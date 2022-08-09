-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_manchester ( nr_atendimento_p bigint, ds_fluxograma_p text, ds_queixa_p text, ds_observacao_p text, ds_usuario_p text, ds_discriminador_p text, cd_evolucao_p INOUT bigint, ds_detalhe_p text default null) AS $body$
DECLARE

																	
ds_texto_w		varchar(32000);
quebra_w			varchar(255)	:= wheb_rtf_pck.get_quebra_linha;
cd_pessoa_fisica_w	varchar(10);
IE_TIPO_EVOLUCAO_w	varchar(10);
nm_usuario_w		varchar(15);
cd_medico_w		varchar(15);
dt_inicio_atendimento_w	varchar(20);
dt_fim_triagem_w		varchar(20);
ds_prioridade_triagem_w	varchar(60);
ds_erro_w				varchar(2000);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(774088, null, wheb_usuario_pck.get_nr_seq_idioma);--Queixas do paciente
expressao2_w	varchar(255) := obter_desc_expressao_idioma(774089, null, wheb_usuario_pck.get_nr_seq_idioma);--Fluxograma escolhido
expressao3_w	varchar(255) := obter_desc_expressao_idioma(303929, null, wheb_usuario_pck.get_nr_seq_idioma);--Discriminador
expressao4_w	varchar(255) := obter_desc_expressao_idioma(774092, null, wheb_usuario_pck.get_nr_seq_idioma);--Prioridade Clinica
expressao5_w	varchar(255) := obter_desc_expressao_idioma(651459, null, wheb_usuario_pck.get_nr_seq_idioma);--Inicio da Classificacao
expressao6_w	varchar(255) := obter_desc_expressao_idioma(774093, null, wheb_usuario_pck.get_nr_seq_idioma);--Fim da Classificacao
expressao7_w	varchar(255) := obter_desc_expressao_idioma(692668, null, wheb_usuario_pck.get_nr_seq_idioma);--Observacoes:
expressao8_w	varchar(255) := obter_desc_expressao_idioma(338377, null, wheb_usuario_pck.get_nr_seq_idioma);--Classificador
expressao9_w	varchar(255) := obter_desc_expressao_idioma(774094, null, wheb_usuario_pck.get_nr_seq_idioma);--Erro ao inserir evolucao no manchester
expressao10_w	varchar(255) := obter_desc_expressao_idioma(875290, null, wheb_usuario_pck.get_nr_seq_idioma);--Dados vitais
BEGIN

if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'de_DE') then
	expressao1_w := obter_desc_expressao_idioma(861932, null, wheb_usuario_pck.get_nr_seq_idioma);
	expressao2_w := obter_desc_expressao_idioma(620839, null, wheb_usuario_pck.get_nr_seq_idioma);
	expressao4_w := obter_desc_expressao_idioma(1027784, null, wheb_usuario_pck.get_nr_seq_idioma);
	expressao6_w := obter_desc_expressao_idioma(711365, null, wheb_usuario_pck.get_nr_seq_idioma);	
end if;

begin
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_atendimento_p	> 0) then
	
	ds_texto_w	:= wheb_rtf_pck.get_cabecalho;

	select	max(cd_pessoa_fisica),
			max(to_char(dt_inicio_atendimento, 'dd/mm/yyyy hh24:mi:ss')),
			max(to_char(dt_fim_triagem, 'dd/mm/yyyy hh24:mi:ss')),
			max(obter_desc_triagem(nr_seq_triagem))
	into STRICT	cd_pessoa_fisica_w,
			dt_inicio_atendimento_w,
			dt_fim_triagem_w,
			ds_prioridade_triagem_w
	from	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;
	
	nm_usuario_w	:= ds_usuario_p;
	
	select	max(ie_tipo_evolucao),
			max(cd_pessoa_fisica)
	into STRICT	ie_tipo_evolucao_w,
			cd_medico_w
	from	usuario
	where	upper(nm_usuario)	= upper(nm_usuario_w);
	
	if (ds_queixa_p IS NOT NULL AND ds_queixa_p::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao1_w||': \b0 '  ||ds_queixa_p||quebra_w;
	end if;

	if (ds_fluxograma_p IS NOT NULL AND ds_fluxograma_p::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao2_w||': \b0 '   || ds_fluxograma_p ||quebra_w;
	end if;
	
	if (ds_discriminador_p IS NOT NULL AND ds_discriminador_p::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao3_w||': \b0 '   || ds_discriminador_p ||quebra_w;
	end if;
		
	if (ds_prioridade_triagem_w IS NOT NULL AND ds_prioridade_triagem_w::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao4_w||': \b0 '   ||ds_prioridade_triagem_w||quebra_w;
	end if;	
	
	if (dt_inicio_atendimento_w IS NOT NULL AND dt_inicio_atendimento_w::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao5_w||': \b0 '   ||dt_inicio_atendimento_w||quebra_w;
	end if;
	
	if (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao6_w||': \b0 '   ||dt_fim_triagem_w||quebra_w;
	end if;
	
	if (ds_detalhe_p IS NOT NULL AND ds_detalhe_p::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao10_w||' \b0 '   ||ds_detalhe_p||quebra_w;
	end if;
	
	if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
		ds_texto_w	:= ds_texto_w||quebra_w||'\b '||expressao7_w||' \b0 '   ||ds_observacao_p||quebra_w;
	end if;
	
	ds_texto_w	:= ds_texto_w||quebra_w|| '\b '||expressao8_w||': \b0 ' || obter_nome_pf(cd_medico_w)||' - '||obter_dados_pf(cd_medico_w,'COPR')||quebra_w;

	ds_texto_w	:= ds_texto_w || wheb_rtf_pck.get_rodape;
	
	select nextval('evolucao_paciente_seq')
	into STRICT   cd_evolucao_p
	;

	insert into evolucao_paciente(	cd_evolucao,
				dt_evolucao,
				ie_tipo_evolucao,
				cd_pessoa_fisica,
				dt_atualizacao,
				nm_usuario,
				nr_atendimento,
				ds_evolucao,					
				dt_liberacao,
				ie_evolucao_clinica,
				cd_medico,
				nr_cirurgia,
				ie_situacao)
		values (cd_evolucao_p,
				clock_timestamp(),
				coalesce(IE_TIPO_EVOLUCAO_w,1),
				cd_pessoa_fisica_w,
				clock_timestamp(),
				nm_usuario_w,
				nr_atendimento_p,
				ds_texto_w,					
				clock_timestamp(),
				'CRM',--Classificacao de Risco Manchester
				cd_medico_w,
				null,
				'A');
	commit;
	
end if;

exception
when others then
	ds_erro_w := substr(sqlerrm(SQLSTATE),2000);

	CALL gravar_log_tasy(99995,
					substr(expressao9_w || ' = ' || ds_erro_w,1,2000),
					DS_USUARIO_P);	
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_manchester ( nr_atendimento_p bigint, ds_fluxograma_p text, ds_queixa_p text, ds_observacao_p text, ds_usuario_p text, ds_discriminador_p text, cd_evolucao_p INOUT bigint, ds_detalhe_p text default null) FROM PUBLIC;
