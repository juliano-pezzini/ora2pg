-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_arq_mov_prestador ( nr_seq_lote_p bigint, cd_interface_p text, nm_arquivo_xml_p text, nm_usuario_p text, ds_local_p INOUT text, nm_arquivo_p INOUT text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar arquivo A400 de acordo com a versão
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionário [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção: PTU 5.0
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ 

nm_arquivo_w			varchar(255);
ds_local_w			varchar(255) := null;
ds_local_windows_w		varchar(255) := null;
ds_erro_w			varchar(255);
ds_local_windows_zip_w		varchar(4000);
nm_arquivo_zip_w		varchar(255);
ds_arquivos_w			varchar(255);
ds_erro_zip_w			varchar(1000);


BEGIN

select	ptu_obter_nome_exportacao(nr_seq_lote_p,'MCP')
into STRICT	nm_arquivo_w
;

begin
SELECT * FROM obter_evento_utl_file(3, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
SELECT * FROM pls_obter_dir_rede_utl_file(3, null, ds_local_windows_w, ds_erro_w) INTO STRICT ds_local_windows_w, ds_erro_w;
exception
when others then
	ds_local_w := null;
	ds_local_windows_w	:= '';
end;

if (coalesce(ds_local_w::text, '') = '') then
	SELECT * FROM obter_evento_utl_file(1, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
	SELECT * FROM pls_obter_dir_rede_utl_file(1, null, ds_local_windows_w, ds_erro_w) INTO STRICT ds_local_windows_w, ds_erro_w;
end if;

-- PTU 5.0
if (cd_interface_p = '2477') then
	CALL ptu_gerar_arq_mov_prestador_50(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 6.0
elsif (cd_interface_p = '2583') then
	CALL ptu_gerar_arq_mov_prestador_60(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 6.2
elsif (cd_interface_p = '2647') then
	CALL ptu_gerar_arq_mov_prestador_62(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 6.3
elsif (cd_interface_p = '2689') then
	CALL ptu_gerar_arq_mov_prestador_63(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);

-- PTU 7.0
elsif (cd_interface_p = '2751') then
	CALL ptu_gerar_arq_mov_prestador_70(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 8.0
elsif (cd_interface_p = '2786') then
	CALL ptu_gerar_arq_mov_prestador_80(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 8.1
elsif (cd_interface_p = '2831') then
	CALL ptu_gerar_arq_mov_prestador_81(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 10.0
elsif (cd_interface_p = '2922') then
	CALL ptu_gerar_arq_mov_prestad_100(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
	
-- PTU 11.0
elsif (cd_interface_p = '2977') then
	CALL ptu_gerar_arq_mov_prestad_110(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);

-- PTU 11.1
elsif (cd_interface_p = '3083') then
	CALL ptu_gerar_arq_mov_prestad_111(nr_seq_lote_p,cd_interface_p,nm_usuario_p,ds_local_w,nm_arquivo_w);
end if;

-- ## REMOVIDA A COMPACTAÇÃO DE ARQUIVO VIA UTL_FILE, O METODO USADO ERA VALIDO SOMENTE NO ORACLE 12C em diante

-- PLS_UTL_ZIP_PCK.COMPACTAR_ARQUIVOS
ds_local_p	:= ds_local_windows_w;
nm_arquivo_p	:= nm_arquivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_arq_mov_prestador ( nr_seq_lote_p bigint, cd_interface_p text, nm_arquivo_xml_p text, nm_usuario_p text, ds_local_p INOUT text, nm_arquivo_p INOUT text) FROM PUBLIC;

