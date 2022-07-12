-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tasy_generated_versions_v (ds_version, branch_hotfix, ie_plataforma) AS select	cd_versao || '.' || cd_build ds_version, CASE WHEN hotfix='' THEN ''  ELSE cd_versao||'.'||hotfix END  branch_hotfix,
	ie_plataforma
FROM (
		select	distinct tvu.cd_version cd_versao,
			lpad(tvu.nr_service_pack, greatest(2, length(tvu.nr_service_pack)), '0') cd_build,
            		CASE WHEN sph.ds_hotfix='' THEN ''  ELSE sph.ds_hotfix END  hotfix,
			'H' ie_plataforma
		FROM tasy_version_udi tvu
LEFT OUTER JOIN service_pack_hotfix sph ON (tvu.cd_version = sph.cd_version AND tvu.nr_service_pack = sph.nr_service_pack) 
union

		select	distinct cd_versao,
			lpad(cd_build, greatest(2, length(cd_build)), '0'),
            		'' hotfix, 
			CASE WHEN ie_aplicacao='J' THEN  'S'  ELSE ie_aplicacao END  /*--dominio 2811*/
		from	man_versao_calendario
		where	cd_build is not null
		and	ie_aplicacao in ('D', 'J')
		order by cd_versao desc, cd_build asc
	) alias7;
