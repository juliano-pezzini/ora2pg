-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_texto_padrao_cirur ( cd_estabelecimento_p bigint, CD_MEDICO_p text) RETURNS bigint AS $body$
DECLARE

/*
C - Código
*/
nr_sequencia_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	CIRURGIA_PROTOCOLO
where	ie_opcao_padrao	= 'S'
and	coalesce(cd_estabelecimento,cd_estabelecimento_p)	= cd_estabelecimento_p
and	coalesce(CD_MEDICO,CD_MEDICO_p)			= CD_MEDICO_p;
---and	nvl(CD_ESPECIALIDADE,CD_ESPECIALIDADE_p)	= CD_ESPECIALIDADE_p;
return nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_texto_padrao_cirur ( cd_estabelecimento_p bigint, CD_MEDICO_p text) FROM PUBLIC;
