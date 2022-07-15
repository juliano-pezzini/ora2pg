-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mob_gerar_comunic_interna (dt_comunicado_p timestamp, ds_titulo_p text, ds_comunicado_p text, nm_usuario_destino_p text, ds_perfil_adicional_p text, nm_usuario_p text, ds_setor_adicional_p text, ds_grupo_p text, cd_perfil_origem_p bigint, cd_setor_origem_p bigint, nr_sequencia_p INOUT bigint) AS $body$
BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '' AND ds_titulo_p IS NOT NULL AND ds_titulo_p::text <> '') then

	select	nextval('comunic_interna_seq')
	into STRICT	nr_sequencia_p
	;

	insert	into comunic_interna(	nr_sequencia,
									nm_usuario,
									dt_atualizacao,
									dt_comunicado,
									ds_titulo,
									ds_comunicado,
									ie_gerencial,
									nm_usuario_destino,
									ds_perfil_adicional,
									ds_setor_adicional,
									ds_grupo,
									cd_perfil_origem,
									cd_setor_origem
									) values (
									nr_sequencia_p,
									nm_usuario_p,
									dt_comunicado_p,
									dt_comunicado_p,
									ds_titulo_p,
									ds_comunicado_p,
									'N',
									nm_usuario_destino_p,
									ds_perfil_adicional_p,
									ds_setor_adicional_p,
									ds_grupo_p,
									cd_perfil_origem_p,
									cd_setor_origem_p);

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mob_gerar_comunic_interna (dt_comunicado_p timestamp, ds_titulo_p text, ds_comunicado_p text, nm_usuario_destino_p text, ds_perfil_adicional_p text, nm_usuario_p text, ds_setor_adicional_p text, ds_grupo_p text, cd_perfil_origem_p bigint, cd_setor_origem_p bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;

