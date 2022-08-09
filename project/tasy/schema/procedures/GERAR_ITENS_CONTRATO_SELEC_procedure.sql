-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_contrato_selec ( cd_contrato_p text, cd_material_p bigint, qt_contrato_p bigint, vl_pagto_p bigint, nr_seq_regra_contrato_p bigint, nr_seq_contrato_p bigint, ie_utilizacao_p text, nm_usuario_p text) AS $body$
DECLARE

nr_sequencia_w	bigint;


BEGIN

select	nextval('w_itens_contrato_selec_seq')
into STRICT	nr_sequencia_w
;

insert into w_itens_contrato_selec(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_contrato,
		nr_seq_regra_contrato,
		cd_contrato,
		cd_material,
		qt_contrato,
		vl_pagto,
		ie_utilizacao)
values (nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_contrato_p,
		nr_seq_regra_contrato_p,
		cd_contrato_p,
		cd_material_p,
		qt_contrato_p,
		vl_pagto_p,
		ie_utilizacao_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_contrato_selec ( cd_contrato_p text, cd_material_p bigint, qt_contrato_p bigint, vl_pagto_p bigint, nr_seq_regra_contrato_p bigint, nr_seq_contrato_p bigint, ie_utilizacao_p text, nm_usuario_p text) FROM PUBLIC;
