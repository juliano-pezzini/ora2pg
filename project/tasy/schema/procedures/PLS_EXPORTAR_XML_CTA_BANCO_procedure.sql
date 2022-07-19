-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_exportar_xml_cta_banco ( nr_seq_xml_arquivo_p pls_xml_arquivo.nr_sequencia%type ) AS $body$
DECLARE


nm_arquivo_w 		pls_xml_arquivo.nm_arquivo%type;
ds_local_w		varchar(255) := null;
ds_local_windows_w	varchar(255) := null;
ds_erro_w		varchar(255);
arq_texto_w		utl_file.file_type;
ds_conteudo_w		text;
file_exist_w		boolean;
size_w			bigint;
block_size_w		bigint;
qt_tamanho_w		integer;
qt_posicao_w		integer;


BEGIN

select	nm_arquivo
into STRICT	nm_arquivo_w
from	pls_xml_arquivo
where	nr_sequencia = nr_seq_xml_arquivo_p;

pls_convert_long_(	'PLS_XML_ARQUIVO',
				'DS_XML',
				'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
				'NR_SEQUENCIA='||nr_seq_xml_arquivo_p,
				ds_conteudo_w);

begin
SELECT * FROM obter_evento_utl_file(19, null, ds_local_w, ds_erro_w) INTO STRICT ds_local_w, ds_erro_w;
exception
when others then
	ds_local_w := null;
	ds_local_windows_w := '';
end;

utl_file.fgetattr(ds_local_w,nm_arquivo_w,file_exist_w,size_w,block_size_w);

if (file_exist_w) then
	utl_file.fremove(ds_local_w,nm_arquivo_w);
end if;

if (coalesce(ds_local_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(387514);
else
	begin
	arq_texto_w := utl_file.fopen(ds_local_w,nm_arquivo_w,'W');
	exception
	when others then
		ds_erro_w := obter_erro_utl_open(SQLSTATE);
		CALL wheb_mensagem_pck.exibir_mensagem_abort('Local: '||ds_local_w||' Nome arquivo: '||nm_arquivo_w||' '||ds_erro_w);
	end;

	qt_tamanho_w	:= octet_length(ds_conteudo_w);
	qt_posicao_w	:= 1;

	while(qt_posicao_w < qt_tamanho_w) loop
		utl_file.put_line(arq_texto_w,substr(ds_conteudo_w, 32767, qt_posicao_w));
		utl_file.fflush(arq_texto_w);
		qt_posicao_w := qt_posicao_w + 32767;
	end loop;

	utl_file.fclose(arq_texto_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_exportar_xml_cta_banco ( nr_seq_xml_arquivo_p pls_xml_arquivo.nr_sequencia%type ) FROM PUBLIC;

