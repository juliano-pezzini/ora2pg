-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_metastase_distancia ( nr_seq_loc_origem_p bigint, nr_seq_loc_destino_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into can_tnm_regra(
	nr_sequencia,
	nr_seq_loc_tnm,
	dt_atualizacao,
	nm_usuario,
	ie_classificacao_tnm,
	ie_componente_tnm,
	cd_tnm,
	ds_regra,
	ds_resumo_regra,
	cd_topografia)
SELECT	nextval('can_tnm_regra_seq'),
	nr_seq_loc_destino_p,
	clock_timestamp(),
	nm_usuario_p,
	'C',
	ie_componente_tnm,
	cd_tnm,
	ds_regra,
	ds_resumo_regra,
	cd_topografia
from	can_tnm_regra
where	cd_tnm not in (select	b.cd_tnm
			from	can_tnm_regra b
			where	b.nr_seq_loc_tnm	= nr_seq_loc_destino_p
			and	b.ie_classificacao_tnm	= 'C')
and	ie_componente_tnm 	= 'M'
and	ie_classificacao_tnm	= 'C'
and	nr_seq_loc_tnm		= nr_seq_loc_origem_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_metastase_distancia ( nr_seq_loc_origem_p bigint, nr_seq_loc_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
