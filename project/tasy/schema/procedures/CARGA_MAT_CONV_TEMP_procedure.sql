-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carga_mat_conv_temp ( cd_mat_con_p text, nm_usuario_p text, ds_mat_con_p text ) AS $body$
BEGIN

delete FROM conversao_mat_conv_temp;

insert into conversao_mat_conv_temp(cd_material_convenio,
									dt_atualizacao,
									nm_usuario,
									ds_material_convenio)
							values ( cd_mat_con_p ,
									clock_timestamp(),
									nm_usuario_p,
								    ds_mat_con_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carga_mat_conv_temp ( cd_mat_con_p text, nm_usuario_p text, ds_mat_con_p text ) FROM PUBLIC;

