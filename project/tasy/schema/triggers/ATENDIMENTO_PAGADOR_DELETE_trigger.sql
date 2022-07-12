-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_pagador_delete ON atendimento_pagador CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_pagador_delete() RETURNS trigger AS $BODY$
DECLARE

BEGIN

CALL gravar_log_exclusao('ATENDIMENTO_PAGADOR',OLD.nm_usuario, 'NR_ATENDIMENTO= ' || OLD.nr_atendimento || ', PESSOA_FISICA= ' || OLD.CD_PESSOA_FISICA || ',CPF= ' || OLD.CD_CGC,'N');

RETURN OLD;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_pagador_delete() FROM PUBLIC;

CREATE TRIGGER atendimento_pagador_delete
	BEFORE DELETE ON atendimento_pagador FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_pagador_delete();

