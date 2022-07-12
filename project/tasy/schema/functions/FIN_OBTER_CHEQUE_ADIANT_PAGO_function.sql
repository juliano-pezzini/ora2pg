-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fin_obter_cheque_adiant_pago (nr_adiant_pago_p bigint) RETURNS varchar AS $body$
DECLARE


nr_cheque_adiant_pago_w varchar(255);

  rec RECORD;

BEGIN

nr_cheque_adiant_pago_w         := '';

for rec in (SELECT      b.nr_cheque
            from        adiantamento_pago_cheque a,
                        cheque b
            where	a.nr_adiantamento       = nr_adiant_pago_p
            and	        a.nr_seq_cheque         = b.nr_sequencia
            and	        coalesce(b.dt_cancelamento::text, '') = ''
            order by    1)
loop
        if (coalesce(nr_cheque_adiant_pago_w::text, '') = '') then
                nr_cheque_adiant_pago_w	:= substr(rec.nr_cheque, 1, 255);
	else
                nr_cheque_adiant_pago_w	:= substr(nr_cheque_adiant_pago_w || ', ' || rec.nr_cheque, 1, 255);
	end if;
end loop;

return	nr_cheque_adiant_pago_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fin_obter_cheque_adiant_pago (nr_adiant_pago_p bigint) FROM PUBLIC;

