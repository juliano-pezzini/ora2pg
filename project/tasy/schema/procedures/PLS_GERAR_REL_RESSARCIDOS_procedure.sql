-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_rel_ressarcidos ( dt_recebimento_ini_p timestamp, dt_recebimento_fin_p timestamp, nr_seq_segurado_p pls_ressarcimento_v.nr_seq_segurado%type, nm_arquivo_p text, nm_usuario_p text) AS $body$
DECLARE

 
ds_conteudo_w			varchar(4000);
nm_arquivo_w			varchar(255);
ds_local_w			varchar(255) := null;
ds_erro_w			varchar(255);
arq_texto_w			utl_file.file_type;

C01 CURSOR FOR 
	SELECT 		nr_seq_conta ||';'|| 
			cd_procedimento ||';'|| 
			ds_procedimento ||';'|| 
			dt_procedimento ||';'|| 
			dt_recebimento ||';'|| 
			cd_usuario_plano ||';'|| 
			nm_segurado ||';'|| 
			nm_prestador_pagto ||';'|| 
			ds_def ||';'|| 
			ds_grupo_ans ||';'|| 
			ds_tipo_relacao ||';'|| 
			ds_ato_cooperado ||';'|| 
			ds_preco ||';'|| 
			ds_regulamentacao ||';'|| 
			ds_tipo_contratacao ||';'|| 
			ds_segmentacao ||';'|| 
			vl_evento ||';'|| 
			vl_ressarcimento ||';'|| 
			dt_movimento ||';'|| 
			cd_classif_prov_deb ||';'|| 
			cd_classif_prov_cred ||';'|| 
			nr_seq_segurado ||';'|| 
			dt_mes_competencia ||';'|| 
			nr_titulo ||';'|| 
			cd_guia ds_conteudo 
	from 		pls_ressarcimento_v a 
	where 		0=0 
	and		dt_recebimento between dt_recebimento_ini_p and fim_dia( dt_recebimento_fin_p ) 
	and ( nr_seq_segurado_p = '0' or a.nr_seq_segurado = nr_seq_segurado_p );


BEGIN 
 
begin 
SELECT * FROM obter_evento_utl_file(1, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
exception 
when others then 
	ds_local_w := null;
end;
 
nm_arquivo_w	:= nm_arquivo_p;
 
begin 
arq_texto_w := utl_file.fopen( ds_local_w,nm_arquivo_w,'W');
exception 
when others then 
	if (SQLSTATE = -29289) then 
		ds_erro_w := 'O acesso ao arquivo foi negado pelo sistema operacional (access_denied).';
	elsif (SQLSTATE = -29298) then 
		ds_erro_w := 'O arquivo foi aberto usando FOPEN_NCHAR, mas efetuaram-se operações de I/O usando funções nonchar comos PUTF ou GET_LINE (charsetmismatch).';
	elsif (SQLSTATE = -29291) then 
		ds_erro_w := 'Não foi possível apagar o arquivo (delete_failed).';
	elsif (SQLSTATE = -29286) then 
		ds_erro_w := 'Erro interno desconhecido no package UTL_FILE (internal_error).';
	elsif (SQLSTATE = -29282) then 
		ds_erro_w := 'O handle do arquivo não existe (invalid_filehandle).';
	elsif (SQLSTATE = -29288) then 
		ds_erro_w := 'O arquivo com o nome especificado não foi encontrado neste local (invalid_filename).';
	elsif (SQLSTATE = -29287) then 
		ds_erro_w := 'O valor de MAX_LINESIZE para FOPEN() é inválido; deveria estar na faixa de 1 a 32767 (invalid_maxlinesize).';
	elsif (SQLSTATE = -29281) then 
		ds_erro_w := 'O parâmetro open_mode na chamda FOPEN é inválido (invalid_mode).';
	elsif (SQLSTATE = -29290) then 
		ds_erro_w := 'O parâmetro ABSOLUTE_OFFSET para a chamada FSEEK() é inválido; deveria ser maior do que 0 e menor do que o número total de bytes do arquivo (invalid_offset).';
	elsif (SQLSTATE = -29283) then 
		ds_erro_w := 'O arquivo não pôde ser aberto ou operado da forma desejada - ou o caminho não foi encontrado (invalid_operation).';
	elsif (SQLSTATE = -29280) then 
		ds_erro_w := 'O caminho especificado não existe ou não está visível ao Oracle (invalid_path).';
	elsif (SQLSTATE = -29284) then 
		ds_erro_w := 'Não é possível efetuar a leitura do arquivo (read_error).';
	elsif (SQLSTATE = -29292) then 
		ds_erro_w := 'Não é possível renomear o arquivo.';
	elsif (SQLSTATE = -29285) then 
		ds_erro_w := 'Não foi possível gravar no arquivo (write_error).';
	else 
		ds_erro_w := 'Erro desconhecido no package UTL_FILE.';
	end if;
end;
 
select 		'Nr conta' ||';'|| 
		'Código procedimento material' ||';'|| 
		'Ds procedimento material' ||';'|| 
		'Dt procedimento' ||';'|| 
		'Dt recebimento' ||';'|| 
		'Cd usuario plano' ||';'|| 
		'Nm segurado' ||';'|| 
		'Prestador' ||';'|| 
		'Definição operação' ||';'|| 
		'Tipo proc' ||';'|| 
		'Tipo vínculo'||';'|| 
		'Definição dos Atos' ||';'|| 
		'Modalidade contratação' ||';'|| 
		'Tipo regulamentação' ||';'|| 
		'Tipo de contratação' ||';'|| 
		'Segmentação' ||';'|| 
		'Valor evento' ||';'|| 
		'Valor recuperação' ||';'|| 
		'Data contabilização' ||';'|| 
		'Conta contábil débito'||';'|| 
		'Conta contábil crédito' ||';'|| 
		'Nr Seq Segurado' ||';'|| 
		'Data contabilização' ||';'|| 
		'Número do título de cobrança' ||';'|| 
		'Cd Guia' ds_conteudo 
into STRICT 		ds_conteudo_w
;
 
utl_file.put_line( arq_texto_w,ds_conteudo_w || chr(13));
utl_file.fflush( arq_texto_w);
ds_conteudo_w := null;
 
open C01;
loop 
fetch C01 into	 
	ds_conteudo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	utl_file.put_line( arq_texto_w,ds_conteudo_w || chr(13));
	utl_file.fflush( arq_texto_w);
	ds_conteudo_w := null;	
	end;
end loop;
close C01;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_rel_ressarcidos ( dt_recebimento_ini_p timestamp, dt_recebimento_fin_p timestamp, nr_seq_segurado_p pls_ressarcimento_v.nr_seq_segurado%type, nm_arquivo_p text, nm_usuario_p text) FROM PUBLIC;

