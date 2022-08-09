-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_valores_cooperativas ( nr_seq_lote_p bigint, nm_usuario_p text, vl_inconsistentes_p INOUT bigint, vl_divergentes_p INOUT bigint, vl_existentes_p INOUT bigint, vl_importadas_p INOUT bigint) AS $body$
DECLARE


vl_inconsistentes_w		bigint := 0;
vl_divergentes_w		bigint := 0;
vl_existentes_w		bigint := 0;
vl_importadas_w		bigint := 0;


BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	begin

	select  count(*)
	into STRICT	vl_inconsistentes_w
	from    pls_w_import_cad_unimed
	where   ie_tipo_inconsistencia  = 12
	and     nr_seq_lote = nr_seq_lote_p;

	select  count(distinct b.nr_sequencia)
	into STRICT	vl_divergentes_w
	from    pls_w_import_cad_unimed b,
	pls_cad_unimed_inconsist a
	where   a.nr_seq_cad_unimed  = b.nr_sequencia
	and		a.ie_tipo_inconsistencia  = 3
	and     b.nr_seq_lote = nr_seq_lote_p;

	select  count(*)
	into STRICT	vl_existentes_w
	from    pls_w_import_cad_unimed
	where   ie_existente   = 'S'
	and     nr_seq_lote    = nr_seq_lote_p;

	select	count(*)
	into STRICT	vl_importadas_w
	from	pls_w_import_cad_unimed
	where	ie_existente   = 'N'
	and	(dt_importacao IS NOT NULL AND dt_importacao::text <> '')
	and	nr_seq_lote    = nr_seq_lote_p;

	end;
end if;

	vl_inconsistentes_p		:= vl_inconsistentes_w;
	vl_divergentes_p		:= vl_divergentes_w;
	vl_existentes_p		:= vl_existentes_w;
	vl_importadas_p		:= vl_importadas_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_valores_cooperativas ( nr_seq_lote_p bigint, nm_usuario_p text, vl_inconsistentes_p INOUT bigint, vl_divergentes_p INOUT bigint, vl_existentes_p INOUT bigint, vl_importadas_p INOUT bigint) FROM PUBLIC;
