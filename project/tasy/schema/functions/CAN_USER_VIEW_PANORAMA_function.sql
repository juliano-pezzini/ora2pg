-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION can_user_view_panorama ( cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

  /*return value*/

  ie_allowed_w varchar(1):= 'S';
  /*Checks if the user can view sensitive data*/

  ie_user_sensitive_w varchar(1):= 'N';
  /*Checks if the user can view personal data*/

  ie_user_patient_w varchar(1):= 'N';
  /*Checks if the user group can view sensitive data*/

  ie_user_grp_sensitive_w varchar(1):= 'N';
  /*Checks if the user group can view personal data*/

  ie_user_grp_patient_w varchar(1):= 'N';

BEGIN

	select	coalesce(ie_can_view_sensitive_info, 'N'),
		coalesce(ie_can_view_patient_info, 'N')
	into STRICT	ie_user_sensitive_w,
		ie_user_patient_w
	from	usuario
	where	nm_usuario = nm_usuario_p;

	select	coalesce(CASE WHEN can_user_see_sensitive_info('', 'S', cd_estabelecimento_p, nm_usuario_p)='Y' THEN  'Y' WHEN can_user_see_sensitive_info('', 'S', cd_estabelecimento_p, nm_usuario_p)='N' THEN  'N' END , 'N'),
		coalesce(CASE WHEN can_user_see_sensitive_info('', 'P', cd_estabelecimento_p, nm_usuario_p)='Y' THEN  'Y' WHEN can_user_see_sensitive_info('', 'P', cd_estabelecimento_p, nm_usuario_p)='N' THEN  'N' END , 'N')
	into STRICT	ie_user_grp_sensitive_w,
		ie_user_grp_patient_w
	;

	if (ie_user_sensitive_w = 'Y' or ie_user_grp_sensitive_w = 'Y') then
		ie_allowed_w    := 'S';
	else
		ie_allowed_w    := 'N';
	end if;

	return ie_allowed_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION can_user_view_panorama ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
