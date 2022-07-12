-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_dados_atuariais_pck.retorna_sql_arq ( lote_atuarial_p INOUT lote_atuarial, campos_arquivo_p INOUT campo_arquivo, ds_tabela_p text, dado_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o arquivo para beneficiarios.
	
	E buscado o titulo das colunas, caso todas forem definidas, elas serao atribuidas
	na primeira linha do arquivo. Caso alguma coluna nao tenha o cabecalho informado,
	todas as demais serao ignoradas.
	
	Sera montado um SQL que ira concatenar todos os campos configurados, conforme
	nr_ordem, sera feita a carga destes dados e entao gravados no UTL FILE.

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ds_retorno_w	varchar(32000):= '';
concat_char_w	varchar(2):='';
BEGIN

if (campos_arquivo_p.nr_seq_regra_campo.count > 0) then

	ds_retorno_w := 'select'|| pls_util_pck.enter_w;
	
	for i in campos_arquivo_p.nr_seq_regra_campo.first..campos_arquivo_p.nr_seq_regra_campo.last loop
	
		if (i != campos_arquivo_p.nr_seq_regra_campo.first) then
		
			concat_char_w := '||';
		end if;
		
		ds_retorno_w := ds_retorno_w ||	chr(9)||concat_char_w||campos_arquivo_p.ds_sql(i)||'||'''||campos_arquivo_p.ie_separador(i)||''''||' /* '||campos_arquivo_p.ie_campo(i)||' */'||pls_util_pck.enter_w;
	end loop;
	
	
	
	ds_retorno_w := ds_retorno_w ||	'	ds_conteudo ' ||pls_util_pck.enter_w ||
					'from	'||ds_tabela_p||'	a, ' ||pls_util_pck.enter_w ||
					'	pls_atuarial_lote	b ' ||pls_util_pck.enter_w ||
					'where	b.nr_sequencia		= a.nr_seq_lote '  ||pls_util_pck.enter_w ||
					'and	a.nr_seq_lote		= :nr_seq_lote '  ||pls_util_pck.enter_w;
					
	dado_bind_p := sql_pck.bind_variable(':nr_seq_lote', lote_atuarial_p.nr_sequencia, dado_bind_p);
end if;

return;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_dados_atuariais_pck.retorna_sql_arq ( lote_atuarial_p INOUT lote_atuarial, campos_arquivo_p INOUT campo_arquivo, ds_tabela_p text, dado_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
