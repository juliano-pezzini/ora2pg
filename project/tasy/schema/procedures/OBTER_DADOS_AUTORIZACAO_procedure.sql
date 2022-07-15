-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_autorizacao ( nr_atendimento_p bigint, dt_inicio_vigencia_p INOUT timestamp, dt_fim_vigencia_p INOUT timestamp, cd_senha_p INOUT text, cd_autorizacao_p INOUT text, qt_dia_autorizado_p INOUT bigint, ie_tipo_guia_p INOUT text) AS $body$
BEGIN

select	max(dt_inicio_vigencia),
	max(dt_fim_vigencia),
	max(cd_senha),
	max(cd_autorizacao),
	max(qt_dia_autorizado),
	max(ie_tipo_guia)
into STRICT	dt_inicio_vigencia_p,
	dt_fim_vigencia_p,
	cd_senha_p,
	cd_autorizacao_p,
	qt_dia_autorizado_p,
	ie_tipo_guia_p
from	autorizacao_convenio
where	nr_sequencia = (SELECT max(nr_sequencia) from autorizacao_convenio where nr_atendimento = nr_atendimento_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_autorizacao ( nr_atendimento_p bigint, dt_inicio_vigencia_p INOUT timestamp, dt_fim_vigencia_p INOUT timestamp, cd_senha_p INOUT text, cd_autorizacao_p INOUT text, qt_dia_autorizado_p INOUT bigint, ie_tipo_guia_p INOUT text) FROM PUBLIC;

