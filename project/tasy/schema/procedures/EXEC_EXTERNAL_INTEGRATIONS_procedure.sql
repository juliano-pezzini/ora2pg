-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE exec_external_integrations ( cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type ) AS $body$
DECLARE


	ds_diretorio_padrao_param_w	funcao_parametro.ds_parametro%type;
	ds_procedure_integra_w		user_objects.object_name%type;
	ie_existe_proc_w			funcao_parametro.ie_consistir_valor%type;


BEGIN

	-- Verificar se eh possivel utilizar a function Wheb_assist_pck.obterParametroFuncao();
	ds_diretorio_padrao_param_w  := Obter_Valor_Param_Usuario(924, 599, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p);
	if (ds_diretorio_padrao_param_w IS NOT NULL AND ds_diretorio_padrao_param_w::text <> '') then

		-- Verificar se e possivel utilizar a function Wheb_assist_pck.obterParametroFuncao();
		ds_procedure_integra_w := substr(Obter_Valor_Param_Usuario(924, 945, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p), 1, 30);
		if (coalesce(ds_procedure_integra_w::text, '') = '') then
			CALL Exec_Sql_Dinamico(nm_usuario_p, ' begin HCC_int_prescr_tasy_lab_ext('||nr_prescricao_p||','||chr(39)
								||ds_diretorio_padrao_param_w||chr(39)||','||chr(39)
								||nr_prescricao_p||'_'||to_char(clock_timestamp(),'dd_mm_yyyy_hh24_mi_ss')||'.txt'||chr(39)||'); end;');
		else
			select	coalesce(max('S'),'N')
			into STRICT	ie_existe_proc_w
			from	user_objects a
			where	upper(a.object_name) = upper(ds_procedure_integra_w);

			if (ie_existe_proc_w = 'S') then
				if (upper(ds_procedure_integra_w) = 'HMSL_INT_PRESCR_TASY_EXAME_EXT') then
					CALL Exec_Sql_Dinamico(nm_usuario_p, ' begin HMSL_int_prescr_tasy_exame_ext('||nr_prescricao_p||','||chr(39)
										||ds_diretorio_padrao_param_w||chr(39)||','||chr(39)
										||nr_prescricao_p||'.txt'||chr(39)||'); end;');
				end if;
				if (upper(ds_procedure_integra_w) = 'GERAR_ARQUIVO_INT_LAB_BCROBO') then
					CALL Exec_Sql_Dinamico(nm_usuario_p, ' begin gerar_arquivo_int_lab_bcrobo('||nr_prescricao_p||','||chr(39)
										||ds_diretorio_padrao_param_w||chr(39)
										||','||chr(39)||nm_usuario_p||chr(39)||'); end;');
				end if;
			end if;
		end if;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE exec_external_integrations ( cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type ) FROM PUBLIC;
