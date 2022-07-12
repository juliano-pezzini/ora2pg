-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_check_current_registration ( cd_estabelecimento_p pls_termo_prestador.cd_estabelecimento%type, dt_inicio_vigencia_p pls_termo_prestador.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_termo_prestador.dt_fim_vigencia%type, nr_sequencia_p pls_termo_prestador.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE

	nr_sequencia_w pls_termo_prestador.nr_sequencia%type;

BEGIN
	select nr_sequencia
	into STRICT nr_sequencia_w
	from pls_termo_prestador
	where cd_estabelecimento_p = cd_estabelecimento
		and nr_sequencia <> nr_sequencia_p
	    and (
	    		(
	    			dt_inicio_vigencia between dt_inicio_vigencia_p and dt_fim_vigencia_p
	    		)
	        	or (
	        		dt_fim_vigencia between dt_inicio_vigencia_p and dt_fim_vigencia_p
	        	)
	        )  LIMIT 1;

return nr_sequencia_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_check_current_registration ( cd_estabelecimento_p pls_termo_prestador.cd_estabelecimento%type, dt_inicio_vigencia_p pls_termo_prestador.dt_inicio_vigencia%type, dt_fim_vigencia_p pls_termo_prestador.dt_fim_vigencia%type, nr_sequencia_p pls_termo_prestador.nr_sequencia%type) FROM PUBLIC;
