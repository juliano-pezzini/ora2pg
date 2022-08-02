-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_texto_macro ( nr_seq_chave_p bigint, ds_texto_p text, nr_seq_contrato_p bigint, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE

/*      ie_opcao_p
C- Contrato
P - Proposta
O - Proposta online
*/
ds_retorno_w		text;
ds_texto_w		text;
ds_texto_alterado_w	text;
pos_macro_w		bigint;
ds_macro_w		varchar(100);
nm_atributo_w		varchar(50);
pos_fim_macro_w		bigint;
vl_atributo_w		varchar(255);
ds_resultado_macro_w	varchar(255);
cd_pessoa_fisica_w	varchar(14);
nr_seq_rtf_string_w	bigint;
ds_texto_alterado_ww	text;

nr_sequencia_w		bigint;
ds_param_w		varchar(255);
ds_sql_w		varchar(255);
ds_campo_clob_w		text;
c001			integer;
ds_conteudo_1_w		varchar(32764);
ds_conteudo_2_w		varchar(32764);
qt_registro_w		bigint;
retorno_w		bigint;
ds_dispositivo_w	varchar(255);


BEGIN

ds_texto_w	:= ds_texto_p;

if (coalesce(ds_texto_w::text, '') = '') then
	select	count(*)
	into STRICT	qt_registro_w
	from	user_tables
	where	table_name = 'W_COPIA_CAMPO_LONG';
	
	if ( qt_registro_w = 0 ) then
		CALL exec_sql_dinamico('','create table w_copia_campo_long (nr_sequencia number(10), ds_texto clob)');
	end if;
	/*FIM - VERIFICAR SE TABELA TEMPORARIO EXISTE SE NAO EXISTIR CRIA*/

	
	/*INICIO - TRANSFERE CONTEUDO DO CAMPO LONG DA TABELA DE ORIGEM PARA O CAMPO CLOB DA TABELA TEMPORARIO*/

	nr_sequencia_w := obter_valor_dinamico('select	(nvl(max(nr_sequencia),0) + 1) from w_copia_campo_long', nr_sequencia_w);
	ds_sql_w   := 'insert into w_copia_campo_long select :SEQUENCE, to_lob(DS_TEMA) from pls_contrato_doc_texto
			where nr_sequencia = :nr_sequencia';
	ds_param_w := 'SEQUENCE='|| TO_CHAR(nr_sequencia_w)||';' || 'nr_sequencia=' || to_char(nr_seq_chave_p);
	CALL exec_sql_dinamico_bv('',ds_sql_w,ds_param_w);
	
	/*FIM - TRANSFERE CONTEUDO DO CAMPO LONG DA TABELA DE ORIGEM PARA O CAMPO CLOB DA TABELA TEMPORARIO*/

	
	/*INICIO - RECUPERA O VALOR DO CAMPO CLOB PARA A VARIAVEL DA PROCEDURE*/

	ds_sql_w	:= ' select ds_texto from w_copia_campo_long where nr_sequencia = :sequence ';
	
	C001 := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE(C001, ds_sql_w, dbms_sql.Native);
	DBMS_SQL.DEFINE_COLUMN(C001, 1, ds_campo_clob_w);
	DBMS_SQL.BIND_VARIABLE(C001, 'SEQUENCE', nr_sequencia_w);
	retorno_w := DBMS_SQL.EXECUTE(c001);
	retorno_w := DBMS_SQL.fetch_rows(c001);
	DBMS_SQL.COLUMN_VALUE(C001, 1, ds_campo_clob_w );
	DBMS_SQL.CLOSE_CURSOR(C001);
	
	/*FIM - RECUPERA O VALOR DO CAMPO CLOB PARA A VARIAVEL DA PROCEDURE*/

	
	/*INICIO - QUEBRA O VALOR DO CONTEUDO CLOB EM VARIOS VARCHAR PARA PODER INSERIR NA TABELA DE ORIGEM*/

	ds_conteudo_1_w := substr(ds_campo_clob_w,32764,1);
	ds_conteudo_2_w := substr(ds_campo_clob_w,32764,32765);
	ds_texto_w	:= ds_conteudo_1_w;
	
	ds_sql_w := 'delete from w_copia_campo_long where nr_sequencia = :nr_sequencia';
	ds_param_w := 'NR_SEQUENCIA='|| TO_CHAR(nr_sequencia_w);
	CALL exec_sql_dinamico_bv('',ds_sql_w,ds_param_w);
end if;

ds_texto_alterado_w	:= ds_texto_w;

if (ds_texto_w IS NOT NULL AND ds_texto_w::text <> '') then
	while(ds_texto_w IS NOT NULL AND ds_texto_w::text <> '') LOOP
		begin
		
		begin
		PERFORM	replace(replace(ds_texto_w,'\',' '),chr(13) || chr(10),' ') -- ' comentario para nao deixar todo o resto em vermelho 
		into	ds_texto_w
		from	dual;
		exception
		when others then
			wheb_mensagem_pck.exibir_mensagem_abort(262244, 'DS_TEXTO=' ||length(ds_texto_w));
			/* Mensagem: DS_TEXTO */

		end; 
		
		select	instr(ds_texto_w,'@')
		into	pos_macro_w
		from	dual;
		
		if	(pos_macro_w > 0) then
			select	substr(ds_texto_w,pos_macro_w,length(ds_texto_w))
			into	ds_texto_w
			from	dual;
			
			select	instr(replace(replace(replace(ds_texto_w,chr(10),' '),chr(160),' '),'<',' '),' ')
			into	pos_fim_macro_w
			from	dual;
			
			select	Elimina_Caracteres_Especiais(substr(ds_texto_w,1,pos_fim_macro_w -1))
			into	ds_macro_w
			from	dual;
			
			if	(nvl(ds_macro_w,null) is not null) then
				begin
				select	nm_atributo
				into	nm_atributo_w
				from	pls_macro_plano
				where	upper(ds_macro) = upper(ds_macro_w);
				exception
				when others then
					nm_atributo_w := null;
				end;
				
				if	(nvl(nm_atributo_w,null) is not null) then
					if	(upper(nm_atributo_w) = 'NR_SEQ_CONTRATO') then
						vl_atributo_w	:= nr_seq_contrato_p;
					end if;
					
					if	(ie_opcao_p	= 'C') then
						if	((upper(nm_atributo_w) = 'CD_PESSOA_FISICA')) then
							select	cd_pf_estipulante
							into	vl_atributo_w
							from	pls_contrato
							where	nr_sequencia	= nr_seq_contrato_p;
						elsif	((upper(nm_atributo_w) = 'CD_CGC')) then
							select	cd_cgc_estipulante
							into	vl_atributo_w
							from	pls_contrato
							where	nr_sequencia	= nr_seq_contrato_p;
						end if;
					elsif	(ie_opcao_p	= 'P') then
						if	((upper(nm_atributo_w) = 'CD_PESSOA_FISICA')) then
							select	cd_estipulante
							into	vl_atributo_w
							from	pls_proposta_adesao
							where	nr_sequencia	= nr_seq_contrato_p;
						elsif	((upper(nm_atributo_w) = 'CD_CGC')) then
							select	cd_cgc_estipulante
							into	vl_atributo_w
							from	pls_proposta_adesao
							where	nr_sequencia	= nr_seq_contrato_p;
						end if;
					elsif	(ie_opcao_p	= 'O') then
						if	((upper(nm_atributo_w) = 'CD_PESSOA_FISICA')) then
							select	max(cd_pessoa_fisica)
							into	vl_atributo_w
							from	pls_proposta_benef_online
							where	nr_seq_prop_online = nr_seq_contrato_p
							and	ie_tipo_benef = 'T';
						elsif	((upper(nm_atributo_w) = 'CD_CGC')) then
							vl_atributo_w	:= null;
						end if;
					end if;

					select	pls_substituir_macro(upper(ds_macro_w), nm_atributo_w, vl_atributo_w, ie_opcao_p)
					into	ds_resultado_macro_w
					from	dual;
					
					begin
					select	replace(ds_texto_alterado_w, ds_macro_w, ds_resultado_macro_w)
					into	ds_texto_alterado_w
					from	dual;
					exception
					when others then
						wheb_mensagem_pck.exibir_mensagem_abort(262248, 'DS_TEXTO_ALTERADO=' || length(ds_texto_alterado_w) || ';DS_MACRO=' || length(ds_macro_w) || ';DS_RESULTADO_MACRO' || length(ds_resultado_macro_w));
						/* Mensagem: DS_TEXTO_ALTERADO DS_MACRO DS_RESULTADO_MACRO */

					end;
				end if;
			end if;
			
			select	substr(ds_texto_w,pos_fim_macro_w, length(ds_texto_w))
			into	ds_texto_w
			from	dual;
		else
			ds_texto_w := '';
		end if;
		
		end;
	end loop;
	
	if	(ie_opcao_p in('C','P','O')) then
		select	max(a.ds_dispositivo)
		into	ds_dispositivo_w
		from	pls_contrato_doc_texto a
		where	a.nr_sequencia	= nr_seq_chave_p;
		
		begin
		if	(length(ds_texto_alterado_w) > 32764) then
			wheb_mensagem_pck.exibir_mensagem_abort(262285, 'DS_DISPOSITIVO=' || ds_dispositivo_w);
			/* Mensagem: O tamanho do texto impede a conversao das macros. Por favor reduza a quantidade de caracteres no dispositivo: DS_DISPOSITIVO */

		else
			select	substr(ds_texto_alterado_w,1,32764)
			into	ds_texto_alterado_ww
			from	dual;
			
			update	pls_contrato_doc_texto
			set	ds_tema		= ds_texto_alterado_ww
			where	nr_sequencia	= nr_seq_chave_p;
		end if;
		exception
		when others then
			wheb_mensagem_pck.exibir_mensagem_abort(262285, 'DS_DISPOSITIVO=' || ds_dispositivo_w);
			/* Mensagem: O tamanho do texto impede a conversao das macros. Por favor reduza a quantidade de caracteres no dispositivo: DS_DISPOSITIVO */

		end;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_texto_macro ( nr_seq_chave_p bigint, ds_texto_p text, nr_seq_contrato_p bigint, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

