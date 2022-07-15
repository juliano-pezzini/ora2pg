-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_calculo_mat ( cd_material_p bigint, nr_seq_matpaci_p bigint, cd_convenio_p bigint, cd_categoria_p text, ds_log_calculo_p text, ie_gravar_log_p text) AS $body$
BEGIN

if (coalesce(ie_gravar_log_p,'N') = 'S') and (obter_funcao_ativa in (67,1115)) then

        insert  into material_log_calculo(     nr_sequencia,
                                                cd_material,
                                                dt_atualizacao,
                                                nr_seq_matpaci,
                                                cd_convenio,
                                                cd_categoria,
                                                ds_log_calculo  )
                                values (     nextval('material_log_calculo_seq'),
                                                cd_material_p,
                                                clock_timestamp(),
                                                nr_seq_matpaci_p,
                                                cd_convenio_p,
                                                cd_categoria_p,
                                                ds_log_calculo_p);

        if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_calculo_mat ( cd_material_p bigint, nr_seq_matpaci_p bigint, cd_convenio_p bigint, cd_categoria_p text, ds_log_calculo_p text, ie_gravar_log_p text) FROM PUBLIC;

