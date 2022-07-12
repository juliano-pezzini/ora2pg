-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION holding_pck.get_acesso_grupo_emp ( cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_param_p text, nr_seq_obj_schem_param_p bigint default null, ie_nivel_acesso_p text DEFAULT NULL, cd_empresa_p bigint DEFAULT NULL) RETURNS bigint AS $body$
DECLARE

  cd_grupo_estrut_w  bigint;
  id_acesso_usu_w    varchar(1);

BEGIN
  cd_grupo_estrut_w  :=  holding_pck.get_grupo_emp_estrut_vigente(cd_empresa_p => cd_empresa_p);

  id_acesso_usu_w    :=  holding_pck.get_acesso_usu_funcao(  cd_funcao_p      =>  cd_funcao_p,
                cd_perfil_p      =>  cd_perfil_p,
                nm_usuario_param_p    =>  nm_usuario_param_p,
                nr_seq_obj_schem_param_p  =>  nr_seq_obj_schem_param_p,
                ie_nivel_acesso_p    =>  ie_nivel_acesso_p);

  if  coalesce(cd_grupo_estrut_w,0)  <>  0
    and coalesce(id_acesso_usu_w,'N')  =  'S' then
    return cd_grupo_estrut_w;
  else
    return 0;
  end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION holding_pck.get_acesso_grupo_emp ( cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_param_p text, nr_seq_obj_schem_param_p bigint default null, ie_nivel_acesso_p text DEFAULT NULL, cd_empresa_p bigint DEFAULT NULL) FROM PUBLIC;
