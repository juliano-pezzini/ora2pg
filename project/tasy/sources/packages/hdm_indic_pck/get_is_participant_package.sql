-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION hdm_indic_pck.get_is_participant ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

		si_participant_w	varchar(1);
	
BEGIN
		select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
		into STRICT	si_participant_w
		from	mprev_participante x
		where	x.cd_pessoa_fisica = cd_pessoa_fisica_p;
		
		return si_participant_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION hdm_indic_pck.get_is_participant ( cd_pessoa_fisica_p text) FROM PUBLIC;
