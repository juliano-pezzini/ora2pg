-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_create_rule_atrib_regra ( nr_seq_lote_p bigint, nr_seq_regra_acao_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
vl_parametro_de_w			html_param_to_rule.vl_parametro%type;
nr_seq_parametro_w			html_param_to_rule.nr_seq_parametro%type;
cd_funcao_w					html_param_to_rule.cd_funcao%type;

nr_seq_rule_w				html_param_to_rule.nr_sequencia%type;	
nr_seq_obj_schematic_w		html_param_to_rule_action.nr_seq_obj_schematic%type;
ie_habilitado_w				html_param_to_rule_action.si_field_enable%type;
ie_obrigatorio_w			html_param_to_rule_action.si_field_mandatory%type;
vl_padrao_w					html_param_to_rule_action.ds_field_default_value%type;
nr_seq_visao_w				html_param_to_rule_action.nr_seq_visao%type;
nm_atributo_w				html_param_to_rule_action.nm_atributo%type;
nm_tabela_w					objeto_schematic.nm_tabela%type;
	
vl_parametro_w				funcao_parametro.vl_parametro%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_perfil_w					perfil.cd_perfil%type;
nm_usuario_param_w			usuario.nm_usuario%type;

c10 CURSOR FOR 
SELECT	cd_estabelecimento 
from	funcao_param_estab 
where	cd_funcao = cd_funcao_w 
and		nr_seq_param = nr_seq_parametro_w 
and		vl_parametro = vl_parametro_de_w;

c11 CURSOR FOR 
SELECT	cd_estabelecimento, 
		cd_perfil 
from	funcao_param_perfil 
where	cd_funcao = cd_funcao_w 
and		nr_sequencia = nr_seq_parametro_w 
and		vl_parametro = vl_parametro_de_w;

c12 CURSOR FOR 
SELECT	cd_estabelecimento, 
		nm_usuario_param 
from	funcao_param_usuario 
where	cd_funcao = cd_funcao_w 
and		nr_sequencia = nr_seq_parametro_w 
and		vl_parametro = vl_parametro_de_w;


BEGIN 
 
select	nr_seq_obj_schematic, 
		si_field_enable, 
		si_field_mandatory, 
		ds_field_default_value, 
		nr_seq_visao, 
		coalesce(nm_atributo,'X'), 
		nr_seq_rule 
into STRICT	nr_seq_obj_schematic_w, 
    ie_habilitado_w, 
    ie_obrigatorio_w, 
    vl_padrao_w, 
    nr_seq_visao_w, 
    nm_atributo_w, 
		nr_seq_rule_w 
from	html_param_to_rule_action 
where	nr_sequencia = nr_seq_regra_acao_p;
 
select	coalesce(nm_tabela,'X') 
into STRICT	nm_tabela_w 
from	objeto_schematic 
where	nr_sequencia = nr_seq_obj_schematic_w;
 
if (nm_tabela_w <> 'X') and (nm_atributo_w <> 'X') then 
	begin 
	 
	select	cd_funcao, 
			nr_seq_parametro, 
			vl_parametro 
	into STRICT	cd_funcao_w, 
			nr_seq_parametro_w, 
			vl_parametro_de_w 
	from	html_param_to_rule 
	where	nr_sequencia = nr_seq_rule_w;
	 
	select	vl_parametro 
	into STRICT	vl_parametro_w 
	from	funcao_parametro 
	where	cd_funcao = cd_funcao_w 
	and		nr_sequencia = nr_seq_parametro_w;
	 
	/* INSERIR REGRA GERAL */
 
	if (vl_parametro_w = vl_parametro_de_w) then 
		CALL INSERT_RULE_ATRIB_REGRA( 
					nr_seq_lote_p, 
					cd_funcao_w, 
					nr_seq_parametro_w, 
					vl_parametro_de_w, 
					null, 
					null, 
					null, 
					ie_habilitado_w, 
					ie_obrigatorio_w, 
					vl_padrao_w, 
					nm_atributo_w, 
					nm_tabela_w, 
					nr_seq_visao_w, 
					nm_usuario_p);
	end if;
	 
	/* INSERIR REGRA POR ESTABELECIMENTO */
 
	open c10;
	loop 
	fetch c10 into 
			cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on c10 */
			begin 
			CALL INSERT_RULE_ATRIB_REGRA( 
					nr_seq_lote_p, 
					cd_funcao_w, 
					nr_seq_parametro_w, 
					vl_parametro_de_w, 
					cd_estabelecimento_w, 
					null, 
					null, 
					ie_habilitado_w, 
					ie_obrigatorio_w, 
					vl_padrao_w, 
					nm_atributo_w, 
					nm_tabela_w, 
					nr_seq_visao_w, 
					nm_usuario_p);
			end;
	end loop;
	close c10;
 
	/* INSERIR REGRA POR PERFIL */
 
	open c11;
	loop 
	fetch c11 into 
			cd_estabelecimento_w, 
			cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on c11 */
			begin 
			CALL INSERT_RULE_ATRIB_REGRA( 
					nr_seq_lote_p, 
					cd_funcao_w, 
					nr_seq_parametro_w, 
					vl_parametro_de_w, 
					cd_estabelecimento_w, 
					cd_perfil_w, 
					null, 
					ie_habilitado_w, 
					ie_obrigatorio_w, 
					vl_padrao_w, 
					nm_atributo_w, 
					nm_tabela_w, 
					nr_seq_visao_w, 
					nm_usuario_p);
			end;
	end loop;
	close c11;
 
	/* INSERIR REGRA POR USUARIO */
 
	open c12;
	loop 
	fetch c12 into 
			cd_estabelecimento_w, 
			nm_usuario_param_w;
	EXIT WHEN NOT FOUND; /* apply on c12 */
			begin 
			CALL INSERT_RULE_ATRIB_REGRA( 
					nr_seq_lote_p, 
					cd_funcao_w, 
					nr_seq_parametro_w, 
					vl_parametro_de_w, 
					cd_estabelecimento_w, 
					null, 
					nm_usuario_param_w, 
					ie_habilitado_w, 
					ie_obrigatorio_w, 
					vl_padrao_w, 
					nm_atributo_w, 
					nm_tabela_w, 
					nr_seq_visao_w, 
					nm_usuario_p);
			end;
	end loop;
	close c12;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_create_rule_atrib_regra ( nr_seq_lote_p bigint, nr_seq_regra_acao_p bigint, nm_usuario_p text) FROM PUBLIC;
