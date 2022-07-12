-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Nessa rotina ser?o identificados os itens a serem inseridos e os valores ser?o armazenados em variaveis tabelas para posterior insert



CREATE OR REPLACE PROCEDURE pls_gerencia_autogerado_pck.pls_atualiza_itens_autogerado ( nr_seq_lote_p pls_lote_auto_gerado.nr_sequencia%type, nr_seq_prestador_p pls_lote_auto_gerado.nr_seq_prestador%type, dt_inicio_p pls_lote_auto_gerado.dt_inicio%type, dt_fim_p pls_lote_auto_gerado.dt_fim%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE


cd_prest_atual_w	pls_conta_proc_v.cd_prestador_exec%type;
tb_seq_lote_w 		dbms_sql.number_table;
tb_cd_prestador_exec_w dbms_sql.varchar2_table;
tb_calculo_auto_ger_w	dbms_sql.number_table;
tb_calculo_total_w	dbms_sql.number_table;
nr_iteracoes_w		integer;
ds_sql_w		varchar(4000);
ds_restr_sql_w		varchar(1000)	:= '';
v_cur_w			pls_util_pck.t_cursor;

vl_liberado_w		double precision;
ie_tipo_calculo_w	pls_perc_auto_gerado.ie_tipo_calculo%type;
cd_prestador_exec_w	pls_conta_proc_v.cd_prestador_exec%type;
	

BEGIN

tb_seq_lote_w.delete; 		
tb_cd_prestador_exec_w.delete;
tb_calculo_auto_ger_w.delete;	
tb_calculo_total_w.delete;
nr_iteracoes_w	:= -1;
cd_prest_atual_w := null;


if (nr_seq_prestador_p IS NOT NULL AND nr_seq_prestador_p::text <> '') then
	
	ds_restr_sql_w	:= 	' and (nr_seq_prestador_exec = :nr_seq_prestador) ';

else
	ds_restr_sql_w	:=  ' and  (:nr_seq_prestador is null)' || pls_tipos_ocor_pck.enter_w
				|| ' and  cp.nr_seq_prestador_exec is not null';
end if;

ds_sql_w 	:= 	'select	cp.cd_prestador_exec,' || pls_tipos_ocor_pck.enter_w	
			||'	pa.ie_tipo_calculo,' || pls_tipos_ocor_pck.enter_w
			||'	sum(vl_liberado) vl_liberado' || pls_tipos_ocor_pck.enter_w
			||'from	pls_conta_proc_v	cp,' || pls_tipos_ocor_pck.enter_w
			||'	pls_perc_auto_gerado	pa' || pls_tipos_ocor_pck.enter_w
			||'where	cp.ie_status_conta 	!= ''C'' ' || pls_tipos_ocor_pck.enter_w
			||'and	cp.ie_status		in (''L'',''S'')' || pls_tipos_ocor_pck.enter_w
			||'and	cp.ie_situacao_protocolo in (''D'',''T'')' || pls_tipos_ocor_pck.enter_w
			||'and	cp.dt_mes_competencia between trunc(:dt_inicio, ''MM'') and fim_dia(:dt_fim)' || pls_tipos_ocor_pck.enter_w
			||'and   	pa.cd_moeda = cp.cd_moeda_autogerado' || pls_tipos_ocor_pck.enter_w
			||''||ds_restr_sql_w || pls_tipos_ocor_pck.enter_w
			||'group by cp.cd_prestador_exec, pa.ie_tipo_calculo' || pls_tipos_ocor_pck.enter_w
			||'order by cp.cd_prestador_exec';

begin

	open v_cur_w for EXECUTE ds_sql_w using  dt_inicio_p, dt_fim_p, nr_seq_prestador_p; loop
		
	fetch v_cur_w 
	into  cd_prestador_exec_w, ie_tipo_calculo_w, vl_liberado_w;
		EXIT WHEN NOT FOUND; /* apply on v_cur_w */	
			
		
			
		if (cd_prest_atual_w <> cd_prestador_exec_w or coalesce(cd_prest_atual_w::text, '') = '') then
			
			if (nr_iteracoes_w >= pls_util_cta_pck.qt_registro_transacao_w) then
				CALL pls_gerencia_autogerado_pck.pls_insere_auto_ger_itens(tb_seq_lote_w, tb_cd_prestador_exec_w, tb_calculo_auto_ger_w,
								tb_calculo_total_w, nm_usuario_p);
				
				nr_iteracoes_w := 0;
				tb_seq_lote_w.delete; 		
				tb_cd_prestador_exec_w.delete;
				tb_calculo_auto_ger_w.delete;	
				tb_calculo_total_w.delete;	
			else
				nr_iteracoes_w := nr_iteracoes_w + 1;
			end if;
			
			tb_seq_lote_w(nr_iteracoes_w)		:= nr_seq_lote_p;	
			tb_cd_prestador_exec_w(nr_iteracoes_w) := cd_prestador_exec_w;
		end if;
		
		if (ie_tipo_calculo_w = '1') then
			tb_calculo_total_w(nr_iteracoes_w) := vl_liberado_w;
			
		elsif (ie_tipo_calculo_w = '2') then
			tb_calculo_auto_ger_w(nr_iteracoes_w) := vl_liberado_w;
		end if;
		
		-- esse exists e?feito para garantir que exista registro sempre quando for mandar para o banco

		-- sen?o d?  NO_DATA_FOUND

		if (not tb_calculo_total_w.exists(nr_iteracoes_w)) then
			tb_calculo_total_w(nr_iteracoes_w) := 0;
		end if;	
		if (not tb_calculo_auto_ger_w.exists(nr_iteracoes_w)) then
			tb_calculo_auto_ger_w(nr_iteracoes_w) := 0;
		end if;
		
		cd_prest_atual_w	:= cd_prestador_exec_w;
		
	end loop;
	close v_cur_w;
exception			
	when others then
		--Fecha cursor

		close v_cur_w;		
end;

--Chama rotina de inser??o de itens pois pode haver algum registros nas variaveis tabela.

--Dentro desta rotina ? realizada uma verifica??o para saber se h? registros nas variaveis tabela.

CALL pls_gerencia_autogerado_pck.pls_insere_auto_ger_itens(tb_seq_lote_w, tb_cd_prestador_exec_w, tb_calculo_auto_ger_w,
						tb_calculo_total_w, nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_autogerado_pck.pls_atualiza_itens_autogerado ( nr_seq_lote_p pls_lote_auto_gerado.nr_sequencia%type, nr_seq_prestador_p pls_lote_auto_gerado.nr_seq_prestador%type, dt_inicio_p pls_lote_auto_gerado.dt_inicio%type, dt_fim_p pls_lote_auto_gerado.dt_fim%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;
