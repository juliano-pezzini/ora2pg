-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE espa_confirmar_adm_item ( nr_seq_item_p bigint, dt_adm_p timestamp, qt_dose_adm_p bigint, qt_pontos_adm_p bigint, nm_usuario_p text, ds_justificativa_p text default null) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);


BEGIN
select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	usuario
where	nm_usuario	= nm_usuario_p;

update	ATEND_TOXINA_ITEM
set		QT_DOSE_ADM	= coalesce(qt_dose_adm_p,0),
		QT_PONTOS_ADM 	= coalesce(qt_pontos_adm_p,0),
		DT_APLICACAO 	= dt_adm_p,
		DS_JUSTIFICATIVA = ds_justificativa_p,
		cd_pessoa_aplicacao = cd_pessoa_fisica_w
where	nr_sequencia	= nr_seq_item_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE espa_confirmar_adm_item ( nr_seq_item_p bigint, dt_adm_p timestamp, qt_dose_adm_p bigint, qt_pontos_adm_p bigint, nm_usuario_p text, ds_justificativa_p text default null) FROM PUBLIC;

