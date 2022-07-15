-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE int_liberar_prescricao (nr_prescricao_p bigint, nr_atendimento_p bigint, ie_tipo_pessoa_p text, ie_prescricao_p text, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
BEGIN
 
ds_erro_p := liberar_prescricao(nr_prescricao_p, nr_atendimento_p, ie_tipo_pessoa_p, cd_perfil_p, nm_usuario_p, ie_prescricao_p, ds_erro_p);
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE int_liberar_prescricao (nr_prescricao_p bigint, nr_atendimento_p bigint, ie_tipo_pessoa_p text, ie_prescricao_p text, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

