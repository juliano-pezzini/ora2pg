-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fin_obter_cheques_deposito ( nr_seq_deposito_p movto_trans_financ.nr_seq_deposito%type ) RETURNS varchar AS $body$
DECLARE


ds_cheque_deposito_w varchar(255) := '';

  vet RECORD;

BEGIN

for vet in (    SELECT	b.nr_cheque
                from	cheque_cr b,
                        deposito_cheque a
                where	a.nr_seq_cheque         = b.nr_seq_cheque
                and     a.nr_seq_deposito       = nr_seq_deposito_p) loop

                begin
                ds_cheque_deposito_w := substr(vet.nr_cheque || ', ' || ds_cheque_deposito_w, 1, 255);
                end;
end loop;

return ds_cheque_deposito_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fin_obter_cheques_deposito ( nr_seq_deposito_p movto_trans_financ.nr_seq_deposito%type ) FROM PUBLIC;

