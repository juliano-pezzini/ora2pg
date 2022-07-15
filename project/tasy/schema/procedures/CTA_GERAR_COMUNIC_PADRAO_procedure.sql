-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cta_gerar_comunic_padrao (dt_comunicado_p timestamp, ds_titulo_p text, ds_comunicado_p text, nm_usuario_p text, ie_geral_p text, nm_usuario_destino_p text, ie_gerencial_p text, nr_seq_classif_p bigint, ds_perfil_adicional_p text, cd_estab_destino_p bigint, ds_setor_adicional_p text, dt_liberacao_p timestamp, ds_grupo_p text, nm_usuario_oculto_p text) AS $body$
BEGIN

insert into comunic_interna(dt_comunicado,
		ds_titulo,
		ds_comunicado,
		nm_usuario,
		dt_atualizacao,
		ie_geral,
		nm_usuario_destino,
		cd_perfil,
		nr_sequencia,
		ie_gerencial,
		nr_seq_classif,
		ds_perfil_adicional,
		cd_setor_destino,
		cd_estab_destino,
		ds_setor_adicional,
		dt_liberacao,
		ds_grupo,
		nm_usuario_oculto)
values (coalesce(dt_comunicado_p, clock_timestamp()),
		ds_titulo_p,
		wheb_rtf_pck.get_texto_rtf(ds_comunicado_p),
		nm_usuario_p,
		clock_timestamp(),
		ie_geral_p,
		nm_usuario_destino_p,
		null,
		nextval('comunic_interna_seq'),
		ie_gerencial_p,
		nr_seq_classif_p,
		ds_perfil_adicional_p,
		null,
		cd_estab_destino_p,
		ds_setor_adicional_p,
		dt_liberacao_p,
		ds_grupo_p,
		nm_usuario_oculto_p);


commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cta_gerar_comunic_padrao (dt_comunicado_p timestamp, ds_titulo_p text, ds_comunicado_p text, nm_usuario_p text, ie_geral_p text, nm_usuario_destino_p text, ie_gerencial_p text, nr_seq_classif_p bigint, ds_perfil_adicional_p text, cd_estab_destino_p bigint, ds_setor_adicional_p text, dt_liberacao_p timestamp, ds_grupo_p text, nm_usuario_oculto_p text) FROM PUBLIC;

