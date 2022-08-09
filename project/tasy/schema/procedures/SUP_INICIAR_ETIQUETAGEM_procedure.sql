-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_iniciar_etiquetagem ( nr_seq_lote_p bigint, qt_impressao_p bigint, ie_reimpressao_p text, ie_urgente_p text, nm_usuario_p text, ds_justificativa_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_material_w	bigint;


BEGIN

select	qt_material
into STRICT	qt_material_w
from	material_lote_fornec
where	nr_sequencia = nr_seq_lote_p;

insert	into material_lote_fornec_etiq(
	nr_sequencia,
	nr_seq_lote_fornec,
	dt_aprovacao,
	nm_usuario_aprovacao,
	qt_material_lote,
	qt_impressao,
	dt_atualizacao,
	dt_atualizacao_nrec,
	nm_usuario,
	nm_usuario_nrec,
	cd_estabelecimento,
	ie_urgente,
	ds_justif_reimpressao)
values ( nextval('material_lote_fornec_etiq_seq'),
	nr_seq_lote_p,
	clock_timestamp(),
	nm_usuario_p,
	qt_material_w,
	qt_impressao_p,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p,
	cd_estabelecimento_p,
	ie_urgente_p,
	ds_justificativa_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_iniciar_etiquetagem ( nr_seq_lote_p bigint, qt_impressao_p bigint, ie_reimpressao_p text, ie_urgente_p text, nm_usuario_p text, ds_justificativa_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
