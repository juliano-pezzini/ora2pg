-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cons_regra_agecons_conv_plano ( cd_convenio_p bigint, cd_categoria_p text, dt_agenda_p timestamp, cd_agenda_p bigint, cd_setor_atendimento_p bigint, nr_min_duracao_p bigint, cd_plano_convenio_p text, cd_pessoa_fisica_p text, ie_consist_especialid_p text, ie_plano_p INOUT text, ie_especialidade_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_empresa_ref_p bigint, nr_sequencia_p bigint default null, ds_mens_conv_p INOUT text DEFAULT NULL) AS $body$
DECLARE

			
ie_plano_w		varchar(1) := 'N';
ie_especialidade_w	varchar(1) := 'S';
ie_consiste_espec_dif_w	varchar(1) := 'N';
ds_mens_conv_w varchar(255) := '';

BEGIN

CALL Consistir_quimio_dur_agecons(dt_agenda_p,
			     cd_pessoa_fisica_p,
			     nm_usuario_p,
			     cd_estabelecimento_p);

ie_consiste_espec_dif_w := obter_param_usuario(821, 432, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consiste_espec_dif_w);

ds_mens_conv_w := consiste_regra_agecons_conv_jv(
		cd_convenio_p, cd_categoria_p, cd_agenda_p, cd_setor_atendimento_p, cd_plano_convenio_p, cd_pessoa_fisica_p, dt_agenda_p, cd_estabelecimento_p, cd_empresa_ref_p, nr_sequencia_p, ds_mens_conv_w);

if (ie_consist_especialid_p = 'S') then
	begin
	ie_especialidade_w := consistir_agend_especialidade(
		cd_pessoa_fisica_p, cd_agenda_p, dt_agenda_p, nr_min_duracao_p, ie_especialidade_w);
	end;
end if;

if (ie_especialidade_w = 'S') and (ie_consiste_espec_dif_w = 'S') then
	ie_especialidade_w := consistir_agend_espec_dif(cd_pessoa_fisica_p, cd_agenda_p, dt_agenda_p, nr_min_duracao_p, ie_especialidade_w);
end if;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_plano_w
from	convenio_plano
where	cd_convenio 	= cd_convenio_p
and	cd_plano 	= cd_plano_convenio_p;

ie_plano_p		:= ie_plano_w;
ie_especialidade_p 	:= ie_especialidade_w;
ds_mens_conv_p := ds_mens_conv_w;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cons_regra_agecons_conv_plano ( cd_convenio_p bigint, cd_categoria_p text, dt_agenda_p timestamp, cd_agenda_p bigint, cd_setor_atendimento_p bigint, nr_min_duracao_p bigint, cd_plano_convenio_p text, cd_pessoa_fisica_p text, ie_consist_especialid_p text, ie_plano_p INOUT text, ie_especialidade_p INOUT text, nm_usuario_p text, cd_estabelecimento_p bigint, cd_empresa_ref_p bigint, nr_sequencia_p bigint default null, ds_mens_conv_p INOUT text DEFAULT NULL) FROM PUBLIC;

