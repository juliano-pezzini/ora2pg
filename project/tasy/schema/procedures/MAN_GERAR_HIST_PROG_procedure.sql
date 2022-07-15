-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gerar_hist_prog ( nm_usuario_p text, ie_plat_delphi_p text, ie_plat_java_p text, ie_plat_html5_p text, ie_plat_plsql_p text, ie_plat_outro_p text, ds_plataforma_p text, ie_script_cliente_p text, ie_script_objeto_p text, ie_script_dados_p text, ie_script_outros_p text, ds_script_cliente_p text, ie_video_defeito_p text, ds_video_defeito_p text, ie_video_testes_p text, ds_video_testes_p text, nr_seq_ordem_serv_p bigint, ie_libera_hist_p text) AS $body$
DECLARE


ds_hist_w		varchar(32000);
nr_seq_idioma_w		bigint;
dt_aprovacao_ccb_w	timestamp;
ds_comando_w		text;
			

BEGIN
	
	select	max(mosi.dt_aprovacao)
	into STRICT	dt_aprovacao_ccb_w
	from	man_ordem_serv_impacto mosi
	where	mosi.nr_seq_ordem_serv = nr_seq_ordem_serv_p;
	
	nr_seq_idioma_w := 5;--Inglês(US)
	
	ds_hist_w := wheb_rtf_pck.get_cabecalho;
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_fonte(20);
					
	if (coalesce(dt_aprovacao_ccb_w::text, '') = '') then
		begin
			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_quebra_linha();

			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_negrito(True)
					|| obter_desc_expressao_idioma(935916, 'Testes não relevantes para o design change control', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);

			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_quebra_linha();
			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_quebra_linha();
		end;
	else
		begin
			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_quebra_linha();

			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_negrito(True)
					|| obter_desc_expressao_idioma(935918, 'Testes relevantes para o design change control', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);

			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_quebra_linha();
			ds_hist_w :=	ds_hist_w || wheb_rtf_pck.get_quebra_linha();
		end;
	end if;
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_negrito(True) || obter_desc_expressao_idioma(757368, 'Preencha as lacunas com [ X ].', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_negrito(True) || obter_desc_expressao_idioma(757372, 'Qual a plataforma foi corrigida/customizada?', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '[ ' || case ie_plat_delphi_p when 'S' then 'X' end || ' ] Delphi    [ ' || case ie_plat_java_p when 'S' then 'X' end || ' ] Java     [ ' || case ie_plat_html5_p when 'S' then 'X' end || ' ] HTML5     [ ' || case ie_plat_plsql_p when 'S' then 'X' end || ' ] PL/SQL';
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();

	ds_hist_w := ds_hist_w || '[ ' || case ie_plat_outro_p when 'S' then 'X' end || ' ] ' || obter_desc_expressao_idioma(757262, 'Outro:', nr_seq_idioma_w) || ' ';
	
	if (ds_plataforma_p IS NOT NULL AND ds_plataforma_p::text <> '') then			
		ds_hist_w := ds_hist_w || wheb_rtf_pck.get_texto_rtf(REPLACE(ds_plataforma_p, '\' , '\\'));	
	end if;	
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_negrito(True) || obter_desc_expressao_idioma(757436, 'Foi enviado script para o cliente?', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
		
	ds_hist_w := ds_hist_w || '[ ' || case ie_script_cliente_p when 'S' then 'X' end || ' ]' || obter_desc_expressao_idioma(327113, 'Sim', nr_seq_idioma_w) || '*' || '    '  || '[ ' || case ie_script_cliente_p when 'N' then 'X' end || ' ]' || obter_desc_expressao_idioma(327114, 'Não', nr_seq_idioma_w);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '*' || obter_desc_expressao_idioma(757460, 'Caso sim, qual tipo de script:', nr_seq_idioma_w);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '  [ ' || case ie_script_objeto_p when 'S' then 'X' end || ' ] ' || obter_desc_expressao_idioma(757236, 'Ajuste de Objeto (procedure, function, view, trigger, package)', nr_seq_idioma_w);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '  [ ' || case ie_script_dados_p when 'S' then 'X' end || ' ] ' || obter_desc_expressao_idioma(757234, 'Ajuste de dados', nr_seq_idioma_w);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '  [ ' || case ie_script_outros_p when 'S' then 'X' end || ' ] ' || obter_desc_expressao_idioma(295053, 'Outro', nr_seq_idioma_w) || '.' || obter_desc_expressao_idioma(289461, 'Especifique', nr_seq_idioma_w) || ': ';
	
	if (ds_script_cliente_p IS NOT NULL AND ds_script_cliente_p::text <> '') then
		ds_hist_w := ds_hist_w || wheb_rtf_pck.get_texto_rtf(REPLACE(ds_script_cliente_p, '\' , '\\'));
	end if;
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_negrito(True) || obter_desc_expressao_idioma(757486, 'Documentou com vídeo o teste reproduzindo o defeito reportado e anexou na OS? Em caso de resposta "Não", favor justificar.', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);
			
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '[ ' || case ie_video_defeito_p when 'S' then 'X' end || ' ]' || obter_desc_expressao_idioma(327113, 'Sim', nr_seq_idioma_w) || '    '  || '[ ' || case ie_video_defeito_p when 'N' then 'X' end || ' ]' || obter_desc_expressao_idioma(327114, 'Não', nr_seq_idioma_w) || '*';
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '*' || obter_desc_expressao_idioma(325773, 'Justificativa:', nr_seq_idioma_w) || ' ';
	
	if (ds_video_defeito_p IS NOT NULL AND ds_video_defeito_p::text <> '') then			
		ds_hist_w := ds_hist_w || wheb_rtf_pck.get_texto_rtf(REPLACE(ds_video_defeito_p, '\' , '\\'));
	end if;
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_negrito(True) || obter_desc_expressao_idioma(757466, 'Documentou com vídeo os testes válidos e inválidos executados após a correção/customização e anexou na OS? Em caso de resposta "Não", favor descrever como executar o teste.', nr_seq_idioma_w) || wheb_rtf_pck.get_negrito(False);
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '[ ' || case ie_video_testes_p when 'S' then 'X' end || ' ]' || obter_desc_expressao_idioma(327113, 'Sim', nr_seq_idioma_w) || '    '  || '[ ' || case ie_video_testes_p when 'N' then 'X' end || ' ]' || obter_desc_expressao_idioma(327114, 'Não', nr_seq_idioma_w) || '*';
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || '*' || obter_desc_expressao_idioma(757490, 'Passo a passo que garante o funcionamento em caso de ausência de vídeo:', nr_seq_idioma_w) || ' ';
	
	if (ds_video_testes_p IS NOT NULL AND ds_video_testes_p::text <> '') then		
		ds_hist_w := ds_hist_w || wheb_rtf_pck.get_texto_rtf(REPLACE(ds_video_testes_p, '\' , '\\'));
	end if;
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha() || wheb_rtf_pck.get_quebra_linha();
		
	ds_hist_w := ds_hist_w || obter_desc_expressao_idioma(297270, 'Realizado por', nr_seq_idioma_w) || ' ' || Obter_nome_usuario(nm_usuario_p) || wheb_rtf_pck.get_quebra_linha();
	
	ds_hist_w := ds_hist_w || OBTER_DESCRICAO_GERENCIA(OBTER_GERENCIA_USUARIO_WHEB(nm_usuario_p));
	
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	ds_hist_w := ds_hist_w || wheb_rtf_pck.get_quebra_linha();
	
	begin
	EXECUTE ' select man_ordem_retorna_log(:nr_seq_ordem_serv) from dual ' into STRICT ds_comando_w	using nr_seq_ordem_serv_p;
	exception
	when others then
		ds_comando_w:= null;
	end;
	
	ds_comando_w:= ds_hist_w || replace(substr(ds_comando_w,1,25000),'@@@',wheb_rtf_pck.get_quebra_linha());
	ds_comando_w:= ds_comando_w || wheb_rtf_pck.get_rodape;	
	
	insert into man_ordem_serv_tecnico( nr_sequencia,
										nr_seq_ordem_serv,
										nr_seq_tipo,
										nm_usuario,
										nm_usuario_lib,
										dt_atualizacao,
										dt_historico,
										dt_liberacao,
										ds_relat_tecnico,
										ie_origem)
	values (nextval('man_ordem_serv_tecnico_seq'),
			nr_seq_ordem_serv_p,
			12,
			nm_usuario_p,
			CASE WHEN ie_libera_hist_p='S' THEN  nm_usuario_p  ELSE null END ,
			clock_timestamp(),
			clock_timestamp(),
			CASE WHEN ie_libera_hist_p='S' THEN  clock_timestamp()  ELSE null END ,
			ds_comando_w,
			'I'			
	);
			
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gerar_hist_prog ( nm_usuario_p text, ie_plat_delphi_p text, ie_plat_java_p text, ie_plat_html5_p text, ie_plat_plsql_p text, ie_plat_outro_p text, ds_plataforma_p text, ie_script_cliente_p text, ie_script_objeto_p text, ie_script_dados_p text, ie_script_outros_p text, ds_script_cliente_p text, ie_video_defeito_p text, ds_video_defeito_p text, ie_video_testes_p text, ds_video_testes_p text, nr_seq_ordem_serv_p bigint, ie_libera_hist_p text) FROM PUBLIC;

