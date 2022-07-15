-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_vincular_relatorio ( nr_seq_rel_philips_p bigint, nr_seq_rel_cliente_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_classif_relat_w	relatorio.cd_classif_relat%type;
cd_relatorio_w		relatorio.cd_relatorio%type;


BEGIN

select	max(cd_classif_relat),
	max(cd_relatorio)
into STRICT	cd_classif_relat_w,
	cd_relatorio_w
from	relatorio
where	nr_sequencia	= nr_seq_rel_philips_p;

if (cd_classif_relat_w IS NOT NULL AND cd_classif_relat_w::text <> '') and (cd_relatorio_w IS NOT NULL AND cd_relatorio_w::text <> '') then

	update	relatorio
	set	cd_classif_relat_wheb	= cd_classif_relat_w,
		cd_relatorio_wheb	= cd_relatorio_w,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_rel_cliente_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_vincular_relatorio ( nr_seq_rel_philips_p bigint, nr_seq_rel_cliente_p bigint, nm_usuario_p text) FROM PUBLIC;

