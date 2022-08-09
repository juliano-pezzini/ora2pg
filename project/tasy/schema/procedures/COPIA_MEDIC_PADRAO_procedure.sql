-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_medic_padrao ( cd_medico_origem_p text, cd_medico_destino_p text, nr_seq_grupo_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_seq_grupo_w	bigint;


BEGIN

Insert into med_via_aplicacao(
	nr_sequencia,
	ds_via_aplicacao,
	dt_atualizacao,
	nm_usuario,
	cd_medico)
SELECT	nextval('med_via_aplicacao_seq'),
	ds_via_aplicacao,
	clock_timestamp(),
	nm_usuario_p,
	cd_medico_destino_p
from	med_via_aplicacao a
where	cd_medico	= cd_medico_origem_p
and	ds_via_aplicacao not in (	select	b.ds_via_aplicacao
					from	med_via_aplicacao b
					where	b.cd_medico	= cd_medico_destino_p);

select	nextval('med_grupo_medic_seq')
into STRICT	nr_seq_grupo_w
;

Insert into med_grupo_medic(
	nr_sequencia,
	ds_grupo_medic,
	cd_medico,
	dt_atualizacao,
	nm_usuario,
	ie_situacao)
SELECT	nr_seq_grupo_w,
	ds_grupo_medic,
	cd_medico_destino_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_situacao
from	med_grupo_medic
where	nr_sequencia	= nr_seq_grupo_p;

Insert into med_medic_padrao(
	nr_sequencia,
	ds_material,
	cd_medico,
	dt_atualizacao,
	nm_usuario,
	ds_posologia,
	ie_tipo_receita,
	nr_seq_grupo_medic,
	ds_generico,
	ie_via_aplicacao,
	ds_observacao,
	ds_laboratorio,
	ds_contra_indicacao,
	ds_efeito,
	ds_indicacao,
	ds_forma_apres,
	ie_situacao)
SELECT	nextval('med_medic_padrao_seq'),
	ds_material,
	cd_medico_destino_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_posologia,
	ie_tipo_receita,
	nr_seq_grupo_w,
	ds_generico,
	Obter_codigo_via_aplic(cd_medico_destino_p,ie_via_aplicacao),
	ds_observacao,
	ds_laboratorio,
	ds_contra_indicacao,
	ds_efeito,
	ds_indicacao,
	ds_forma_apres,
	ie_situacao
from	med_medic_padrao
where	cd_medico		= cd_medico_origem_p
and	nr_seq_grupo_medic	= nr_seq_grupo_p;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_medic_padrao ( cd_medico_origem_p text, cd_medico_destino_p text, nr_seq_grupo_p bigint, nm_usuario_p text) FROM PUBLIC;
