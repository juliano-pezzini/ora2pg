-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE realizar_proc_previstos_html ( nr_cirurgia_p bigint, cd_local_estoque_p bigint, cd_motivo_alta_p INOUT bigint, ie_gerar_alta_p INOUT text) AS $body$
DECLARE

cd_perfil_w			integer;
cd_estabelecimento_w		integer;
nm_usuario_w			varchar(15);
ie_atualiza_proc_partic_w		varchar(15);
nr_prescricao_w			bigint;
nr_atendimento_w			bigint;
cd_setor_atendimento_w		integer;
cd_motivo_alta_w			integer;
ie_gerar_alta_w			varchar(15);
ie_alta_exec_proc_w		varchar(15);
ie_inicio_real_w        		varchar(15);

BEGIN
cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;
nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

select	max(nr_prescricao),
	max(nr_atendimento),
	max(obter_unid_setor_cirurgia(nr_cirurgia_p,'C')),
	max(CASE WHEN coalesce(dt_inicio_real::text, '') = '' THEN  'N'  ELSE 'S' END )
into STRICT	nr_prescricao_w,
	nr_atendimento_w,
	cd_setor_atendimento_w,
	ie_inicio_real_w
from	cirurgia
where	nr_cirurgia = nr_cirurgia_p;

if (ie_inicio_real_w = 'S') then
	ie_atualiza_proc_partic_w := obter_param_usuario(872, 329, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_atualiza_proc_partic_w);
	ie_alta_exec_proc_w := obter_param_usuario(872, 194, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_alta_exec_proc_w);

	CALL realizar_proc_previstos(nr_cirurgia_p,nr_prescricao_w,nm_usuario_w, 'S');
	CALL executar_taxa_equipamento(nr_cirurgia_p,nm_usuario_w);
	CALL gerar_lancto_auto_dispositivos(nr_cirurgia_p,cd_estabelecimento_w,nm_usuario_w);
	CALL executar_material_equipamento(nr_cirurgia_p,cd_local_estoque_p,nm_usuario_w);

	if (ie_atualiza_proc_partic_w = 'S') then
		CALL atualizar_proc_partic_cirurgia(nr_cirurgia_p,cd_estabelecimento_w,nm_usuario_w);
	end if;

	if (ie_alta_exec_proc_w = 'S') then
		SELECT * FROM gerar_regra_alta_exec_proc(nr_atendimento_w, nr_prescricao_w, cd_setor_atendimento_w, nm_usuario_w, cd_motivo_alta_w, ie_gerar_alta_w) INTO STRICT cd_motivo_alta_w, ie_gerar_alta_w;
	end if;
end if;

cd_motivo_alta_p	:= cd_motivo_alta_w;
ie_gerar_alta_p	:= ie_gerar_alta_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE realizar_proc_previstos_html ( nr_cirurgia_p bigint, cd_local_estoque_p bigint, cd_motivo_alta_p INOUT bigint, ie_gerar_alta_p INOUT text) FROM PUBLIC;
