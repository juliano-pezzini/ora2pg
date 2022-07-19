-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_third_party_inv_value ( nr_interno_conta_p conta_paciente.nr_interno_conta%type) AS $body$
DECLARE

			
nr_fatura_w		third_party_invoice.nr_fatura%type;
total_value_w		third_party_invoice_item.vl_item_total%type;
total_discount_w	third_party_invoice_item.vl_desconto%type;

			
C01 CURSOR FOR
	SELECT	nr_fatura
	from	third_party_invoice
	where	nr_interno_conta = nr_interno_conta_p;


BEGIN

	open C01;
	loop
	fetch C01 into	
		nr_fatura_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select  sum(vl_item_total),
			sum(vl_desconto)
		into STRICT	total_value_w,
			total_discount_w
		from    third_party_invoice_item
		where   nr_seq_third_party_inv = nr_fatura_w;
		
		update	third_party_invoice
		set	vl_total_nota = total_value_w,
			vl_descontos  = total_discount_w
		where	nr_sequencia = nr_fatura_w;
		
		end;
	end loop;
	close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_third_party_inv_value ( nr_interno_conta_p conta_paciente.nr_interno_conta%type) FROM PUBLIC;

