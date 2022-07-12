-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapa_atual_npt ( nr_prescricao_p bigint, nr_seq_item_p bigint) RETURNS bigint AS $body$
DECLARE


ie_alteracao_w		smallint;
qt_cont_w		smallint;
qt_cont_w2		smallint;

C01 CURSOR FOR
	SELECT	ie_alteracao
	from	prescr_solucao_evento
	where	ie_tipo_solucao = 4
	and		nr_prescricao	= nr_prescricao_p
	and		nr_seq_nut		= nr_seq_item_p
	and		(((ie_alteracao		= 1) or ((ie_alteracao = 2) and (obter_se_motivo_troca_frasco(nr_seq_motivo) = 'S'))) or (ie_alteracao		= 12))
	and		ie_evento_valido = 'S';


BEGIN
qt_cont_w := 0;
qt_cont_w2 := 0;
open C01;
loop
fetch C01 into
	ie_alteracao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_alteracao_w in (1,2)) then
		qt_cont_w := qt_cont_w + 1;

		qt_cont_w := qt_cont_w + qt_cont_w2;

	elsif (ie_alteracao_w = 12) then
		qt_cont_w2 := qt_cont_w2 + 1;
	end if;


	end;
end loop;
close C01;

return	qt_cont_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapa_atual_npt ( nr_prescricao_p bigint, nr_seq_item_p bigint) FROM PUBLIC;
