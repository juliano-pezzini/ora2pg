-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aceita_valor_analise ( nr_sequencia_p bigint, ie_tipo_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


vl_calculado_w		double precision;
vl_total_apres_w	double precision;
vl_liberado_w		double precision;
qt_liberada_w		bigint;
vl_unit_lib_w		double precision;
qt_apresentado_w	bigint;
vl_unitario_apres_w	double precision;
nr_seq_conta_w		bigint;
nr_seq_analise_w	bigint;
nr_seq_item_w		bigint;
ie_tipo_item_w		varchar(1);


BEGIN

select	nr_seq_conta,
	nr_seq_analise,
	nr_seq_item,
	ie_tipo_item
into STRICT	nr_seq_conta_w,
	nr_seq_analise_w,
	nr_seq_item_w,
	ie_tipo_item_w
from	w_pls_resumo_conta
where 	nr_sequencia = nr_sequencia_p;

if (ie_tipo_p = 1) then
/*Aceitar melhor valor*/

	select	vl_calculado,
		vl_total_apres,
		coalesce(qt_apresentado,1),
		vl_unitario_apres
	into STRICT	vl_calculado_w,
		vl_total_apres_w,
		qt_apresentado_w,
		vl_unitario_apres_w
	from	w_pls_resumo_conta
	where	nr_sequencia = nr_sequencia_p;

	if (vl_calculado_w < vl_total_apres_w) then
		vl_liberado_w	:= vl_calculado_w;
		qt_liberada_w	:= qt_apresentado_w;
		vl_unit_lib_w	:= dividir_sem_round(vl_calculado_w, qt_apresentado_w);
	else
		vl_liberado_w	:= vl_total_apres_w;
		qt_liberada_w	:= qt_apresentado_w;
		vl_unit_lib_w	:= vl_unitario_apres_w;
	end if;

	update	w_pls_resumo_conta
	set	vl_total = vl_liberado_w,
		qt_liberado = qt_liberada_w,
		vl_unitario = vl_unit_lib_w
	where	nr_sequencia = nr_sequencia_p;

	CALL pls_inserir_hist_analise(nr_seq_conta_w, nr_seq_analise_w, 13,
				 nr_seq_item_w, ie_tipo_item_w, null,
				 null, '', nr_seq_grupo_p,
				 nm_usuario_p, cd_estabelecimento_p);

elsif (ie_tipo_p = 2) then
/*Aceitar valor calculado*/

	update	w_pls_resumo_conta
	set	vl_total = vl_calculado,
		qt_liberado = coalesce(qt_apresentado,1),
		vl_unitario = dividir_sem_round(vl_calculado, qt_apresentado)
	where	nr_sequencia = nr_sequencia_p;

	CALL pls_inserir_hist_analise(nr_seq_conta_w, nr_seq_analise_w, 12,
				 nr_seq_item_w, ie_tipo_item_w, null,
				 null, '', nr_seq_grupo_p,
				 nm_usuario_p, cd_estabelecimento_p);


elsif (ie_tipo_p = 3) then
/*Aceitar valor apresentado*/

	update	w_pls_resumo_conta
	set	vl_total = vl_total_apres,
		qt_liberado = coalesce(qt_apresentado,1),
		vl_unitario = vl_unitario_apres
	where	nr_sequencia = nr_sequencia_p;

	CALL pls_inserir_hist_analise(nr_seq_conta_w, nr_seq_analise_w, 11,
				 nr_seq_item_w, ie_tipo_item_w, null,
				 null, '', nr_seq_grupo_p,
				 nm_usuario_p, cd_estabelecimento_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aceita_valor_analise ( nr_sequencia_p bigint, ie_tipo_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

