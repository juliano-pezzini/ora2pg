-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gt_obter_qt_irmao_pf (cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


--ie_executa_w	varchar2(1):='N';
qt_irmaos_w integer:=NULL;


BEGIN

		SELECT 	COUNT(*)
		INTO STRICT	qt_irmaos_w
		FROM   	PF_RELACAO_PARENTESCO
		WHERE  	nr_seq_grau_parent = 41
		AND	cd_pessoa_fisica = cd_pessoa_fisica_p;
	--end if;
RETURN qt_irmaos_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gt_obter_qt_irmao_pf (cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

