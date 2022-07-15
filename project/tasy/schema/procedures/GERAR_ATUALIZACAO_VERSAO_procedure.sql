-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atualizacao_versao ( cd_versao_p text, dt_versao_p timestamp) AS $body$
DECLARE


dt_versao_w				timestamp;


BEGIN
update tabela_sistema
set ie_criar_alterar = 'M',
    ie_gera_definicao = 'N';

update tabela_atributo
set ie_criar_alterar = 'M';

update indice
set ie_criar_alterar = 'M';

update integridade_referencial
set ie_criar_alterar = 'M';

update Objeto_sistema
set ie_gerar_script = 'N';

dt_versao_w		:= dt_versao_p;
if (cd_versao_p IS NOT NULL AND cd_versao_p::text <> '') then
	begin
	select dt_versao
	into STRICT 	dt_versao_w
	from aplicacao_tasy_versao
	where cd_aplicacao_tasy = 'Tasy'
	  and cd_versao	= cd_versao_p;
	exception
		when others then
			dt_versao_w	:= dt_versao_p;
	end;
end if;

if (dt_versao_w IS NOT NULL AND dt_versao_w::text <> '') then
	begin
	update tabela_sistema
	set ie_criar_alterar = 'I',
	    ie_gera_definicao = 'S'
	where ie_situacao = 'A'
	  and dt_criacao >= dt_versao_w;

	update tabela_Atributo a
	set ie_criar_alterar = 'I'
	where ie_situacao = 'A'
	  and dt_criacao >= dt_versao_w
	  and exists (
		SELECT 1
		from tabela_sistema b
		where a.nm_tabela 	= b.nm_tabela
		  and b.ie_situacao = 'A'
		  and b.ie_criar_alterar <> 'I');

	update Indice a
	set ie_criar_alterar = 'I'
	where ie_situacao = 'A'
	  and dt_criacao >= dt_versao_w
	  and exists (
		SELECT 1
		from tabela_sistema b
		where a.nm_tabela 	= b.nm_tabela
		  and b.ie_situacao = 'A'
		  and b.ie_criar_alterar <> 'I');

	update Integridade_Referencial a
	set ie_criar_alterar = 'I'
	where ie_situacao = 'A'
	  and dt_criacao >= dt_versao_w
	  and exists (
		SELECT 1
		from tabela_sistema b
		where a.nm_tabela 	= b.nm_tabela
		  and b.ie_situacao = 'A'
		  and b.ie_criar_alterar <> 'I');

	update tabela_sistema
	set ie_criar_alterar = 'A',
	    ie_gera_definicao = 'S'
	where ie_situacao = 'A'
        and ie_criar_alterar <> 'I'
	  and nm_tabela in (
		SELECT distinct nm_tabela
		from tabela_atributo
		where ie_criar_alterar = 'I'
		
union

		SELECT distinct nm_tabela
		from Indice
		where ie_criar_alterar = 'I'
		
union

		select distinct nm_tabela
		from Integridade_Referencial
		where ie_criar_alterar = 'I');
	end;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atualizacao_versao ( cd_versao_p text, dt_versao_p timestamp) FROM PUBLIC;

