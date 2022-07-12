-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_posicao_npt_adulto (nr_seq_cpoe_p cpoe_dieta.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_posicao_administracao_w	cpoe_dieta.ie_posicao_administracao%type;


BEGIN	
	select	max(obter_valor_dominio(10680, a.ie_posicao_administracao))
	into STRICT	ie_posicao_administracao_w
	from 	cpoe_dieta a
	where 	a.nr_sequencia = nr_seq_cpoe_p
          and (ie_posicao_administracao IS NOT NULL AND ie_posicao_administracao::text <> '');

return ie_posicao_administracao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_posicao_npt_adulto (nr_seq_cpoe_p cpoe_dieta.nr_sequencia%type) FROM PUBLIC;
