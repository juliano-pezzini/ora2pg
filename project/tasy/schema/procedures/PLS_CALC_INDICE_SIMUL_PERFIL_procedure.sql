-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_calc_indice_simul_perfil ( nr_seq_simul_perfil_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_simulacao_w		bigint;
nr_seq_parametro_com_w		bigint;
ie_forma_calculo_w		varchar(2);
nr_seq_simul_param_item_w	bigint;
tx_indice_w			double precision;
tx_tot_arimetico_indice_w	double precision := 0;
tx_indice_perfil_w		double precision := 0;
qt_itens_perfis_cad_w		bigint := 0;
vl_peso_item_w			double precision := 0;
vl_soma_peso_item_w		double precision := 0;
tx_tot_indice_ponderado_w	double precision := 0;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_simul_param_item
	where	nr_seq_regra_perfil	= nr_seq_simul_perfil_p;


BEGIN

select	max(nr_seq_simulacao)
into STRICT	nr_seq_simulacao_w
from	pls_simulacao_perfil
where	nr_sequencia	= nr_seq_simul_perfil_p;

select	max(NR_SEQ_PARAMETRO_COM)
into STRICT	nr_seq_parametro_com_w
from	pls_simulacao_preco
where	nr_sequencia	= nr_seq_simulacao_w;

select	max(ie_forma_calculo)
into STRICT	ie_forma_calculo_w
from	pls_simul_regra_param
where	nr_sequencia	= nr_seq_parametro_com_w;

open C01;
loop
fetch C01 into
	nr_seq_simul_param_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_itens_perfis_cad_w	:= qt_itens_perfis_cad_w + 1;
	select	tx_indice,
		vl_peso
	into STRICT	tx_indice_w,
		vl_peso_item_w
	from	pls_simul_param_item
	where	nr_sequencia	= nr_seq_simul_param_item_w;

	if (coalesce(tx_indice_w::text, '') = '') then
		tx_indice_w	:= 0;
	end if;

	if (coalesce(vl_peso_item_w::text, '') = '') then
		vl_peso_item_w	:= 0;
	end if;

	tx_tot_arimetico_indice_w		:= tx_tot_arimetico_indice_w + tx_indice_w;
	tx_tot_indice_ponderado_w		:= tx_tot_indice_ponderado_w +  (tx_indice_w * vl_peso_item_w);
	vl_soma_peso_item_w			:= vl_soma_peso_item_w + vl_peso_item_w;

	end;
end loop;
close C01;

if (ie_forma_calculo_w = 'A') then
	if (qt_itens_perfis_cad_w <> 0) then
		tx_indice_perfil_w		:= tx_tot_arimetico_indice_w/qt_itens_perfis_cad_w;
	else
		tx_indice_perfil_w		:= 1;
	end if;
elsif (ie_forma_calculo_w = 'P') then
	if (vl_soma_peso_item_w <> 0) then
		tx_indice_perfil_w		:= tx_tot_indice_ponderado_w/vl_soma_peso_item_w;
	else
		tx_indice_perfil_w		:= 1;
	end if;
end if;

update	pls_simulacao_perfil
set	tx_indice		= tx_indice_perfil_w
where	nr_sequencia	= nr_seq_simul_perfil_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_calc_indice_simul_perfil ( nr_seq_simul_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;

