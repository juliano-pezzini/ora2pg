-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_espera_pa ( ie_clinica_p bigint, nr_seq_classif_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_tempo_regra_espera_w		bigint;


BEGIN

	select	coalesce(max(QT_TEMPO),0)
	into STRICT	qt_tempo_regra_espera_w
	from 	regra_tempo_espera_pa a
	where 	coalesce(a.ie_clinica,coalesce(ie_clinica_p,0))		= coalesce(ie_clinica_p,0)
	and	coalesce(a.nr_seq_classif, coalesce(nr_seq_classif_p,0))	= coalesce(nr_seq_classif_p,0);

return	qt_tempo_regra_espera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_espera_pa ( ie_clinica_p bigint, nr_seq_classif_p bigint, ie_opcao_p text) FROM PUBLIC;
