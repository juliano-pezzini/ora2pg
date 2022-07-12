-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_maior_guia_conta ( nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


nr_doc_convenio_w	varchar(20);


BEGIN

SELECT	MAX(cd_autorizacao)
INTO STRICT	nr_doc_convenio_w
FROM 	conta_paciente_guia
WHERE	nr_interno_conta	= nr_interno_conta_p
and 	(cd_autorizacao IS NOT NULL AND cd_autorizacao::text <> '')
and	cd_autorizacao <> 'Não Informada';

return nr_doc_convenio_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_maior_guia_conta ( nr_interno_conta_p bigint) FROM PUBLIC;
