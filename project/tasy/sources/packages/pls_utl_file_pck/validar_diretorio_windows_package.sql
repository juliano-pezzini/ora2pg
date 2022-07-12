-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Validar diret? Windows
CREATE OR REPLACE PROCEDURE pls_utl_file_pck.validar_diretorio_windows (ds_local_windows_p text, nr_seq_erro_p INOUT dic_objeto.nr_sequencia%type ) AS $body$
BEGIN

-- Validar para que o diret? Windows seja obrigat?
if (coalesce(ds_local_windows_p::text, '') = '') then
	nr_seq_erro_p := 460844; -- Favor verificar o cadastro UTL_FILE, necess?o informar o campo Local na rede (Windows)
end if;

-- Validar se o diret? ?omum para o Windows
if (ds_local_windows_p IS NOT NULL AND ds_local_windows_p::text <> '') and
	(position('\') = 0) then --'
	nr_seq_erro_p := 460848; -- Favor verificar o cadastro UTL_FILE, necess?o informar um diret? v?do para o Windows no campo Local na rede (Windows)
end if;

end pls_utl_file_pck.validar_diretorio_windows();

-- Obter o erro causado no UTL_FILE
function pls_utl_file_pck.obter_erro_utl( sqlcode_p	number )
			return number is

begin

if	(sqlcode = -29289) then
	return 281845; -- O acesso ao arquivo foi negado pelo sistema operacional (access_denied).
	
elsif	(sqlcode = -29298) then
	return 281846; -- O arquivo foi aberto usando FOPEN_NCHAR,  mas efetuaram-se opera?s de I/O usando fun?s nonchar comos PUTF ou GET_LINE (charsetmismatch).
	
elsif	(sqlcode = -29291) then
	return 281847; -- N?foi poss?l apagar o arquivo (delete_failed).
	
elsif	(sqlcode = -29286) then
	return 281848; -- Erro interno desconhecido no package UTL_FILE (internal_error).
	
elsif	(sqlcode = -29282) then
	return 281849; -- O handle do arquivo n?existe (invalid_filehandle).
			
elsif	(sqlcode = -29288) then
	return 281850; -- O arquivo com o nome especificado n?foi encontrado neste local (invalid_filename).
			
elsif	(sqlcode = -29287) then
	return 281851; -- O valor de MAX_LINESIZE para FOPEN() ?nv?do; deveria estar na faixa de 1 a 32767 (invalid_maxlinesize).
	
elsif	(sqlcode = -29281) then
	return 281852; -- O par?tro open_mode na chamda FOPEN ?nv?do (invalid_mode).
			
elsif	(sqlcode = -29290) then
	return 281853; -- O par?tro ABSOLUTE_OFFSET para a chamada FSEEK() ?nv?do; deveria ser maior do que 0 e menor do que o n?mero total de bytes do arquivo (invalid_offset).
			
elsif	(sqlcode = -29283) then
	return 1080852; -- O arquivo n?p?ser aberto ou n?foi encontrado no diret? especificado.
	
elsif	(sqlcode = -29280) then
	return 281855; -- O caminho especificado n?existe ou n?est?is?l ao Oracle (invalid_path).
	
elsif	(sqlcode = -29284) then
	return 281856; -- N??oss?l efetuar a leitura do arquivo (read_error).
			
elsif	(sqlcode = -29292) then
	return 281857; -- N??oss?l renomear o arquivo.
			
elsif	(sqlcode = -29285) then
	return 281858; -- N?foi poss?l gravar no arquivo (write_error).
			
else
	return 281859; -- Erro desconhecido no package UTL_FILE.
end if;

end;

-- Obter os diretorios UTL / Windows
procedure pls_utl_file_pck.obter_local_utl(	cd_evento_p			evento_tasy_utl_file.cd_evento%type,
				ds_local_utl_p		out	varchar,
				ds_local_windows_p	out	varchar,
				ie_valida_dir_ws_p		varchar) is
begin

begin
-- Obter local reconhecido pelo ORACLE para gera? do arquivo UTL_FILE
obter_evento_utl_file( cd_evento_p, null, ds_local_utl_p, ds_erro_w);
exception
when others then
	ds_local_utl_p 		:= null;
end;

-- Obter local reconhecido pelo WINDOWS para gera? do arquivo UTL_FILE
if	(ie_valida_dir_ws_p = 'S') and
	(ds_erro_w is null)  then
	begin
	pls_obter_dir_rede_utl_file( cd_evento_p, null, ds_local_windows_p, ds_erro_w);
	exception
	when others then
		ds_local_windows_p	:= null;
	end;
	
	-- Validar diret? Windows
	if	(ds_erro_w is null) then
		pls_utl_file_pck.validar_diretorio_windows( ds_local_windows_p, nr_seq_erro_w);
	end if;
end if;

-- Caso tenha erro no diret? do arquivo por UTL_FILE, barrar o processo
pls_utl_file_pck.tratar_erro( ds_erro_w, nr_seq_erro_w);

end pls_utl_file_pck.obter_local_utl();

-- Abrir arquivo para leitura
procedure pls_utl_file_pck.nova_leitura(	cd_evento_p		evento_tasy_utl_file.cd_evento%type,
				nm_arquivo_p		varchar2,
				ie_acao_p		varchar2 default 'R') is

-- Variaveis
ds_local_w		varchar2(4000) := null;
ds_local_windows_w	varchar2(4000) := null;

begin
-- Obter local reconhecido pelo ORACLE para gera? do arquivo UTL_FILE
pls_utl_file_pck.obter_local_utl( cd_evento_p, ds_local_w, ds_local_windows_w, 'N');

-- Abrir para leitura o arquivo texto por UTL_FILE dentro do diret? reconhecido pelo ORACLE
pls_utl_file_pck.criar_abrir( ds_local_w, nm_arquivo_p, nvl(ie_acao_p,'R'), 4000);

end pls_utl_file_pck.nova_leitura();

-- Retornar linha do arquivo
procedure pls_utl_file_pck.ler(	ds_conteudo_p	out varchar2,
			ie_leitura_p	out boolean ) is
begin
-- Verificar se o arquivo esta aberto para leitura
if	(utl_file.is_open(ds_arquivo_w)) then
	ie_leitura_p := true;

	-- Obter a linha
	begin
	utl_file.get_line( ds_arquivo_w, ds_conteudo_p);
	exception
	when others then
		ie_leitura_p := false;
	end;
end if;

end pls_utl_file_pck.ler();

-- Copiar arquivo
procedure pls_utl_file_pck.copiar_arquivo(	cd_evento_origem_p	evento_tasy_utl_file.cd_evento%type,
				nm_arquivo_origem_p	varchar2,
				cd_evento_dest_p	evento_tasy_utl_file.cd_evento%type,
				nm_arquivo_dest_p	varchar2,
				nr_seq_linha_ini_p	number,
				nr_seq_linha_fim_p	number ) is

-- Variaveis
ds_local_origem_w	varchar2(4000) := null;
ds_local_dest_w		varchar2(4000) := null;
ds_local_windows_w	varchar2(4000) := null;

begin
-- Obter local reconhecido pelo ORACLE para gera? do arquivo UTL_FILE
pls_utl_file_pck.obter_local_utl( cd_evento_origem_p, ds_local_origem_w, ds_local_windows_w, 'N');

if	(nr_seq_erro_w is null) then
	-- Obter local reconhecido pelo ORACLE para gera? do arquivo UTL_FILE
	pls_utl_file_pck.obter_local_utl( nvl(cd_evento_dest_p,cd_evento_origem_p), ds_local_dest_w, ds_local_windows_w, 'N');
end if;

-- Copiar as informa?s do arquivo origem para arquivo destino (o arquivo destino n?pode existir)
begin
utl_file.fcopy( ds_local_origem_w, nm_arquivo_origem_p, ds_local_dest_w, nm_arquivo_dest_p, nr_seq_linha_ini_p, nr_seq_linha_fim_p);
exception
when others then
	nr_seq_erro_w := 462978; -- N?foi poss?l copiar o arquivo por UTL_FILE
end;

-- Caso tenha erro para copiar o diret? UTL_FILE
pls_utl_file_pck.tratar_erro( null, nr_seq_erro_w);

end pls_utl_file_pck.copiar_arquivo();

-- Excluir arquivo
procedure pls_utl_file_pck.excluir_arquivo(	cd_evento_exc_p		evento_tasy_utl_file.cd_evento%type,
				nm_arquivo_exc_p	varchar2) is

-- Variaveis
ds_local_exc_w		varchar2(4000) := null;
ds_local_windows_w	varchar2(4000) := null;

begin
-- Obter local reconhecido pelo ORACLE para gera? do arquivo UTL_FILE
pls_utl_file_pck.obter_local_utl( cd_evento_exc_p, ds_local_exc_w, ds_local_windows_w, 'N');

-- Comando para excluir arquivo
begin
utl_file.fremove( ds_local_exc_w, nm_arquivo_exc_p);
exception
when others then
	nr_seq_erro_w := 466335; -- N?foi poss?l excluir o arquivo por UTL_FILE
end;

-- Caso tenha erro para excluir o diret? UTL_FILE
pls_utl_file_pck.tratar_erro( null, nr_seq_erro_w);

end pls_utl_file_pck.excluir_arquivo();

-- Obtem informa?s sobre o arquivo
function pls_utl_file_pck.obter_dados_arquivo(	cd_evento_p		evento_tasy_utl_file.cd_evento%type,
					nm_arquivo_p		varchar2, -- nome do arquivo com a exten?, exemplo: teste.txt
					ie_opcao_p		varchar2)
					return varchar2 is

-- Variaveis
ds_local_w		varchar2(4000) := null;
ds_local_windows_w	varchar2(4000) := null;
ds_retorno_w		varchar2(4000) := null;
ie_existe_arq_w		boolean;
nr_tamanho_arq_w	number(20,4);
nr_tam_bloco_arq_w	number(20,4);

begin
-- Obter local reconhecido pelo ORACLE para gera? do arquivo UTL_FILE
pls_utl_file_pck.obter_local_utl( cd_evento_p, ds_local_w, ds_local_windows_w, 'N');

begin
-- Comando para verificar informa?s sobre o arquivo
utl_file.fgetattr(ds_local_w,nm_arquivo_p, ie_existe_arq_w, nr_tamanho_arq_w, nr_tam_bloco_arq_w);
exception
when others then
	ie_existe_arq_w		:= false;
	nr_tamanho_arq_w	:= 0;
	nr_tam_bloco_arq_w	:= 0;
end;

--	Existe o arquivo no diret? UTL
if	(ie_opcao_p = 'E') then
	ds_retorno_w := 'N';
	if	(ie_existe_arq_w) then
		ds_retorno_w := 'S';
	end if;

--	Tamanho do arquivo em bytes.
elsif	(ie_opcao_p = 'T') then
	ds_retorno_w := nr_tamanho_arq_w;
	
--	Sistema de arquivos tamanho do bloco em bytes.
elsif	(ie_opcao_p = 'B') then
	ds_retorno_w := nr_tam_bloco_arq_w;
end if;

return ds_retorno_w;

end pls_utl_file_pck.obter_dados_arquivo();

-- Obtem local do windows do UTL
function pls_utl_file_pck.obter_local_windows(	cd_evento_p		evento_tasy_utl_file.cd_evento%type) 
					return varchar2 is

ds_retorno_w		varchar2(4000) := null;

begin
pls_obter_dir_rede_utl_file( cd_evento_p, null, ds_retorno_w, ds_erro_w);

if	(ds_erro_w is not null) then
	pls_utl_file_pck.tratar_erro( ds_erro_w, null);
end if;

return ds_retorno_w;

end pls_utl_file_pck.obter_local_windows();

function pls_utl_file_pck.obter_local(	cd_evento_p			evento_tasy_utl_file.cd_evento%type,
			ie_opcao_p			varchar2) return varchar2 is
			
ds_local_windows_w	varchar2(4000) := null;
ds_local_w		varchar2(4000) := null;
ds_retorno_w		varchar2(4000) := null;

begin

if	(ie_opcao_p = 'W') then
	ds_retorno_w	:= pls_utl_file_pck.obter_local_windows(cd_evento_p);
	
elsif	(ie_opcao_p = 'L') then
	pls_utl_file_pck.obter_local_utl( cd_evento_p, ds_local_w, ds_local_windows_w, 'N' in ds_local_windows_p);
	
	ds_retorno_w	:= ds_local_w;
end if;

return;

end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utl_file_pck.validar_diretorio_windows (ds_local_windows_p text, nr_seq_erro_p INOUT dic_objeto.nr_sequencia%type ) FROM PUBLIC;
