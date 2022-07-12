-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_consulta_se_gera_mapa_imp ( nm_usuario_p text, ie_opcao_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
									nr_seq_grup_imp_w				bigint;
nr_seq_mapa_w					bigint;
ds_mapas_w						varchar(1);
nr_seq_impressao_mapa_w			bigint;
nr_prescricao_w					bigint;
nr_prescricao_ww				bigint;
nr_seq_prescr_w					bigint;
qt_max_exames_w					bigint;
ie_tipo_atendimento_w			bigint;
ie_urgencia_w					prescr_procedimento.ie_urgencia%type;

/* 	ie_opcao_p 
	0 - Consiste os registros com valor menor que o definido no parâmetro 2 
	1 - Consiste os registros com valor maior que o definido no parâmetro 2*/
 
 
C01 CURSOR FOR 
		SELECT	nr_seq_grupo_imp, 
				ie_urgencia 
		from	lab_impressao_mapa_v 
		where	qtdade_exames >= qt_max_exames_w 
		and 	1 = ie_opcao_p 
		and		ie_tipo_atendimento = ie_tipo_atendimento_w 
		and 	cd_estabelecimento = cd_estabelecimento_p 
	
union
 
		SELECT	nr_seq_grupo_imp, 
				ie_urgencia 
		from	lab_impressao_mapa_v 
		where	qtdade_exames < qt_max_exames_w 
		and 	0 = ie_opcao_p	 
		and		ie_tipo_atendimento = ie_tipo_atendimento_w 
		and 	cd_estabelecimento = cd_estabelecimento_p 
	order by 	ie_urgencia, nr_seq_grupo_imp;


BEGIN 
 
select	Obter_Valor_Param_Usuario(10209, 2, Obter_perfil_Ativo, nm_usuario_p, obter_estabelecimento_ativo) 
into STRICT	qt_max_exames_w
;
 
select	Obter_Valor_Param_Usuario(10209, 6, Obter_perfil_Ativo, nm_usuario_p, obter_estabelecimento_ativo) 
into STRICT	ie_tipo_atendimento_w
;
 
 
ds_mapas_w := '';
 
open C01;
	loop 
	fetch C01 into	 
		nr_seq_grup_imp_w, 
		ie_urgencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		 
			ds_mapas_w := 'S';
			exit;
		end;
	end loop;
	close C01;
 
return	ds_mapas_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_consulta_se_gera_mapa_imp ( nm_usuario_p text, ie_opcao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

