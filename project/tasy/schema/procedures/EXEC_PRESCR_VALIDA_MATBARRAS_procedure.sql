-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE exec_prescr_valida_matbarras ( cd_material_p bigint, nr_atendimento_p bigint, nr_seq_lote_fornec_p text, nr_sequencia_p INOUT bigint, nr_prescricao_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


/**Faz a validação do material - Juliane Menin*/

nr_sequencia_w		bigint;
nr_prescricao_w		bigint;
ie_consignado_w		varchar(2);
cd_cgc_w		varchar(14);
ds_erro_w		varchar(600);



BEGIN

begin

select	a.nr_prescricao,
	a.nr_sequencia
into STRICT	nr_prescricao_w,
	nr_sequencia_w
from	prescr_medica b,
	prescr_material a
where	a.cd_motivo_baixa	= 0
and	a.cd_material          	= cd_material_p
and	a.nr_prescricao        	= b.nr_prescricao
and	b.nr_atendimento       	= nr_atendimento_p
and	not exists (SELECT 1
	from cirurgia x
	where	x.nr_prescricao	= a.nr_prescricao)
order by	a.nr_prescricao desc, a.nr_sequencia LIMIT 1;
exception
			when others then
	nr_sequencia_w	:= '';
	nr_prescricao_w	:= '';
end;

select	ie_consignado
into STRICT	ie_consignado_w
from	material
where	cd_material	= cd_material_p;

if ( ie_consignado_w > 0) then

	if ( nr_seq_lote_fornec_p != ' ' and nr_seq_lote_fornec_p != 0 ) then

		select	cd_cgc_fornec
		into STRICT	cd_cgc_w
		from	material_lote_fornec
		where	nr_sequencia	=	nr_seq_lote_fornec_p;
	else
		begin
		select	a.cd_fornecedor
		into STRICT	cd_cgc_w
		from	fornecedor_mat_consignado a,
			Material m
		where	a.cd_material           = m.cd_material_estoque
		and	a.dt_mesano_referencia  > (clock_timestamp() - interval '60 days')
		and	m.cd_material           = cd_material_p
		group by	a.cd_fornecedor;

		if ( ie_consignado_w = 1 and cd_cgc_w = '') then
			ds_erro_w	:=	wheb_mensagem_pck.get_texto(280734);
		end if;

		exception
			when others then

				ds_erro_w	:= wheb_mensagem_pck.get_texto(280735, 'CD_MATERIAL_P=' || cd_material_p);
		end;
	end if;

end if;

nr_prescricao_p := 	nr_prescricao_w;
nr_sequencia_p	:=	nr_sequencia_w;
ds_erro_p	:=	ds_erro_w;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE exec_prescr_valida_matbarras ( cd_material_p bigint, nr_atendimento_p bigint, nr_seq_lote_fornec_p text, nr_sequencia_p INOUT bigint, nr_prescricao_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;
