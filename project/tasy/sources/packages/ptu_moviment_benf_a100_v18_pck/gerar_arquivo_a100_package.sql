-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_moviment_benf_a100_v18_pck.gerar_arquivo_a100 ( nr_seq_lote_p bigint, cd_unimed_destino_p bigint, cd_intercambio_envio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ds_nome_arq_p INOUT text, ds_caminho_rede_p INOUT text) AS $body$
DECLARE

	
	arq_texto_w			utl_file.file_type;
	ds_local_w			varchar(255) := null;
	ds_erro_w			varchar(255);
	current_setting('ptu_moviment_benf_a100_v18_pck.nm_arquivo_w')::varchar(255)			varchar(255);
	ds_caminho_rede_w		varchar(255) := null;
	
	
BEGIN
	PERFORM set_config('ptu_moviment_benf_a100_v18_pck.ds_arquivo_w', null, false);
	CALL CALL CALL CALL CALL CALL CALL CALL ptu_moviment_benf_a100_v18_pck.set_nm_usuario(nm_usuario_p);
	CALL CALL CALL CALL CALL CALL CALL CALL CALL ptu_moviment_benf_a100_v18_pck.set_cd_estabelecimento(cd_estabelecimento_p);
	CALL CALL CALL ptu_moviment_benf_a100_v18_pck.set_cd_intercambio(cd_intercambio_envio_p);
	begin
	select	max(ds_local),
		max(ds_local_rede)
	into STRICT	ds_local_w,
		ds_caminho_rede_w
	from	evento_tasy_utl_file
	where	cd_evento	= 21
	and	ie_tipo 	= 'G';
	exception
	when others then
		ds_local_w := null;
		ds_caminho_rede_w:= null;
		ds_erro_w := 'Erro ao buscar configurações UTL_FILE';
	end;
	
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		ds_erro_p	:= ds_erro_w;
		goto error;
	end if;
	
	ds_caminho_rede_P := ds_caminho_rede_w;
	
	PERFORM set_config('ptu_moviment_benf_a100_v18_pck.nm_arquivo_w', ptu_obter_nome_exportacao(cd_intercambio_envio_p,'IN'), false);
	CALL CALL CALL ptu_moviment_benf_a100_v18_pck.set_nome_arquivo(current_setting('ptu_moviment_benf_a100_v18_pck.nm_arquivo_w')::varchar(255));
	
	begin
	arq_texto_w := utl_file.fopen(ds_local_w,current_setting('ptu_moviment_benf_a100_v18_pck.nm_arquivo_w')::varchar(255),'w');
	exception
	when others then
		if (SQLSTATE = -29289) then
			ds_erro_p  := 'O acesso ao arquivo foi negado pelo sistema operacional (access_denied).';
		elsif (SQLSTATE = -29298) then
			ds_erro_p  := 'O arquivo foi aberto usando FOPEN_NCHAR,  mas efetuaram-se operações de I/O usando funções nonchar comos PUTF ou GET_LINE (charsetmismatch).';
		elsif (SQLSTATE = -29291) then
			ds_erro_p  := 'Não foi possível apagar o arquivo (delete_failed).';
		elsif (SQLSTATE = -29286) then
			ds_erro_p  := 'Erro interno desconhecido no package UTL_FILE (internal_error).';
		elsif (SQLSTATE = -29282) then
			ds_erro_p  := 'O handle do arquivo não existe (invalid_filehandle).';
		elsif (SQLSTATE = -29288) then
			ds_erro_p  := 'O arquivo com o nome especificado não foi encontrado neste local (invalid_filename).';
		elsif (SQLSTATE = -29287) then
			ds_erro_p  := 'O valor de MAX_LINESIZE para FOPEN() é inválido; deveria estar na faixa de 1 a 32767 (invalid_maxlinesize).';
		elsif (SQLSTATE = -29281) then
			ds_erro_p  := 'O parâmetro open_mode na chamda FOPEN é inválido (invalid_mode).';
		elsif (SQLSTATE = -29290) then
			ds_erro_p  := 'O parâmetro ABSOLUTE_OFFSET para a chamada FSEEK() é inválido; deveria ser maior do que 0 e menor do que o número total de bytes do arquivo (invalid_offset).';
		elsif (SQLSTATE = -29283) then
			ds_erro_p  := 'O arquivo não pôde ser aberto ou operado da forma desejada - ou o caminho não foi encontrado (invalid_operation).';
		elsif (SQLSTATE = -29280) then
			ds_erro_p  := 'O caminho especificado não existe ou não está visível ao Oracle (invalid_path).';
		elsif (SQLSTATE = -29284) then
			ds_erro_p  := 'Não é possível efetuar a leitura do arquivo (read_error).';
		elsif (SQLSTATE = -29292) then
			ds_erro_p  := 'Não é possível renomear o arquivo.';
		elsif (SQLSTATE = -29285) then
			ds_erro_p  := 'Não foi possível gravar no arquivo (write_error).';
		else
			ds_erro_p  := 'Erro desconhecido no package UTL_FILE.';
		end if;
		goto error;
	end;
	
	CALL CALL CALL CALL CALL ptu_moviment_benf_a100_v18_pck.processar_arquivo(nr_seq_lote_p,cd_unimed_destino_p,arq_texto_w);
	
	utl_file.fclose(arq_texto_w);
	
	ds_nome_arq_p := current_setting('ptu_moviment_benf_a100_v18_pck.nm_arquivo_w')::varchar(255);
	
	<<error>>
	ds_erro_w  := '';
	
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_moviment_benf_a100_v18_pck.gerar_arquivo_a100 ( nr_seq_lote_p bigint, cd_unimed_destino_p bigint, cd_intercambio_envio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ds_nome_arq_p INOUT text, ds_caminho_rede_p INOUT text) FROM PUBLIC;
