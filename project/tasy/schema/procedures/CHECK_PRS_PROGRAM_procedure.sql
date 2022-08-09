-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE check_prs_program ( nr_seq_product_requirement_p bigint, nr_seq_reg_program_p bigint) AS $body$
DECLARE


nr_exists_w reg_program_prs.nr_seq_product_requirement%type;


BEGIN

select	coalesce(max(1), 0)
into STRICT	nr_exists_w
from    reg_program_prs
where	nr_seq_product_requirement = nr_seq_product_requirement_p
and     nr_seq_reg_program = nr_seq_reg_program_p
and     ie_situacao = 'A';

if (nr_exists_w = 1) then
	begin
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1196559, wheb_usuario_pck.get_nr_seq_idioma);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE check_prs_program ( nr_seq_product_requirement_p bigint, nr_seq_reg_program_p bigint) FROM PUBLIC;
