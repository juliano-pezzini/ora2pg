-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_suspend_order_unit ( nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type, nr_seq_cpoe_rp_p cpoe_rp.nr_sequencia%type, nm_usuario_p cpoe_material.nm_usuario%type) AS $body$
DECLARE


nr_sequencia_w		cpoe_material.nr_sequencia%type;
ie_tipo_item_w		varchar(3);
nr_atendimento_w	cpoe_material.nr_atendimento%type;
ds_liberacao_w		varchar(1);
ds_lista_w			varchar(2000);

ds_lista_itens_ret_w	varchar(2000);
ds_lista_itens_ex_w		varchar(2000);
ds_lista_sol_consistir_w	varchar(2000);



c01 CURSOR FOR
SELECT 	nr_sequencia,
		ie_tipo_item_cpoe,
  		nr_atendimento,
  		CASE WHEN coalesce(dt_liberacao::text, '') = '' THEN  'N'  ELSE 'S' END  ds_liberacao
from	cpoe_itens_v
where 	NR_SEQ_CPOE_ORDER_UNIT = nr_seq_cpoe_order_unit_p 
or 		nr_seq_cpoe_rp = nr_seq_cpoe_rp_p;


BEGIN
	ds_lista_w := '';

	open c01;
	loop
	fetch c01 into	nr_sequencia_w,
					ie_tipo_item_w,	
					nr_atendimento_w,
					ds_liberacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
		if (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then
			ds_lista_w := ds_lista_w || ',';
		end if;
		ds_lista_w := ds_lista_w || nr_sequencia_w || ';' || ie_tipo_item_w;
	end;
	end loop;
	close c01;

	if (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then
		ds_lista_w := '[' || ds_lista_w || ']';

		SELECT * FROM cpoe_ajustar_itens_susp(ds_lista_w, clock_timestamp(), nm_usuario_p, ds_lista_itens_ret_w, 'I', ds_lista_sol_consistir_w, ds_lista_itens_ex_w) INTO STRICT ds_lista_itens_ret_w, ds_lista_sol_consistir_w, ds_lista_itens_ex_w;
	end if;

	if (nr_seq_cpoe_order_unit_p IS NOT NULL AND nr_seq_cpoe_order_unit_p::text <> '') then
		-- order unit
		update	cpoe_order_unit
		set 	dt_suspensao = clock_timestamp(),
				nm_usuario_susp = nm_usuario_p
		where	nr_sequencia = nr_seq_cpoe_order_unit_p;
	else
		-- rp
		update	cpoe_rp
		set 	dt_suspensao = clock_timestamp(),
				nm_usuario_susp = nm_usuario_p
		where	nr_sequencia = nr_seq_cpoe_rp_p;
	end if;

	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_suspend_order_unit ( nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type, nr_seq_cpoe_rp_p cpoe_rp.nr_sequencia%type, nm_usuario_p cpoe_material.nm_usuario%type) FROM PUBLIC;
