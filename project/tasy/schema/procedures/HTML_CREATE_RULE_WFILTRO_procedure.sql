-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_create_rule_wfiltro ( nr_seq_lote_p bigint, nr_seq_regra_acao_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_parametro_de_w			html_param_to_rule.vl_parametro%type;
nr_seq_parametro_w			html_param_to_rule.nr_seq_parametro%type;
cd_funcao_w					html_param_to_rule.cd_funcao%type;

nr_seq_rule_w				html_param_to_rule.nr_sequencia%type;
nr_seq_dic_objeto_filtro_w	html_param_to_rule_action.nr_seq_dic_objeto_filtro%type;
si_field_enable_w			html_param_to_rule_action.si_field_enable%type;
si_field_mandatory_w		html_param_to_rule_action.si_field_mandatory%type;
ds_field_default_value_w	html_param_to_rule_action.ds_field_default_value%type;
vl_param_regra_w			wfiltro_atrib_regra_item.ie_configuracao%type;

nr_seq_regra_filtro_w		wfiltro_atrib_regra.nr_sequencia%type;
vl_parametro_w				funcao_parametro.vl_parametro%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_perfil_w					perfil.cd_perfil%type;
nm_usuario_param_w			usuario.nm_usuario%type;

qt_tamanho_config_w				integer := 200;

c10 CURSOR FOR
SELECT	cd_estabelecimento,
		vl_parametro
from	funcao_param_estab
where	cd_funcao = cd_funcao_w
and		nr_seq_param = nr_seq_parametro_w
and		vl_parametro = vl_parametro_de_w

union all

select	cd_estabelecimento,
		vl_parametro
from	funcao_param_estab
where	cd_funcao = cd_funcao_w
and		nr_seq_param = nr_seq_parametro_w
and		vl_parametro_de_w = '@PARAMETRO';

c11 CURSOR FOR
SELECT	cd_estabelecimento,
		cd_perfil,
		vl_parametro
from	funcao_param_perfil
where	cd_funcao = cd_funcao_w
and		nr_sequencia = nr_seq_parametro_w
and		vl_parametro = vl_parametro_de_w

union all

select	cd_estabelecimento,
		cd_perfil,
		vl_parametro
from	funcao_param_perfil
where	cd_funcao = cd_funcao_w
and		nr_sequencia = nr_seq_parametro_w
and		vl_parametro_de_w = '@PARAMETRO';

c12 CURSOR FOR
SELECT	cd_estabelecimento,
		nm_usuario_param,
		vl_parametro
from	funcao_param_usuario
where	cd_funcao = cd_funcao_w
and		nr_sequencia = nr_seq_parametro_w
and		vl_parametro = vl_parametro_de_w

union all

select	cd_estabelecimento,
		nm_usuario_param,
		vl_parametro
from	funcao_param_usuario
where	cd_funcao = cd_funcao_w
and		nr_sequencia = nr_seq_parametro_w
and		vl_parametro_de_w = '@PARAMETRO';


BEGIN

select	nr_seq_dic_objeto_filtro,
		si_field_enable,
		si_field_mandatory,
		upper(ds_field_default_value),
		nr_seq_rule
into STRICT	nr_seq_dic_objeto_filtro_w,
		si_field_enable_w,
		si_field_mandatory_w,
		ds_field_default_value_w,
		nr_seq_rule_w
from	html_param_to_rule_action
where	nr_sequencia = nr_seq_regra_acao_p;

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

if (vl_parametro_w = vl_parametro_de_w) or
	(vl_parametro_w IS NOT NULL AND vl_parametro_w::text <> '' AND vl_parametro_de_w = '@PARAMETRO') then

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_regra_filtro_w
	from	wfiltro_atrib_regra
	where	nr_seq_wfiltro = nr_seq_dic_objeto_filtro_w
	and		coalesce(cd_estabelecimento::text, '') = ''
	and		coalesce(cd_perfil::text, '') = ''
	and		coalesce(nm_usuario_regra::text, '') = '';

	if (si_field_enable_w = 'S') and (ds_field_default_value_w in ('S','N')) then
		begin

		nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
					nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, null, null, null, nr_seq_dic_objeto_filtro_w, 'HA', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

		end;
	end if;

	if (si_field_mandatory_w = 'S') and (ds_field_default_value_w in ('S','N')) then
		begin

		nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
					nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, null, null, null, nr_seq_dic_objeto_filtro_w, 'OB', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

		end;
	end if;

	if (si_field_mandatory_w = 'N') and (si_field_enable_w = 'N') and (ds_field_default_value_w IS NOT NULL AND ds_field_default_value_w::text <> '') then
		begin

		if (ds_field_default_value_w = '@PARAMETRO') then
			vl_param_regra_w	:= substr(vl_parametro_w,1,qt_tamanho_config_w);
		else
			vl_param_regra_w	:= substr(ds_field_default_value_w,1,qt_tamanho_config_w);
		end if;

		nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
					nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, null, null, null, nr_seq_dic_objeto_filtro_w, 'VP', vl_param_regra_w, nm_usuario_p, nr_seq_regra_filtro_w);

		end;
	end if;

end if;

/* INSERIR REGRA POR ESTABELECIMENTO*/

open c10;
loop
fetch c10 into
		cd_estabelecimento_w,
		vl_parametro_w;
EXIT WHEN NOT FOUND; /* apply on c10 */
		begin

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_regra_filtro_w
		from	wfiltro_atrib_regra
		where	nr_seq_wfiltro = nr_seq_dic_objeto_filtro_w
		and		cd_estabelecimento = cd_estabelecimento_w
		and		coalesce(cd_perfil::text, '') = ''
		and		coalesce(nm_usuario_regra::text, '') = '';

		if (si_field_enable_w = 'S') and (ds_field_default_value_w in ('S','N')) then
			begin

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, null, null, nr_seq_dic_objeto_filtro_w, 'HA', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		if (si_field_mandatory_w = 'S') and (ds_field_default_value_w in ('S','N')) then
			begin

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, null, null, nr_seq_dic_objeto_filtro_w, 'OB', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		if (si_field_mandatory_w = 'N') and (si_field_enable_w = 'N') and (ds_field_default_value_w IS NOT NULL AND ds_field_default_value_w::text <> '') then
			begin

			if (ds_field_default_value_w = '@PARAMETRO') then
				vl_param_regra_w	:= substr(vl_parametro_w,1,qt_tamanho_config_w);
			else
				vl_param_regra_w	:= substr(ds_field_default_value_w,1,qt_tamanho_config_w);
			end if;

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, null, null, nr_seq_dic_objeto_filtro_w, 'VP', vl_param_regra_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		end;
end loop;
close c10;

/* INSERIR REGRA POR PERFIL*/

open c11;
loop
fetch c11 into
		cd_estabelecimento_w,
		cd_perfil_w,
		vl_parametro_w;
EXIT WHEN NOT FOUND; /* apply on c11 */
		begin

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_regra_filtro_w
		from	wfiltro_atrib_regra
		where	nr_seq_wfiltro = nr_seq_dic_objeto_filtro_w
		and		coalesce(cd_estabelecimento,0) = coalesce(cd_estabelecimento_w,0)
		and		cd_perfil = cd_perfil_w
		and		coalesce(nm_usuario_regra::text, '') = '';

		if (si_field_enable_w = 'S') and (ds_field_default_value_w in ('S','N')) then
			begin

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, cd_perfil_w, null, nr_seq_dic_objeto_filtro_w, 'HA', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		if (si_field_mandatory_w = 'S') and (ds_field_default_value_w in ('S','N')) then
			begin

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, cd_perfil_w, null, nr_seq_dic_objeto_filtro_w, 'OB', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		if (si_field_mandatory_w = 'N') and (si_field_enable_w = 'N') and (ds_field_default_value_w IS NOT NULL AND ds_field_default_value_w::text <> '') then
			begin

			if (ds_field_default_value_w = '@PARAMETRO') then
				vl_param_regra_w	:= substr(vl_parametro_w,1,qt_tamanho_config_w);
			else
				vl_param_regra_w	:= substr(ds_field_default_value_w,1,qt_tamanho_config_w);
			end if;

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, cd_perfil_w, null, nr_seq_dic_objeto_filtro_w, 'VP', vl_param_regra_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		end;
end loop;
close c11;

/* INSERIR REGRA POR USUARIO*/

open c12;
loop
fetch c12 into
		cd_estabelecimento_w,
		nm_usuario_param_w,
		vl_parametro_w;
EXIT WHEN NOT FOUND; /* apply on c12 */
		begin

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_regra_filtro_w
		from	wfiltro_atrib_regra
		where	nr_seq_wfiltro = nr_seq_dic_objeto_filtro_w
		and		coalesce(cd_estabelecimento,0) = coalesce(cd_estabelecimento_w,0)
		and		coalesce(cd_perfil::text, '') = ''
		and		nm_usuario_regra = nm_usuario_param_w;

		if (si_field_enable_w = 'S') and (ds_field_default_value_w in ('S','N')) then
			begin

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, null, nm_usuario_param_w, nr_seq_dic_objeto_filtro_w, 'HA', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		if (si_field_mandatory_w = 'S') and (ds_field_default_value_w in ('S','N')) then
			begin

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, null, nm_usuario_param_w, nr_seq_dic_objeto_filtro_w, 'OB', ds_field_default_value_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		if (si_field_mandatory_w = 'N') and (si_field_enable_w = 'N') and (ds_field_default_value_w IS NOT NULL AND ds_field_default_value_w::text <> '') then
			begin

			if (ds_field_default_value_w = '@PARAMETRO') then
				vl_param_regra_w	:= substr(vl_parametro_w,1,qt_tamanho_config_w);
			else
				vl_param_regra_w	:= substr(ds_field_default_value_w,1,qt_tamanho_config_w);
			end if;

			nr_seq_regra_filtro_w := INSERT_RULE_WFILTRO(
						nr_seq_lote_p, cd_funcao_w, nr_seq_parametro_w, vl_parametro_de_w, cd_estabelecimento_w, null, nm_usuario_param_w, nr_seq_dic_objeto_filtro_w, 'VP', vl_param_regra_w, nm_usuario_p, nr_seq_regra_filtro_w);

			end;
		end if;

		end;
end loop;
close c12;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_create_rule_wfiltro ( nr_seq_lote_p bigint, nr_seq_regra_acao_p bigint, nm_usuario_p text) FROM PUBLIC;

