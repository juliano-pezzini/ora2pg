-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_recalcular_excesso (nr_seq_entrega_item_p bigint, nr_seq_rec_entregue_p bigint, nr_seq_pac_entrega_p bigint, cd_material_p bigint, cd_unidade_baixa_p text, qt_dispensar_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


nr_saldo_w		double precision;
qt_saldo_ant_w		double precision;
qt_dose_w		double precision;
qt_saldo_atu_w		double precision;
qt_gerado_w		double precision;
qt_saldo_exc_w		double precision;
ie_cancelar_saldo_w	varchar(1);


BEGIN

nr_saldo_w := fa_obter_saldo_paciente(nr_seq_rec_entregue_p,cd_material_p,nm_usuario_p);

--obtem saldo da entrega anterior
select 	coalesce(fa_obter_saldo_anterior(nr_seq_rec_entregue_p,nr_seq_pac_entrega_p,cd_material_p,nm_usuario_p,qt_dispensar_p),0)
into STRICT	qt_saldo_ant_w
;


qt_dose_w := qt_dispensar_p - coalesce(nr_saldo_w,0) - qt_saldo_ant_w;
if (qt_dose_w < 0) then
	qt_dose_w := 0;
end if;

qt_saldo_atu_w := fa_obter_excesso_medic(cd_material_p,qt_dose_w,cd_unidade_baixa_p);

--verificar se foi dispensado a mais do que foi gerado
select 	max(qt_gerado),
	max(coalesce(ie_cancelar_saldo_w,'N'))
into STRICT	qt_gerado_w,
	ie_cancelar_saldo_w
from	fa_entrega_medicacao_item
where	nr_sequencia	= nr_seq_entrega_item_p
and	cd_material	= cd_material_p;

if (qt_saldo_atu_w < 0) then
	qt_saldo_atu_w := 0;
end if;

if (qt_dispensar_p > qt_gerado_w) then
	qt_saldo_exc_w := (qt_dispensar_p - qt_gerado_w);
	qt_saldo_atu_w := qt_saldo_atu_w + qt_saldo_exc_w;
end if;

if (ie_cancelar_saldo_w = 'S') then
	qt_saldo_atu_w:= 0;
end if;


return	qt_saldo_atu_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_recalcular_excesso (nr_seq_entrega_item_p bigint, nr_seq_rec_entregue_p bigint, nr_seq_pac_entrega_p bigint, cd_material_p bigint, cd_unidade_baixa_p text, qt_dispensar_p bigint, nm_usuario_p text) FROM PUBLIC;
