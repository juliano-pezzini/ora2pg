-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_medida_referencia (nr_seq_med_laudo_p bigint, ie_tipo_medida_p text, qt_idade_p bigint, qt_peso_p bigint) RETURNS varchar AS $body$
DECLARE


ds_medida_referencia_w		varchar(80);
ds_medida_referencia_aux_w	varchar(255);

C01 CURSOR FOR
SELECT	max(a.ds_medida_referencia)
into STRICT	ds_medida_referencia_w
from	medida_exame_refer a,
	medida_exame_laudo b
where	a.nr_seq_medida = b.nr_sequencia
and	b.nr_sequencia = nr_seq_med_laudo_p
and	a.ie_tipo_medida = ie_tipo_medida_p
and ((a.ie_tipo_medida = 'P' AND qt_peso_p between a.QT_PESO_MINIMO and a.QT_PESO_MAXIMO) or
	(a.ie_tipo_medida = 'I' AND qt_idade_p between a.QT_IDADE_MINIMA and a.QT_IDADE_MAXIMA));


BEGIN

open C01;
loop
fetch C01 into
	ds_medida_referencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;


return	ds_medida_referencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_medida_referencia (nr_seq_med_laudo_p bigint, ie_tipo_medida_p text, qt_idade_p bigint, qt_peso_p bigint) FROM PUBLIC;
