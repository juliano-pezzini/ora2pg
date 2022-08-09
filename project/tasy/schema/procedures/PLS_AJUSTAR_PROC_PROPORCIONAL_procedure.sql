-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_proc_proporcional ( nr_seq_conta_proc_p bigint, ie_commitar_p text, vl_liberado_co_p INOUT bigint, vl_liberado_hi_p INOUT bigint, vl_liberado_material_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE


/*Rotina que tem o objetivo de atualizar os valores proporcionais liberados do procedimento (HI, MAT e MED)

Exemplo:	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	HI_CALC		MAT_CALC			MED_CALC
	10,00		20,00			70,00

	No caso de ser liberado 80,00 reais o sistema deve obetr os valores relativos proporcionais ao calculado, com base no liberado, e atualizar os campos individuais liberados.

	Vl. LIBERADO
	80,00

	HI_LIB		MAT_LIB			MED_LIB
	8,00		16,00			56,00

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	HI_CALC		MAT_CALC			MED_CALC
	10,00		20,00			170,00

	No caso de ser liberado 80,00 reais o sistema deve obetr os valores relativos proporcionais ao calculado, com base no liberado, e atualizar os campos individuais liberados.

	Vl. LIBERADO
	80,00

	HI_LIB		MAT_LIB			MED_LIB
	4,00		8,00			68,00

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/
vl_liberado_co_w		double precision;
vl_liberado_hi_w		double precision;
vl_liberado_material_w		double precision;
ie_repassa_medico_w		varchar(1);

vl_calculado_hi_w		double precision;
vl_calculado_co_w		double precision;
vl_calculado_material_w		double precision;

vl_base_w			double precision;
vl_liberado_w			double precision;
vl_calculado_w			double precision;

vl_lib_w			double precision;
vl_participantes_w		double precision;

BEGIN

begin
select	ie_repassa_medico,
	vl_total_partic,
	vl_custo_operacional,
	vl_materiais,
	vl_liberado,
	vl_procedimento
into STRICT	ie_repassa_medico_w,
	vl_calculado_hi_w,
	vl_calculado_co_w,
	vl_calculado_material_w,
	vl_liberado_w,
	vl_calculado_w
from	pls_conta_proc
where	nr_sequencia = nr_seq_conta_proc_p;
exception
when others then
	vl_calculado_hi_w	:= 0;
	vl_calculado_co_w	:= 0;
	vl_calculado_material_w	:= 0;
	vl_liberado_w		:= 0;
	vl_calculado_w		:= 0;
end;

--(S,N,H)(Total,Somente CO e Filme,Somente honorário)
if (coalesce(ie_repassa_medico_w,'S') = 'H') then
	vl_calculado_co_w	 := 0;
	vl_calculado_material_w	 := 0;
end if;

for i in 1..3 loop
	begin

	if (i = 1) then
		vl_base_w := vl_calculado_hi_w;
	elsif (i = 2) then
		vl_base_w := vl_calculado_co_w;
	else
		vl_base_w := vl_calculado_material_w;
	end if;

	vl_lib_w := dividir_sem_round((vl_liberado_w * vl_base_w),vl_calculado_w);

	if (i = 1) then
		vl_liberado_hi_w 	:= vl_lib_w;
	elsif (i = 2) then
		vl_liberado_co_w 	:= vl_lib_w;
	else
		vl_liberado_material_w 	:= vl_lib_w;
	end if;

	end;
end loop;

--Para que seja mantido o valor liberado correto quando existe participantes; e nestes existirem valo rde participante.
/*select	nvl(sum(vl_participante),0)
into	vl_participantes_w
from	pls_proc_participante
where	nr_seq_conta_proc = nr_seq_conta_proc_p;

vl_liberado_hi_w := vl_liberado_hi_w + vl_participantes_w;
*/
update	pls_conta_proc
set	vl_liberado_co		= vl_liberado_co_w,
	vl_liberado_hi		= vl_liberado_hi_w,
	vl_liberado_material	= vl_liberado_material_w
where	nr_sequencia 		= nr_seq_conta_proc_p;

vl_liberado_co_p		:= vl_liberado_co_w;
vl_liberado_hi_p		:= vl_liberado_hi_w;
vl_liberado_material_p		:= vl_liberado_material_w;

if (coalesce(ie_commitar_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_proc_proporcional ( nr_seq_conta_proc_p bigint, ie_commitar_p text, vl_liberado_co_p INOUT bigint, vl_liberado_hi_p INOUT bigint, vl_liberado_material_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;
