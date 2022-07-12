-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_guia_convenio (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_guia_w	varchar(20);


BEGIN

SELECT	max(ie_tipo_guia)
INTO STRICT	ie_tipo_guia_w
FROM	atend_categoria_convenio
WHERE	nr_seq_interno = obter_atecaco_atendimento(nr_atendimento_p)
and 	nr_atendimento = nr_atendimento_p;

RETURN	ie_tipo_guia_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_guia_convenio (nr_atendimento_p bigint) FROM PUBLIC;

