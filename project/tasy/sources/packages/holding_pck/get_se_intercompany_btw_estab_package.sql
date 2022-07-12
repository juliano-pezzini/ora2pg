-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION holding_pck.get_se_intercompany_btw_estab (cd_estabelecimento_p bigint, cd_estab_info_p bigint) RETURNS varchar AS $body$
DECLARE

cd_raiz_cnpj_w      varchar(8);
cd_empresa_w        empresa.cd_empresa%type;
cd_empresa_info_w      empresa.cd_empresa%type;
cd_grupo_empresa_w    grupo_emp_estrutura.nr_sequencia%type;
cd_grupo_empresa_info_w    grupo_emp_estrutura.nr_sequencia%type;
ie_intercompany_w      varchar(1)  := 'N';

BEGIN

  if (coalesce(cd_estabelecimento_p, 0) <> 0 and coalesce(cd_estab_info_p, 0) <> 0) then
    cd_empresa_w    := obter_empresa_estab(cd_estabelecimento_p);
    cd_empresa_info_w    := obter_empresa_estab(cd_estab_info_p);
    begin
      cd_grupo_empresa_w   := holding_pck.get_grupo_emp_usuario(cd_empresa_w);
      cd_grupo_empresa_info_w   := holding_pck.get_grupo_emp_usuario(cd_empresa_info_w);
      if (cd_grupo_empresa_w = cd_grupo_empresa_info_w) then
        ie_intercompany_w := 'S';
      end if;
    end;
  end if;
  return ie_intercompany_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION holding_pck.get_se_intercompany_btw_estab (cd_estabelecimento_p bigint, cd_estab_info_p bigint) FROM PUBLIC;