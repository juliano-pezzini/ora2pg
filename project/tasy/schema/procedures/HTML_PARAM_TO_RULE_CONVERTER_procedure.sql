-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_param_to_rule_converter ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_tipo_acao_w			html_param_to_rule_action.ie_tipo_acao%type;
nr_seq_acao_w			html_param_to_rule_action.nr_sequencia%type;
nr_seq_parametro_w			funcao_parametro.nr_sequencia%type;
vl_parametro_w			funcao_parametro.vl_parametro%type;
ie_tipo_param_w			valor_dominio.vl_dominio%type;
qt_existe_param_w		bigint;
nr_seq_funcao_lote_w	lote_par_regra_html_funcao.nr_sequencia%type;

cd_funcao_w				funcao.cd_funcao%type;

c00 CURSOR FOR 
SELECT	cd_funcao, 
		nr_sequencia 
from	lote_par_regra_html_funcao 
where	nr_seq_lote = nr_seq_lote_p;

c01 CURSOR FOR 
SELECT	nr_seq_parametro 
from	lote_par_regra_html_item 
where	cd_funcao = cd_funcao_w 
and		nr_seq_funcao_lote = nr_seq_funcao_lote_w;

c02 CURSOR FOR 
SELECT	b.nr_sequencia, 
		b.ie_tipo_acao 
from	html_param_to_rule_action b, 
		html_param_to_rule a 
where	b.nr_seq_rule = a.nr_sequencia 
and		a.cd_funcao = cd_funcao_w 
and		a.nr_seq_parametro = nr_seq_parametro_w 
and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
and		coalesce(a.dt_inativacao::text, '') = '' 
order by b.nr_seq_rule;


BEGIN 
 
open c00;
loop 
fetch c00 into 
	cd_funcao_w, 
	nr_seq_funcao_lote_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
	begin 
	 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_parametro_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		 
		/* A consulta abaixo verifica se existe algum valor cadastrado 
		na base do cliente, para o parametro que será convertido */
 
 
		select	sum(qt) 
		into STRICT	qt_existe_param_w 
		from ( 
			SELECT	count(*) qt 
			from	funcao_parametro 
			where	cd_funcao = cd_funcao_w 
			and	nr_sequencia = nr_seq_parametro_w 
			and	(vl_parametro IS NOT NULL AND vl_parametro::text <> '') 
			
union all
 
			SELECT	count(*) qt 
			from	funcao_param_estab 
			where	cd_funcao = cd_funcao_w 
			and	nr_seq_param = nr_seq_parametro_w 
			and	(vl_parametro IS NOT NULL AND vl_parametro::text <> '') 
			
union all
 
			select	count(*) qt 
			from	funcao_param_perfil 
			where	cd_funcao = cd_funcao_w 
			and	nr_sequencia = nr_seq_parametro_w 
			and	(vl_parametro IS NOT NULL AND vl_parametro::text <> '') 
			
union all
 
			select	count(*) qt 
			from	funcao_param_usuario 
			where	cd_funcao = cd_funcao_w 
			and	nr_sequencia = nr_seq_parametro_w 
			and	(vl_parametro IS NOT NULL AND vl_parametro::text <> '')) alias9;
			 
		if (qt_existe_param_w > 0) then 
			begin 
			 
			open c02;
			loop 
			fetch c02 into 
				nr_seq_acao_w, 
				ie_tipo_acao_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin 
				 
				if (ie_tipo_acao_w = 'EXTERNO') or (ie_tipo_acao_w = 'TAB') then 
					/* Parâmetro de controle de visibilidade acesso externo e TAB*/
 
					CALL HTML_CREATE_RULE_OBJ_SCHEM(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
 
				elsif (ie_tipo_acao_w = 'FILTRO') then 
					/* Parâmetro de controle de filtros */
 
					CALL HTML_CREATE_RULE_WFILTRO(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
	 
				elsif (ie_tipo_acao_w = 'BD') then 
					/* Parâmetro de controle de item popup */
 
					CALL HTML_CREATE_RULE_FUNC_POPUP(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
	 
				elsif (ie_tipo_acao_w = 'CRUD') then 
					/* Parâmetro de CRUD */
 
					CALL HTML_CREATE_RULE_CRUD_PARAM(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
 
				elsif (ie_tipo_acao_w = 'TAB_INICIO') then 
					/* Parâmetro de pasta padrão do navegador */
 
					CALL HTML_CREATE_RULE_SCHEM_ORDER(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
 
				elsif (ie_tipo_acao_w = 'ATRIB') then 
					/* Parâmetro de regra de atributo */
 
					CALL HTML_CREATE_RULE_ATRIB_REGRA(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
 
				elsif (ie_tipo_acao_w = 'ARQUIVO') then 
					/* Parâmetro de repositório de arquivo */
 
					CALL HTML_CREATE_RULE_REPOSITORY(nr_seq_lote_p,nr_seq_acao_w,nm_usuario_p);
				end if;
				 
				end;
			end loop;
			close c02;
			 
			end;
		end if;
		 
		end;
	end loop;
	close c01;
	 
	end;
end loop;
close c00;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_param_to_rule_converter ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
