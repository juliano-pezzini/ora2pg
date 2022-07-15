-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_baixa_prescricao ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_atualiza_estoque_w		varchar(01);
nr_movimento_estoque_w		bigint;
cd_material_w			integer;
qt_material_w			double precision;



BEGIN

select	coalesce(max(ie_atualiza_estoque),'N'),
	max(cd_material),
	max(qt_material)
into STRICT	ie_atualiza_estoque_w,
	cd_material_w,
	qt_material_w
from	tipo_baixa_prescricao b,
	Prescr_material a
where	a.nr_prescricao		= nr_prescricao_p
and	a.nr_sequencia		= nr_sequencia_p
and	a.cd_motivo_baixa		= b.cd_tipo_baixa
and	b.ie_prescricao_devolucao	= 'P';

select	coalesce(max(nr_movimento_estoque),0)
into STRICT	nr_movimento_estoque_w
from	movimento_estoque
where	nr_prescricao		= nr_prescricao_p
and	nr_sequencia_item_docto	= nr_sequencia_p
and	coalesce(nr_movimento_estoque_corresp::text, '') = ''
and	cd_acao			= 1
and	ie_atualiza_estoque_w	= 'S';

if (nr_movimento_estoque_w	> 0) and (ie_atualiza_estoque_w	= 'S') and (qt_material_w 		> 0) then
	CALL Estornar_movimento_estoque(nr_movimento_estoque_w, nm_usuario_p);
end if;

update prescr_material
set	dt_baixa		 = NULL,
	cd_motivo_baixa	= 0,
	nm_usuario	= nm_usuario_p,
	qt_baixa_especial	= 0,
	qt_baixa_nconta	= 0
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	= nr_sequencia_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_baixa_prescricao ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

