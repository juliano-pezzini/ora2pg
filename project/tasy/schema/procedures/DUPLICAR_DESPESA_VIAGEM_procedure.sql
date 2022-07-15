-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_despesa_viagem ( nr_sequencia_p bigint, dt_despesa_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	via_despesa.nr_sequencia%type := nr_sequencia_p;
dt_despesa_w	via_despesa.dt_despesa%type := dt_despesa_p;
nm_usuario_w	usuario.nm_usuario%type := nm_usuario_p;


BEGIN

if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
	insert into via_despesa(
		nr_sequencia,
		nr_seq_relat,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_despesa,
		nr_seq_classif_desp,
		vl_despesa,
		nr_documento,
		ds_complemento,
		ie_responsavel_custo,
		cd_cgc_resp_custo,
		ie_tipo_despesa,
		nr_seq_forma_pagto,
		cd_cgc,
		vl_desp_original,
		nr_seq_motivo_alt_valor,
		ds_justificativa,
		qt_km,
		cd_moeda,
		cd_centro_custo	)
	SELECT 	nextval('via_despesa_seq'),
		nr_seq_relat,
		clock_timestamp(),
		nm_usuario_w,
		clock_timestamp(),
		nm_usuario_w,
		dt_despesa_w,
		nr_seq_classif_desp,
		vl_despesa,
		nr_documento,
		ds_complemento,
		ie_responsavel_custo,
		cd_cgc_resp_custo,
		ie_tipo_despesa,
		nr_seq_forma_pagto,
		cd_cgc,
		vl_desp_original,
		nr_seq_motivo_alt_valor,
		ds_justificativa,
		qt_km,
		cd_moeda,
		cd_centro_custo
	from	via_despesa
	where	nr_sequencia = nr_sequencia_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_despesa_viagem ( nr_sequencia_p bigint, dt_despesa_p timestamp, nm_usuario_p text) FROM PUBLIC;

