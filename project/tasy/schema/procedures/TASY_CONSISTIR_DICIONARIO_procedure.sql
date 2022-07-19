-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_consistir_dicionario ( nm_owner_origem_p text, ds_msg_erro_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


qt_count_tasy_w		bigint;
qt_count_tasy_versao_w	bigint;
ds_msg_erro_w		varchar(4000);



BEGIN

ds_msg_erro_w := '';

CALL gravar_processo_longo('Verificando a tabela TABELA_ATRIBUTO','TASY_CONSISTIR_DICIONARIO',-1);

qt_count_tasy_versao_w := Obter_valor_dinamico('select count(1) from ' || nm_owner_origem_p || '.TABELA_ATRIBUTO', qt_count_tasy_versao_w);
qt_count_tasy_w := Obter_valor_dinamico('select count(1) from TABELA_ATRIBUTO', qt_count_tasy_w);

if (qt_count_tasy_versao_w > qt_count_tasy_w) then

	Tasy_Atualizar_Base_versao(nm_owner_origem_p);
	qt_count_tasy_versao_w := Obter_valor_dinamico('select count(1) from ' || nm_owner_origem_p || '.TABELA_ATRIBUTO', qt_count_tasy_versao_w);
	qt_count_tasy_w := Obter_valor_dinamico('select count(1) from TABELA_ATRIBUTO', qt_count_tasy_w);

	if (qt_count_tasy_versao_w > qt_count_tasy_w) then
		ds_msg_erro_w := ds_msg_erro_w || '-'||obter_desc_expressao(786813)||' (TABELA_ATRIBUTO).' || chr(13)||chr(10);
	end if;

end if;

CALL gravar_processo_longo('Verificando a tabela FUNCAO_PARAMETRO','TASY_CONSISTIR_DICIONARIO',-1);

qt_count_tasy_versao_w := Obter_valor_dinamico('select count(1) from ' || nm_owner_origem_p || '.FUNCAO_PARAMETRO', qt_count_tasy_versao_w);
qt_count_tasy_w := Obter_valor_dinamico('select count(1) from FUNCAO_PARAMETRO', qt_count_tasy_w);

if (qt_count_tasy_versao_w > qt_count_tasy_w) then

	CALL Tasy_Atualizar_Base(nm_usuario_p, nm_owner_origem_p);
	qt_count_tasy_versao_w := Obter_valor_dinamico('select count(1) from ' || nm_owner_origem_p || '.FUNCAO_PARAMETRO', qt_count_tasy_versao_w);
	qt_count_tasy_w := Obter_valor_dinamico('select count(1) from FUNCAO_PARAMETRO', qt_count_tasy_w);

	if (qt_count_tasy_versao_w > qt_count_tasy_w) then
		ds_msg_erro_w := ds_msg_erro_w || '-'||obter_desc_expressao(786813)||' (FUNCAO_PARAMETRO).'|| chr(13)||chr(10);
	end if;

end if;

if (ds_msg_erro_w IS NOT NULL AND ds_msg_erro_w::text <> '') then

	ds_msg_erro_w := obter_desc_expressao(786815)/*'Ocorreram os seguintes erros ao atualizar o dicionário do TASY:'*/
||chr(13)||chr(10)||chr(13)||chr(10) || ds_msg_erro_w;
	--dbms_output.put_line(ds_msg_erro_w);
end if;

ds_msg_erro_p := ds_msg_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_consistir_dicionario ( nm_owner_origem_p text, ds_msg_erro_p INOUT text, nm_usuario_p text) FROM PUBLIC;

