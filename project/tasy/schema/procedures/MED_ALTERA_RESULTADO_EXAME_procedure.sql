-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_altera_resultado_exame (nr_sequencia_p bigint, vl_exame_p bigint, nr_seq_cliente_p bigint, nr_seq_exame_p bigint) AS $body$
DECLARE


vl_padrao_minimo_w	varchar(255);
vl_padrao_maximo_w	varchar(255);


BEGIN

if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') and (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then
	begin
	select	med_obter_ref_exame(obter_pessoa_cliente(nr_seq_cliente_p), nr_seq_exame_p, null, 'MIN') vl_padrao_minimo,
		med_obter_ref_exame(obter_pessoa_cliente(nr_seq_cliente_p), nr_seq_exame_p, null, 'MAX') vl_padrao_maximo
	into STRICT	vl_padrao_minimo_w,
		vl_padrao_maximo_w
	;

	update	med_result_exame
	set	ie_tipo_resultado = 'N'
	where	nr_sequencia = nr_sequencia_p;

	if	(vl_padrao_minimo_w IS NOT NULL AND vl_padrao_minimo_w::text <> '' AND vl_exame_p < vl_padrao_minimo_w) then
		update	med_result_exame
		set	ie_tipo_resultado = 'B'
		where	nr_sequencia = nr_sequencia_p;
	end if;

	if (vl_padrao_maximo_w IS NOT NULL AND vl_padrao_maximo_w::text <> '') and (vl_exame_p > vl_padrao_maximo_w) then
		update	med_result_exame
		set	ie_tipo_resultado = 'A'
		where	nr_sequencia = nr_sequencia_p;
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_altera_resultado_exame (nr_sequencia_p bigint, vl_exame_p bigint, nr_seq_cliente_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
