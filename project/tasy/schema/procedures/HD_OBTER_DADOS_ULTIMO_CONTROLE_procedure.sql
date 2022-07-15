-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_obter_dados_ultimo_controle ( nr_seq_dialise_p bigint, qt_fluxo_sangue_p INOUT bigint, qt_fluxo_dialisado_p INOUT bigint, qt_pa_arterial_p INOUT bigint, qt_heparina_p INOUT bigint, qt_sangue_dial_p INOUT bigint ) AS $body$
DECLARE


nr_sequencia_w			bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	hd_controle
where	nr_seq_dialise = nr_seq_dialise_p;

if (nr_Sequencia_w IS NOT NULL AND nr_Sequencia_w::text <> '')	 then
	select	qt_fluxo_sangue,
		qt_fluxo_dialisado,
		qt_pa_arterial,
		qt_heparina,
		qt_sangue_dial
	into STRICT	qt_fluxo_sangue_p,
		qt_fluxo_dialisado_p,
		qt_pa_arterial_p,
		qt_heparina_p,
		qt_sangue_dial_p
	from	hd_controle
	where	nr_sequencia = nr_sequencia_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_obter_dados_ultimo_controle ( nr_seq_dialise_p bigint, qt_fluxo_sangue_p INOUT bigint, qt_fluxo_dialisado_p INOUT bigint, qt_pa_arterial_p INOUT bigint, qt_heparina_p INOUT bigint, qt_sangue_dial_p INOUT bigint ) FROM PUBLIC;

