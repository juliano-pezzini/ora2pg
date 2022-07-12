-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_dados_atuariais_pck.consistir_sql_regra_arq ( nr_seq_regra_p pls_atuarial_arq_regra.nr_sequencia%type, ds_erro_p INOUT text) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Realiza verificacao de sintax do sql final montado para a regra do lote.

	Sera utilizada a tabela conforme o tipo de arquivo da regra.
	
	O SQL sera montado, e o unico binding que tera vai ser o valor "0" (zero)
	para nao retornar nenhum valor de fato, apenas executar o SQL.
	
	O SQL sera armazenado em uma variavel, que sera atribuida a um parametro out,
	para permitir a sua visualizacao pelo desktop.
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


campos_arquivo_w	campo_arquivo;
regra_arquivo_w		regra_arquivo;
lote_atuarial_w		lote_atuarial;

ds_tabela_dados_w	varchar(30);

ds_sql_w		varchar(32000):= '';
dado_bind_w		sql_pck.t_dado_bind;

cursor_w		sql_pck.t_cursor;


BEGIN

ds_erro_p	:= '';

regra_arquivo_w	:= pls_dados_atuariais_pck.retorna_regra_arquivo(nr_seq_regra_p);

-- Para a simulacao, sera utilizado o valor fixo "0", para nao retornar nenhum registro.

lote_atuarial_w.nr_sequencia := 0;

-- levanta a tabela de dados 

ds_tabela_dados_w := pls_dados_atuariais_pck.retorna_tabela_dados_arq(regra_arquivo_w.ie_tipo_arquivo);

-- Carrega os campos

campos_arquivo_w := pls_dados_atuariais_pck.gera_campo_arquivo(regra_arquivo_w.nr_seq_regra, 'a');

-- Monta o SQL e os bindings

dado_bind_w.delete;

SELECT * FROM pls_dados_atuariais_pck.retorna_sql_arq(lote_atuarial_w, campos_arquivo_w, ds_tabela_dados_w, dado_bind_w) INTO STRICT _ora2pg_r;
 lote_atuarial_w := _ora2pg_r.lote_atuarial_p; campos_arquivo_w := _ora2pg_r.campos_arquivo_p; dado_bind_w := _ora2pg_r.dado_bind_p;

begin

	-- Grava o SQL gerado como log na regra. Esse SQL NAO sera utilizado na consulta, ele e apenas ilustrativo

	update	pls_atuarial_arq_regra
	set	ds_sql		= ds_sql_w
	where	nr_sequencia	= nr_seq_regra_p;
	commit;

	-- abre o cursor com os dados, nao e necessario navegar entre eles.

	dado_bind_w := sql_pck.executa_sql_cursor(ds_sql_w, dado_bind_w);

	if (cursor_w%isopen) then
		
		close cursor_w;
	end if;

exception

	when others then
		ds_erro_p	:= substr(sqlerrm,1,255);
		
		if (cursor_w%isopen) then
			
			close cursor_w;
		end if;
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_dados_atuariais_pck.consistir_sql_regra_arq ( nr_seq_regra_p pls_atuarial_arq_regra.nr_sequencia%type, ds_erro_p INOUT text) FROM PUBLIC;