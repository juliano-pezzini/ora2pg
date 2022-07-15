-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_importar_plano_conta_ifrs (cd_classificacao_p ctb_plano_conta_ifrs.cd_classificacao%type, ds_conta_p ctb_plano_conta_ifrs.ds_conta%type, nr_nivel_p ctb_plano_conta_ifrs.nr_nivel%type, cd_classif_sup_p ctb_plano_conta_ifrs.cd_classif_sup%type, dt_inicio_vigencia_p ctb_plano_conta_ifrs.dt_inicio_vigencia%type, nm_usuario_p ctb_plano_conta_ifrs.nm_usuario%type, ie_tipo_p ctb_plano_conta_ifrs.ie_tipo%type, cd_empresa_p ctb_plano_conta_ifrs.cd_empresa%type) AS $body$
DECLARE


dt_atual_w			constant ctb_plano_conta_ifrs.dt_atualizacao%type := clock_timestamp();


BEGIN

begin
insert into ctb_plano_conta_ifrs(	
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	cd_classificacao,
	ds_conta,
	nr_nivel,
	cd_classif_sup,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	dt_inicio_vigencia,
	ie_tipo,
	cd_empresa)
values (
	nextval('ctb_plano_conta_ifrs_seq'),
	dt_atual_w,
	nm_usuario_p,
	substr(cd_classificacao_p,1,40),
	substr(ds_conta_p,1,255),
	nr_nivel_p,
	cd_classif_sup_p,
	dt_atual_w,
	nm_usuario_p,
	dt_inicio_vigencia_p,
	ie_tipo_p,
	cd_empresa_p);
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_importar_plano_conta_ifrs (cd_classificacao_p ctb_plano_conta_ifrs.cd_classificacao%type, ds_conta_p ctb_plano_conta_ifrs.ds_conta%type, nr_nivel_p ctb_plano_conta_ifrs.nr_nivel%type, cd_classif_sup_p ctb_plano_conta_ifrs.cd_classif_sup%type, dt_inicio_vigencia_p ctb_plano_conta_ifrs.dt_inicio_vigencia%type, nm_usuario_p ctb_plano_conta_ifrs.nm_usuario%type, ie_tipo_p ctb_plano_conta_ifrs.ie_tipo%type, cd_empresa_p ctb_plano_conta_ifrs.cd_empresa%type) FROM PUBLIC;

