-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_troca_tipo_campo_tabela ( nm_tabela_p text, nm_campo_p text, ds_novo_tipo_dado_p text, ds_tamanho_p bigint, ds_precisao_p bigint default null) AS $body$
DECLARE


qt_registro_campo_w		integer;
qt_registro_campo_tipo_w	integer;
qt_registro_w			integer;
ds_nome_campo_new_w		varchar(50);
ds_nome_campo_old_w		varchar(50);
ds_novo_tipo_dado_w		varchar(50);

v_cur_w				pls_util_pck.t_cursor;
ds_sql_w			varchar(1000);
nr_sequencia_min_w		bigint;
nr_sequencia_max_w		bigint;
tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
nr_seq_reg_ini_w		bigint;
nr_seq_reg_fim_w		bigint;
ds_valor_update_w		varchar(500);
ie_finaliza_processo_w		varchar(1);


BEGIN

begin
	select	count(1)
	into STRICT	qt_registro_campo_w
	from	user_tab_columns a
	where  	a.table_name = upper(nm_tabela_p)
	and  	a.column_name = upper(nm_campo_p);

	select	count(1)
	into STRICT	qt_registro_campo_tipo_w
	from	user_tab_columns a
	where  	a.table_name = upper(nm_tabela_p)
	and  	a.column_name = upper(nm_campo_p)
	and  	a.data_type != upper(ds_novo_tipo_dado_p);

	-- só continua se o campo existe e o tipo de dados dele for diferente do que deve ser modificado
	-- esta função só trabalha com varchar2 e number
	if (qt_registro_campo_w > 0 and qt_registro_campo_tipo_w > 0 and upper(ds_novo_tipo_dado_p) in ('VARCHAR2', 'NUMBER')) then

		ds_nome_campo_new_w := nm_campo_p || '_NEW';
		ds_nome_campo_old_w := nm_campo_p || '_OLD';

		ds_novo_tipo_dado_w := upper(ds_novo_tipo_dado_p) || '(';
		ds_novo_tipo_dado_w := ds_novo_tipo_dado_w || ds_tamanho_p;

		if (ds_precisao_p IS NOT NULL AND ds_precisao_p::text <> '') then
			ds_novo_tipo_dado_w := ds_novo_tipo_dado_w || ',' || ds_precisao_p;
		end if;

		ds_novo_tipo_dado_w := ds_novo_tipo_dado_w || ')';

		select	count(1)
		into STRICT	qt_registro_w
		from	user_tab_columns a
		where	a.table_name = upper(nm_tabela_p)
		and	a.column_name = upper(ds_nome_campo_new_w);

		-- se não existe cria o campo novo
		if (qt_registro_w = 0) then
			CALL exec_sql_dinamico('Tasy', 'alter table ' || nm_tabela_p || ' add (' || ds_nome_campo_new_w ||' ' || ds_novo_tipo_dado_w || ')');
		end if;

		ds_sql_w := '
			select	min(a.nr_sequencia),
				max(a.nr_sequencia)
			from	' || nm_tabela_p || ' a';
		-- recupera os intervalos das sequencias
		EXECUTE ds_sql_w into STRICT nr_sequencia_min_w, nr_sequencia_max_w;

		nr_seq_reg_ini_w := nr_sequencia_min_w;
		nr_seq_reg_fim_w := nr_seq_reg_ini_w + pls_util_pck.qt_registro_transacao_w;

		ds_sql_w := '
			select	a.nr_sequencia
			from	' || nm_tabela_p || ' a
			where	a.nr_sequencia between :nr_seq_inicio_pc and :nr_seq_fim_pc';

		-- novo valor do update
		if (upper(ds_novo_tipo_dado_p) = 'VARCHAR2') then
			ds_valor_update_w := 'to_char(' || nm_campo_p || ')';
		else
			ds_valor_update_w := 'pls_util_pck.obter_somente_numero(' || nm_campo_p || ')';
		end if;

		loop
			tb_nr_sequencia_w.delete;

			-- faz o update dos valores no campo novo
			open v_cur_w for EXECUTE ds_sql_w using nr_seq_reg_ini_w, nr_seq_reg_fim_w;

			fetch v_cur_w bulk collect into tb_nr_sequencia_w;

			if (tb_nr_sequencia_w.count > 0) then
				-- manda os dados para atualizar no banco
				-- só informa null no campo e deixa a trigger setar o valor correto para o campo
				forall i in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
					EXECUTE
					'UPDATE ' || nm_tabela_p || ' SET
					' || ds_nome_campo_new_w || ' = ' || ds_valor_update_w ||'
					 WHERE nr_sequencia = :1'
					 USING tb_nr_sequencia_w(i);
				commit;
			end if;
			close v_cur_w;

			-- calcula os novos intervalos
			nr_seq_reg_ini_w := nr_seq_reg_fim_w + 1;
			nr_seq_reg_fim_w := nr_seq_reg_ini_w + pls_util_pck.qt_registro_transacao_w;

			-- se o início ainda não ultrassou a última sequencia da tabela executa novamente
			if (nr_seq_reg_ini_w <= nr_sequencia_max_w) then
				ie_finaliza_processo_w := 'N';
			else
				ie_finaliza_processo_w := 'S';
			end if;

			exit when ie_finaliza_processo_w = 'S';
		end loop;

		-- renomeia o campo atual para old
		CALL exec_sql_dinamico('Tasy', 'alter table ' || nm_tabela_p || ' rename column ' || nm_campo_p || ' to ' || ds_nome_campo_old_w || '');

		-- renomeia o campo new para o atual
		CALL exec_sql_dinamico('Tasy', 'alter table ' || nm_tabela_p || ' rename column ' || ds_nome_campo_new_w || ' to ' || nm_campo_p || '');
	end if;

exception
when others then
	null;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_troca_tipo_campo_tabela ( nm_tabela_p text, nm_campo_p text, ds_novo_tipo_dado_p text, ds_tamanho_p bigint, ds_precisao_p bigint default null) FROM PUBLIC;
