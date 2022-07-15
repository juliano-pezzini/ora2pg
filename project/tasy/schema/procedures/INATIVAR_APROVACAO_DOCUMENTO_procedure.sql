-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_aprovacao_documento (nm_tabela_p text, nm_chave_p text, qt_chave_p bigint, nm_usuario_p text) AS $body$
DECLARE

				
nr_seq_item_w bigint;
nr_seq_doc_w 	  bigint;
ds_sql		  varchar(1000);
nr_cirurgia_w bigint;
cd_funcao_w bigint;


BEGIN

cd_funcao_w := wheb_usuario_pck.get_cd_funcao;		


    update documento_aprovacao
    set dt_inativacao = clock_timestamp(),
        ie_situacao = 'I',
        ds_justificativa = 'Inativacao do item origem'
      where nm_tabela_origem = nm_tabela_p
		   and nr_seq_origem = qt_chave_p;

commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_aprovacao_documento (nm_tabela_p text, nm_chave_p text, qt_chave_p bigint, nm_usuario_p text) FROM PUBLIC;

