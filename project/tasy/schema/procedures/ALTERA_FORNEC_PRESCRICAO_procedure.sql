-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_fornec_prescricao ( nr_lote_p bigint, nr_seq_prescricao_p bigint, cd_cgc_fornec_p text, nm_usuario_p text) AS $body$
DECLARE


nr_prescricao_w		bigint;


BEGIN

select	coalesce(max(nr_prescricao),0)
into STRICT	nr_prescricao_w
from	ap_lote
where	nr_sequencia = nr_lote_p;

if (nr_prescricao_w > 0) and (nr_seq_prescricao_p > 0) then

	update	prescr_material
	set	cd_fornec_consignado = cd_cgc_fornec_p
	where	nr_prescricao = nr_prescricao_w
	and	nr_sequencia = nr_seq_prescricao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_fornec_prescricao ( nr_lote_p bigint, nr_seq_prescricao_p bigint, cd_cgc_fornec_p text, nm_usuario_p text) FROM PUBLIC;
